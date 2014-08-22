Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34263 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbaHVIjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 04:39:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKkNR-0004Lt-6P
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 10:39:17 +0200
Received: from zmail.pkvoda.ru ([77.82.81.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 10:39:17 +0200
Received: from kamheric by zmail.pkvoda.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 10:39:17 +0200
To: linux-btrfs@vger.kernel.org
From: Mihail Zaporozhets <kamheric@gmail.com>
Subject: Re: btrfs restore
Date: Fri, 22 Aug 2014 08:39:04 +0000 (UTC)
Message-ID: <loom.20140822T100842-195@post.gmane.org>
References: <loom.20140821T061503-238@post.gmane.org> <20140822015216.GE3875@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc <at> merlins.org> writes:

> 
> On Thu, Aug 21, 2014 at 05:52:01AM +0000, Mihail Zaporozhets wrote:
> > # btrfs-zero-log /dev/sda1                         
> > warning devid 5 not found already
> > Check tree block failed, want=16845270495232, have=0
> > read block failed check_tree_block
> > Couldn't read tree root
> 
> You may be hitting the same problem I was a week back. See the thread
> that says "btrfs-zero-log fails, can't mount FS"
> 
> Download the source for btrfs-progs, and apply this patch from Chris:
> 
> diff --git a/disk-io.c b/disk-io.c
> index 8db0335..d9a8e19 100644
> --- a/disk-io.c
> +++ b/disk-io.c
>  <at>  <at>  -911,13 +911,13  <at>  <at>  int btrfs_setup_all_roots(struct
btrfs_fs_info *fs_info, u64 root_tree_bytenr,
>                         return -EIO;
>         }
>         fs_info->csum_root->track_dirty = 1;
> -
> +#if 0
>         ret = find_and_setup_log_root(root, fs_info, sb);
>         if (ret) {
>                 printk("Couldn't setup log root tree\n");
>                 return -EIO;
>         }
> -
> +#endif
>         fs_info->generation = generation;
>         fs_info->last_trans_committed = generation;
>         if (extent_buffer_uptodate(fs_info->extent_root->node) &&
> 
> Or if you're desparate and want a binary, I'll Email you one directly
> (not that you should run a binary you got from someone via Email as
> root, so it's only if you're desperate)
> 
> Marc

Thanks for answers. 
ok,
git clone git://repo.or.cz/btrfs-progs-unstable/devel.git;
make;
Do I need to patch devel's version, or it contains this changes? if no:

sudo ./btrfs-zero-log /dev/sda1
warning devid 5 not found already
Check tree block failed, want=16845270495232, have=0
read block failed check_tree_block
Couldn't read tree root

sudo btrfs-debug-tree -R /dev/sda1              
warning devid 5 not found already
Check tree block failed, want=16845270495232, have=0
read block failed check_tree_block
Couldn't read tree root

sudo ./btrfs-show-super /dev/sda1
superblock: bytenr=65536, device=/dev/sda1
---------------------------------------------------------
csum			0x9867082d [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			841f1b5c-adb2-485f-a4cf-83bbf880dced
label			
generation		59176
root			16845270495232
sys_array_size		97
chunk_root_generation	59166
root_level		2
chunk_root		11409648779264
chunk_root_level	2
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		10001983041536
bytes_used		9997613580288
sectorsize		4096
nodesize		4096
leafsize		4096
stripesize		4096
root_dir		6
num_devices		5
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x1
csum_type		0
csum_size		4
cache_generation	59176
uuid_tree_generation	59176
dev_item.uuid		1ef01e06-b355-4a17-a2c8-5623188813f9
dev_item.fsid		841f1b5c-adb2-485f-a4cf-83bbf880dced [match]
dev_item.type		0
dev_item.total_bytes	2000397885440
dev_item.bytes_used	1999324119040
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0


./btrfs --version
Btrfs v3.14.2

last dmesg :
[110290.284290] show_signal_msg: 174 callbacks suppressed                  
                          
[110290.284294] btrfs-debug-tre[6014]: segfault at e0 ip 00000000004022b0 sp
00007fffcb77d1d0 error 4 in btrfs-debug-tree[400000+27000]            
[111278.465863] btrfs-debug-tre[10907]: segfault at e0 ip 00000000004022b0
sp 00007fff856c6bd0 error 4 in btrfs-debug-tree[400000+27000]


sudo ./btrfs rescue chunk-recover -v /dev/sda1    
All Devices:
	Device: id = 4, name = /dev/sde1
	Device: id = 3, name = /dev/sdd1
	Device: id = 2, name = /dev/sdc1
	Device: id = 1, name = /dev/sda1

still waiting....
 I started this before write to mail list, but, as i remember, my pc after
one night stay fully freeze,  and had no reaction for anyone keys, and I
just reboot it at that time.


Nothing changes until this moment...

