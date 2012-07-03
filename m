Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:20015 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2GCQ0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 12:26:41 -0400
Message-ID: <4FF31D40.6080103@giantdisaster.de>
Date: Tue, 03 Jul 2012 18:26:40 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Testing permanent IO errors with btrfs
References: <CAHf9xva5sdgwoTMJE5_Pmh_OBba2Jr6Ox4ov+rZUT6-aynb7CQ@mail.gmail.com> <4FF2FB5B.70909@giantdisaster.de>
In-Reply-To: <4FF2FB5B.70909@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 03 Jul 2012 16:02:03 +0200, Stefan Behrens wrote:
On 7/3/2012 4:02 PM, Stefan Behrens wrote:
> On Mon, 2 Jul 2012 22:57:01 +0300, Alex Lyakas wrote:
>> Hi everybody,
>> I am interested to test how btrfs behaves when the underlying block
>> device starts returning permanent IO errors. To test this, I set up a
>> linear device-mapper, mapped to the block device and start IOs. At
>> some point, I switch the device-mapper's table to "error" table (using
>> "dmsetup reload" and "dmsetup resume").
>> With older version of btrfs, I experienced kernel panics and sometimes
>> the IO processes would not terminate.
> 
> Did you fully switch to the "error" table or to a mixture of linear and
> error? And how did you write to the disk?
> 
> I tried several times with the following script and everything was fine:
> the filesystem was forced readonly, the fs fell back to an consistent
> state and was mountable.
> 
> Therefore, more details how to reproduce the issue would be helpful, and
> if you have the kernel logs for the issue, that would be helpful, too.

The issue is that during unmount, the super blocks are written which
contain a root that was not written. This is done for the case that the
filesystem was flagged with BTRFS_SUPER_FLAG_ERROR before due to an
fatal I/O error. This means, the transaction aborting is not correct.

Call trace:
write_dev_supers+0x2e6/0x2f0 [btrfs]
write_all_supers+0x69a/0x870 [btrfs]
btrfs_error_commit_super+0x74/0x80 [btrfs]
close_ctree+0x2c0/0x330 [btrfs]

