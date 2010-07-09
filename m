From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Fri, 9 Jul 2010 16:30:15 -0400
Message-ID: <20100709203015.GC3032@think>
References: <4C07C321.8010000@redhat.com>
 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
 <4C1B7560.1000806@gmail.com>
 <20100618155653.GC10919@shareable.org>
 <4C1BC924.30604@redhat.com>
 <20100618193555.GV27466@think>
 <4C1BED56.9010300@redhat.com>
 <20100621131528.GA17979@think>
 <20100621180013.GD17979@think>
 <4C36A2BA.7010807@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C36A2BA.7010807@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've just been giving a long stress run.  It is working here without
trouble though, and I'll send it for the next rc.

-chris

On Fri, Jul 09, 2010 at 02:16:58PM +1000, Chris Samuel wrote:
> Chris,
> 
> On 22/06/10 04:00, Chris Mason wrote:
> 
> > I'm still putting this patch through more testing, the
> > double split code is used in some difficult corners and
> > I need to make sure I've tried all of them.
> 
> How did that patch go ?
> 
> I've got a few people on our local LUG list who are interested
> in btrfs but were concerned about all the noise about balancing;
> I thought this might have hit git for 2.6.35, but I can't see
> it there..
> 
> cheers,
> Chris
> -- 
>  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
