Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.visageimaging.com ([80.150.143.228]:45532 "EHLO
        mail.visageimaging.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753241AbcHWPxn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 11:53:43 -0400
From: Malte Westerhoff <MWesterhoff@visageimaging.com>
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs partition fails to mount after power outage
Date: Tue, 23 Aug 2016 15:51:19 +0000
Message-ID: <E80D3AE3-69A9-40E7-9946-D2F66214828B@visageimaging.com>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
 <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com>
 <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com>
 <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
In-Reply-To: <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

    >>     btrfs-show-super -fa /dev/mapper/VGBIGRAID6-DATA1
    
>    Where is this output?

I had attached it as a separate file. Here it is again:

superblock: bytenr=65536, device=/dev/mapper/VGBIGRAID6-DATA1
---------------------------------------------------------
csum			0xd6fc94ec [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2
label			
generation		52059
root			3421559472128
sys_array_size		226
chunk_root_generation	52005
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		17592186044416
bytes_used		7386753196032
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x163
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	52059
uuid_tree_generation	52059
dev_item.uuid		4e582c98-ccfc-4740-8e59-a1cb1cbfca56
dev_item.fsid		0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2 [match]
dev_item.type		0
dev_item.total_bytes	17592186044416
dev_item.bytes_used	7661185662976
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
		chunk length 4194304 owner 2 type SYSTEM num_stripes 1
			stripe 0 devid 1 offset 0
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
		chunk length 8388608 owner 2 type SYSTEM|DUP num_stripes 2
			stripe 0 devid 1 offset 20971520
			stripe 1 devid 1 offset 29360128
backup_roots[4]:
	backup 0:
		backup_tree_root:	3421559472128	gen: 52059	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	3421770170368	gen: 52059	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7304828502016	gen: 52059	level: 1
		backup_csum_root:	7315970588672	gen: 52059	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753196032
		backup_num_devices:	1

	backup 1:
		backup_tree_root:	7442297503744	gen: 52056	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442294161408	gen: 52056	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442298175488	gen: 52056	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753163264
		backup_num_devices:	1

	backup 2:
		backup_tree_root:	7442289229824	gen: 52057	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442283692032	gen: 52057	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442294063104	gen: 52057	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1

	backup 3:
		backup_tree_root:	7442297503744	gen: 52058	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442284920832	gen: 52058	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442299355136	gen: 52058	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1


superblock: bytenr=67108864, device=/dev/mapper/VGBIGRAID6-DATA1
---------------------------------------------------------
csum			0x69cac6a6 [match]
bytenr			67108864
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2
label			
generation		52058
root			7442297503744
sys_array_size		226
chunk_root_generation	52005
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		17592186044416
bytes_used		7386753179648
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x163
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	52058
uuid_tree_generation	52058
dev_item.uuid		4e582c98-ccfc-4740-8e59-a1cb1cbfca56
dev_item.fsid		0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2 [match]
dev_item.type		0
dev_item.total_bytes	17592186044416
dev_item.bytes_used	7661185662976
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
		chunk length 4194304 owner 2 type SYSTEM num_stripes 1
			stripe 0 devid 1 offset 0
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
		chunk length 8388608 owner 2 type SYSTEM|DUP num_stripes 2
			stripe 0 devid 1 offset 20971520
			stripe 1 devid 1 offset 29360128
backup_roots[4]:
	backup 0:
		backup_tree_root:	7442297978880	gen: 52055	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442297290752	gen: 52055	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442298601472	gen: 52055	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753163264
		backup_num_devices:	1

	backup 1:
		backup_tree_root:	7442297503744	gen: 52056	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442294161408	gen: 52056	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442298175488	gen: 52056	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753163264
		backup_num_devices:	1

	backup 2:
		backup_tree_root:	7442289229824	gen: 52057	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442283692032	gen: 52057	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442294063104	gen: 52057	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1

	backup 3:
		backup_tree_root:	7442297503744	gen: 52058	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442284920832	gen: 52058	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442299355136	gen: 52058	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1


superblock: bytenr=274877906944, device=/dev/mapper/VGBIGRAID6-DATA1
---------------------------------------------------------
csum			0x944d9097 [match]
bytenr			274877906944
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2
label			
generation		52058
root			7442297503744
sys_array_size		226
chunk_root_generation	52005
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		17592186044416
bytes_used		7386753179648
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x163
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	52058
uuid_tree_generation	52058
dev_item.uuid		4e582c98-ccfc-4740-8e59-a1cb1cbfca56
dev_item.fsid		0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2 [match]
dev_item.type		0
dev_item.total_bytes	17592186044416
dev_item.bytes_used	7661185662976
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
		chunk length 4194304 owner 2 type SYSTEM num_stripes 1
			stripe 0 devid 1 offset 0
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
		chunk length 8388608 owner 2 type SYSTEM|DUP num_stripes 2
			stripe 0 devid 1 offset 20971520
			stripe 1 devid 1 offset 29360128
backup_roots[4]:
	backup 0:
		backup_tree_root:	7442297978880	gen: 52055	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442297290752	gen: 52055	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442298601472	gen: 52055	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753163264
		backup_num_devices:	1

	backup 1:
		backup_tree_root:	7442297503744	gen: 52056	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442294161408	gen: 52056	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442298175488	gen: 52056	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753163264
		backup_num_devices:	1

	backup 2:
		backup_tree_root:	7442289229824	gen: 52057	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442283692032	gen: 52057	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442294063104	gen: 52057	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1

	backup 3:
		backup_tree_root:	7442297503744	gen: 52058	level: 1
		backup_chunk_root:	20971520	gen: 52005	level: 1
		backup_extent_root:	7442284920832	gen: 52058	level: 3
		backup_fs_root:		29556736	gen: 6	level: 0
		backup_dev_root:	7254075654144	gen: 52005	level: 1
		backup_csum_root:	7442299355136	gen: 52058	level: 3
		backup_total_bytes:	17592186044416
		backup_bytes_used:	7386753179648
		backup_num_devices:	1



    

On 8/23/16, 5:45 PM, "chris@colorremedies.com on behalf of Chris Murphy" <chris@colorremedies.com on behalf of lists@colorremedies.com> wrote:

    On Tue, Aug 23, 2016 at 9:19 AM, Malte Westerhoff
    <MWesterhoff@visageimaging.com> wrote:
    > Hi Chris,
    > Thanks for the response.
    > Yes, there is one large raid6 on which there is one LVM physical volume, which has four logical volumes that each have a btrfs file system.
    > Only one of them fails to mount, the other three are fine (data2...4).
    > The RAID itself claims to be clean (see below).
    >
    > Output of btrfs-show-super attached.
    >
    > btrfs-find-root is running now for 30 minutes. It has produced the following output so far (but is still running ‚Äì not sure whether it is hanging or will eventually terminate).
    >
    > quickstore2:~/btrfs-progs # ./btrfs-find-root  /dev/mapper/VGBIGRAID6-DATA1
    > parent transid verify failed on 7375769206784 wanted 52059 found 52028
    > parent transid verify failed on 7375769206784 wanted 52059 found 52028
    > parent transid verify failed on 7375769206784 wanted 52059 found 52028
    > parent transid verify failed on 7375769206784 wanted 52059 found 52028
    > Ignoring transid failure
    > leaf parent key incorrect 7375769206784
    > Superblock thinks the generation is 52059
    > Superblock thinks the level is 1
    
    
    Huh. Well someone who knows more about Btrfs and devices doing the
    wrong thing will have to speak up. To me this looks like something got
    the commit order wrong, where the superblock has a more recent
    generation than any tree generation, as if the metadata for generation
    52059 (or even 52058, 52057, or 52056) is not written or not where
    it's supposed to be, and yet the superblock was updated.
    
    
    >>     btrfs-show-super -fa /dev/mapper/VGBIGRAID6-DATA1
    
    Where is this output?
    
    
    
    -- 
    Chris Murphy
    

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
