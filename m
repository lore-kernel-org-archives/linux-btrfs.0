From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 2/2] Btrfs: introduce free space cluster for each node
Date: Tue, 1 Nov 2011 12:04:40 -0400
Message-ID: <20111101160440.GA13340@shiny>
References: <4E687A41.8080101@cn.fujitsu.com>
 <4EAFA21F.5010200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EAFA21F.5010200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 03:39:11PM +0800, Miao Xie wrote:
> Any Comment?

This is definitely interesting, in terms of trying to avoid btree
fragmentation and improve the performance of the allocator.

But I'm worried about what happens to performance as the FS fills up?
What kind of benchmarks have you done on larger filesystems that are
almost full?

-chris
