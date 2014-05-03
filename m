Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56226 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaECHy0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 May 2014 03:54:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WgUlz-0007rF-Ah
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 09:54:15 +0200
Received: from 5ED60B40.cm-7-7a.dynamic.ziggo.nl ([94.214.11.64])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 09:54:15 +0200
Received: from jaap by 5ED60B40.cm-7-7a.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 09:54:15 +0200
To: linux-btrfs@vger.kernel.org
From: Jaap Pieroen <jaap@pieroen.nl>
Subject: Re: btrfs raid56 Was: 
Date: Sat, 3 May 2014 07:53:58 +0000 (UTC)
Message-ID: <loom.20140503T093108-442@post.gmane.org>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com> <pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net> <loom.20140502T194216-357@post.gmane.org> <pan$7fdf7$8b1d584a$86e500d9$23690ab4@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> > - How can I salvage this situation and convert to raid1?
> > 
> > Unfortunately I have little spare drives left. Not enough to contain
> > 4.7TiB of data.. :(
> 
> [OK, this goes a bit philosophical, but it's something to think about...]
> 
> ... 
>
> Anyway, at least for now you should still be able to recover most of the 
> data using skip_balance or read-only mounting.  My guess is that if push 
> comes to shove you can either prioritize that data and give up a TiB or 
> two if it comes to that, or scrimp here and there, putting a few gigs on 
> the odd blank DVD you may have lying around or downgrading a few meals to 
> Raman-noodle to afford the $100 or so shipped that pricewatch says a new 
> 3 TB drive costs, these days.  I've been there, and have found that if I 
> think I need it bad enough, that $100 has a way of appearing, like I said 
> even if I'm noodling it for a few meals to do it.
> 

Thanks for the philosophical response. Both telling me I can't simply
convert, and reminding me that this was an outcome I was prepared
to face. :) Because you are right. When push comes to shove, it's 
data I'm prepared to lose.

I'm going to hedge my bets and convince the Mrs te let me invest in
some new hardware. 

