Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59448 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2FLPjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SeTBg-0000UJ-CS
	for linux-btrfs@vger.kernel.org; Tue, 12 Jun 2012 17:39:20 +0200
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 17:39:20 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 17:39:20 +0200
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: KVM on top of BTRFS
Date: Tue, 12 Jun 2012 15:39:10 +0000 (UTC)
Message-ID: <loom.20120612T162801-407@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org> <20120612133311.58af9d8f@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov <rm <at> romanrm.ru> writes:

(Machine has no other load at all)

No material difference between cache types (none, writeback and writethrough)
when I tried.
I had been using partition based KVM which is obviously going to
be much faster.

Seems a little unfair on btrfs to just to look at absolutes in this context.
Prior reports said that the fs ground to a halt,
it isn't doing that by any stretch.

The installs are very much diskbound iotop/atop.
More than happy to answer questions and try out things.

I haven't let any of these installs complete and used it as intended.
So that's what I intend to do next; after all one doesn't install every day.







