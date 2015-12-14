Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbbLNQ0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 11:26:45 -0500
Date: Mon, 14 Dec 2015 17:24:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Enhance super validation check
Message-ID: <20151214162441.GL4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449560158-32577-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449560158-32577-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 03:35:57PM +0800, Qu Wenruo wrote:
> @@ -4005,31 +3989,47 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	}
>  
>  	/*
> -	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
> -	 * items yet, they'll be verified later. Issue just a warning.
> +	 * Check sectorsize and nodesize first, some other check will need it.
> +	 * XXX: Just do a favor for later subpage size check. Check all

Same as in v1: Please do not add new XXX or TODO markers to the sources.
The comment would be fine with just:

	 "Check all possible sectorsizes (4K, 8K, 16K, 32K, 64K) here."

With that fixed,

Reviewed-by: David Sterba <dsterba@suse.com>
