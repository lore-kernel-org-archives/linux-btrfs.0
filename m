Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaJFRTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 13:19:33 -0400
Date: Mon, 6 Oct 2014 19:19:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix uninitialized warining in
 btrfs_calc_stripe_index
Message-ID: <20141006171931.GD11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412209921-21002-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412209921-21002-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 02, 2014 at 08:32:01AM +0800, Anand Jain wrote:
> chunk-recover.c: In function ‘btrfs_calc_stripe_index’:
> chunk-recover.c:1481: warning: ‘index’ may be used uninitialized in this function
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -1478,7 +1478,7 @@ static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
>  	u64 offset = logical - chunk->offset;
>  	int stripe_nr;
>  	int nr_data_stripes;
> -	int index;
> +	int index = 0;
>  
>  	stripe_nr = offset / chunk->stripe_len;
>  	if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID0) {

The catch-all branch does BUG_ON so the compiler probably misses that
for some reason, otherwise the index value is always defined. It would
be better to replace the BUG_ON with "return -1" and handle the error in
the callers.

The BUG_ON happens if there's an unknown block group type, these are
well known and any error here means there's a corruption or unsupported
type. Both condition could be handled in a better way.
