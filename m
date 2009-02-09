From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressor options and speed vs size tradeoff.
Date: Mon, 09 Feb 2009 10:16:38 -0500
Message-ID: <1234192598.1262.13.camel@think.oraclecorp.com>
References: <e692861c0902090023v42104857p47058f13829686be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c0902090023v42104857p47058f13829686be@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-02-09 at 03:23 -0500, Gregory Maxwell wrote:
> I ran across an interesting page which reviews the performance of a
> number of compressors which are already available for the Linux Kernel
> (zlib, lzop, lzma) and which shows the highest performing compressor
> choice given the authors test CPU for a variety of data transfer
> rates, and read vs write ratio.
> 
> http://users.elis.ugent.be/~wheirman/compression/
> 
> 
> It shows that for normal disk speeds (i.e. >200mbit/sec) LZOP of some
> flavor will yield the greatest performance.
> 
> (LZMA, however, has considerably greater space savings; but isn't
> likely to increase overall performance with normal disk)

The compression metadata has what it needs to understand other
compression algorithms, but we haven't gotten around to actually coding
in support for other ones.

>From a latency point of view, the decompression speed matters most, but
both compression and decompression are done in the background by a
number of async helper threads in the kernel.

So, lots of the smaller differences between the compression algos end up
hidden for most users.  I'm definitely not saying zlib is the perfect
compression routine, but it holds up well overall.

-chris


