Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51329 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbcCKXjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 18:39:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aeWe2-0007tx-Pw
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 00:38:58 +0100
Received: from 87-127-16-100.static.enta.net ([87.127.16.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Mar 2016 00:38:58 +0100
Received: from 6401e46d by 87-127-16-100.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Mar 2016 00:38:58 +0100
To: linux-btrfs@vger.kernel.org
From: boris <6401e46d@opayq.com>
Subject: Re: Snapshots slowing system
Date: Fri, 11 Mar 2016 23:38:48 +0000 (UTC)
Message-ID: <loom.20160312T002538-774@post.gmane.org>
References: <56E324AD.6010002@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wondered whether you had elimated fragmentation, or any other known gotchas, 
as a cause?

Out of curiosity, what is/was the utilisation of the disk? Were the snapshots 
read-only or read-write?

Apropos Nada: quick shout out to Qu to wish him luck for the 4.6 merge.

[Also, damn you autocorrection on my phone!]



