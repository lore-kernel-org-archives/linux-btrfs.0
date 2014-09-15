Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57276 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbaIOVl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 17:41:59 -0400
Received: by mail-la0-f48.google.com with SMTP id ty20so5487047lab.21
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 14:41:57 -0700 (PDT)
MIME-Version: 1.0
From: Tony Murray <murraytony@gmail.com>
Date: Mon, 15 Sep 2014 21:41:37 +0000
Message-ID: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com>
Subject: unable to mount, tools segfault
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I started up my computer today to an unmountable rootfs.

I was able to get some recovery media that has kernel 3.16.0 and
btrfsprogs 3.16.0.

I cannot get any of the recovery tools to do anything and some segfault.


# mount -o ro,recovery /dev/sda7 /mnt/sda7/
mount: wrong fs type, bad option, bad superblock on /dev/sda7,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg|tail
[ 6982.556502] BTRFS info (device sda7): enabling auto recovery
[ 6982.556509] BTRFS info (device sda7): disk space caching is enabled
[ 6982.558519] BTRFS: bad tree block start 0 688963584
[ 6982.558592] BTRFS: bad tree block start 0 688963584
[ 6982.558668] BTRFS: bad tree block start 0 688783360
[ 6982.558676] BTRFS: failed to read tree root on sda7
[ 6982.558746] BTRFS: bad tree block start 0 686161920
[ 6982.558752] BTRFS: failed to read tree root on sda7
[ 6982.558959] parent transid verify failed on 685129728 wanted 7493 found 7495
[ 6982.558962] BTRFS: failed to read tree root on sda7
[ 6982.586002] BTRFS: open_ctree failed




# btrfs-find-root /dev/sda7
Super think's the tree root is at 689520640, chunk root 147456
Found tree root at 689520640 gen 7496 level 0



# btrfs-show-super /dev/sda7
superblock: bytenr=65536, device=/dev/sda7
---------------------------------------------------------
csum 0x87b4f44b [match]
bytenr 65536
flags 0x1
magic _BHRfS_M [match]
fsid 5bcbb7e4-ec95-41dc-bc72-b5532662efb2
label
generation 7496
root 689520640
sys_array_size 97
chunk_root_generation 6479
root_level 0
chunk_root 147456
chunk_root_level 0
log_root 687718400
log_root_transid 0
log_root_level 0
total_bytes 55624859648
bytes_used 18957094912
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x69
csum_type 0
csum_size 4
cache_generation 7496
uuid_tree_generation 294
dev_item.uuid 108f8602-5f7d-45bd-a6d2-dc6176155bb8
dev_item.fsid 5bcbb7e4-ec95-41dc-bc72-b5532662efb2 [match]
dev_item.type 0
dev_item.total_bytes 55624859648
dev_item.bytes_used 29012000768
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0



# btrfsck --repair /dev/sda7
enabling repair mode
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
read block failed check_tree_block
Couldn't setup log root tree
Checking filesystem on /dev/sda7
UUID: 5bcbb7e4-ec95-41dc-bc72-b5532662efb2
Critical roots corrupted, unable to fsck the FS
Segmentation fault


# btrfs restore -v -i /dev/sda7 /mnt/sdb1/
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
read block failed check_tree_block
Couldn't setup log root tree
Check tree block failed, want=686931968, have=0
Check tree block failed, want=686931968, have=0
Check tree block failed, want=686931968, have=0
read block failed check_tree_block
Couldn't read fs root: -5

Pretty much all tools fail similarly.  Is there anyway to recover
this?  I just spent several days getting this computer set up and
would not like to spend that much time a second time.  If I could pull
some files from the fs, that could speed up my reinstall
siginificantly.

Also, if I can't even recover files from btrfs I'm pretty sure I will
not be using btrfs on the rebuild, that's just silly.

Thanks.  FYI, probably have less than a day before I blow away the fs
and start over.
