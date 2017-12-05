Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbdLES0D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:26:03 -0500
Date: Tue, 5 Dec 2017 19:24:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: do not merge rbios if their fail stripe index
 are not identical
Message-ID: <20171205182404.GQ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-3-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171204224037.7556-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 03:40:36PM -0700, Liu Bo wrote:
> Since fail stripe index in rbio would be used to decide which
> algorithm reconstruction would be run, we cannot merge rbios if
> their's fail striped index are different, otherwise, one of the two
> reconstructions would fail.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index c4188fb..8d09535 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -601,6 +601,15 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
>  	if (last->operation == BTRFS_RBIO_REBUILD_MISSING)
>  		return 0;
>  
> +	if (last->operation == BTRFS_RBIO_READ_REBUILD) {
> +		int fa = (last->faila < last->failb) ? last->faila : last->failb;
> +		int fb = (last->faila < last->failb) ? last->failb : last->faila;
> +		int cur_fa = (cur->faila < cur->failb) ? cur->faila : cur->failb;
> +		int cur_fb = (cur->faila < cur->failb) ? cur->failb : cur->faila;

Can you please convert it to if/else? All the lines look very similar.
