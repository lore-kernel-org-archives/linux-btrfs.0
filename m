Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:45778 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEHNG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 09:06:26 -0400
Received: by mail-vc0-f182.google.com with SMTP id la4so3277123vcb.27
        for <linux-btrfs@vger.kernel.org>; Thu, 08 May 2014 06:06:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 May 2014 13:06:25 +0000
Message-ID: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
Subject: Unable to mount filesystem
From: Chris Korent <ckorent@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This seemed to happen after a power failure. I rebooted and the FS was
mounted, but read-only and there were some errors (journalctl not able
to start. I did not capture all the errors). I rebooted again and then
it wouldn't mount at all. Is there anything else I can do?

uname -a
Linux sysresccd 3.10.35-std420-amd64 #2 SMP Wed Apr 2 18:31:51 UTC
2014 x86_64 Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz GenuineIntel
GNU/Linux

btrfs --version
Btrfs v3.14.1

btrfs fi show
Label: 'ROOT'  uuid: c3117347-03eb-4746-9981-814a32749785
Total devices 1 FS bytes used 605.88GiB
devid    1 size 913.00GiB used 754.06GiB path /dev/mapper/vg_crypt-lv_root

Btrfs v3.14.1

When I try to mount:
mount -o recovery /dev/mapper/vg_crypt-lv_root /mnt/frog
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/vg_crypt-lv_root,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

Output in dmesg:
[76286.328518] device label ROOT devid 1 transid 562914
/dev/mapper/vg_crypt-lv_root
[76286.329709] btrfs: enabling auto recovery
[76286.329714] btrfs: disk space caching is enabled
[76286.336555] btrfs bad tree block start 142638070361910812 1107795361792
[76286.336641] btrfs bad tree block start 142638070361910812 1107795361792
[76286.336734] btrfs bad tree block start 142638070361910812 1107795361792
[76286.336945] btrfs bad tree block start 142638070361910812 1107795361792
[76286.337057] btrfs bad tree block start 142638070361910812 1107791572992
[76286.337184] btrfs bad tree block start 142638070361910812 1107791572992
[76286.337198] btrfs: failed to read tree root on dm-2
[76286.337301] btrfs bad tree block start 142638070361910812 1107768221696
[76286.337399] btrfs bad tree block start 142638070361910812 1107768221696
[76286.337409] btrfs: failed to read tree root on dm-2
[76286.337605] parent transid verify failed on 1107746967552 wanted
562911 found 562914
[76286.337812] parent transid verify failed on 1107746967552 wanted
562911 found 562914
[76286.337818] btrfs: failed to read tree root on dm-2
[76286.352774] btrfs: open_ctree failed

btrfs-find-root /dev/mapper/vg_crypt-lv_root
Super think's the tree root is at 1107748114432, chunk root 1621341777920
Went past the fs size, exiting#

This shows 3 bad chunks
btrfs rescue chunk-recover -v /dev/mapper/vg_crypt-lv_root
---SNIP---
Bad Chunks:
  Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 0
      Block Group: start = 0, len = 4194304, flag = 2
      No device extent.
  Chunk: start = 4194304, len = 8388608, type = 4, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 4194304
      Block Group: start = 4194304, len = 8388608, flag = 4
      No device extent.
  Chunk: start = 12582912, len = 8388608, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 12582912
      No block group.
      No device extent.

Total Chunks: 758
  Heathy: 755
  Bad: 3

Orphan Block Groups:

Orphan Device Extents:
Fail to recover the chunk tree.

