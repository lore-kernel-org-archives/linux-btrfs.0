Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35474 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdG1R05 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 13:26:57 -0400
Received: by mail-lf0-f46.google.com with SMTP id t128so64115567lff.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 10:26:56 -0700 (PDT)
Received: from [192.168.0.10] (m80-170-192-61.cust.tele2.se. [80.170.192.61])
        by smtp.gmail.com with ESMTPSA id c79sm4279012lfh.89.2017.07.28.10.26.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jul 2017 10:26:54 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: A L <crimsoncottage@gmail.com>
Subject: Btrfs incremental send | receive fails with Error: File not found
Message-ID: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
Date: Fri, 28 Jul 2017 19:26:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I often hit the following error when doing incremental btrfs send-receive:
Btrfs incremental send | receive fails with Error: File not found

Sometimes I can do two-three incremental snapshots, but then the same 
error (different file) happens again. It seems that the files were 
changed or replaced between snapshots, which is causing the problems for 
send-receive. I have tried to delete all snapshots and started over but 
the problem comes back, so I think it must be a bug.

The source volume is:   /mnt/storagePool (with RAID1 profile)
with subvolume:   volume/userData
Backup disk is:   /media/usb-backup (external USB disk)


# cat /proc/version
Linux version 4.13.0-rc2 (root@e350) (gcc version 6.3.0 (Gentoo 6.3.0 
p1.0)) #2 SMP PREEMPT Fri Jul 28 14:25:15 CEST 2017

# btrfs version
btrfs-progs v4.11.1

# btrfs fi show:
Label: 'Backup'  uuid: f021a039-87d6-4498-a0f5-6bbba3dfb1f1
         Total devices 1 FS bytes used 362.85GiB
         devid    1 size 931.51GiB used 367.06GiB path /dev/sdf1

Label: 'pool'  uuid: ea4f1d6d-c2c5-4247-a903-15b36ee276a7
         Total devices 2 FS bytes used 362.33GiB
         devid    1 size 927.51GiB used 367.03GiB path /dev/sdc2
         devid    2 size 927.51GiB used 367.03GiB path /dev/sdd2


(backup) /media/usb-backup/volumes/userData # btrfs sub list .
ID 258 gen 30 top level 5 path scripts
ID 1622 gen 3227 top level 5 path volumes/userData/userData.20170727T1222
ID 1999 gen 3251 top level 5 path volumes/userData/userData.20170727T2102

(source) /mnt/storagePool/snapshots # btrfs sub list .
ID 262 gen 118703 top level 5 path volume/userData
ID 1928 gen 118105 top level 5 path snapshots/userData.20170727T1222
ID 1930 gen 118151 top level 5 path snapshots/userData.20170727T2102
ID 1932 gen 118167 top level 5 path snapshots/userData.20170727T2300
ID 1936 gen 118390 top level 5 path snapshots/userData.20170728T0100
ID 1939 gen 118502 top level 5 path snapshots/userData.20170728T0200
ID 1955 gen 118667 top level 5 path snapshots/userData.20170728T1300
ID 1960 gen 118695 top level 5 path snapshots/userData.20170728T1700
ID 1962 gen 118699 top level 5 path snapshots/userData.20170728T1800


