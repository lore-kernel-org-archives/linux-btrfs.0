From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Wed, 18 Jan 2012 16:05:20 +0100
Message-ID: <4F16DFB0.2060404@oberhumer.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-01-13 01:28, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

I'd like to note that the LZO version in the current Linux kernel is
rather outdated - it seems to be based on the 2005 release.

In fact the latest version LZO 2.06 does compress both slightly faster and
better than snappy 1.0.4 when benchmarking the Calgary and Silesia
compression corpus (tested with gcc 4.6 on Nehalem & Sandy Bridge).

Furthermore please be aware that from a pure compression point of view
snappy et al. are very close cousins of LZO (strictly byte-aligned LZ77)
that mainly differ in implementation issues like using a table to
number of branches - and indeed similar optimizations could be applied
to any version.

I'm not sure if there is an official kernel maintainer of LZO, but I'd
offer to assist you updating to the latest version and eliminating
any possible performance issues.

Cheers,
Markus

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
