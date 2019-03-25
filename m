Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6591BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C528C206DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="SBmZKImm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfCYXu3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:50:29 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:37071 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfCYXu3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 19:50:29 -0400
Date:   Mon, 25 Mar 2019 23:50:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553557824;
        bh=ST0nRcR1Nv/xIYZ1Tn1kwZ4AAUI2uFbzIV84kctNNB8=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=SBmZKImmmaqx3fwViIzuF/Xs+27qlf5CjchWk5dma1Xrf05+K958g8nAwdUbhYc/L
         5Hbdsif+QqmTkDZf/bprgHMCn07t21G0nYoUnz3S+APWBtOJ1Msqjco0FOtFlvfA0+
         BoLyXab425I1mXHfAU2exGTm7FRNm3CsM99Vij64=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: =?UTF-8?Q?backup_uuid=5Ftree_generation_not_consistent_across_multi_devic?=
 =?UTF-8?Q?e_(raid0)_btrfs_-_won=C2=B4t_mount?=
Message-ID: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear all, I had posted already (excuse for separate mails) that I have a co=
rrupt filesystem that would be very important to get recovered.

Please note I would really appreciate assistance and am willing to PAY for =
consultation and time.

Kernel 4.20.17
btrfs-progs 4.20.2

The filesystem consists of 4 (HW raid6) devices, each of them shows differe=
nt superblock backups but my hope is that backup 2 is "consistent" across a=
ll of them.

Is there any way to restore a specific superblock backup and attempt to mou=
nt the filesystem? Running "btrfs restore" did partially recover the data, =
but the most important bit is still missing.

See also how "generation" is different between devices 1,2 and 3,4.

Please see below output of the different devices.

My hope is that I can somehow "restore" the smallest common generation of s=
uperblock on 60232 to make the FS at least read-only mountable.


################# SDB ############

# btrfs inspect-internal dump-super -f /dev/sdb
superblock: bytenr=3D65536, device=3D/dev/sdb
---------------------------------------------------------
csum_type=09=090 (crc32c)
csum_size=09=094
csum=09=09=090xebea13e2 [match]
bytenr=09=09=0965536
flags=09=09=090x1
=09=09=09( WRITTEN )
magic=09=09=09_BHRfS_M [match]
fsid=09=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
metadata_uuid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
label=09=09=09FS1
generation=09=0960233
root=09=09=0955432745107456
sys_array_size=09=09194
chunk_root_generation=0960232
root_level=09=091
chunk_root=09=091146880
chunk_root_level=091
log_root=09=0955432747958272
log_root_transid=090
log_root_level=09=090
total_bytes=09=0995999901040640
bytes_used=09=0960378125692928
sectorsize=09=094096
nodesize=09=0916384
leafsize (deprecated)=0916384
stripesize=09=094096
root_dir=09=096
num_devices=09=094
compat_flags=09=090x0
compat_ro_flags=09=090x3
=09=09=09( FREE_SPACE_TREE |
=09=09=09  FREE_SPACE_TREE_VALID )
incompat_flags=09=090x161
=09=09=09( MIXED_BACKREF |
=09=09=09  BIG_METADATA |
=09=09=09  EXTENDED_IREF |
=09=09=09  SKINNY_METADATA )
cache_generation=0918446744073709551615
uuid_tree_generation=0960233
dev_item.uuid=09=097833ce66-ffa3-4baa-a2db-e98d5ec2e369
dev_item.fsid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
dev_item.type=09=090
dev_item.total_bytes=0923999975260160
dev_item.bytes_used=0915122592432128
dev_item.io_align=094096
dev_item.io_width=094096
dev_item.sector_size=094096
dev_item.devid=09=091
dev_item.dev_group=090
dev_item.seek_speed=090
dev_item.bandwidth=090
dev_item.generation=090
sys_chunk_array[2048]:
=09item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
=09=09length 4194304 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 4096 io_width 4096 sector_size 4096
=09=09num_stripes 1 sub_stripes 0
=09=09=09stripe 0 devid 1 offset 1048576
=09=09=09dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
=09item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
=09=09length 33554432 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 65536 io_width 65536 sector_size 4096
=09=09num_stripes 1 sub_stripes 1
=09=09=09stripe 0 devid 2 offset 15033460326400
=09=09=09dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
backup_roots[4]:
=09backup 0:
=09=09backup_tree_root:=0955432745107456=09gen: 60233=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

=09backup 1:
=09=09backup_tree_root:=0955432755216384=09gen: 60230=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432754511872=09gen: 60230=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372281278464
=09=09backup_num_devices:=094

=09backup 2:
=09=09backup_tree_root:=0955432746385408=09gen: 60231=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432738242560=09gen: 60231=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372283375616
=09=09backup_num_devices:=094

=09backup 3:
=09=09backup_tree_root:=0955432763015168=09gen: 60232=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

########### SDC ############

