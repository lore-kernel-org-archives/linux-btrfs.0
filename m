From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] btrfs: Switching the extent buffer rbtree into a
 unlock radix tree
Date: Tue, 12 Oct 2010 14:43:23 -0400
Message-ID: <20101012184323.GU22691@think>
References: <4CB42DB2.5080906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CB42DB2.5080906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 12, 2010 at 05:43:14PM +0800, Miao Xie wrote:
> This patch reduces the CPU time spent in the extent buffer search by using the
> radix tree instead of the rbtree and using the rcu lock instead of the spin
> lock.
> 
> I did a quick test by the benchmark tool[1] and found the patch improve the
> file creation/deletion performance problem that I have reported[2].

Thanks, this is much smaller than I expected.  I'll hammer on it here.

-chris
