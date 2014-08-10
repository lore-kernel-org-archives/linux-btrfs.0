Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44469 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaHJPmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 11:42:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGVGJ-0003dH-Qr
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 17:42:23 +0200
Received: from pd953ed30.dip0.t-ipconnect.de ([217.83.237.48])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 17:42:23 +0200
Received: from holger.hoffstaette by pd953ed30.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 17:42:23 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Fixing the btrfs deadlocks
Date: Sun, 10 Aug 2014 15:42:09 +0000 (UTC)
Message-ID: <pan.2014.08.10.15.42.09@googlemail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<20140809182113.GI12778@merlins.org>
	<pan.2014.08.10.12.43.31@googlemail.com>
	<20140810143900.GB27670@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 10 Aug 2014 07:39:00 -0700, Marc MERLIN wrote:

> My apologies if I missed some Emails, but I'm a bit confused.
> The deadlocks happen reliably with 3.15+, but those patches are marked as
> being for 3.14 in your URL, but then you say you didn't backport them to
> 3.14.

sigh :)

My patch queue is meant for 3.14 only. The notorious hangs in 3.15+
are a different issue, as we have seen likely caused by the workqueue
changes; I was only interested in keeping & improving 3.14.x, precisely
because 3.15 is still borked and short-lived, and 3.16 has exciting new,
completely btrfs-unrelated problems for which I really don't have much
patience at the moment.

> That said, if you'd like to me try a set of patches that applies to
> 3.15.latest or 3.16 to see if they stop my frequent btrfs deadlocks, I'd be
> happy to.

I meant you could try my patch queue if you intend to use 3.14.x for a
longer period of time since it's a longterm kernel. If and when The Great
Hang has been fixed I migh look at 3.16+ again, but thanks to the quite
unhelpful general btrfs backport policy I'm not holding my breath.
"Simply use the latest kernel" is laughably impractical for many reasons,
and for the majority of people it's just easier to not use btrfs at all -
which helps nobody.

The - admittedly poorly worded - "backporting" referred to getting a set
of identified patches (aka my queue) into 3.14-longterm via Greg KH; there
is nothing to do except apply them.

> If the patches are meant for 3.14, that's not very helpful since 3.14 is
> reasonably stable for me in comparison.

..which is precisely what I said and why I'm using it. :)
That does not mean problems identified post-3.14 cannot or should not
be patched if they are being addressed in other trees and apply easily.

-h

