#!/bin/env bash

home=$HOME/.lovebuilder
versions=$home/versions

mkdir -p $versions

if [[ $# -ne 2 ]]; then
    echo "Require project name and version as params"
    exit -1
fi

name=$1 #my-new-project
version=$2 #v0.1
here=`pwd`
love_file=`pwd`/$name.love
folder_name=love-11.5-win64
archive_name=love-11.5-win64.zip
url=https://github.com/love2d/love/releases/download/11.5/$archive_name

if [ ! -f $versions/$archive_name ]; then
    wget  -O $versions/$archive_name $url
fi

output_dir=/tmp/lovebuilder-`date +%s`
unzip $versions/$archive_name -d $output_dir

cd $output_dir/love-11.5-win64
cat lovec.exe $love_file > my-new-project.exe
rm love.exe lovec.exe

zip $here/$name-$version-win64.zip *
cd -
