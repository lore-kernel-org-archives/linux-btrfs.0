Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab3LSMem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 07:34:42 -0500
Date: Thu, 19 Dec 2013 13:34:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Cleanup the unused btrfs_check_super_valid.
Message-ID: <20131219123440.GC6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1387336468-28785-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387336468-28785-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 18, 2013 at 11:14:28AM +0800, Qu Wenruo wrote:
> Since in David's commit 1104a8855, there is nothing really check the
> super block now, the btrfs_check_super_valid function can be removed if
> no one else needs the function.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Cc: David Sterba <dsterba@suse.cz>
> ---
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> -			      int read_only)
> -{
> -	/*
> -	 * Placeholder for checks

The comment should motivate to add more tests, not to remove the
supporting code. Please keep it.

> -	 */
> -	return 0;
> -}