btrfs inspect-internal dump-super -f /dev/sdc
superblock: bytenr=3D65536, device=3D/dev/sdc
---------------------------------------------------------
csum_type=09=090 (crc32c)
csum_size=09=094
csum=09=09=090x310a7e9a [match]
bytenr=09=09=0965536
flags=09=09=090x1
=09=09=09( WRITTEN )
magic=09=09=09_BHRfS_M [match]
fsid=09=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
metadata_uuid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
label=09=09=09FS1
generation=09=0960233
root=09=09=0955432745107456
sys_array_size=09=09194
chunk_root_generation=0960232
root_level=09=091
chunk_root=09=091146880
chunk_root_level=091
log_root=09=0955432747958272
log_root_transid=090
log_root_level=09=090
total_bytes=09=0995999901040640
bytes_used=09=0960378125692928
sectorsize=09=094096
nodesize=09=0916384
leafsize (deprecated)=0916384
stripesize=09=094096
root_dir=09=096
num_devices=09=094
compat_flags=09=090x0
compat_ro_flags=09=090x3
=09=09=09( FREE_SPACE_TREE |
=09=09=09  FREE_SPACE_TREE_VALID )
incompat_flags=09=090x161
=09=09=09( MIXED_BACKREF |
=09=09=09  BIG_METADATA |
=09=09=09  EXTENDED_IREF |
=09=09=09  SKINNY_METADATA )
cache_generation=0918446744073709551615
uuid_tree_generation=0960233
dev_item.uuid=09=09bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
dev_item.fsid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
dev_item.type=09=090
dev_item.total_bytes=0923999975260160
dev_item.bytes_used=0915122613403648
dev_item.io_align=094096
dev_item.io_width=094096
dev_item.sector_size=094096
dev_item.devid=09=092
dev_item.dev_group=090
dev_item.seek_speed=090
dev_item.bandwidth=090
dev_item.generation=090
sys_chunk_array[2048]:
=09item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
=09=09length 4194304 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 4096 io_width 4096 sector_size 4096
=09=09num_stripes 1 sub_stripes 0
=09=09=09stripe 0 devid 1 offset 1048576
=09=09=09dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
=09item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
=09=09length 33554432 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 65536 io_width 65536 sector_size 4096
=09=09num_stripes 1 sub_stripes 1
=09=09=09stripe 0 devid 2 offset 15033460326400
=09=09=09dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
backup_roots[4]:
=09backup 0:
=09=09backup_tree_root:=0955432745107456=09gen: 60233=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

=09backup 1:
=09=09backup_tree_root:=0955432755216384=09gen: 60230=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432754511872=09gen: 60230=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372281278464
=09=09backup_num_devices:=094

=09backup 2:
=09=09backup_tree_root:=0955432746385408=09gen: 60231=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432738242560=09gen: 60231=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372283375616
=09=09backup_num_devices:=094

=09backup 3:
=09=09backup_tree_root:=0955432763015168=09gen: 60232=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

########### SDD ##########

btrfs inspect-internal dump-super -f /dev/sdd
superblock: bytenr=3D65536, device=3D/dev/sdd
---------------------------------------------------------
csum_type=09=090 (crc32c)
csum_size=09=094
csum=09=09=090x56f1abb4 [match]
bytenr=09=09=0965536
flags=09=09=090x1
=09=09=09( WRITTEN )
magic=09=09=09_BHRfS_M [match]
fsid=09=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
metadata_uuid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
label=09=09=09FS1
generation=09=0960234
root=09=09=0955432766062592
sys_array_size=09=09194
chunk_root_generation=0960234
root_level=09=091
chunk_root=09=091048576
chunk_root_level=091
log_root=09=090
log_root_transid=090
log_root_level=09=090
total_bytes=09=0995999901040640
bytes_used=09=0960382615777280
sectorsize=09=094096
nodesize=09=0916384
leafsize (deprecated)=0916384
stripesize=09=094096
root_dir=09=096
num_devices=09=094
compat_flags=09=090x0
compat_ro_flags=09=090x3
=09=09=09( FREE_SPACE_TREE |
=09=09=09  FREE_SPACE_TREE_VALID )
incompat_flags=09=090x161
=09=09=09( MIXED_BACKREF |
=09=09=09  BIG_METADATA |
=09=09=09  EXTENDED_IREF |
=09=09=09  SKINNY_METADATA )
cache_generation=0918446744073709551615
uuid_tree_generation=0960234
dev_item.uuid=09=09cc6e5f1c-081c-441f-9634-6908164e1375
dev_item.fsid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
dev_item.type=09=090
dev_item.total_bytes=0923999975260160
dev_item.bytes_used=0915123653591040
dev_item.io_align=094096
dev_item.io_width=094096
dev_item.sector_size=094096
dev_item.devid=09=093
dev_item.dev_group=090
dev_item.seek_speed=090
dev_item.bandwidth=090
dev_item.generation=090
sys_chunk_array[2048]:
=09item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
=09=09length 4194304 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 4096 io_width 4096 sector_size 4096
=09=09num_stripes 1 sub_stripes 0
=09=09=09stripe 0 devid 1 offset 1048576
=09=09=09dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
=09item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
=09=09length 33554432 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 65536 io_width 65536 sector_size 4096
=09=09num_stripes 1 sub_stripes 1
=09=09=09stripe 0 devid 2 offset 15033460326400
=09=09=09dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
backup_roots[4]:
=09backup 0:
=09=09backup_tree_root:=0955432745107456=09gen: 60233=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

