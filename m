Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34255 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdHSO5C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Aug 2017 10:57:02 -0400
Received: by mail-wm0-f53.google.com with SMTP id c14so5890729wmh.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Aug 2017 07:57:01 -0700 (PDT)
Received: from exnet.gdb.it ([151.82.133.212])
        by smtp.gmail.com with ESMTPSA id l43sm8829294wrl.33.2017.08.19.07.56.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Aug 2017 07:56:59 -0700 (PDT)
From: Giuseppe Della Bianca <giusdbg@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sat, 19 Aug 2017 16:56:38 +0200
Message-ID: <4569285.HZbdzRP5F5@exnet.gdb.it>
In-Reply-To: <3299660.qyGp9ij9r0@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08> <3299660.qyGp9ij9r0@exnet.gdb.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Two news (one is OT and advertising to my btrfsManage script)

I had to recreate from scratch two corrupted btrfs filesystems probably due to 
out of space during a snapshot receive.

Almost it's a habit rebuild the filesystems after a few months.



OT

I have released the latest version of my backup and btrfs manage scritp.

https://sourceforge.net/projects/btrfsmanage/

Bash script for managing btrfs filesystem (local and remote):
- Perform scrubs
- Creating snapshots
- Send snapshots
- List and delete snapshot
- Mount snapshot
- Simple to use and verify proper operation.
- Designed to be run from the shell or from the crontab.
- No setup, just copy btrfsManage.
- The subvolume on which to perform the snapshot is detected by the subvolume 
currently mounted.
- The subvolume necessary to btrfsManage are created and mounted 
automatically.


For example

/usr/local/bin/btrfsManage OPTION:usage SEND / /dev/sda3


(2017-08-19 15:45:01) Start btrfsManage
. . . Start managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda3 '

Sending ' root-2017-08-19_15:20:01.129 ' source snapshot to ' btrfsreceive ' 
subvolume
. . . btrfs send -p /tmp/tmp.p8JVMMpzZI/btrfssnapshot/root/
root-2017-08-17_10:43:01.128 /tmp/tmp.p8JVMMpzZI/btrfssnapshot/root/
root-2017-08-19_15:20:01.129 | btrfs receive /tmp/tmp.UexL3E9E2F/btrfsreceive/
root/.part/
. . . At subvol /tmp/tmp.p8JVMMpzZI/btrfssnapshot/root/
root-2017-08-19_15:20:01.129
. . . At snapshot root-2017-08-19_15:20:01.129

Creation ' root-2017-08-19_15:20:01.129 ' snapshot from ' .part/
root-2017-08-19_15:20:01.129 ' subvolume
. . . Create a readonly snapshot of '/tmp/tmp.UexL3E9E2F/btrfsreceive/
root/.part/root-2017-08-19_15:20:01.129' in '/tmp/tmp.UexL3E9E2F/btrfsreceive/
root/root-2017-08-19_15:20:01.129'
. . . Delete subvolume (commit): '/tmp/tmp.UexL3E9E2F/btrfsreceive/root/.part/
root-2017-08-19_15:20:01.129'

btrfs filesystem usage -T /tmp/tmp.UexL3E9E2F
Overall:
 Device size: 830.44GiB
 Device allocated: 513.02GiB
 Device unallocated: 317.42GiB
 Device missing: 0.00B
 Used: 509.83GiB
 Free (estimated): 318.41GiB (min: 159.70GiB)
 Data ratio: 1.00
 Metadata ratio: 2.00
 Global reserve: 512.00MiB (used: 0.00B)

 Data Metadata System 
Id Path single DUP DUP Unallocated
-- --------- --------- -------- -------- -----------
 1 /dev/sda3 505.01GiB 8.00GiB 16.00MiB 317.42GiB
-- --------- --------- -------- -------- -----------
 Total 505.01GiB 4.00GiB 8.00MiB 317.42GiB
 Used 504.01GiB 2.91GiB 80.00KiB 

Snapshot list in ' /dev/sda3 ' device
. . . btrfsreceive/root/root-2017-07-23_19:46:01.117
. . . btrfsreceive/root/root-2017-07-29_15:20:01.118
. . . btrfsreceive/root/root-2017-07-29_16:54:01.119
. . . btrfsreceive/root/root-2017-08-05_15:20:01.120
. . . btrfsreceive/root/root-2017-08-06_17:59:01.121
. . . btrfsreceive/root/root-2017-08-12_13:00:01.122
. . . btrfsreceive/root/root-2017-08-12_15:20:01.123
. . . btrfsreceive/root/root-2017-08-14_17:59:01.124
. . . btrfsreceive/root/root-2017-08-15_15:20:01.125
. . . btrfsreceive/root/root-2017-08-15_15:56:01.126
. . . btrfsreceive/root/root-2017-08-16_18:40:01.127
. . . btrfsreceive/root/root-2017-08-17_10:43:01.128
. . . btrfsreceive/root/root-2017-08-19_15:20:01.129

(2017-08-19 15:46:09) End btrfsManage
. . . End managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda3 '
CORRECTLY


 
Regards.
 
 
Gdb

