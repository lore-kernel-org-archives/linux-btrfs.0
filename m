Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:37950 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdHAU1h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 16:27:37 -0400
Received: by mail-pg0-f43.google.com with SMTP id l64so12187136pge.5
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 13:27:37 -0700 (PDT)
MIME-Version: 1.0
From: Paulo Dias <paulo.miguel.dias@gmail.com>
Date: Tue, 1 Aug 2017 17:27:16 -0300
Message-ID: <CADJPUQ-=PURD72xZFO77tM6kV43=7CB_bfibTrL4uN7QnZWtFA@mail.gmail.com>
Subject: cant removed a corrupted dir and some files, btrfs-check crashes
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi/2 all...

I've been using btrfs for years without any major issues (ok, not true
but it was always my own fault).

This time around i was testing the new BFQ in 4.12 (hint, dont use it
for heavy i/o), and the laptop froze solid. So far so good, the thing
is, once i rebooted i had a corrupted qcow2 image and a dir with some
files that cant be removed or fixed.

The qcow2 i fixed easily, i understand that using compression with
sparse files might result it corruption, so no btrfs fault here.

Now, the "unkillable" dir is another story.

every time i run btrfs scrub <device> i get:

root@kerberos:~# btrfs check /dev/sda3
Checking filesystem on /dev/sda3
UUID: 619d4eb2-2c94-438b-9b9e-182ed969ad61
checking extents
checking free space cache
checking fs roots
root 258 inode 51958 errors 100, file extent discount
Found file extent holes:
       start: 8192, len: 499712
root 258 inode 4522616 errors 200, dir isize wrong
       unresolved ref dir 4522616 index 3 namelen 84 name
ECRYPTFS_FNEK_ENCRYPTED.FWY9yE0bBJvSm-S7O71XRP3G1sxpTJjXp7LPoLQZgemwYbF7SG.ZpQvWlk--
filetype 1 errors 2, no dir index
root 258 inode 6036422 errors 1, no inode item
       unresolved ref dir 4522616 index 46227 namelen 104 name
ECRYPTFS_FNEK_ENCRYPTED.FXY9yE0bBJvSm-S7O71XRP3G1sxpTJjXp7LPXtMCQ9BwG3JHBHoMOf9hI0EvP6p11X8OCd8Iew1bYMQ-
filetype 1 errors 5, no dir item, no inode
ref
root 258 inode 6036423 errors 1, no inode item
       unresolved ref dir 4522616 index 46229 namelen 84 name
ECRYPTFS_FNEK_ENCRYPTED.FWY9yE0bBJvSm-S7O71XRP3G1sxpTJjXp7LPCSCfQYa2WG4o8T93CrHv0k--
filetype 1 errors 5, no dir item, no inode ref
root 258 inode 8792178 errors 1, no inode item
       unresolved ref dir 4522616 index 133165 namelen 84 name
ECRYPTFS_FNEK_ENCRYPTED.FWY9yE0bBJvSm-S7O71XRP3G1sxpTJjXp7LPCSCfQYa2WG4o8T93CrHv0k--
filetype 1
errors 5, no dir item, no inode ref
root 258 inode 8792183 errors 1, no inode item
       unresolved ref dir 4522616 index 133167 namelen 104 name
ECRYPTFS_FNEK_ENCRYPTED.FXY9yE0bBJvSm-S7O71XRP3G1sxpTJjXp7LPXtMCQ9BwG3JHBHoMOf9hI0EvP6p11X8OCd8Iew1bYMQ-
filetype 1 errors 5, no dir item, no inode
ref
ERROR: errors found in fs roots
found 109814329344 bytes used, error(s) found
total csum bytes: 106513584
total tree bytes: 672759808
total fs tree bytes: 455245824
total extent tree bytes: 82968576
btree space waste bytes: 139453318
file data blocks allocated: 581567266816
referenced 103288545280

as you may have guessed, its a btrfs + ecryptfs mount, i tried to
delete the inodes but the system cant "find" them.

when i try a btrfs check --repair <device> i get:

