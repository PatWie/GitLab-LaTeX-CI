<?php
$group = isset($_GET['group']) ? $_GET['group'] : '';
$project = isset($_GET['project']) ? $_GET['project'] : '';

if(isset($_GET['group']) && isset($_GET['project'])){

$path = '/var/www/latex-ci/outputs/'.$group.'/'.$project.'/';

$html = <<<EOF
        <h1>$group/$project</h1>
        <table class="table">
      <caption>build history</caption>
      <thead>
        <tr>
          <th>Sha-1</th>
          <th>Branch</th>
          <th>Commiter</th>
          <th>#Commits</th>
          <th>PDF</th>
        </tr>
      </thead>
      <tbody>
EOF;
    foreach (new DirectoryIterator($path) as $fileInfo) {
        if($fileInfo->isDot()) continue;
        $pdf = '';
        foreach (new DirectoryIterator($path.$fileInfo->getFilename()) as $pdfInfo) {
            $ext = explode('.',$pdfInfo->getFilename());
            if($ext[count($ext)-1] == 'pdf'){
                 $pdf = $pdfInfo->getFilename();
            break;
            }
          
        }
        
        $info = json_decode(file_get_contents($path.$fileInfo->getFilename().'/info.json'));
        
        $refs = explode('/',$info->ref);
        $html .= '<tr>
          <td><a target="_blank" href="'.$info->repository->homepage.'">'.substr($info->after,0,8).'</a></td>
          <td>'.$refs[2].'</td>
          <td>'.$info->user_name.'</td>
          <td>';
        
        
        for($i=0;$i<count($info->commits);$i++){
            $d = date_parse($info->commits[$i]->timestamp);
            $html .= '<a data-toggle="tooltip" data-placement="top" title="'.$info->commits[$i]->message.'"  target="_blank" href="'.$info->commits[$i]->url.'">'.substr($info->commits[$i]->id,0,8).'</a> ('.$d['day'].'.'.$d['month'].'.'.$d['year'].' '.$d['hour'].':'.$d['minute'].':'.$d['second'].') by '.$info->commits[$i]->author->name.'<br>'; //$info->commits[$i]->timestamp
        }
        
        $html .='</td>
          <td><a target="_blank" href="http://latex-ci.wieschollek.info/outputs/'.$group.'/'.$project.'/'.$fileInfo->getFilename().'/'.$pdf.'">'.$pdf.'</a></td>
        </tr>';
    }

      
        
       
$html .='      </tbody>
    </table>';
}else{

$html = <<<EOF
        <form role="form" method="get">
            <div class="form-group">
                <label for="exampleInputEmail1">Groupname:</label>
                <input type="text" class="form-control" id="group" name="group" placeholder="Enter groupname">
            </div>
            <div class="form-group">
                <label for="exampleInputPassword1">Projectname:</label>
                <input type="text" class="form-control" id="project" name="project" placeholder="Enter projectname">
            </div>
            <button type="submit" class="btn btn-default">Load</button>
        </form>
EOF;

}
echo $html;
