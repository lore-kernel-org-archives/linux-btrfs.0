Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbaDNQva (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:51:30 -0400
Date: Mon, 14 Apr 2014 18:51:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: check if items are ordered when a leaf is marked
 dirty
Message-ID: <20140414165128.GQ29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397054226-17950-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397054226-17950-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 09, 2014 at 03:37:06PM +0100, Filipe David Borba Manana wrote:
> To ease finding bugs during development related to modifying btree leaves
> in such a way that it makes its items not sorted by key anymore. Since this
> is an expensive check, it's only enabled if CONFIG_BTRFS_FS_CHECK_INTEGRITY
> is set, which isn't meant to be enabled for regular users.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> @@ -3695,6 +3695,12 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>  		__percpu_counter_add(&root->fs_info->dirty_metadata_bytes,
>  				     buf->len,
>  				     root->fs_info->dirty_metadata_batch);
> +#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> +	if (btrfs_header_level(buf) == 0 && check_leaf(root, buf)) {

You coud also add the 'level == 0' to check_leaf() itself.
