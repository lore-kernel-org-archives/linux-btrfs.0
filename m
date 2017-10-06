Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbdJFS0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 14:26:36 -0400
Date: Fri, 6 Oct 2017 20:24:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Btrfs: heuristic add shannon entropy calculation
Message-ID: <20171006182451.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171005100726.16438-1-nefelim4ag@gmail.com>
 <20171005100726.16438-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171005100726.16438-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 05, 2017 at 01:07:26PM +0300, Timofey Titovets wrote:
> Byte distribution check in heuristic will filter edge data
> cases and some time fail to classificate input data
> 
> Let's fix that by adding Shannon entropy calculation,
> that will cover classification of most other data types.
> 
> As Shannon entropy need log2 with some precision to work,
> i precalculate table for our max sample size (8KiB).
> 
> Shannon entropy slightly changed for avoiding signed numbers
> and divisions
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 314 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 313 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 0060bc4ae5f2..b002ee980243 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1225,6 +1225,290 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
>  }
>  
>  
> + /*
> +  * Precalculated log2 values for 0 - 8193 range
> +  * return data shifted to left for 4 bit,
> +  * for improve precision without float point.
> +  *
> +  * Used only in shannon entropy for heuristic
> +  *
> +  * Only first 128 elements precalculated for save memory
> +  */
> +
> +#define LOG2_RET_SHIFT (1 << 4)
> +
> +static int log2_lshift4(uint16_t x)
> +{
> +	/*
> +	 * Predefined array for first 128 values
> +	 * Python generator example
> +	 * import math
> +	 * for i in range(1, 128):
> +	 *     print(int(math.log2(i)*16),end=', ')
> +	 */
> +	uint8_t ret[128] = {

	static const uint8_t ret

Otherwise it consumes 128 bytes of the stack space.

> +		0,    0,    16,   25,   32,   37,   41,   44,   48,   50,
> +		53,   55,   57,   59,   60,   62,   64,   65,   66,   67,
> +		69,   70,   71,   72,   73,   74,   75,   76,   76,   77,
> +		78,   79,   80,   80,   81,   82,   82,   83,   83,   84,
> +		85,   85,   86,   86,   87,   87,   88,   88,   89,   89,
> +		90,   90,   91,   91,   92,   92,   92,   93,   93,   94,
> +		94,   94,   95,   95,   96,   96,   96,   97,   97,   97,
> +		98,   98,   98,   99,   99,   99,   99,   100,  100,  100,
> +		101,  101,  101,  102,  102,  102,  102,  103,  103,  103,
> +		103,  104,  104,  104,  104,  105,  105,  105,  105,  106,
> +		106,  106,  106,  106,  107,  107,  107,  107,  108,  108,
> +		108,  108,  108,  109,  109,  109,  109,  109,  110,  110,
> +		110,  110,  110,  111,  111,  111,  111,  111
> +
> +	};
> +
> +
> +	if (x < 128)
> +		return ret[x];
> +
> +	if (x < 1024) {
> +		if (x < 256) {
> +		}
> +		if (x < 470) {
> +		}
> +		if (x < 981) {
> +		}
> +		return 159;
> +	}
> +
> +	if (x < 8193) {
> +		if (x < 2048) {
> +		}
> +		if (x < 4096) {
> +		}
> +		if (x < 7845) {
> +		}
> +		return 207;
> +	}
> +	return 208;

I hear the compiler scream, trying to optimize all the ifs. And I think
the CPU branch prediction would have a hard time, there's practically no
expected pattern and the performance could be worse compared to the
formula calculation.

What's the reason you opencode it like that? Could you please post how
it would be implemented in C? There are potentially optimized functions
to do integer log2 (ilog2).

Code like that could be microbenchmarked so we can see actual numbers,
so far I'm just guessing.

> +}
> +
> +
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
> + */
> +
> +#define ENTROPY_LVL_ACEPTABLE 70
> +#define ENTROPY_LVL_HIGH 85
> +
> +static uint32_t shannon_entropy(struct heuristic_ws *ws)
> +{
> +	const u32 entropy_max = 8*LOG2_RET_SHIFT;
> +	const u32 q = log2_lshift4(ws->sample_size);
> +	u32 p, i;
> +	u64 entropy_sum;
> +
> +	entropy_sum = 0;
> +	for (i = 0; i < BUCKET_SIZE && ws->bucket[i].count > 0; i++) {
> +		p = ws->bucket[i].count;
> +		entropy_sum += p * (q - log2_lshift4(p));
> +	}
> +
> +	entropy_sum = div_u64(entropy_sum, ws->sample_size);
> +	return div_u64(entropy_sum * 100, entropy_max);I

I wonder if some of the 64bit types and 64bit division could be avoided.
