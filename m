Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaHWNJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 09:09:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLB4t-0001zU-TO
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 15:09:55 +0200
Received: from pd953eba6.dip0.t-ipconnect.de ([217.83.235.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 15:09:55 +0200
Received: from holger.hoffstaette by pd953eba6.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 15:09:55 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted
 in various ways
Date: Sat, 23 Aug 2014 13:09:42 +0000 (UTC)
Message-ID: <pan.2014.08.23.13.09.42@googlemail.com>
References: <20140822155040.GU3875@merlins.org>
	<pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
	<20140822184919.GE3875@merlins.org>
	<pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
	<20140823031055.GH3875@merlins.org>
	<CAEe67=9gN2F58C2MJO0Ag-P7cRAux8+gcov0k5J2PwtNmi=MBg@mail.gmail.com>
	<20140823123249.GJ3875@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 23 Aug 2014 05:32:49 -0700, Marc MERLIN wrote:

> [snip]
> Thanks for that data point, so that rules out discard and SSDs.
> 
> Given that, it sounds like btrfs may still have a bug where everything
> does not get to disk in the right order before the system stops.

A popular candidate for this is mmap'ed IO (almost always a bad idea, 
certainly for writes). This almost always goes wrong one way or the 
other, depending on filesystem + block/VFS/mm bugs of the day.

-h