=09backup 1:
=09=09backup_tree_root:=0955432766062592=09gen: 60234=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60234=09level: 1
=09=09backup_extent_root:=0955432746352640=09gen: 60234=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432755789824=09gen: 60234=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960382615777280
=09=09backup_num_devices:=094

=09backup 2:
=09=09backup_tree_root:=0955432746385408=09gen: 60231=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432738242560=09gen: 60231=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372283375616
=09=09backup_num_devices:=094

=09backup 3:
=09=09backup_tree_root:=0955432763015168=09gen: 60232=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

####### SDE #######

 btrfs inspect-internal dump-super -f /dev/sde
superblock: bytenr=3D65536, device=3D/dev/sde
---------------------------------------------------------
csum_type=09=090 (crc32c)
csum_size=09=094
csum=09=09=090x6fcc7a25 [match]
bytenr=09=09=0965536
flags=09=09=090x1
=09=09=09( WRITTEN )
magic=09=09=09_BHRfS_M [match]
fsid=09=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
metadata_uuid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
label=09=09=09FS1
generation=09=0960234
root=09=09=0955432766062592
sys_array_size=09=09194
chunk_root_generation=0960234
root_level=09=091
chunk_root=09=091048576
chunk_root_level=091
log_root=09=090
log_root_transid=090
log_root_level=09=090
total_bytes=09=0995999901040640
bytes_used=09=0960382615777280
sectorsize=09=094096
nodesize=09=0916384
leafsize (deprecated)=0916384
stripesize=09=094096
root_dir=09=096
num_devices=09=094
compat_flags=09=090x0
compat_ro_flags=09=090x3
=09=09=09( FREE_SPACE_TREE |
=09=09=09  FREE_SPACE_TREE_VALID )
incompat_flags=09=090x161
=09=09=09( MIXED_BACKREF |
=09=09=09  BIG_METADATA |
=09=09=09  EXTENDED_IREF |
=09=09=09  SKINNY_METADATA )
cache_generation=0918446744073709551615
uuid_tree_generation=0960234
dev_item.uuid=09=09d97063ad-078a-44b5-ae47-4f0f9f9755f9
dev_item.fsid=09=098b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd [match]
dev_item.type=09=090
dev_item.total_bytes=0923999975260160
dev_item.bytes_used=0915123653591040
dev_item.io_align=094096
dev_item.io_width=094096
dev_item.sector_size=094096
dev_item.devid=09=094
dev_item.dev_group=090
dev_item.seek_speed=090
dev_item.bandwidth=090
dev_item.generation=090
sys_chunk_array[2048]:
=09item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
=09=09length 4194304 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 4096 io_width 4096 sector_size 4096
=09=09num_stripes 1 sub_stripes 0
=09=09=09stripe 0 devid 1 offset 1048576
=09=09=09dev_uuid 7833ce66-ffa3-4baa-a2db-e98d5ec2e369
=09item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 60713713270784)
=09=09length 33554432 owner 2 stripe_len 65536 type SYSTEM
=09=09io_align 65536 io_width 65536 sector_size 4096
=09=09num_stripes 1 sub_stripes 1
=09=09=09stripe 0 devid 2 offset 15033460326400
=09=09=09dev_uuid bb5e99fe-3beb-44f3-a6e0-43395ddfcd84
backup_roots[4]:
=09backup 0:
=09=09backup_tree_root:=0955432745107456=09gen: 60233=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

=09backup 1:
=09=09backup_tree_root:=0955432766062592=09gen: 60234=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60234=09level: 1
=09=09backup_extent_root:=0955432746352640=09gen: 60234=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432755789824=09gen: 60234=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960382615777280
=09=09backup_num_devices:=094

=09backup 2:
=09=09backup_tree_root:=0955432746385408=09gen: 60231=09level: 1
=09=09backup_chunk_root:=091048576=09gen: 60230=09level: 1
=09=09backup_extent_root:=0955432738242560=09gen: 60231=09level: 3
=09=09backup_fs_root:=09=0955432756281344=09gen: 60231=09level: 2
=09=09backup_dev_root:=0955432755625984=09gen: 60230=09level: 1
=09=09backup_csum_root:=0955432750727168=09gen: 60230=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960372283375616
=09=09backup_num_devices:=094

=09backup 3:
=09=09backup_tree_root:=0955432763015168=09gen: 60232=09level: 1
=09=09backup_chunk_root:=091146880=09gen: 60232=09level: 1
=09=09backup_extent_root:=0955432763981824=09gen: 60233=09level: 3
=09=09backup_fs_root:=09=0955432763850752=09gen: 60233=09level: 2
=09=09backup_dev_root:=0955432753725440=09gen: 60232=09level: 1
=09=09backup_csum_root:=0955432764342272=09gen: 60233=09level: 0
=09=09backup_total_bytes:=0995999901040640
=09=09backup_bytes_used:=0960378125692928
=09=09backup_num_devices:=094

###########################

