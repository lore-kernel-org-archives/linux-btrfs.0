Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57660 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab3JOP4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 11:56:55 -0400
Received: by mail-ie0-f177.google.com with SMTP id e14so11692750iej.36
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 08:56:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Oct 2013 17:56:54 +0200
Message-ID: <CAN3gubk5xUxBzjZdknNc3j=at-z22t52ii+_aMBvLsk2RL1t_w@mail.gmail.com>
Subject: ACL rules doesn't propagate on btrfs
From: Giuseppe Fierro <giuseppe@fierro.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm playing with acl permission on btrfs (my favourite filesytem).
When I set ACL permission on directory happens that this permission doesn't
propagate inside the directory structure.

As you can see from the following example after the second level the ACL's
rules are completely forgotten.


gspe@Jura:~/Videos$ sudo mkdir test_prj
> [sudo] password for gspe:
> gspe@Jura:~/Videos$ ls -l
> total 0
> drwxr-xr-x 1 root root 0 ott 15 17:48 test_prj
> gspe@Jura:~/Videos$ sudo chown root:gmingegneria test_prj
> gspe@Jura:~/Videos$ ls -l
> total 0
> drwxr-xr-x 1 root gmingegneria 0 ott 15 17:48 test_prj
> gspe@Jura:~/Videos$ sudo chmod o-rwx test_prj
> gspe@Jura:~/Videos$ sudo chmod g+rwx test_prj
> gspe@Jura:~/Videos$ ls -l
> total 0
> drwxrwx--- 1 root gmingegneria 0 ott 15 17:48 test_prj
> gspe@Jura:~/Videos$ sudo chmod g+s test_prj
> gspe@Jura:~/Videos$ ls -l
> total 0
> drwxrws--- 1 root gmingegneria 0 ott 15 17:48 test_prj
> gspe@Jura:~/Videos$ sudo setfacl -d --set u::rwx,g::rwx,o::- test_prj
> gspe@Jura:~/Videos$ ls -l
> total 0
> drwxrws---+ 1 root gmingegneria 0 ott 15 17:48 test_prj
> gspe@Jura:~/Videos$ getfacl test_prj
> # file: test_prj
> # owner: root
> # group: gmingegneria
> # flags: -s-
> user::rwx
> group::rwx
> other::---
> default:user::rwx
> default:group::rwx
> default:other::---
> gspe@Jura:~/Videos$ cd test_prj
> gspe@Jura:~/Videos/test_prj$ touch file01
> gspe@Jura:~/Videos/test_prj$ mkdir test01
> gspe@Jura:~/Videos/test_prj$ ls -l
> total 0
> -rw-rw---- 1 gspe gmingegneria 0 ott 15 17:51 file01
> drwxrws--- 1 gspe gmingegneria 0 ott 15 17:51 test01
> gspe@Jura:~/Videos/test_prj$ getfacl file01
> # file: file01
> # owner: gspe
> # group: gmingegneria
> user::rw-
> group::rw-
> other::---
> gspe@Jura:~/Videos/test_prj$ getfacl test01
> # file: test01
> # owner: gspe
> # group: gmingegneria
> # flags: -s-
> user::rwx
> group::rwx
> other::---
> gspe@Jura:~/Videos/test_prj$ cd test01
