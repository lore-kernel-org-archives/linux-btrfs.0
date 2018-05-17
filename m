Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751680AbeEQHsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 03:48:38 -0400
Subject: Re: [PATCH 2/4] btrfs: lzo: Add comment about the how btrfs records
 its lzo compressed data
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
References: <20180517062753.25973-1-wqu@suse.com>
 <20180517062753.25973-3-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a8146d5e-0558-e9f0-bf98-c51c9736691a@suse.com>
Date: Thu, 17 May 2018 10:48:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180517062753.25973-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.05.2018 09:27, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Overall it looks good and useful just a couple of nits below.
> ---
>  fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 0667ea07f766..3d2ae4c08876 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -17,6 +17,29 @@
>  
>  #define LZO_LEN	4
>  
> +/*
> + * Btrfs LZO compression format
> + *
> + * Regular LZO compressed data extent is consist of:
nit: s/is consist/consists
> + * 1.  Header
> + *     Fixed size. LZO_LEN (4) bytes long, LE16.
> + *     Records the total size (*includes* the header) of real compressed data.
> + *
> + * 2.  Segment(s)
> + *     Variable size. Includes one segment header, and then data payload.
> + *     One btrfs compressed data can have one or more segments.

So "one btrfs compressed data" should really mean "one btrfs compressed
extent" I guess?

> + *
> + * 2.1 Segment header
> + *     Fixed size. LZO_LEN (4) bytes long, LE16.
> + *     Records the total size of the segment (*excludes* the header).
> + *
> + * 2.2 Data Payload
> + *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
> + *
> + * While for inlined LZO compressed data extent, it doesn't have Header, just
> + * one Segment.



> + */
> +
>  struct workspace {
>  	void *mem;
>  	void *buf;	/* where decompressed data goes */
> 