# btrfs subvolume list -p -a -c -g -u -q -R -t /mnt/storagePool/snapshots
ID      gen     cgen    parent  top level       parent_uuid 
received_uuid   uuid    path
--      ---     ----    ------  ---------       ----------- 
-------------   ----    ----
260     118702  24      5       5               - 
6e20167e-8d72-cc42-b486-10c6a5516ca7 
dd86162c-4df2-d646-a65f-77768adc132d    volume/mail
262     118703  39      5       5               - 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
94c256cb-970e-e349-a660-ff4d9291c829    volume/userData
506     118691  333     5       5               - 
d0c6ff24-1766-b049-abe9-80396795448f 
c759b1cc-106e-134a-8cef-f1da1bc5e169    volume/storageTemp
1469    78671   78671   5       5               -       - 
8a94524e-a956-c14b-bb8d-d453627f27d5    volume/mysql
1928    118105  118105  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
7aed8444-34a7-c54d-ae06-e0e80ead3c18 snapshots/userData.20170727T1222
1930    118151  118151  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
20b4fab3-f75c-4445-914a-23465e09626c snapshots/userData.20170727T2102
1932    118167  118167  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
2b0069dc-5d71-df49-9c32-d5e0f17c09e9 snapshots/userData.20170727T2300
1936    118390  118390  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
8aa3ea70-b703-b740-8012-373be0616720 snapshots/userData.20170728T0100
1939    118502  118502  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
ad84276f-a481-d04a-ad26-301dd79b158f snapshots/userData.20170728T0200
1955    118667  118667  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
605cf43c-5e01-9d4e-ad22-77488f0d3e90 snapshots/userData.20170728T1300
1960    118695  118695  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
31c72ce0-5765-b042-a073-8c4296e111ec snapshots/userData.20170728T1700
1962    118699  118699  5       5 94c256cb-970e-e349-a660-ff4d9291c829 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
feadb1df-867b-7245-86d0-5472cd3c899b snapshots/userData.20170728T1800


# btrfs subvolume list -p -a -c -g -u -q -R -t 
/media/usb-backup/volumes/userData
ID      gen     cgen    parent  top level       parent_uuid 
received_uuid   uuid    path
--      ---     ----    ------  ---------       ----------- 
-------------   ----    ----
258     30      9       5       5               -       - 
95dafde0-677c-7542-9d18-9bbfdbf7c9b3    scripts
1622    3227    2532    5       5               - 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
cfe52e52-b7dd-7e48-8616-43286f5a11e0 volumes/userData/userData.20170727T1222
1999    3251    3224    5       5 cfe52e52-b7dd-7e48-8616-43286f5a11e0 
8464242d-0e81-e84e-ba93-78b1c8f00fc9 
c2625b3d-7d3f-fa48-9c73-3d67209bf3f8 volumes/userData/userData.20170727T2102






###
### Running the incremental send, using an existing snapshot as parent.
###

# btrfs send -p /mnt/storagePool/snapshots/userData.20170727T2102 
/mnt/storagePool/snapshots/userData.20170727T2300 | btrfs receive 
/media/usb-backup/volumes/userData/
At subvol /mnt/storagePool/snapshots/userData.20170727T2300
At snapshot userData.20170727T2300
ERROR: unlink Documents/Art & Craft/Scrapbook-Journal/FAR FAR 
HILL/Paper/000_29082014_w.zip failed. No such file or directory



There are no kernel errors in dmesg. The file was changed between 
snapshots from a Windows client. The volume 'userData' is shared by Samba.


# ls -l
-rw-rwx---+ 1 user user 112643654 Jul 27 17:46 
'/mnt/storagePool/snapshots/userData.20170727T2102/Documents/Art & 
Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip'
-rw-rw----  1 user user  88269510 Jul 27 22:28 
'/mnt/storagePool/snapshots/userData.20170727T2300/Documents/Art & 
Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip'
-rw-rwx---+ 1 user user 112643654 Jul 27 17:46 
'/media/usb-backup/volumes/userData/userData.20170727T2102/Documents/Art 
& Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip'

# getfattr -d -m ".*"
file: mnt/storagePool/snapshots/userData.20170727T2102/Documents/Art & 
Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip
system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAYA/////wgABgDoAwAAEAAHAP////8gAAAA/////w==
user.DOSATTRIB=0sMHgyMAAAAwADAAAAEQAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALb7FertBtMBAAAAAAAAAAA=

file: mnt/storagePool/snapshots/userData.20170727T2300/Documents/Art & 
Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip
user.DOSATTRIB=0sMHgyMAAAAwADAAAAEQAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGbb2O8WB9MBAAAAAAAAAAA=

file: 
media/usb-backup/volumes/userData/userData.20170727T2102/Documents/Art & 
Craft/Scrapbook-Journal/FAR FAR HILL/Paper/000_29082014_w.zip
system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAYA/////wgABgDoAwAAEAAHAP////8gAAAA/////w==
user.DOSATTRIB=0sMHgyMAAAAwADAAAAEQAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALb7FertBtMBAAAAAAAAAAA=





