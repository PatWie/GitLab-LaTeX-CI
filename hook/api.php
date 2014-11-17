<?php

//
$url_stetting = "git.example.com";
$privkey_setting = 'secret123'

// a passphrase to protect the build server
if(!isset($_GET['k']))
exit;
if($_GET['k'] != $privkey_setting)
exit;

chdir("/var/www/latex-builder/hook");
// read from stdin
$input = file_get_contents("php://input");

// parse json-information
$Push = json_decode(str_replace('\\n','',$input));

// get username
$Username = $Push->user_name;
// get branchname
$t = explode("/",$Push->ref); $Branch = $t[count($t)-1];
// get sha1 of HEAD
$After = $Push->after;
// get name of repository
$Name = $Push->repository->name;

$Path = str_replace('http://'.$url_stetting,'',$Push->repository->homepage);
$Path = str_replace('https://'.$url_stetting,'',$Path);
$p = explode("/",$Path);

// prepare job
file_put_contents($After.'.json',$input);
file_put_contents($After.'.job',$After.';'.$Path.';'.$Branch.';'.$p[1].';'.$p[2]);
