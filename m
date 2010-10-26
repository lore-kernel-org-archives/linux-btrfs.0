From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] btrfs: Add lzo compression support
Date: Tue, 26 Oct 2010 10:34:30 +0800
Message-ID: <4CC63E36.8050105@cn.fujitsu.com>
References: <4CC52D9A.3030709@cn.fujitsu.com> <20101026021341.GW18818@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101026021341.GW18818@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Oct 25, 2010 at 03:11:22PM +0800, Li Zefan wrote:
>> Lzo is a much faster compression algorithm than gzib, so would allow
>> more users to enable transparent compression, and some users can
>> choose from compression ratio and compression speed.
> 
> This is also much smaller than I expected, really nice.  It looks like
> older kernels won't properly deal (nicely give EIO) with lzo compressed
> files?
> 
> We can add compatbits to deal with that if it is the case.
> 

I forgot compatibility issue with older kernels..

Though I didn't test older kernels, I don't think they can deal with lzo
compressed files properly, at least not for inlined extents, in which
case I think btrfs will just show compressed data to the users.

So yes, an incompat flag is needed.
