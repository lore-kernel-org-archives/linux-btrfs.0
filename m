Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeEVOCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 10:02:49 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7BE99ADCB
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 14:02:48 +0000 (UTC)
Date: Tue, 22 May 2018 16:00:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: lzo: Add comment about the how btrfs
 records its lzo compressed data
Message-ID: <20180522140005.GL6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180521051927.3715-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 01:19:25PM +0800, Qu Wenruo wrote:
> Although it's not that complex, but such comment could still save
> several minutes for newer reader/reviewer.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 0667ea07f766..d0c6789ff78f 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -17,6 +17,29 @@
>  
>  #define LZO_LEN	4
>  
> +/*
> + * Btrfs LZO compression format
> + *
> + * Regular LZO compressed data extent consists of:
> + * 1.  Header
> + *     Fixed size. LZO_LEN (4) bytes long, LE32.
> + *     Records the total size (*includes* the header) of real compressed data.
> + *
> + * 2.  Segment(s)
> + *     Variable size. Includes one segment header, and then data payload.
> + *     One regular LZO compressed extent can have one or more segments.
> + *
> + * 2.1 Segment header
> + *     Fixed size. LZO_LEN (4) bytes long, LE32.
> + *     Records the total size of the segment (*excludes* the header).
> + *
> + * 2.2 Data Payload
> + *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
> + *
> + * While for inlined LZO compressed data extent, it doesn't have Header, just
> + * *ONE* Segment.

It does have header that has the same value as the 1st segment header so
it's skipped.

There's also one catch in the format that if there's a less then 4 bytes
left to the page size, the new segment starts on the new page.
