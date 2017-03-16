Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:42541 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdCPMjo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 08:39:44 -0400
From: "=?gb18030?B?ut+637n+utk=?=" <fl0621@vip.qq.com>
To: "=?gb18030?B?bGludXgtYnRyZnM=?=" <linux-btrfs@vger.kernel.org>
Subject: help!!! error when mount a btrfs file system
Mime-Version: 1.0
Content-Type: text/plain;
        charset="gb18030"
Date: Thu, 16 Mar 2017 20:39:40 +0800
Message-ID: <tencent_2A12039E5636D6717B4BBE83@qq.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi, buddy

   I have a file server with btrfs file system, it's work well for several months.

but after last system reboot, the /dev/sdb become not mountable.

below is the details.   is there any advise?


######Version info
Fedora 25 Server
Kernel 4.9.13-201.fc25.x86_64
btrfs-progs v4.6.1

#####error messages when mount
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
missing codepage or helper program, or other error

In some cases useful info is found in syslog - try
dmesg | tail or so.

######dmesg |tail
[79570.756871] BTRFS error (device sdb): parent transid verify failed on 21413888 wanted 755660 found 623605
[79570.762307] BTRFS error (device sdb): bad tree block start 0 21413888
[79570.762345] BTRFS error (device sdb): failed to read chunk tree: -5
[79570.778129] BTRFS error (device sdb): open_ctree failed
[79589.743772] BTRFS error (device sdb): support for check_integrity* not compiled in!
[79589.803176] BTRFS error (device sdb): open_ctree failed

######btrfsck 
parent transid verify failed on 21413888 wanted 755660 found 623605
parent transid verify failed on 21413888 wanted 755660 found 623605
checksum verify failed on 21413888 found E4E3BDB6 wanted 00000000
parent transid verify failed on 21413888 wanted 755660 found 623605
Ignoring transid failure
checksum verify failed on 21331968 found E4E3BDB6 wanted 00000000
checksum verify failed on 21331968 found E4E3BDB6 wanted 00000000
checksum verify failed on 21692416 found E4E3BDB6 wanted 00000000
checksum verify failed on 21692416 found E4E3BDB6 wanted 00000000
checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=22888448, have=0
Couldn't read chunk tree
Couldn't open file system

######btrfs-find-root
parent transid verify failed on 21413888 wanted 755660 found 623605
parent transid verify failed on 21413888 wanted 755660 found 623605
parent transid verify failed on 21413888 wanted 755660 found 623605
Ignoring transid failure
Couldn't read chunk tree
ERROR: open ctree failed

######btrfs-show-super -a /dev/sdb 
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum 0xb6f3ccb1 [match]
bytenr 65536
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
label samba_fs
generation 770740
root 16187774615552
sys_array_size 355
chunk_root_generation 755799
root_level 1
chunk_root 24331161698304
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 23999996231680
bytes_used 22205028102144
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x169
( MIXED_BACKREF |
COMPRESS_LZO |
BIG_METADATA |
EXTENDED_IREF |
SKINNY_METADATA )
csum_type 0
csum_size 4
cache_generation 770740
uuid_tree_generation 770740
dev_item.uuid dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
dev_item.fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
dev_item.type 0
dev_item.total_bytes 23999996231680
dev_item.bytes_used 23274943676416
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=67108864, device=/dev/sdb
---------------------------------------------------------
csum 0x1692e47f [match]
bytenr 67108864
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
label samba_fs
generation 770740
root 16187774615552
sys_array_size 355
chunk_root_generation 755799
root_level 1
chunk_root 24331161698304
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 23999996231680
bytes_used 22205028102144
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x169
( MIXED_BACKREF |
COMPRESS_LZO |
BIG_METADATA |
EXTENDED_IREF |
SKINNY_METADATA )
csum_type 0
csum_size 4
cache_generation 770740
uuid_tree_generation 770740
dev_item.uuid dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
dev_item.fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
dev_item.type 0
dev_item.total_bytes 23999996231680
dev_item.bytes_used 23274943676416
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=274877906944, device=/dev/sdb
---------------------------------------------------------
csum 0xeb15b24e [match]
bytenr 274877906944
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
label samba_fs
generation 770740
root 16187774615552
sys_array_size 355
chunk_root_generation 755799
root_level 1
chunk_root 24331161698304
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 23999996231680
bytes_used 22205028102144
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x169
( MIXED_BACKREF |
COMPRESS_LZO |
BIG_METADATA |
EXTENDED_IREF |
SKINNY_METADATA )
csum_type 0
csum_size 4
cache_generation 770740
uuid_tree_generation 770740
dev_item.uuid dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
dev_item.fsid 7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
dev_item.type 0
dev_item.total_bytes 23999996231680
dev_item.bytes_used 23274943676416
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0




------------------


Best Regards
Denny LeeˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