btrfsck does not run
btrfsck /dev/mapper/vg_crypt-lv_root
Check tree block failed, want=1107795361792, have=142638070361910812
Check tree block failed, want=1107795361792, have=142638070361910812
Check tree block failed, want=1107795361792, have=142638070361910812
Check tree block failed, want=1107795361792, have=142638070361910812
Check tree block failed, want=1107795361792, have=142638070361910812
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=1107745558528, have=142638070361910812
Check tree block failed, want=1107745558528, have=142638070361910812
Check tree block failed, want=1107745558528, have=142638070361910812
Check tree block failed, want=1107745558528, have=142638070361910812
Check tree block failed, want=1107745558528, have=142638070361910812
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=1107795329024, have=142638070361910812
Check tree block failed, want=1107795329024, have=142638070361910812
Check tree block failed, want=1107795329024, have=142638070361910812
Check tree block failed, want=1107795329024, have=142638070361910812
Check tree block failed, want=1107795329024, have=142638070361910812
read block failed check_tree_block
Checking filesystem on /dev/mapper/vg_crypt-lv_root
UUID: c3117347-03eb-4746-9981-814a32749785
Critical roots corrupted, unable to fsck the FS

btrfs rescue super-recover -v /dev/mapper/vg_crypt-lv_root
All Devices:
Device: id = 1, name = /dev/mapper/vg_crypt-lv_root

Before Recovering:
[All good supers]:
device name = /dev/mapper/vg_crypt-lv_root
superblock bytenr = 65536

device name = /dev/mapper/vg_crypt-lv_root
superblock bytenr = 67108864

device name = /dev/mapper/vg_crypt-lv_root
superblock bytenr = 274877906944

[All bad supers]:

All supers are valid, no need to recover

btrfs-show-super -a /dev/mapper/vg_crypt-lv_root
superblock: bytenr=65536, device=/dev/mapper/vg_crypt-lv_root
---------------------------------------------------------
csum 0x808ef02b [match]
bytenr 65536
flags 0x1
magic _BHRfS_M [match]
fsid c3117347-03eb-4746-9981-814a32749785
label ROOT
generation 562914
root 1107748114432
sys_array_size 129
chunk_root_generation 562226
root_level 1
chunk_root 1621341777920
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 980326285312
bytes_used 650558619648
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0xb
csum_type 0
csum_size 4
cache_generation 562914
uuid_tree_generation 108092
dev_item.uuid 5c783feb-181c-4bb5-b0af-3c4899c5228f
dev_item.fsid c3117347-03eb-4746-9981-814a32749785 [match]
dev_item.type 0
dev_item.total_bytes 980326285312
dev_item.bytes_used 809668444160
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=67108864, device=/dev/mapper/vg_crypt-lv_root
---------------------------------------------------------
csum 0x20efd8e5 [match]
bytenr 67108864
flags 0x1
magic _BHRfS_M [match]
fsid c3117347-03eb-4746-9981-814a32749785
label ROOT
generation 562914
root 1107748114432
sys_array_size 129
chunk_root_generation 562226
root_level 1
chunk_root 1621341777920
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 980326285312
bytes_used 650558619648
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0xb
csum_type 0
csum_size 4
cache_generation 562914
uuid_tree_generation 108092
dev_item.uuid 5c783feb-181c-4bb5-b0af-3c4899c5228f
dev_item.fsid c3117347-03eb-4746-9981-814a32749785 [match]
dev_item.type 0
dev_item.total_bytes 980326285312
dev_item.bytes_used 809668444160
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=274877906944, device=/dev/mapper/vg_crypt-lv_root
---------------------------------------------------------
csum 0xdd688ed4 [match]
bytenr 274877906944
flags 0x1
magic _BHRfS_M [match]
fsid c3117347-03eb-4746-9981-814a32749785
label ROOT
generation 562914
root 1107748114432
sys_array_size 129
chunk_root_generation 562226
root_level 1
chunk_root 1621341777920
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 980326285312
bytes_used 650558619648
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0xb
csum_type 0
csum_size 4
cache_generation 562914
uuid_tree_generation 108092
dev_item.uuid 5c783feb-181c-4bb5-b0af-3c4899c5228f
dev_item.fsid c3117347-03eb-4746-9981-814a32749785 [match]
dev_item.type 0
dev_item.total_bytes 980326285312
dev_item.bytes_used 809668444160
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

Thanks,
Chris
