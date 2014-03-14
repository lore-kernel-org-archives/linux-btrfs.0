Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55385 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbaCNUqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 16:46:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOYzy-0001wD-EN
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 21:46:34 +0100
Received: from p5b005895.dip0.t-ipconnect.de ([91.0.88.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 21:46:34 +0100
Received: from holger.hoffstaette by p5b005895.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 21:46:34 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: discard synchronous on most SSDs?
Date: Fri, 14 Mar 2014 20:46:09 +0000 (UTC)
Message-ID: <pan.2014.03.14.20.46.24@googlemail.com>
References: <1756989.4ep0Vdupld@tethys>
	<20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org>
	<pan$667da$c4955705$c59674a0$a844850c@cox.net> <531C1CC4.701@gmail.com>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad>
	<20140314192605.GD6143@merlins.org> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Mar 2014 15:57:41 -0400, Martin K. Petersen wrote:

> So right now I'm afraid we don't have a good way for a user to determine
> whether a device supports queued trims or not.

Mount with discard, unpack kernel tree, sync, rm -rf tree.
If it takes several seconds, you have sync discard, no?

This changed somewhere around kernel 3.8.x; before that it used to be 
acceptably fast. Since then I only do batch trims, daily (server) or 
weekly (laptop).

-h

