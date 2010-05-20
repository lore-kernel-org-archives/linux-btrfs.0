From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fullfil the bmap operation
Date: Wed, 19 May 2010 22:03:08 -0400
Message-ID: <20100520020308.GI3318@think>
References: <4BF39CB1.8040607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF39CB1.8040607@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 04:09:21PM +0800, liubo wrote:
> Hi,
> 
> When we tested btrfs with Josef's test-tools, a FAIL
> came to us.
> 
> After looking into it, we found that aops->bmap had
> been deleted because btrfs's COW + swapfile led to
> corruption.
> 
> So, is there a plan for this bmap operation?
> 

The idea was the swap over NFS patches were going to help.  Until then
it is better to use fiemap anyway.

-chris

