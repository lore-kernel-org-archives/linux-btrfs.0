Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:60358 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbcEZLIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 07:08:34 -0400
Message-ID: <254003815.145831464260911184.JavaMail.defaultUser@defaultHost>
Date: Thu, 26 May 2016 13:08:31 +0200 (CEST)
From: "kreijack@inwind.it" <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: R: Re: [PATCH 1/2] btrfs-progs: utils: Introduce new pseudo random
 API
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>----Messaggio originale----
>Da: "Qu Wenruo" <quwenruo@cn.fujitsu.com>
>Data: 26/05/2016 2.38
>A: <kreijack@inwind.it>
>Ogg: Re: [PATCH 1/2] btrfs-progs: utils: Introduce new pseudo random API
>
>
>
>Goffredo Baroncelli wrote on 2016/05/25 18:15 +0200:
>> On 2016-05-25 06:14, Qu Wenruo wrote:
>>> +void rand_seed(u64 seed)
>>> +{
>>> +	int i;
>>> +	/* only use the last 48 bits */
>>> +	for (i = 0; i < 3; i++) {
>>> +		seeds[i] = (unsigned short)(seed ^ (unsigned short)(-1));
>>> +		seed >>= 16;
>>> +	}
>>> +	seed_initlized = 1;
>>> +}
>>> +
>>> +u32 rand_u32(void)
>>> +{
>>> +	struct timeval tv;
>>> +
>>> +	if (seed_initlized)
>>> +		return nrand48(seeds);
>>> +
>>> +	/*
>>> +	 * It's possible to use /dev/random, but we don't need that true
>>> +	 * random number nor want to wait for entropy,
>>> +	 * since we're only using random API to do corruption to test.
>>> +	 * Time and pid/ppid based seed would be good enough, and won't
>>> +	 * cause sleep for entropy pool.
>>> +	 */
>>> +	gettimeofday(&tv, 0);
>>> +	seeds[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
>>> +	seeds[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
>>> +	seeds[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
>>> +	seed_initlized = 1;
>>> +
>>> +	return (u32)nrand48(seeds);
>>> +}
>>
>>
>> Just for my curiosity, which is the advantage of rand48() respect to rand() 
if we utilize only the
>> lower 32 bit ? It wouldn't be more simple to use:
>
>Of course rand() is my first candidate.
>
>However a quick check on manpage of rand(3) shows, the up limit of 
>RAND_MAX, is not always the same.
>
>In my system, RAND_MAX is 2^31 -1, while example code from rand(3) 
>assumes the up limit is 32767.

In glibc RAND_MAX is always ~2^31: http://www.gnu.
org/software/libc/manual/html_node/ISO-Random.html

If it is true for glibc, it should be true also for the others linux libc 
(dietlibc[1], musl[2]);  I think that assuming in linux RAND_MAX  = 2^31-1 
should be safe.

BR
Goffredo

[1] https://github.com/ensc/dietlibc/blob/master/include/stdlib.h#L101
[2] https://github.com/cloudius-systems/musl/blob/master/include/stdlib.h#L81


