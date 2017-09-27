Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44623 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753181AbdI0NtE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 09:49:04 -0400
Date: Wed, 27 Sep 2017 15:47:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 4/6] Btrfs: heuristic add detection of repeated data
 patterns
Message-ID: <20170927134730.GD31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
 <20170825091845.4120-5-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825091845.4120-5-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 12:18:43PM +0300, Timofey Titovets wrote:
> Walk over data sample and use memcmp to detect
> repeated data (like zeroed)
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/heuristic.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
> index 5192e51ab81e..f1fa6e4f1c11 100644
> --- a/fs/btrfs/heuristic.c
> +++ b/fs/btrfs/heuristic.c
> @@ -66,6 +66,19 @@ static struct list_head *heuristic_alloc_workspace(void)
>  	return ERR_PTR(-ENOMEM);
>  }
> 
> +static bool sample_repeated_patterns(struct workspace *ws)
> +{
> +	u32 i = 0;
> +	u8 *p = ws->sample;
> +
> +	for (; i < ws->sample_size - READ_SIZE; i += READ_SIZE) {

Please use the inline initializatio of the iteration variables.

	for (i = 0; i < ws->sample_size - READ_SIZE; i += READ_SIZE) {

> +		if(memcpy(&p[i], &p[i + READ_SIZE], READ_SIZE))
> +			return false;

I think zeros are by far the most common repeated pattern, for that we
can use some speedy tests, built on top of "find first bit", possibly
with hardware support.

OTOH if it's a more generic "any repeated bytes", this might be actually
slower, and the heuristic needs to be as fast as possible. I don't want
to start optimizing now, so the generic pattern is ok for now.

> +	}
> +
> +	return true;
> +}
> +
>  static int heuristic(struct list_head *ws, struct inode *inode,
>  		     u64 start, u64 end)
>  {
> @@ -115,6 +128,9 @@ static int heuristic(struct list_head *ws, struct inode *inode,
> 
>  	workspace->sample_size = b;
> 
> +	if (sample_repeated_patterns(workspace))
> +		return 1;
> +
>  	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);
> 
>  	for (a = 0; a < workspace->sample_size; a++) {
> --
> 2.14.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
