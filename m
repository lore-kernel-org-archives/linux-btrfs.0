Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbcE0S40 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 14:56:26 -0400
Date: Fri, 27 May 2016 20:55:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, steve.capper@linaro.org, chandan@mykolab.com,
        jbacik@fb.com, dsterba@suse.com, feifeixu.sh@gmail.com
Subject: Re: [PATCH 5/5] Btrfs: self-test: fix extent buffer bitmap test fail
 on BE system
Message-ID: <20160527185549.GW29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>
 <201605270701.u4R6xUai016007@mx0a-001b2d01.pphosted.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201605270701.u4R6xUai016007@mx0a-001b2d01.pphosted.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 03:00:38PM +0800, Feifei Xu wrote:
> In __test_eb_bitmaps(), we write random data to a bitmap. Then copy
> the bitmap to another bitmap that resides inside an extent buffer.
> Later we verify the values of corresponding bits in the bitmap and the
> bitmap inside the extent buffer. However, extent_buffer_test_bit()
> reads in byte granularity while test_bit() reads in unsigned long
> granularity. Hence we end up comparing wrong bits on big-endian
> systems such as ppc64. This commit fixes the issue by reading the
> bitmap in byte granularity.
> 
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
> ---
>  fs/btrfs/tests/extent-io-tests.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index b06b13a..d33f28f 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -275,6 +275,16 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * test_bit_in_byte - Determine whether a bit is set in a byte
> + * @nr: bit number to test
> + * @addr: Address to start counting from
> + */
> +static inline int test_bit_in_byte(int nr, const u8 *addr)
> +{
> +	return 1UL & (addr[nr/BITS_PER_BYTE] >> (nr & (BITS_PER_BYTE-1)));

minor nit:

	return 1UL & (addr[nr / BITS_PER_BYTE] >> (nr & (BITS_PER_BYTE - 1)));

otherwise looks ok.
