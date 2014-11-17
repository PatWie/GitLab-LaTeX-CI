#!/bin/sh
alias dolatex='pdflatex -synctex=1 -interaction=nonstopmode'
alias dobibtex='bibtex -terse'

# parse args
COMMITNAME=$1
REPOPATH=$2
BRANCH_NAME=$3
GROUP_NAME=$4
GIT_NAME=$5

echo -e "LaTeX CI - build process\n"
echo -e "------------------------\n\n"


ROOT_DIR="/var/www/latex-builder/"
OUT_DIR="${ROOT_DIR}/outputs"


echo "prepare temporary directory"
cd $ROOT_DIR
mkdir $COMMITNAME
cd $COMMITNAME

echo "clone git repository"
git clone /home/git/repositories${REPOPATH}.git
REPONAME=`dir $TMP_DIR`
echo "found repository ${REPONAME}"
cd $REPONAME

echo "change to branch ${BRANCH_NAME}"
git checkout "$BRANCH_NAME"

echo "prepare persistents directory"
echo "create dir ${OUT_DIR}/${GROUP_NAME}/${GIT_NAME}/${COMMITNAME}/"
mkdir "${OUT_DIR}/${GROUP_NAME}"
mkdir "${OUT_DIR}/${GROUP_NAME}/${GIT_NAME}"
mkdir "${OUT_DIR}/${GROUP_NAME}/${GIT_NAME}/${COMMITNAME}"


cat "${ROOT_DIR}/${COMMITNAME}/${REPONAME}/latex-builder.config"
echo "------latex-builder.config-------"


cd "${ROOT_DIR}/${COMMITNAME}/${REPONAME}"
pwd
if [ -f "${ROOT_DIR}/${COMMITNAME}/${REPONAME}/latex-builder.config" ]
  then

  for texfile in $(cat "${ROOT_DIR}/${COMMITNAME}/${REPONAME}/latex-builder.config")
  do
 
    echo "run latex on $texfile"

    pdffile=`echo ${texfile%.*}`
    dolatex $texfile > "${pdffile}-2.log"
    echo $pdffile
    echo "check if pdf ${pdffile}.pdf was created"
    if [ ! -f "${pdffile}.pdf" ]; then
      echo "--> File not found!"
      #exit 0  (does not work at the moment)
    else
      echo "--> pdf exists"
    fi
  done
  echo "check if bibtex exists"
  bibnumber=`find . -name "*.bib" | wc -l`
  if [ ! $bibnumber -eq 0 ]
    then
    # we need to run latex multiple times
    echo "--> found bibtex"
    LAST_TEXFILE=`cat ${ROOT_DIR}/${COMMITNAME}/${REPONAME}/latex-builder.config | tail -n 1`
    pdffile=`echo ${LAST_TEXFILE%.*}`
    echo "running ${LAST_TEXFILE}"
    echo "running bibtex on ${pdffile}.aux"
    
    dolatex $LAST_TEXFILE > "${pdffile}-2.log"
    dobibtex "${pdffile}.aux"
    dolatex $LAST_TEXFILE > "${pdffile}-2.log"
    dolatex $LAST_TEXFILE > "${pdffile}-2.log"
  else
    echo "--> no bibtex found"
  fi
  LAST_TEXFILE=`cat ${ROOT_DIR}/${COMMITNAME}/${REPONAME}/latex-builder.config | tail -n 1`
  pdffile=`echo ${LAST_TEXFILE%.*}`
  cp "${pdffile}.pdf" "${OUT_DIR}/${GROUP_NAME}/${GIT_NAME}/${COMMITNAME}/${pdffile}.pdf" 
else
	echo "nothing to build!"
fi
mv "${ROOT_DIR}/hook/${COMMITNAME}.json" "${OUT_DIR}/${GROUP_NAME}/${GIT_NAME}/${COMMITNAME}/info.json"
rm -Rf "${ROOT_DIR}${COMMITNAME}"

