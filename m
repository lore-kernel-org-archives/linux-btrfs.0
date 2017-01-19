Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754173AbdASSe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 13:34:27 -0500
Date: Thu, 19 Jan 2017 19:21:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 00/24] tree-log inode vs btrfs_inode cleanups
Message-ID: <20170119182152.GA11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2017 at 12:31:26AM +0200, Nikolay Borisov wrote:
> So here is a new set of patches cleaning up tree-log function 
> w.r.t inode vs btrfs_inode. There are still some which remain 
> but I didn't find compelling arguments to cleaning them up, so 
> I've left them unchanged. This time there are some size shrinkage:
> 
>    text	   data	    bss	    dec	    hex	filename
>    2530598	 174661	  28288	2733547	 29b5eb	fs/btrfs/btrfs.ko - upstream master
> 
>  	text	   data	    bss	    dec	    hex	filename
>  	2530774	 174661	  28288	2733723	 29b69b	fs/btrfs/btrfs.ko - before tree-log cleanup
> 
>     text	   data	    bss	    dec	    hex	filename
> 	2530163	 174661	  28288	2733112	 29b438	fs/btrfs/btrfs.ko - both series applied 
> 
> So the net result of the 2 series is 435 bytes and I assume there 
> will be further reduction in size once further cleanups are made 
> 
> Changes since v1: 
>  * Rebased all patche to latest master
> 
> Nikolay Borisov (24):
>   btrfs: Make btrfs_must_commit_transaction take btrfs_inode
>   btrfs: Make btrfs_record_unlink_dir take btrfs_inode
>   btrfs: Make btrfs_record_snapshot_destroy take btrfs_inode
>   btrfs: Make btrfs_inode_in_log take btrfs_inode
>   btrfs: Make btrfs_log_new_name take btrfs_inode
>   btrfs: Make btrfs_del_dir_entries_in_log take btrfs_inode
>   btrfs: Make btrfs_del_inode_ref take btrfs_inode
>   btrfs: Make logged_inode_size take btrfs_inode
>   btrfs: Make btrfs_check_ref_name_override take btrfs_inode
>   btrfs: Make copy_items take btrfs_inode
>   btrfs: Make btrfs_log_all_xattrs take btrfs_inode
>   btrfs: Make btrfs_log_trailing_hole take btrfs_inode
>   btrfs: Make btrfs_get_logged_extents take btrfs_inode
>   btrfs: Make btrfs_log_changed_extents take btrfs_inode
>   btrfs: Make log_dir_items take btrfs_inode
>   btrfs: Make log_directory_changes take btrfs_inode
>   btrfs: Make log_new_dir_dentries take btrfs_inode
>   btrfs: Make btrfs_unlink_inode take btrfs_inode
>   btrfs: Make drop_one_dir_item take btrfs_inode
>   btrfs: Make __add_inode_ref take btrfs_inode
>   btrfs: Make log_inode_item take btrfs_inode
>   btrfs: Make btrfs_log_inode take btrfs_inode
>   btrfs: Make count_inode_extrefs take btrfs_inode
>   btrfs: Make count_inode_refs take btrfs_inode

Added to 4.11 queue, thanks. There were several 80+ lines added by the
patches, I've updated the patches during review. Please be more careful
with changes like this

>From https://patchwork.kernel.org/patch/9522051/

-	if (S_ISDIR(inode->i_mode) ||
+	if (S_ISDIR(inode->vfs_inode.i_mode) ||
 	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-		       &BTRFS_I(inode)->runtime_flags) &&
-	     inode_only >= LOG_INODE_EXISTS))
+		       &inode->runtime_flags) &&
+	     inode_only == LOG_INODE_EXISTS))

Notice the change from >= to == .
