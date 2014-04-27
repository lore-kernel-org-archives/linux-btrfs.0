Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44213 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaD0VJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 17:09:39 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so4247959eek.39
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 14:09:37 -0700 (PDT)
Received: from [192.168.3.10] (bzq-84-109-114-49.red.bezeqint.net. [84.109.114.49])
        by mx.google.com with ESMTPSA id q41sm44590792eez.7.2014.04.27.14.09.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 27 Apr 2014 14:09:36 -0700 (PDT)
Message-ID: <535D720E.1080900@gmail.com>
Date: Mon, 28 Apr 2014 00:09:34 +0300
From: Niv Gal Waizer <nivwiz@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: File system errors
References: <535D714C.3000507@gmail.com>
In-Reply-To: <535D714C.3000507@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


A week ago I installed kernel 3.14 on an existing laptop with btrfs 
install by ubuntu.  I upgraded ubuntu to 14.04 a few days ago.
I had problems installing a package, then I removed libc6 by mistake, I 
could no longer boot the system. I booted from a usb disk with ubuntu 
14.04. I ran btrfsck on the btrfs partition and find many errors:
root@ubuntu:~# btrfsck /dev/sda1
Checking filesystem on /dev/sda1
UUID: a4e2f8a7-3a4e-47a0-8d96-20d70a53af04
checking extents
Incorrect local backref count on 772273311744 parent 839903506432 owner 
0 offset 0 found 0 wanted 1 back 0x2e5d7f0
Backref disk bytenr does not match extent record, bytenr=772273311744, 
ref bytenr=0
Backref 772273311744 root 256 owner 1453610 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 772273311744 root 256 owner 1453610 
offset 0 found 1 wanted 0 back 0x7c79cd0
backpointer mismatch on [772273311744 8192]
Incorrect local backref count on 772276248576 parent 839903506432 owner 
0 offset 0 found 0 wanted 1 back 0x342da60
Backref disk bytenr does not match extent record, bytenr=772276248576, 
ref bytenr=0
Backref 772276248576 root 256 owner 1453611 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 772276248576 root 256 owner 1453611 
offset 0 found 1 wanted 0 back 0x7c7a5d0
backpointer mismatch on [772276248576 12288]
Incorrect local backref count on 772277743616 parent 839903506432 owner 
0 offset 0 found 0 wanted 1 back 0x43b1a70
Backref disk bytenr does not match extent record, bytenr=772277743616, 
ref bytenr=0
Backref 772277743616 root 256 owner 1453614 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 772277743616 root 256 owner 1453614 
offset 0 found 1 wanted 0 back 0x7c7b7d0
backpointer mismatch on [772277743616 16384]
Backref 821382955008 root 256 owner 1870931 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821382955008 root 256 owner 1870931 
offset 0 found 1 wanted 0 back 0xd387530
Incorrect local backref count on 821382955008 parent 839914647552 owner 
0 offset 0 found 0 wanted 1 back 0x4565fb0
Backref disk bytenr does not match extent record, bytenr=821382955008, 
ref bytenr=64
backpointer mismatch on [821382955008 16384]
Backref 821382971392 root 256 owner 1870932 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821382971392 root 256 owner 1870932 
offset 0 found 1 wanted 0 back 0xec1d240
Incorrect local backref count on 821382971392 parent 839914647552 owner 
0 offset 0 found 0 wanted 1 back 0x45829c0
Backref disk bytenr does not match extent record, bytenr=821382971392, 
ref bytenr=64
backpointer mismatch on [821382971392 12288]
Backref 821382983680 root 256 owner 1870933 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821382983680 root 256 owner 1870933 
offset 0 found 1 wanted 0 back 0x6e71620
Incorrect local backref count on 821382983680 parent 839914647552 owner 
0 offset 0 found 0 wanted 1 back 0x8c86800
Backref disk bytenr does not match extent record, bytenr=821382983680, 
ref bytenr=64
backpointer mismatch on [821382983680 8192]
Backref 821382991872 root 256 owner 1870934 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821382991872 root 256 owner 1870934 
offset 0 found 1 wanted 0 back 0x3707e40
Incorrect local backref count on 821382991872 parent 839914647552 owner 
0 offset 0 found 0 wanted 1 back 0x8c86c80
Backref disk bytenr does not match extent record, bytenr=821382991872, 
ref bytenr=64
backpointer mismatch on [821382991872 8192]
Backref 821383000064 root 256 owner 1870936 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821383000064 root 256 owner 1870936 
offset 0 found 1 wanted 0 back 0x3707cc0
Incorrect local backref count on 821383000064 parent 839914647552 owner 
0 offset 0 found 0 wanted 1 back 0x47addf0
Backref disk bytenr does not match extent record, bytenr=821383000064, 
ref bytenr=64
backpointer mismatch on [821383000064 20480]
Backref 821383643136 root 256 owner 1871006 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 821383643136 root 256 owner 1871006 
offset 0 found 1 wanted 0 back 0x965b6b0
Incorrect local backref count on 821383643136 parent 839914913792 owner 
0 offset 0 found 0 wanted 1 back 0xcf696c0
Backref disk bytenr does not match extent record, bytenr=821383643136, 
ref bytenr=64
backpointer mismatch on [821383643136 28672]
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 256 inode 146314 errors 200, dir isize wrong
root 256 inode 160861 errors 400, nbytes wrong
root 256 inode 967929 errors 1800, odd csum item, some csum missing
root 256 inode 996928 errors 1800, odd csum item, some csum missing
root 256 inode 1326452 errors 400, nbytes wrong
root 256 inode 1326453 errors 400, nbytes wrong
root 261 inode 160861 errors 400, nbytes wrong
root 261 inode 967929 errors 1800, odd csum item, some csum missing
root 261 inode 996928 errors 1800, odd csum item, some csum missing
root 261 inode 1326452 errors 400, nbytes wrong
root 261 inode 1326453 errors 400, nbytes wrong
found 77318565024 bytes used err is 1
total csum bytes: 203137304
total tree bytes: 2158280704
total fs tree bytes: 1807392768
total extent tree bytes: 124895232
btree space waste bytes: 539994004
file data blocks allocated: 3634757378048
  referenced 303491842048
Btrfs v3.12

I then ran btrfsck --repair /dev/sda1
I then ran it again and got:
btrfsck /dev/sda1
Checking filesystem on /dev/sda1
UUID: a4e2f8a7-3a4e-47a0-8d96-20d70a53af04
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 256 inode 160861 errors 400, nbytes wrong
root 256 inode 967929 errors 1800, odd csum item, some csum missing
root 256 inode 996928 errors 1800, odd csum item, some csum missing
root 256 inode 1326452 errors 400, nbytes wrong
root 256 inode 1326453 errors 400, nbytes wrong
root 261 inode 160861 errors 400, nbytes wrong
root 261 inode 967929 errors 1800, odd csum item, some csum missing
root 261 inode 996928 errors 1800, odd csum item, some csum missing
root 261 inode 1326452 errors 400, nbytes wrong
root 261 inode 1326453 errors 400, nbytes wrong
found 237847721824 bytes used err is 1
total csum bytes: 203137304
total tree bytes: 2158297088
total fs tree bytes: 1807392768
total extent tree bytes: 124911616
btree space waste bytes: 540009404
file data blocks allocated: 3634757378048
  referenced 303491842048
Btrfs v3.12

I ran the btrfsck from this kerenl:
Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux
I ran an offline smart long test and found no errors on the drive.

What is wrong with my file system?
What extra info need I supply?



