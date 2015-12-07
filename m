Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34823 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbbLGQDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 11:03:16 -0500
Date: Mon, 7 Dec 2015 16:02:49 +0100
From: David Sterba <dave@jikos.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Enhance super validation check
Message-ID: <20151207150249.GQ26112@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1449477555-10333-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449477555-10333-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2015 at 04:39:15PM +0800, Qu Wenruo wrote:
> Enhance btrfs_check_super_valid() function by the following points:
> 1) Restrict sector/node size check
>    Not the old max/min valid check, but also check if it's a power of 2.
>    So some bogus number like 12K nodesize won't pass now.
> 
> 2) Super flag check
>    Except some common one like WRITTEN and RELOC, and other one used in
>    btrfs-progs, unrecognized flag will cause btrfs refuse to mount.
> 
> 3) Better root alignment check
>    Now root bytenr is checked against sectorsize.
> 
> 4) Move some check into btrfs_check_super_valid().
>    Like nodesize vs leafsize check, and PAGESIZE vs sectorsize check.
>    And MAGIC check.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Good, the code is better structured now, eg. the sb magic check came too
late before.

> @@ -4005,31 +3993,47 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	}
>  
>  	/*
> -	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
> -	 * items yet, they'll be verified later. Issue just a warning.
> +	 * Check sectorsize and nodesize first, some other check will need it.
> +	 * XXX: Just do a favor for later subpage size check. Check all

Please do not add new XXX or TODO markers to the sources. The comment
would be fine with just:

	 "Check all possible sectorsizes (4K, 8K, 16K, 32K, 64K) here."

With that fixed,

Reviewed-by: David Sterba <dsterba@suse.com>
