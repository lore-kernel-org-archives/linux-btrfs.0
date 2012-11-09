Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58296 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab2KIBFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 20:05:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TWd21-0004t2-5f
	for linux-btrfs@vger.kernel.org; Fri, 09 Nov 2012 02:05:13 +0100
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2012 02:05:13 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2012 02:05:13 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: How does btrfs handle sudden shutdowns?
Date: Fri, 9 Nov 2012 01:04:51 +0000 (UTC)
Message-ID: <loom.20121109T020158-874@post.gmane.org>
References: <20121106123308.GA2676@yeono.kjorling.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Kjörling <michael <at> kjorling.se> writes:

> 
> Can btrfs deal reasonably gracefully with sudden shutdowns? (I'm
> mainly thinking of power outages which lead to logical structure
> damage but not physical media damage.)
> 

Really rather well! We've had a sequence of power-cuts around here and I've
scrubbed each time, finding only one corruption over all which was fixed by the
scrub and no data lost.




