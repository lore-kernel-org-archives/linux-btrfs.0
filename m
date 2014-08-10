Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46267 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaHJQhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 12:37:08 -0400
Date: Sun, 10 Aug 2014 09:36:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140810163659.GO12778@merlins.org>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
 <2242759.aOKEuU2TTR@xev>
 <20140809143206.GJ11855@bitfolk.com>
 <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
 <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
 <pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
 <20140809182113.GI12778@merlins.org>
 <pan.2014.08.10.12.43.31@googlemail.com>
 <20140810143900.GB27670@merlins.org>
 <pan.2014.08.10.15.42.09@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.08.10.15.42.09@googlemail.com>
Subject: Re: Fixing the btrfs deadlocks
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 10, 2014 at 03:42:09PM +0000, Holger Hoffstätte wrote:
> On Sun, 10 Aug 2014 07:39:00 -0700, Marc MERLIN wrote:
> 
> > My apologies if I missed some Emails, but I'm a bit confused.
> > The deadlocks happen reliably with 3.15+, but those patches are marked as
> > being for 3.14 in your URL, but then you say you didn't backport them to
> > 3.14.
> 
> sigh :)
> 
> My patch queue is meant for 3.14 only. The notorious hangs in 3.15+
> are a different issue, as we have seen likely caused by the workqueue
> changes; I was only interested in keeping & improving 3.14.x, precisely
> because 3.15 is still borked and short-lived, and 3.16 has exciting new,
> completely btrfs-unrelated problems for which I really don't have much
> patience at the moment.
 
Aaah, gotcha, and to be clear, 3.16 has the same hang problems so far
(or maybe even worse).

> I meant you could try my patch queue if you intend to use 3.14.x for a
> longer period of time since it's a longterm kernel. If and when The Great

Ok, I understand you now.

> "Simply use the latest kernel" is laughably impractical for many reasons,
> and for the majority of people it's just easier to not use btrfs at all -
> which helps nobody.
 
I totally agree with you on that one.

> ..which is precisely what I said and why I'm using it. :)
> That does not mean problems identified post-3.14 cannot or should not
> be patched if they are being addressed in other trees and apply easily.

Ok, I'm following you now. 
So, I don't really have time to deal with potential recoveries and
restores if anything goes wrong in the next 3 weeks, and since 3.14
works well enough for me (the hangs are rare enough that I can deal with
them), I'm unfortunately going to skip on your offer.
I do appreciate the work you did and the rationale behind it very much
actually, I'm just not the right "customer" for this at the moment.

Hopefully this new thread will bring up your work again for others to
see and hopefully it will be useful to some.

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
