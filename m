From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result properly
Date: Tue, 19 Apr 2011 07:55:21 -0400
Message-ID: <1303213987-sup-4275@think>
References: <4DA409E6.7020406@cn.fujitsu.com> <4DACEA40.5020008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <4DACEA40.5020008@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Xiao Guangrong's message of 2011-04-18 21:49:52 -0400:
> On 04/12/2011 04:14 PM, Xiao Guangrong wrote:
> > It doesn't allocate extent_state and check the result properly:
> > - in set_extent_bit, it doesn't allocate extent_state if the path is not
> >   allowed wait
> > 
> > - in clear_extent_bit, it doesn't check the result after atomic-ly allocate,
> >   we trigger BUG_ON() if it's fail
> > 
> > - if allocate fail, we trigger BUG_ON instead of returning -ENOMEM since
> >   the return value of clear_extent_bit() is ignored by many callers
> > 
> 
> Ping...to see what happened. :-)

Sorry, could you please change this to check the results of the atomic
allocatoin in set/clear_extent_bit?  I'd rather not add a new BUG_ON
deeper into the code.

-chris