It is reproducible like this (with today's btrfs-next):

#!/bin/sh
echo 0 25165824 linear /dev/sdm 0 | dmsetup create foo
ls -alLF /dev/mapper/foo
mkfs.btrfs /dev/mapper/foo
mount /dev/mapper/foo /mnt
sync
# switch into I/O error mode:
echo 0 25165824 error | dmsetup reload foo
dmsetup resume foo
ls -alF /mnt
touch /mnt/1
ls -alF /mnt
sleep 35
# during the sleep 35, the "btrfs is forced readonly" and
# "btrfs: Transaction aborted" appears.
# switch dm back into I/O good mode:
echo 0 25165824 linear /dev/sdm 0 | dmsetup reload foo
dmsetup resume foo
sleep 1
umount /mnt
# now write_all_supers() is called and points to something
# that is never written to disk
btrfsck /dev/mapper/foo


> 
> #!/bin/sh
> set -x
> DISK=/dev/sdm
> # 12GB
> echo 0 25165824 linear $DISK 0 | dmsetup create foo
> dmsetup info foo
> ls -alLF /dev/mapper/foo
> dd if=/dev/zero of=/dev/mapper/foo bs=1M
> mkfs.btrfs /dev/mapper/foo
> mount /dev/mapper/foo /mnt
> dd if=/dev/zero of=/mnt/30G bs=1M count=12000 &
> sleep 10
> sync
> sleep 5
> echo 0 25165824 error | dmsetup reload foo
> dmsetup resume foo
> wait
> ls -alF /mnt
> umount /mnt
> sleep 1
> echo 0 25165824 linear $DISK 0 | dmsetup reload foo
> dmsetup resume foo
> sleep 1
> mount /dev/mapper/foo /mnt
> ls -alF /mnt
> umount /mnt
> btrfsck /dev/mapper/foo
> dmsetup remove foo
> 
> 
>>
>> Today I tested with
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git up
>> to commit 782b7bca60c5021213e87ab26bbf94deb7654b62 (Merge branch
>> 'for-chris' of git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next
>> into for-linus). Things look better - kernel issued a warning about
>> aborting the transaction, and all IO processes exited with error.
>> However, after I unmounted (got some kernel warnings on unmount) and
>> mounted again, mount failed. Using btrfs-debug-tree, I followed the
>> __open_ctree_fd() path and discovered that:
>>
>> Problem 1: superblock tells transaction id (13) higher than the chunk
>> tree root (5). (The chunk tree itself has only one leaf, which is also
>> the root.)
>> Problem 2: when trying to read the block of the root of tree roots
>> (read_tree_block()), using bytenr stored at superblock->root and the
>> chunk tree (with low transaction id) to map the block, brings
>> corrupted nodes from both locations (DUP).
>>
>> At this point btrfs-debug-tree aborts, because the root of tree roots
>> is not available.
>>
>> Below is some information, pls let me know if any additional info is needed.
>>
>> Thanks,
>> Alex.
>>
>> The superblock structure:
>> $11 = {csum = "Ø\017\336", '\000' <repeats 27 times>, fsid =
>> "??CC\330\344M\327\272\237\003\363\065\266\274", <incomplete sequence
>> \372>, bytenr = 65536, flags = 1, magic = 5575266562640200287,
>> generation = 13, root = 29515776, chunk_root = 20971520, log_root = 0,
>> log_root_transid = 0, total_bytes = 21474836480, bytes_used =
>> 3674767360, root_dir_objectid = 6, num_devices = 1, sectorsize = 4096,
>> nodesize = 4096, leafsize = 4096, stripesize = 4096,
>> sys_chunk_array_size = 226, chunk_root_generation = 13, compat_flags =
>> 0, compat_ro_flags = 0, incompat_flags = 1, csum_type = 0, root_level
>> = 0 '\000', chunk_root_level = 0 '\000', log_root_level = 0 '\000',
>> dev_item = {devid = 1, total_bytes = 21474836480, bytes_used =
>> 7553941504, io_align = 4096, io_width = 4096, sector_size = 4096, type
>> = 0, generation = 0, start_offset = 4294967312, dev_group = 0,
>> seek_speed = 1 '\001', bandwidth = 0 '\000', uuid =
>> "\206\201\355\"\311\330L\234\221\305\016d\362\241\276", <incomplete
>> sequence \356>, fsid =
>> "??CC\330\344M\327\272\237\003\363\065\266\274", <incomplete sequence
>> \372>}, label = '\000' <repeats 255 times>, cache_generation = 0,
>> reserved = {0 <repeats 31 times>}, sys_chunk_array =
>> "\000\001\000\000\000\000\000\000\344\000\000\000\000\000\000\000\000\000\000@\000\000\000\000\000\002\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\002\000\000\000\000\000\000\000\000\020\000\000\000\020\000\000\000\020\000\000\001\000\000\000\001",
>> '\000' <repeats 15 times>"\206,
>> \201\355\"\311\330L\234\221\305\016d\362\241\276\356\000\001\000\000\000\000\000\000\344\000\000@\001\000\000\000\000\000\000\200\000\000\000\000\000\002\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\"\000\000\000\000\000\000\000\000\000\001\000\000\000\001\000\000\020\000\000\002\000\000\000\001\000\000\000\000\000\000\000\000\000@\001\000\000\000\000\206\201\355\"\311\330L\234\221\305\016d\362\241\276\356\001\000\000\000\000\000\000\000\000\000\300\001\000\000\000\000\206\201\355\"\311\330L\234\221\305\016d\362\241\276\356",
>> '\000' <repeats 1821 times>, super_roots = {{tree_root = 29425664,
>> tree_root_gen = 12, chunk_root = 20975616, chunk_root_gen = 11,
>> extent_root = 29417472, extent_root_gen = 12, fs_root = 29429760,
>> fs_root_gen = 13, dev_root = 29372416, dev_root_gen = 11, csum_root =
>> 29376512, csum_root_gen = 5, total_bytes = 21474836480, bytes_used =
>> 2252435456, num_devices = 1, unsed_64 = {0, 0, 0, 0}, tree_root_level
>> = 0 '\000', chunk_root_level = 0 '\000', extent_root_level = 0 '\000',
>> fs_root_level = 1 '\001', dev_root_level = 0 '\000', csum_root_level =
>> 0 '\000', unused_8 = "\000\000\000\000\000\000\000\000\000"},
>> {tree_root = 29515776, tree_root_gen = 13, chunk_root = 20971520,
>> chunk_root_gen = 13, extent_root = 29507584, extent_root_gen = 13,
>> fs_root = 29519872, fs_root_gen = 14, dev_root = 29503488,
>> dev_root_gen = 13, csum_root = 29376512, csum_root_gen = 5,
>> total_bytes = 21474836480, bytes_used = 3674767360, num_devices = 1,
>> unsed_64 = {0, 0, 0, 0}, tree_root_level = 0 '\000', chunk_root_level
>> = 0 '\000', extent_root_level = 1 '\001', fs_root_level = 1 '\001',
>> dev_root_level = 0 '\000', csum_root_level = 0 '\000', unused_8 =
>> "\000\000\000\000\000\000\000\000\000"}, {tree_root = 29405184,
>> tree_root_gen = 10, chunk_root = 20971520, chunk_root_gen = 5,
>> extent_root = 29409280, extent_root_gen = 10, fs_root = 29360128,
>> fs_root_gen = 5, dev_root = 29392896, dev_root_gen = 8, csum_root =
>> 29376512, csum_root_gen = 5, total_bytes = 21474836480, bytes_used =
>> 28672,       num_devices = 1, unsed_64 = {0, 0, 0, 0}, tree_root_level
>> = 0 '\000', chunk_root_level = 0 '\000', extent_root_level = 0 '\000',
>>       fs_root_level = 0 '\000', dev_root_level = 0 '\000',
>> csum_root_level = 0 '\000', unused_8 =
>> "\000\000\000\000\000\000\000\000\000"}, { tree_root = 29396992,
>> tree_root_gen = 11, chunk_root = 20975616, chunk_root_gen = 11,
>> extent_root = 29417472, extent_root_gen = 12, fs_root = 29401088,
>> fs_root_gen = 12, dev_root = 29372416, dev_root_gen = 11, csum_root =
>> 29376512, csum_root_gen = 5, total_bytes = 21474836480, bytes_used =
>> 2125430784, num_devices = 1, unsed_64 = {0, 0, 0, 0}, tree_root_level
>> = 0 '\000', chunk_root_level = 0 '\000', extent_root_level = 0 '\000',
>> fs_root_level = 1 '\001', dev_root_level = 0 '\000', csum_root_level =
>> 0 '\000', unused_8 = "\000\000\000\000\000\000\000\000\000"}}}
>>
>> Chunk tree:
>> chunk tree
>> leaf 20971520 items 6 free space 3283 generation 5 owner 3
>> fs uuid 3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa
>> chunk uuid a872f18c-9a34-4875-809b-eb56f400bcd1
>> 	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
>> 		dev item devid 1 gen 0 total_bytes 21474836480 bytes used 2185232384
>> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3817 itemsize 80
>> 		chunk length 4194304 owner 2 type 2 num_stripes 1
>> 			stripe 0 devid 1 offset 0
>> 	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3737 itemsize 80
>> 		chunk length 8388608 owner 2 type 4 num_stripes 1
>> 			stripe 0 devid 1 offset 4194304
>> 	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3657 itemsize 80
>> 		chunk length 8388608 owner 2 type 1 num_stripes 1
>> 			stripe 0 devid 1 offset 12582912
>> 	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 3545 itemsize 112
>> 		chunk length 8388608 owner 2 type 34 num_stripes 2
>> 			stripe 0 devid 1 offset 20971520
>> 			stripe 1 devid 1 offset 29360128
>> 	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 3433 itemsize 112
>> 		chunk length 1073741824 owner 2 type 36 num_stripes 2
>> 			stripe 0 devid 1 offset 37748736
>> 			stripe 1 devid 1 offset 1111490560
>> total bytes 21474836480
>> bytes used 3674767360
>> uuid 3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa
>>
>> both attempts to read the root block:
>> $84 = {csum = "\006\000\000\000\006\000\000\000\002\000\000\000\002\000\000\000\016\000\000\000\016\000\000\000\002\000\000\000\002\000\000",
>>  fsid = "\006\000\000\000\006\000\000\000\002\000\000\000\002\000\000",
>> bytenr = 128849018910, flags = 8589934594,  chunk_tree_uuid =
>> "\006\000\000\000\006\000\000\000\002\000\000\000\002\000\000",
>> generation = 60129542158, owner = 8589934594, nritems = 6,  level = 6
>> '\006'}
>>
>> $90 = {csum = "\aYZ9\aYZ:\aYZ;\aYZ<\aYZ=\aYZ>\aYZ?\aYZ@", fsid =
>> "\aYZA\aYZB\aYZC\aYZD", bytenr = 5069462218322106631, flags =
>> 5213577406431516935, chunk_tree_uuid = "\aYZI\aYZJ\aYZK\aYZL",
>> generation = 5645922970759747847, owner = 5790038158869158151, nritems
>> = 1364875527, level = 7 '\a'}
>>
>> btrfs-find-root output:
>> parent transid verify failed on 20971520 wanted 13 found 5
>> parent transid verify failed on 20971520 wanted 13 found 5
>> parent transid verify failed on 20971520 wanted 13 found 5
>> parent transid verify failed on 20971520 wanted 13 found 5
>> Ignoring transid failure
>> Super think's the tree root is at 29515776, chunk root 20971520
>> Well block 4194304 seems great, but generation doesn't match, have=3, want=13
>> Well block 4206592 seems great, but generation doesn't match, have=4, want=13
>> Well block 29396992 seems great, but generation doesn't match, have=11, want=13
>> Well block 29405184 seems great, but generation doesn't match, have=10, want=13
>> Well block 29425664 seems great, but generation doesn't match, have=12, want=13
>> No more metdata to scan, exiting
