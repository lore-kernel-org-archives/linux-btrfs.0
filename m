Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46165 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2KTN6Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 08:58:25 -0500
Date: Tue, 20 Nov 2012 21:58:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ross Moore <ross@rossmoore.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Bug
Message-ID: <20121120135755.GB2620@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <CAJDbZnThjTHNON46Sb5QWyaJ9VuaKkza=Z6+OE_dh_YqavtDJQ@mail.gmail.com>
 <20121112150847.GD6347@gmail.com>
 <CAJDbZnTMmzMJYR6=qkX1CTQ365MSYeSX7L8LrE_GLsxWAbz58Q@mail.gmail.com>
 <20121120131959.GA2620@gmail.com>
 <CAJDbZnT2h8eoSHPHLjMVLMjKW+J0PcaV=pzPJs6r7=nkgTBP4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJDbZnT2h8eoSHPHLjMVLMjKW+J0PcaV=pzPJs6r7=nkgTBP4Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 20, 2012 at 09:25:02PM +0800, Ross Moore wrote:
> Strange. Does that imply a problem with disks or disk cables physically?
> Our just the data rather than the metadata?
> 

It seems to be a kernel bug since another user also reported it sometime ago.

> I've compiled the latest btrfs-tools from git trunk add of a week ago when
> I reported the bug, same results. I haven't tried an updated kernel, just
> the 3.5. Should I upgrade to 3.7 rc? Will that hold any hope of change?

To be honest, I'm not sure if it'll help.

Hope that others can come up with where goes wrong.

thanks,
liubo

> On 20 Nov 2012 21:20, "Liu Bo" <bo.li.liu@oracle.com> wrote:
> 
> > On Tue, Nov 20, 2012 at 05:54:35PM +0800, Ross Moore wrote:
> > > Hi,
> > > Any update on this before I wipe the disks and start again?
> >
> > Hi Ross,
> >
> > Sorry but I failed to reproduce it locally, although I've tried various
> > disk operations like balance, dev add/del etc...
> >
> > So have you also tried the latest btrfs or the last stable one?
> > Does they show the same 'btrfs fi df' output?
> >
> > thanks,
> > liubo
> >
