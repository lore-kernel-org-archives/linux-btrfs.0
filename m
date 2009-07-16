From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs warnings: -rc2
Date: Thu, 16 Jul 2009 14:32:50 -0400
Message-ID: <20090716183250.GC3883@think>
References: <4A5F3AD9.5040005@rambler.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michael Raskin <a0091f122@rambler.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A5F3AD9.5040005@rambler.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 16, 2009 at 06:36:09PM +0400, Michael Raskin wrote:
> 	I checked the same usage scenario with -rc2 kernel..
> 
> 	Looks like it is just because of allmodconfig. Interesting fact,
> though: now warnings are thrown on on-disk operations, errors are on
> rbtree operations.

Could you please touch foo ; ls -lai foo and send us the results.  Yan
Zheng has a theory that it is related to inode numbers

-chris
