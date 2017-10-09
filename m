Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754551AbdJIP6s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:58:48 -0400
Date: Mon, 9 Oct 2017 17:57:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: heuristic add shannon entropy calculation
Message-ID: <20171009155703.GF3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171008131159.31239-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171008131159.31239-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 08, 2017 at 04:11:59PM +0300, Timofey Titovets wrote:
> Byte distribution check in heuristic will filter edge data
> cases and some time fail to classificate input data
> 
> Let's fix that by adding Shannon entropy calculation,
> that will cover classification of most other data types.
> 
> As Shannon entropy need log2 with some precision to work,
> let's use ilog2(N) and for increase precision,
> by do ilog2(pow(N, 4))
> 
> Shannon entropy slightly changed for avoiding signed numbers
> and divisions.
> 
> Changes:
>   v1 -> v2:
>     - Replace log2_lshift4 wiht ilog2
>     - To compensate accuracy errors of ilog2
>       @ENTROPY_LVL_ACEPTABLE 70 -> 65
>       @ENTROPY_LVL_HIGH      85 -> 80
>     - Drop usage of u64 from shannon calculation
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 0060bc4ae5f2..8efbce5633b5 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -34,6 +34,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sort.h>
> +#include <linux/log2.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -1224,6 +1225,60 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
>  	return 1;
>  }
> 
> +/*
> + * Shannon Entropy calculation
> + *
> + * Pure byte distribution analyze fail to determine
> + * compressiability of data. Try calculate entropy to
> + * estimate the average minimum number of bits needed
> + * to encode a sample data.
> + *
> + * For comfort, use return of percentage of needed bit's,
> + * instead of bit's amaount directly.
> + *
> + * @ENTROPY_LVL_ACEPTABLE - below that threshold sample has low byte
> + * entropy and can be compressible with high probability
> + *
> + * @ENTROPY_LVL_HIGH - data are not compressible with high probability,
> + *
> + * Use of ilog2() decrease precision, so to see ~ correct answer
> + * LVL decreased by 5.
> + */
> +
> +#define ENTROPY_LVL_ACEPTABLE 65
> +#define ENTROPY_LVL_HIGH 80
> +
> +/*
> + * For increase precision in shannon_entropy calculation
> + * Let's do pow(n, M) to save more digits after comma
> + *
> + * Max int bit lengh 64
> + * ilog2(MAX_SAMPLE_SIZE) -> 13
> + * 13*4 = 52 < 64 -> M = 4
> + * So use pow(n, 4)
> + */
> +static inline u32 ilog2_w(u64 n)
> +{
> +	return ilog2(n * n * n * n);
> +}
> +
> +static u32 shannon_entropy(struct heuristic_ws *ws)
> +{
> +	const u32 entropy_max = 8*ilog2_w(2);
> +	u32 entropy_sum = 0;
> +	u32 p, p_base, sz_base;
> +	u32 i;
> +
> +	sz_base = ilog2_w(ws->sample_size);
> +	for (i = 0; i < BUCKET_SIZE && ws->bucket[i].count > 0; i++) {
> +		p = ws->bucket[i].count;
> +		p_base = ilog2_w(p);
> +		entropy_sum += p * (sz_base - p_base);
> +	}
> +
> +	entropy_sum /= ws->sample_size;
> +	return entropy_sum * 100 / entropy_max;
> +}

That's much better :) I'll add the patch to the rest of the heuristics.
