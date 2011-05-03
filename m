From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: abysmal performance
Date: Tue, 3 May 2011 22:54:46 +0800
Message-ID: <BANLkTi=rOx2RT5MZxWzdrA1dmEfS7dsEEg@mail.gmail.com>
References: <1304088305-sup-3784@localhost>
	<1304089239-sup-5110@think>
	<BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
	<20110430235539.6205.qmail@stuge.se>
	<ipolll$2h0$1@dough.gmane.org>
	<1304420831-sup-4737@think>
	<4DBFE75C.2000104@birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DBFE75C.2000104@birkenwald.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 3 May 2011 19:30, Bernhard Schmidt <berni@birkenwald.de> wrote:
[]
>> The file the defrag ioctl works is that it schedules things for defrag
>> but doesn't force out the IO immediately unless you use -f.
>>
>> So, to test the result of the defrag, you need to either wait a bit or
>> run sync.
>
> Did so, no change. See my reply to cwillu for the data.

Can you try with the compression option enabled? Eg:

# filefrag foo.dat
foo.dat: 11 extents found

# find . -xdev -type f -print0 | xargs -0 btrfs filesystem defragment -c

# filefrag foo.dat
foo.dat: 1 extent found

Seems to work fine on 2.6.39-rc5; I mounted with '-o
compress,clear_cache' though.

Daniel
-- 
Daniel J Blueman
