Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s36.hotmail.com ([65.55.116.47]:53201 "EHLO
	BLU004-OMC1S36.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757234AbaKUB1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 20:27:24 -0500
Message-ID: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
Date: Fri, 21 Nov 2014 01:27:17 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Changing label few times killed filesystem?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


     I have changed file system label few times in total. When I tried 
to mount it after that, it became not mountable:

# mount /dev/sdb1 /mnt
mount: Not a directory

     In dmesg I see the following after above command:

[ 5198.413202] BTRFS info (device sdb1): disk space caching is enabled
[ 5198.629958] BTRFS: checking UUID tree

     I have lots of manually sorted downloaded files on this partition 
(in other words nothing very important but downloading and sorting all 
files again would require a lot of time), so I would appreciate any 
help.  This is what I have tried so far to restore it:

# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
btrfs: cmds-check.c:2266: check_owner_ref: Assertion `!(rec->is_root)' 
failed.
zsh: abort      btrfs check /dev/sdb1

     Since it failed after "checking extents" I decided to try 
--init-extent-tree:

# btrfs check --init-extent-tree /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
Creating a new extent tree
Failed to find [29376512, 168, 16384]
btrfs unable to find ref byte nr 29376512 parent 0 root 1  owner 1 offset 0
Failed to find [30818304, 168, 16384]
btrfs unable to find ref byte nr 30818304 parent 0 root 1  owner 0 offset 1
Failed to find [47546368, 168, 16384]
btrfs unable to find ref byte nr 47546368 parent 0 root 1  owner 0 offset 1
parent transid verify failed on 29442048 wanted 4 found 2758
Ignoring transid failure
checking extents
btrfs: cmds-check.c:2266: check_owner_ref: Assertion `!(rec->is_root)' 
failed.
zsh: abort      btrfs check --init-extent-tree /dev/sdb1

# btrfs restore /dev/sdb1 /media/backup/sdb1  # this commands exits 
after a second with 0 return code
# echo $?
0

     I also tried btrfs restore with --path-regex and got the same result.

# btrfs-find-root /dev/sdb1
Super think's the tree root is at 29360128, chunk root 20971520
Well block 4194304 seems great, but generation doesn't match, have=2, 
want=2759 level 0
Well block 4243456 seems great, but generation doesn't match, have=3, 
want=2759 level 0
Found tree root at 29360128 gen 2759 level 1

https://btrfs.wiki.kernel.org/index.php/Restore talks about picking root 
with largest transid, but I do not see "transid" in my output, so not 
sure what to do.

     I also tried btrfsck:

# btrfsck /dev/sdb1
*** Error in `btrfs check': double free or corruption (fasttop): 
0x0000000001074020 ***
zsh: abort      btrfsck /dev/sdb1

# btrfsck -b /dev/sdb1
*** Error in `btrfs check': double free or corruption (fasttop): 
0x00000000024e8020 ***
zsh: abort      btrfsck -b /dev/sdb1

# btrfsck --repair /dev/sdb1
enabling repair mode
*** Error in `btrfs check': double free or corruption (fasttop): 
0x0000000000e26020 ***
zsh: abort      btrfsck --repair /dev/sdb1

# uname -a
Linux debian 3.15.0-pf2 #1 SMP Sat Jun 28 15:09:48 EEST 2014 x86_64 
GNU/Linux
# btrfs --version
Btrfs v3.14.1
# btrfs fi show
Label: 'label'  uuid: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
         Total devices 1 FS bytes used 411.76GiB
         devid    1 size 465.76GiB used 465.76GiB path /dev/sdb1

Btrfs v3.14.1

