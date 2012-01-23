From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Subject: ANN: linux-kernel-lzo-2.06.20120123 - update LZO to v2.06
Date: Mon, 23 Jan 2012 17:19:40 +0100
Message-ID: <4F1D889C.2050706@oberhumer.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <4F16DFB0.2060404@oberhumer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
	Richard Purdie <rpurdie@openedhand.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F16DFB0.2060404@oberhumer.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've prepared a small package that updates the LZO version in the Linux
kernel to LZO v2.06.

Please get it from:

  http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-2.06.20120123.tar.gz

As stated in the README, its main purpose is to allow easy benchmarking of the
latest LZO versions - these do feature some nice speed improvements, and while
I have done a lot of synthetic benchmarking I'm really very curious and
appreciate feedback on "real-world" performance numbers like usage in
btrfs and zram.

Share and enjoy,
Markus

http://www.oberhumer.com/opensource/lzo/

On 2012-01-18 16:05, Markus F.X.J. Oberhumer wrote:
> On 2012-01-13 01:28, Andi Kleen wrote:
>> Here's a slightly updated version of the BTRFS snappy interface.
>> snappy is a faster compression algorithm that provides similar
>> compression as LZO, but generally better performance.
> 
> I'd like to note that the LZO version in the current Linux kernel is
> rather outdated - it seems to be based on the 2005 release.
> 
> In fact the latest version LZO 2.06 does compress both slightly faster and
> better than snappy 1.0.4 when benchmarking the Calgary and Silesia
> compression corpus (tested with gcc 4.6 on Nehalem & Sandy Bridge).
> 
> Furthermore please be aware that from a pure compression point of view
> snappy et al. are very close cousins of LZO (strictly byte-aligned LZ77)
> that mainly differ in implementation issues like using a table to
> number of branches - and indeed similar optimizations could be applied
> to any version.
> 
> I'm not sure if there is an official kernel maintainer of LZO, but I'd
> offer to assist you updating to the latest version and eliminating
> any possible performance issues.

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
