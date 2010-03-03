From: Arjan Filius <iafilius@xs4all.nl>
Subject: ./btrfsck /dev/sdb: btrfsck: disk-io.c:739: open_ctree_fd: Assertion
 `!(!tree_root->node)' failed.
Date: Wed, 3 Mar 2010 15:24:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1003031507040.26631@sjoerd>
Reply-To: Arjan Filius <iafilius@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

new on the btrfs list, my name is Arjan Filius.

new with btrfs i used my old laptop disk as USB external disk now, 
formatted with btrfs, running ubuntu 10.04LTS alpha. (x86_64)

while running (for some reason) on that USB/btrfs:
~/bin$ cat manydir.sh
#!/bin/bash

declare -i counter=0
DIRS="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 
27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49"

for dirA in $DIRS
do
  mkdir $dirA
  cd $dirA
  for dirB in $DIRS
  do
  mkdir $dirB
  cd $dirB
   for dirC in $DIRS
   do
   mkdir $dirC
   cd $dirC
    touch $DIRS
   cd ..
   done
  cd ..
  done
cd ..
done


and doing/trying a "mount -i remount,noatime /dev/sdb" after a while, 
because the possible time gain.

I found getting my system unusable (slow).  i looked in my syslog and 
found a 
warning like:
Mar  3 13:48:02 arfi-laptop kernel: [24960.532815] INFO: task mount:30662 
blocked for more than 120 seconds.
Mar  3 13:48:02 arfi-laptop kernel: [24960.532819] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  3 13:48:02 arfi-laptop kernel: [24960.532822] mount         D 
00000000ffffffff     0 30662  21991 0x00000000
Mar  3 13:48:02 arfi-laptop kernel: [24960.532827]  ffff8800b2543c78 
0000000000000082 0000000000015b00 0000000000015b00
Mar  3 13:48:02 arfi-laptop kernel: [24960.532838]  ffff8801384903c0 
ffff8800b2543fd8 0000000000015b00 ffff880138490000
Mar  3 13:48:02 arfi-laptop kernel: [24960.532842]  0000000000015b00 
ffff8800b2543fd8 0000000000015b00 ffff8801384903c0
Mar  3 13:48:02 arfi-laptop kernel: [24960.532847] Call Trace:
Mar  3 13:48:02 arfi-laptop kernel: [24960.532857]  [<ffffffff81162770>] ? 
bdi_sched_wait+0x0/0x20
Mar  3 13:48:02 arfi-laptop kernel: [24960.532860]  [<ffffffff8116277e>] 
bdi_sched_wait+0xe/0x20
Mar  3 13:48:02 arfi-laptop kernel: [24960.532865]  [<ffffffff8155d60f>] 
__wait_on_bit+0x5f/0x90
Mar  3 13:48:02 arfi-laptop kernel: [24960.532868]  [<ffffffff81162770>] ? 
bdi_sched_wait+0x0/0x20
Mar  3 13:48:02 arfi-laptop kernel: [24960.532872]  [<ffffffff8155d6b8>] 
out_of_line_wait_on_bit+0x78/0x90
Mar  3 13:48:02 arfi-laptop kernel: [24960.532876]  [<ffffffff810835c0>] ? 
wake_bit_function+0x0/0x40
Mar  3 13:48:02 arfi-laptop kernel: [24960.532880]  [<ffffffff81162734>] ? 
bdi_queue_work+0xa4/0xe0
Mar  3 13:48:02 arfi-laptop kernel: [24960.532883]  [<ffffffff81163aaf>] 
bdi_sync_writeback+0x6f/0x80
Mar  3 13:48:02 arfi-laptop kernel: [24960.532887]  [<ffffffff81163ae0>] 
sync_inodes_sb+0x20/0x30
Mar  3 13:48:02 arfi-laptop kernel: [24960.532890]  [<ffffffff811675c2>] 
__sync_filesystem+0x82/0x90
Mar  3 13:48:02 arfi-laptop kernel: [24960.532901]  [<ffffffff811677cb>] 
sync_filesystem+0x4b/0x70
Mar  3 13:48:02 arfi-laptop kernel: [24960.532905]  [<ffffffff81141e74>] 
do_remount_sb+0x54/0x190
Mar  3 13:48:02 arfi-laptop kernel: [24960.532908]  [<ffffffff8115b454>] 
do_remount+0x174/0x210
Mar  3 13:48:02 arfi-laptop kernel: [24960.532911]  [<ffffffff8115e12d>] 
do_mount+0x1bd/0x250
Mar  3 13:48:02 arfi-laptop kernel: [24960.532915]  [<ffffffff8115e250>] 
sys_mount+0x90/0xe0
Mar  3 13:48:02 arfi-laptop kernel: [24960.532920]  [<ffffffff810131f2>] 
system_call_fastpath+0x16/0x1b

which is explainable i think, as my disk was quite busy.


however, as my system got quite unasable, and i wanted back to work, i 
tried first just to unplug the USB disk, in the hope i could back to work. 
no luck.. a hard reboot was required (or more time perhaps)


But here it comes, after the reboot, i cant't mont the btrfs USB disk, and 
get with the latest git version:
# ./btrfsck /dev/sdb
parent transid verify failed on 38783700992 wanted 22494 found 22498
parent transid verify failed on 38783700992 wanted 22494 found 22498
parent transid verify failed on 38783700992 wanted 22494 found 22498
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' 
failed.
Aborted (core dumped)

the code lines disk-io.c:
         tree_root->node = read_tree_block(tree_root,
                                           btrfs_super_root(disk_super),
                                           blocksize, generation);
         BUG_ON(!tree_root->node);		<<<< line 739


and:
# ./btrfs-show  /dev/sdb
failed to read /dev/sr0
Label: none  uuid: d68dc8f3-ab9f-46ac-b041-3de619f71283
 	Total devices 1 FS bytes used 52.27GB
 	devid    1 size 111.79GB used 111.79GB path /dev/sdb

Btrfs v0.19-4-gab8fb4c
root@arfi-laptop:~/btrfs/btrfs-progs-unstable#


Is there a way, witch may lead to recover my data, or copy my data of the 
disk, or even better recover the filesystem?
I can live without it, but if it can be done, i realy would like that.

Thanks , and thanks in advance

ps:
more or less a same situation on:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03863.html

Regards,

-- 
Arjan Filius
mailto:iafilius@xs4all.nl
