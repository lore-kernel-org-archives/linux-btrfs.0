From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 17:10:57 +0200
Message-ID: <4DC01B01.1080306@birkenwald.de>
References: <1304088305-sup-3784@localhost>	<1304089239-sup-5110@think>	<BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>	<20110430235539.6205.qmail@stuge.se>	<ipolll$2h0$1@dough.gmane.org>	<1304420831-sup-4737@think>	<4DBFE75C.2000104@birkenwald.de> <BANLkTi=rOx2RT5MZxWzdrA1dmEfS7dsEEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=rOx2RT5MZxWzdrA1dmEfS7dsEEg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 03.05.2011 16:54, schrieb Daniel J Blueman:

Hi,

>>> The file the defrag ioctl works is that it schedules things for defrag
>>> but doesn't force out the IO immediately unless you use -f.
>>>
>>> So, to test the result of the defrag, you need to either wait a bit or
>>> run sync.
>>
>> Did so, no change. See my reply to cwillu for the data.
> 
> Can you try with the compression option enabled? Eg:
> 
> # filefrag foo.dat
> foo.dat: 11 extents found
> 
> # find . -xdev -type f -print0 | xargs -0 btrfs filesystem defragment -c
> 
> # filefrag foo.dat
> foo.dat: 1 extent found
> 
> Seems to work fine on 2.6.39-rc5; I mounted with '-o
> compress,clear_cache' though.

Maybe I was expecting too much. I tried it on a file with 72 extends and
was expecting for the count to go down to 1 (or very very few). This
does not seem to happen with this particular file. I just tested another
file (with 193 extends) and it was reduced to 5. defrag with -f, but
without -c. Still mounted with compress=lzo.

However, the 72 frags file is not getting any better, no matter which
flags I tried. No big problem at the moment, I've found an older (Ubuntu
Maverick) based system with a rotating disk that had like 50000 extends
for a single file. I expect defragging that will increase performance
quite nicely :-)

Bernhard
