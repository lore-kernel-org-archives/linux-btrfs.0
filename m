Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52105 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaKWWtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 17:49:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xsfy4-0004dO-OH
	for linux-btrfs@vger.kernel.org; Sun, 23 Nov 2014 23:49:20 +0100
Received: from pd953ef80.dip0.t-ipconnect.de ([217.83.239.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 23:49:20 +0100
Received: from holger.hoffstaette by pd953ef80.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 23:49:20 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Sun, 23 Nov 2014 22:49:01 +0000 (UTC)
Message-ID: <pan.2014.11.23.22.49.01@googlemail.com>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<20141123211650.GU8916@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 23 Nov 2014 13:16:50 -0800, Marc MERLIN wrote:

(snip)

> That makes sense. I'll try to synthetize all this and rewrite my blog
> post and the wiki to make this clearer.

Maybe also add that as of 3.18 empty block groups are automatically
collected, so balancing to prevent ENOSPC-by-empty-chunks is no longer
necessary. This works pretty well; I haven't run balance in weeks,
and my total-vs.-used overhead has always been <10 GB.

Holger

