Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34982 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcAGECq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 23:02:46 -0500
Received: by mail-qk0-f180.google.com with SMTP id n135so171201042qka.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 20:02:46 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Jan 2016 21:02:46 -0700
Message-ID: <CANevpVj4kfGg2KEhpbvjS7UUhRQMUy_84PFy85+=fo7EqCVbcQ@mail.gmail.com>
Subject: Recovery of a raid1 FS
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a two-disk RAID1 btrfs volume, which crashed for no apparent
reason and was corrupt on next boot. Relevant command runs and
outputs:

[root@archiso ~]# mount -osubvol=.,ro,recovery /dev/mapper/rootvol_1 mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/rootvol_1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
[  372.665800] Btrfs loaded
[  372.666481] BTRFS: device fsid 91f7e058-1142-4036-b1f7-4f64163dc8ae
devid 1 transid 257371 /dev/dm-4
[  389.339860] BTRFS: device fsid 91f7e058-1142-4036-b1f7-4f64163dc8ae
devid 2 transid 257371 /dev/dm-5
[  781.695931] BTRFS info (device dm-5): enabling auto recovery
[  781.695933] BTRFS info (device dm-5): disk space caching is enabled
[  781.695934] BTRFS: has skinny extents
[  781.776198] BTRFS: bdev /dev/mapper/rootvol_2 errs: wr 0, rd 0,
flush 0, corrupt 10, gen 426
[  791.982552] BTRFS critical (device dm-5): corrupt leaf, bad key
order: block=6210228551680,root=1, slot=49
[  791.982836] BTRFS critical (device dm-5): corrupt leaf, bad key
order: block=6210228551680,root=1, slot=49
[  791.982862] BTRFS: Failed to read block groups: -5
[  792.030513] BTRFS: open_ctree failed

[root@archiso ~]# btrfs restore -D /dev/mapper/rootvol_1
/root/tmp_data | tee data_mnt/tom/restore_list.txt
bad key ordering 49 50
Error searching -1
Error searching /root/tmp_data/home
This is a dry-run, no files are going to be restored
We have looped trying to restore files in
/exherbo/root/squashfs-root/usr/bin too many times to be making
progress, stopping
We have looped trying to restore files in
/exherbo/root/squashfs-root/usr/share/man/man1 too many times to be
making progress, stopping
We have looped trying to restore files in
/exherbo/root/squashfs-root/usr/share/man/man3 too many times to be
making progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/bin too many times to be making
progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/include/firefox/mozilla/dom too many
times to be making progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/include/firefox too many times to be
making progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/lib/python3.5/test/__pycache__ too
many times to be making progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/lib/python2.7/test too many times to
be making progress, stopping
We have looped trying to restore files in
/exherbo/usr/x86_64-pc-linux-gnu/lib/debug/usr/x86_64-pc-linux-gnu/bin
too many times to be making progress, stopping
We have looped trying to restore files in /exherbo/usr/share/man/man3
too many times to be making progress, stopping
We have looped trying to restore files in /exherbo/usr/share/man/man1
too many times to be making progress, stopping
We have looped trying to restore files in
/exherbo/usr/share/idl/firefox too many times to be making progress,
stopping

[root@archiso ~]# btrfs restore -v -l /dev/mapper/rootvol_1
bad key ordering 49 50
 tree key (EXTENT_TREE ROOT_ITEM 0) 6210219163648 level 2
 tree key (DEV_TREE ROOT_ITEM 0) 3792640000000 level 1
 tree key (FS_TREE ROOT_ITEM 0) 3792595566592 level 0
 tree key (CSUM_TREE ROOT_ITEM 0) 6210220048384 level 3
 tree key (UUID_TREE ROOT_ITEM 0) 3792855105536 level 0
 tree key (257 ROOT_ITEM 0) 3792551755776 level 2
 tree key (258 ROOT_ITEM 0) 6210218557440 level 2
 tree key (3785 ROOT_ITEM 0) 7588191682560 level 0
 tree key (3786 ROOT_ITEM 0) 7588191633408 level 0
 tree key (7565 ROOT_ITEM 0) 6210221588480 level 2
 tree key (7566 ROOT_ITEM 0) 4055721377792 level 0
 tree key (7567 ROOT_ITEM 101377) 3792849616896 level 2
 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 3792520544256 level 0

Any help available? I tried using btrfs-restore previously on a
different machine with only one of the disks plugged in, and it at
least showed some files, though the 'Error searching -1' still showed
up. (The /home subvolume is the only one I really care about;
everything else is nice-to-have.)

-- 
Tom Hunt
