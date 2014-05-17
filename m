Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33754 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaEQMvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 08:51:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wle4v-0004Ca-Ok
	for linux-btrfs@vger.kernel.org; Sat, 17 May 2014 14:51:05 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 May 2014 14:51:05 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 May 2014 14:51:05 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ditto blocks on ZFS
Date: Sat, 17 May 2014 13:50:52 +0100
Message-ID: <ll7lvd$ulk$1@ger.gmane.org>
References: <2308735.51F3c4eZQ7@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <2308735.51F3c4eZQ7@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/05/14 04:07, Russell Coker wrote:
> https://blogs.oracle.com/bill/entry/ditto_blocks_the_amazing_tape
> 
> Probably most of you already know about this, but for those of you who haven't 
> the above describes ZFS "ditto blocks" which is a good feature we need on 
> BTRFS.  The briefest summary is that on top of the RAID redundancy there...
[... are additional copies of metadata ...]


Is that idea not already implemented in effect in btrfs with the way
that the superblocks are replicated multiple times, ever more times, for
ever more huge storage devices?

The one exception is for SSDs whereby there is the excuse that you
cannot know whether your data is usefully replicated across different
erase blocks on a single device, and SSDs are not 'that big' anyhow.


So... Your idea of replicating metadata multiple times in proportion to
assumed 'importance' or 'extent of impact if lost' is an interesting
approach. However, is that appropriate and useful considering the real
world failure mechanisms that are to be guarded against?

Do you see or measure any real advantage?


Regards,
Martin

