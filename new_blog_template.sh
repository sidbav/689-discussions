#!/bin/bash

source .env

post_address='new-blog-post'
if [ $# -ne 0 ]
  then
    post_address="$1"
fi

post_folder=$root_folder_path/content/blog/$post_address

if [ -d "$post_folder" ]
  then
    echo "\"$post_address\" already exists, use a different name"
    exit 1
fi

mkdir $post_folder
touch $post_folder/index.md

echo "---
title: \"New Post\"
date: \"$(date +%F)\"
description: \"\"
---

Hello world on new post" >> $post_folder/index.md

