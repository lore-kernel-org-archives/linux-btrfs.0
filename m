Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:38961 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbcEYTGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 15:06:11 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] btrfs-progs: utils: Introduce new pseudo random API
Reply-To: kreijack@inwind.it
References: <1464149645-4308-1-git-send-email-quwenruo@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5745F79F.1000203@inwind.it>
Date: Wed, 25 May 2016 21:06:07 +0200
MIME-Version: 1.0
In-Reply-To: <1464149645-4308-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 06:14, Qu Wenruo wrote:
> +void rand_seed(u64 seed)
> +{
> +	int i;
> +	/* only use the last 48 bits */
> +	for (i = 0; i < 3; i++) {
> +		seeds[i] = (unsigned short)(seed ^ (unsigned short)(-1));
> +		seed >>= 16;
> +	}
> +	seed_initlized = 1;
> +}
> +
> +u32 rand_u32(void)
> +{
> +	struct timeval tv;
> +
> +	if (seed_initlized)
> +		return nrand48(seeds);
> +
> +	/*
> +	 * It's possible to use /dev/random, but we don't need that true
> +	 * random number nor want to wait for entropy,
> +	 * since we're only using random API to do corruption to test.
> +	 * Time and pid/ppid based seed would be good enough, and won't
> +	 * cause sleep for entropy pool.
> +	 */
> +	gettimeofday(&tv, 0);
> +	seeds[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
> +	seeds[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
> +	seeds[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
> +	seed_initlized = 1;
> +
> +	return (u32)nrand48(seeds);
> +}


Just for my curiosity, which is the advantage of rand48() respect to rand() if we utilize only the lower 32 bit ? It wouldn't be more simple to use:

#define rand_seed(x) srand((int)(x))

/*
 *  NOTE: not for cryptographic use 
 */
u32 rand_u32(void)
{
	static __thread int initialized = 0;

	if (!initialized) {
		struct timeval tv;
		gettimeofday(&tv, 0);
		rand_seed(tv.tv_usec | (tv.tv_sec ^ getpid() ^ getppid()) << 16);
		initialized = 1;
	}
	return (u32)rand();
}

this in order to avoid the mess of the 48 bit ?

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
