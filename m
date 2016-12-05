Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751080AbcLEP3K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 10:29:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8805FABFA
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Dec 2016 15:29:08 +0000 (UTC)
Date: Mon, 5 Dec 2016 16:29:04 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/18] btrfs: root->fs_info cleanup,
 btrfs_calc_{trans,trunc}_metadata_size
Message-ID: <20161205152904.GW12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-11-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480655258-15400-11-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:07:30AM -0500, jeffm@suse.com wrote:
> -static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
> +static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
>  						 unsigned num_items)
>  {
> -	return root->fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
> +	return fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;

Is there a missing patch that moves 'nodesize' to fs_info? The patch has
a minor conflict in the original line where it's just 'root->nodesize',
but thre are many compilation faiures due to lack of fs_info::nodesize.
