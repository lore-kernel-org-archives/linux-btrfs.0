Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaI3Lf7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 07:35:59 -0400
Date: Tue, 30 Sep 2014 13:35:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL
 tree_root or fs_root.
Message-ID: <20140930113556.GI11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 30, 2014 at 10:39:22AM +0800, Qu Wenruo wrote:
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1134,7 +1134,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  	return fs_info;
>  
>  out_failed:
> -	if (flags & OPEN_CTREE_PARTIAL)
> +	if (flags & OPEN_CTREE_PARTIAL &&
> +	    fs_info->tree_root && fs_info->fs_root)
>  		return fs_info;

I see a conflict with a pending patch
https://patchwork.kernel.org/patch/4254631/

that removes the check completely but fixes the crash in another way. I
like Wang's patch because it keeps the logic about partial open inside
btrfs_setup_all_roots(). Please test if it fixes the crash with the
corrupted image you have. Thanks.

>  out_chunk:
>  	btrfs_release_all_roots(fs_info);
