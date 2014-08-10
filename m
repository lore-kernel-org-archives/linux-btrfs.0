Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55682 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaHJMno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 08:43:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGSTO-0000kP-Be
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 14:43:42 +0200
Received: from pd953ed30.dip0.t-ipconnect.de ([217.83.237.48])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 14:43:42 +0200
Received: from holger.hoffstaette by pd953ed30.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 14:43:42 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 12:43:31 +0000 (UTC)
Message-ID: <pan.2014.08.10.12.43.31@googlemail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<20140809182113.GI12778@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 09 Aug 2014 11:21:13 -0700, Marc MERLIN wrote:

> I sure hope that deadlock patch is going to be added to the 3.16.x tree,
> I'm not super stocked with being stuck at 3.14.

Let me try to re-stoke your enthusiasm a bit :)

If you are comfortable with patching your own kernel you can take
a look at my custom patch queue, which I just put up at:
https://github.com/hhoffstaette/kernel-patches/tree/master/3.14
You can take only what you need, i.e. btrfs-*.

These are meant to be ironed over latest stable in order. and mostly
address "corner cases" that seem to happen infrequently, but still
are bad enough to leave a bad taste.

Unfortunately the btrfs code has changed significantly with 3.15+,
so later patches often no longer apply at all. However the ones that do
have been working well for me. I don't just blindly add them, but rather
at least try to understand what they do/change.

I sent out an email for comments about backporting this select set of
patches to 3.14, but got no replies. :(

-h

