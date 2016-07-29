Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40364 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbcG2XKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 19:10:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bTGuk-0005eM-6a
	for linux-btrfs@vger.kernel.org; Sat, 30 Jul 2016 01:09:58 +0200
Received: from p579d0472.dip0.t-ipconnect.de ([87.157.4.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 01:09:58 +0200
Received: from holger by p579d0472.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 01:09:58 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Subject: Re: memory overflow or undeflow in free space tree / space_info?
Date: Fri, 29 Jul 2016 23:09:48 +0000 (UTC)
Message-ID: <pan$38209$d40d4dd1$72fe2517$2469e42b@applied-asynchrony.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
	<20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
	<40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
	<pan$37980$c346042$59d16808$deaf83b2@applied-asynchrony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 29 Jul 2016 22:57:36 +0000, Holger Hoffstätte wrote:

> The only other patch I just found missing and which looks like it
> could/should (I think?) work on top of the 4.4.x pagesize-based
> calculations in file.c is:
> 
> a2af23b7 "__btrfs_buffered_write: Pass valid file offset when
> releasing delalloc space"
> 
> Would that make sense?

No it wouldn't, not without some other sectorsize-related patches
that came before...and those would just make matters worse.

So forget the above.

-h