root@kerberos:~# btrfs check --repair /dev/sda3
enabling repair mode
Checking filesystem on /dev/sda3
UUID: 619d4eb2-2c94-438b-9b9e-182ed969ad61
checking extents
Unable to find block group for 0
extent-tree.c:287: find_search_start: Warning: assertion `1` failed, value 1
btrfs(+0x20c38)[0x936fcaac38]
btrfs(btrfs_reserve_extent+0x585)[0x936fcaee61]
btrfs(btrfs_alloc_free_block+0x63)[0x936fcaf229]
btrfs(__btrfs_cow_block+0xfe)[0x936fca30b9]
btrfs(btrfs_cow_block+0xc4)[0x936fca366f]
btrfs(+0x1d7ca)[0x936fca77ca]
btrfs(btrfs_commit_transaction+0xac)[0x936fca8f4a]
btrfs(+0x5557b)[0x936fcdf57b]
btrfs(cmd_check+0x1309)[0x936fce09ac]
btrfs(main+0x142)[0x936fca20d9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f956c3153f1]
btrfs(_start+0x2a)[0x936fca211a]
Unable to find block group for 0
extent-tree.c:287: find_search_start: Warning: assertion `1` failed, value 1
btrfs(+0x20c38)[0x936fcaac38]
btrfs(btrfs_reserve_extent+0x585)[0x936fcaee61]
btrfs(btrfs_alloc_free_block+0x63)[0x936fcaf229]
btrfs(__btrfs_cow_block+0xfe)[0x936fca30b9]
btrfs(btrfs_cow_block+0xc4)[0x936fca366f]
btrfs(+0x1d7ca)[0x936fca77ca]
btrfs(btrfs_commit_transaction+0xac)[0x936fca8f4a]
btrfs(+0x5557b)[0x936fcdf57b]
btrfs(cmd_check+0x1309)[0x936fce09ac]
btrfs(main+0x142)[0x936fca20d9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f956c3153f1]
btrfs(_start+0x2a)[0x936fca211a]
Unable to find block group for 0
extent-tree.c:287: find_search_start: Warning: assertion `1` failed, value 1
btrfs(+0x20c38)[0x936fcaac38]
btrfs(btrfs_reserve_extent+0x585)[0x936fcaee61]
btrfs(btrfs_alloc_free_block+0x63)[0x936fcaf229]
btrfs(__btrfs_cow_block+0xfe)[0x936fca30b9]
btrfs(btrfs_cow_block+0xc4)[0x936fca366f]
btrfs(+0x1d7ca)[0x936fca77ca]
btrfs(btrfs_commit_transaction+0xac)[0x936fca8f4a]
btrfs(+0x5557b)[0x936fcdf57b]
btrfs(cmd_check+0x1309)[0x936fce09ac]
btrfs(main+0x142)[0x936fca20d9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f956c3153f1]
btrfs(_start+0x2a)[0x936fca211a]
extent-tree.c:2694: btrfs_reserve_extent: BUG_ON `ret` triggered, value -28
btrfs(+0x20c38)[0x936fcaac38]
btrfs(+0x20ca8)[0x936fcaaca8]
btrfs(+0x20cbb)[0x936fcaacbb]
btrfs(btrfs_reserve_extent+0x751)[0x936fcaf02d]
btrfs(btrfs_alloc_free_block+0x63)[0x936fcaf229]
btrfs(__btrfs_cow_block+0xfe)[0x936fca30b9]
btrfs(btrfs_cow_block+0xc4)[0x936fca366f]
btrfs(+0x1d7ca)[0x936fca77ca]
btrfs(btrfs_commit_transaction+0xac)[0x936fca8f4a]
btrfs(+0x5557b)[0x936fcdf57b]
btrfs(cmd_check+0x1309)[0x936fce09ac]
btrfs(main+0x142)[0x936fca20d9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f956c3153f1]
btrfs(_start+0x2a)[0x936fca211a]
Aborted (core dumped)

i get the same result if i use --init-csum-tree or --init-extent-tree,
same crash.

Im using, kernel 4.12, btrfs-tools 4.12, ecryptsfs 111.

my /etc/fstab is pretty spartan, no funky shit:

UUID=e31faa09-99e5-4c75-815c-629402ec92f2 /               btrfs
defaults,compress=lzo,discard,subvol=@ 0       1
# /boot was on /dev/sda1 during installation
UUID=55796428-a9b8-4f1b-9a7e-8fe3aa8d8097 /boot           ext4
defaults        0       2
# /boot/efi was on /dev/sdb2 during installation
UUID=D4F8-9F87  /boot/efi       vfat    umask=0077      0       1
# /home was on /dev/sda3 during installation
UUID=619d4eb2-2c94-438b-9b9e-182ed969ad61 /home           btrfs
defaults,compress=lzo,discard,subvol=@home 0       2
# swap was on /dev/sdb6 during installation
#UUID=fc2a432b-4c40-4fe4-9730-869a1d1911ef none            swap    sw
            0       0
/dev/mapper/cryptswap1 none swap sw 0 0

root@kerberos:~# btrfs filesystem usage -T /home/
Overall:
   Device size:                 333.50GiB
   Device allocated:            122.12GiB
   Device unallocated:          211.38GiB
   Device missing:                  0.00B
   Used:                        103.52GiB
   Free (estimated):            224.12GiB      (min: 118.43GiB)
   Data ratio:                       1.00
   Metadata ratio:                   2.00
   Global reserve:              209.64MiB      (used: 0.00B)

            Data      Metadata  Metadata System   System
Id Path      single    RAID1     DUP      RAID1    DUP      Unallocated
-- --------- --------- --------- -------- -------- -------- -----------
1 /dev/sda3  91.00GiB   2.00GiB  2.00GiB 32.00MiB        -   104.97GiB
2 /dev/sdb7  24.00GiB   2.00GiB  1.00GiB 32.00MiB 64.00MiB   105.93GiB
3 /dev/sdb8         -         -        -        -        -   488.13MiB
-- --------- --------- --------- -------- -------- -------- -----------
  Total     115.00GiB   2.00GiB  1.50GiB 32.00MiB 32.00MiB   211.38GiB
  Used      102.26GiB 555.27MiB 90.22MiB 48.00KiB    0.00B

/dev/sda its a:
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 850 EVO M.2 500GB

/dev/sdb its a:
Model Family:     Intel 320 Series SSDs
Device Model:     INTEL SSDSA2BW300G3

is there any way to fix this? its not impacting me in any way, since
its only a few bytes in use, but its bothering me to no end, knowing i
have corrupted stuff and cant do anything about it.

best regards

| Paulo Dias
| paulo.miguel.dias@gmail.com

Tempora mutantur, nos et mutamur in illis.
