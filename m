From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [patch 1/2] Balance progress monitoring (updated)
Date: Tue, 02 Nov 2010 08:51:25 +0800
Message-ID: <4CCF608D.8030706@cn.fujitsu.com>
References: <20101030000726.286517546@carfax.org.uk> <20101030000741.689283553@carfax.org.uk> <20101030133934.GD9369@selene> <4CCE751D.6030204@cn.fujitsu.com> <20101101125510.GA4709@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101101125510.GA4709@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2010 08:55 PM, Hugo Mills wrote:
> On Mon, Nov 01, 2010 at 04:06:53PM +0800, liubo wrote:
>> On 10/30/2010 09:39 PM, Hugo Mills wrote:
>>> This patch introduces a basic form of progress monitoring for balance
>>> operations, by counting the number of block groups remaining. The
>>> information is exposed to userspace by an ioctl.
>>>
>> IMO, tracking the information of blocks which are balancing also makes sense. 
>> For example, the block information's blocknr. 
>> It can help us monitor better.
> 
>    I don't see how that will help. The block group IDs (which is all
> that we get at this level) are effectively arbitrary 64-bit numbers,
> and are what appear in the kernel logs. How could that information be
> used to improve monitoring?

64-bit numbers are also shown in btrfs-debug-tree.
With btrfs-debug-tree, it would be helpful to track balanced extent buffers.

thanks,
liubo

> 
>    I'm not ruling out the idea completely -- I just can't see at the
> moment how it would be used.
> 
>    Hugo.
> 

