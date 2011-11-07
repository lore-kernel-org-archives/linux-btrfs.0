From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] btrfs: Don't leak mem in scrub_fixup().
Date: Mon, 07 Nov 2011 10:24:50 +0100
Message-ID: <4EB7A3E2.2060400@gmx.net>
References: <alpine.LNX.2.00.1111062331350.5763@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1111062331350.5763@swampdragon.chaosbits.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.11.2011 23:33, Jesper Juhl wrote:
> It seems to me that we may leak the memory allocated to 'multi' in
> scrub_fixup() if, for example, 'length' turns out to be less than
> PAGE_SIZE after we call btrfs_map_block(). This patch should take care
> of the leak by always kfree'ing 'multi' before we return in that error
> case.

Thanks for looking into this. The current pull request already contains
a fix for this, from Ilya Dryomov.

-Arne

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/btrfs/scrub.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
>  Compile tested only since I don't have any btrfs filesystems to test on.
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index a8d03d5..b53433e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -271,6 +271,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
>  	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
>  			      &multi, 0);
>  	if (ret || !multi || length < PAGE_SIZE) {
> +		kfree(multi);
>  		printk(KERN_ERR
>  		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
>  		       (unsigned long long)logical);
