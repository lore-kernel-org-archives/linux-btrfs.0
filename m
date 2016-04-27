Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbcD0QjQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 12:39:16 -0400
Date: Wed, 27 Apr 2016 18:39:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: fix divide error upon chunk's stripe_len
Message-ID: <20160427163903.GK29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461718411-809-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461718411-809-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 05:53:31PM -0700, Liu Bo wrote:
> The struct 'map_lookup' uses type int for @stripe_len, while
> btrfs_chunk_stripe_len() can return a u64 value, and it may end up with
> @stripe_len being undefined value and it can lead to 'divide error' in
>  __btrfs_map_block().
> 
> This changes 'map_lookup' to use type u64 for stripe_len, also right now
> we only use BTRFS_STRIPE_LEN for stripe_len, so this adds a valid checker for
> BTRFS_STRIPE_LEN.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>

I smell some fuzzing :) do you have the image available? I'll add it to
the rest in btrfsprogs.

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  fs/btrfs/volumes.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e2b54d5..b5cb859 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6242,7 +6242,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>  			"invalid chunk length %llu", length);
>  		return -EIO;
>  	}
> -	if (!is_power_of_2(stripe_len)) {
> +	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {

Unfortunatelly this will break current state, as mkfs does not set the
stripe length to 64k but to 4k. But the value is otherwise ignored in
kernel.
