From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/5] btrfs: Add lzo compression support
Date: Mon, 25 Oct 2010 22:13:41 -0400
Message-ID: <20101026021341.GW18818@think>
References: <4CC52D9A.3030709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC52D9A.3030709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 03:11:22PM +0800, Li Zefan wrote:
> Lzo is a much faster compression algorithm than gzib, so would allow
> more users to enable transparent compression, and some users can
> choose from compression ratio and compression speed.

This is also much smaller than I expected, really nice.  It looks like
older kernels won't properly deal (nicely give EIO) with lzo compressed
files?

We can add compatbits to deal with that if it is the case.

-chris
