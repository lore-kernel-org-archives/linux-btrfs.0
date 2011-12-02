From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Blocked for more than 120 seconds
Date: Fri, 2 Dec 2011 09:01:12 -0500
Message-ID: <20111202140112.GN10535@shiny>
References: <4ED34359.6010305@robotech.de>
 <1322472549.1962.2.camel@Nokia-N900>
 <4ED5FAEF.8070400@robotech.de>
 <20111130141006.GY24338@shiny>
 <4ED738E5.3080200@robotech.de>
 <20111201184158.GB10535@shiny>
 <4ED8D6C8.4020609@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, miaox <miaox@cn.fujitsu.com>
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED8D6C8.4020609@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 02, 2011 at 02:46:48PM +0100, Tobias wrote:
> Hi Chris!
> 
> Am 01.12.2011 19:41, schrieb Chris Mason:
> >
> >So, the transaction close is in btrfs_evict_inode, which sounds like a
> >deadlock recently fixed by this commit:
> >
> >http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=commit;h=aa38a711a893accf5b5192f3d705a120deaa81e0
> >
> >If you pull the for-linus branch from today, hopefully the problem will
> >be gone.
> >
> 
> This looks very good. With this Kernel i still have some hangs, but
> only in rsync, only under high load and they don't lock up the
> system - so i guess it's ok now.
> 
> Thank You very much for Your help!

Glad to hear this is working.  All the credit to Miao, who found the
deadlock.

> 
> When will this patches go into the main Kernel?

Linus pulled them in yesterday.

-chris

