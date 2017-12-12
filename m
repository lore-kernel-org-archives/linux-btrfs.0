Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:42533 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbdLLOC6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 09:02:58 -0500
Received: by mail-wr0-f175.google.com with SMTP id s66so21259059wrc.9
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 06:02:57 -0800 (PST)
MIME-Version: 1.0
From: Neal Becker <ndbecker2@gmail.com>
Date: Tue, 12 Dec 2017 09:02:56 -0500
Message-ID: <CAG3t+pHLcrMLH8XxWSc+P6v-gtMZds+RNKBz6RKzAWdWr8ObhQ@mail.gmail.com>
Subject: broken btrfs filesystem
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sudo ls -la ~/
[sudo] password for nbecker:
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
ls: cannot access '/home/nbecker/.bash_history': No such file or directory
total 11652
drwxr-xr-x. 1 nbecker nbecker     5826 Dec 12 08:48  .
drwxr-xr-x. 1 root    root          48 Aug  2 19:32  ..
[...]
-rwxrwxr-x. 1 nbecker nbecker      207 Dec  3  2015  BACKUP.sh
-?????????? ? ?       ?              ?            ?  .bash_history
-?????????? ? ?       ?              ?            ?  .bash_history
-?????????? ? ?       ?              ?            ?  .bash_history
-?????????? ? ?       ?              ?            ?  .bash_history
-?????????? ? ?       ?              ?            ?  .bash_history
-?????????? ? ?       ?              ?            ?  .bash_history
-rw-r--r--. 1 nbecker nbecker       18 Oct  8  2014  .bash_logout
[...]

uname -a
Linux nbecker2 4.14.3-300.fc27.x86_64 #1 SMP Mon Dec 4 17:18:27 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

 btrfs --version
btrfs-progs v4.11.1

sudo btrfs fi show
Label: 'fedora'  uuid: 93c586fa-6d86-4148-a528-e61e644db0c8
Total devices 1 FS bytes used 80.96GiB
devid    1 size 230.00GiB used 230.00GiB path /dev/sda3

sudo btrfs fi df /home
Data, single: total=226.99GiB, used=78.89GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=3.01GiB, used=2.07GiB
GlobalReserve, single: total=222.36MiB, used=0.00B

dmesg.log is here:
https://nbecker.fedorapeople.org/dmesg.txt

mount | grep btrfs
/dev/sda3 on / type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/root)
/dev/sda3 on /home type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=318,subvol=/home)

-- 
Those who don't understand recursion are doomed to repeat it
