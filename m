Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbeDRUuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 16:50:08 -0400
Date: Wed, 18 Apr 2018 22:47:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, osandov@osandov.com, jeffm@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Fix race condition between delayed refs and
 blockgroup removal
Message-ID: <20180418204735.GU21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524033714-20063-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524033714-20063-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 09:41:54AM +0300, Nikolay Borisov wrote:
> When the delayed refs for a head are all run, eventually
> cleanup_ref_head is called which (in case of deletion) obtains a
> reference for the relevant btrfs_space_info struct by querying the bg
> for the range. This is problematic because when the last extent of a
> bg is deleted a race window emerges between removal of that bg and the
> subsequent invocation of cleanup_ref_head. This can result in cache being null
> and either a null pointer dereference or assertion failure.
> 
> 	task: ffff8d04d31ed080 task.stack: ffff9e5dc10cc000
> 	RIP: 0010:assfail.constprop.78+0x18/0x1a [btrfs]
> 	RSP: 0018:ffff9e5dc10cfbe8 EFLAGS: 00010292
> 	RAX: 0000000000000044 RBX: 0000000000000000 RCX: 0000000000000000
> 	RDX: ffff8d04ffc1f868 RSI: ffff8d04ffc178c8 RDI: ffff8d04ffc178c8
> 	RBP: ffff8d04d29e5ea0 R08: 00000000000001f0 R09: 0000000000000001
> 	R10: ffff9e5dc0507d58 R11: 0000000000000001 R12: ffff8d04d29e5ea0
> 	R13: ffff8d04d29e5f08 R14: ffff8d04efe29b40 R15: ffff8d04efe203e0
> 	FS:  00007fbf58ead500(0000) GS:ffff8d04ffc00000(0000) knlGS:0000000000000000
> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	CR2: 00007fe6c6975648 CR3: 0000000013b2a000 CR4: 00000000000006f0
> 	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 	DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 	Call Trace:
> 	 __btrfs_run_delayed_refs+0x10e7/0x12c0 [btrfs]
> 	 btrfs_run_delayed_refs+0x68/0x250 [btrfs]
> 	 btrfs_should_end_transaction+0x42/0x60 [btrfs]
> 	 btrfs_truncate_inode_items+0xaac/0xfc0 [btrfs]
> 	 btrfs_evict_inode+0x4c6/0x5c0 [btrfs]
> 	 evict+0xc6/0x190
> 	 do_unlinkat+0x19c/0x300
> 	 do_syscall_64+0x74/0x140
> 	 entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> 	RIP: 0033:0x7fbf589c57a7
> 
> To fix this, introduce a new flag "is_system" to head_ref structs,
> which is populated at insertion time. This allows to decouple the
> querying for the spaceinfo from querying the possibly deleted bg.
> 
> Fixes: d7eae3403f46 ("Btrfs: rework delayed ref total_bytes_pinned accounting")
> Suggested-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to next, thanks.

> @@ -550,8 +550,10 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  		     struct btrfs_delayed_ref_head *head_ref,
>  		     struct btrfs_qgroup_extent_record *qrecord,
>  		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
> -		     int action, int is_data, int *qrecord_inserted_ret,
> +		     int action, int is_data, int is_system,
> +		     int *qrecord_inserted_ret,
>  		     int *old_ref_mod, int *new_ref_mod)

At some point we might want to peel of a few arguments of that function.
It now has 14.  The fs_info/trans should work and the
action/is_data/is_system could be merged to a bitmask.
