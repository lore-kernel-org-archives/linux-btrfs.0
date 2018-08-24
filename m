Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:44168 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725735AbeHXFjq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 01:39:46 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9FECAAC020D
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2018 11:07:15 +0900 (JST)
Subject: Re: fs/btrfs/volumes.c:6114 suspicious rcu_dereference_check() usage!
To: David Howells <dhowells@redhat.com>
CC: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <22614.1535039351@warthog.procyon.org.uk>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <450873e0-2a8a-d757-4c68-f24e6a0466a1@jp.fujitsu.com>
Date: Fri, 24 Aug 2018 11:07:00 +0900
MIME-Version: 1.0
In-Reply-To: <22614.1535039351@warthog.procyon.org.uk>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/24 0:49, David Howells wrote:
> I'm seeing the attached message generated from this line:
> 
> 	btrfs_debug_in_rcu(fs_info,
> 	"btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
> 		bio_op(bio), bio->bi_opf, (u64)bio->bi_iter.bi_sector,
> 		(u_long)dev->bdev->bd_dev, rcu_str_deref(dev->name), dev->devid,
> 		bio->bi_iter.bi_size);
> 
> in submit_stripe_bio().  I'm not sure exactly why, but I suspect
> rcu_str_deref() is the point from where it is generated.
> 
> Note that the mount succeeds.
> 
> This code was introduced by:
> 
> 	commit 672d599041c862dd61a1576c32e946ef0d77aa34
> 	Author: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> 	Date:   Thu Aug 2 16:19:07 2018 +0900
> 


Thanks for the reporting.
I didn't turn on CONFIG_PROVE_RCU and missed the warning.

I will send a fix.

Thanks,
Misono

> David
> ---
> =============================
> WARNING: suspicious RCU usage
> 4.18.0-fscache+ #540 Not tainted
> -----------------------------
> fs/btrfs/volumes.c:6114 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by mount/3194:
>  #0: 0000000072604777 (&fc->fs_type->s_umount_key#54/1){+.+.}, at: alloc_super+0xa4/0x313
> 
> stack backtrace:
> CPU: 2 PID: 3194 Comm: mount Not tainted 4.18.0-fscache+ #540
> Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
> Call Trace:
>  dump_stack+0x67/0x8e
>  btrfs_map_bio+0x282/0x321
>  btree_submit_bio_hook+0x71/0xa6
>  submit_one_bio+0x55/0x66
>  read_extent_buffer_pages+0x1ec/0x2ab
>  btree_read_extent_buffer_pages+0x6e/0x237
>  ? alloc_extent_buffer+0x28f/0x2f2
>  read_tree_block+0x43/0x5e
>  open_ctree+0x139b/0x1ee4
>  btrfs_get_tree+0x357/0xa33
>  ? selinux_fs_context_dup+0x2d/0x104
>  vfs_get_tree+0x7a/0x162
>  btrfs_mount_root+0x52/0x8b
>  btrfs_get_tree+0x4ab/0xa33
>  ? vfs_parse_fs_string+0x5b/0x9e
>  vfs_get_tree+0x7a/0x162
>  do_mount+0x7f0/0x8b2
>  ? memdup_user+0x3e/0x5a
>  ksys_mount+0x72/0x97
>  __x64_sys_mount+0x21/0x24
>  do_syscall_64+0x7d/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f11b8365ada
> Code: 48 8b 0d c9 a3 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 96 a3 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffe0d9a5b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00005562bf7702a0 RCX: 00007f11b8365ada
> RDX: 00005562bf77a620 RSI: 00005562bf7704a0 RDI: 00005562bf770480
> RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f11b8620c40
> R10: 00000000c0ed0000 R11: 0000000000000246 R12: 00005562bf770480
> R13: 00005562bf77a620 R14: 0000000000000000 R15: 00007f11b90f9184
> 
> 
