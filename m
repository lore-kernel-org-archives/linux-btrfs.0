Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37441 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab2FLUkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 16:40:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SeXsj-0000fz-Cu
	for linux-btrfs@vger.kernel.org; Tue, 12 Jun 2012 22:40:05 +0200
Received: from mail1.donaanacounty.org ([67.134.23.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 22:40:05 +0200
Received: from steamraven by mail1.donaanacounty.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 22:40:05 +0200
To: linux-btrfs@vger.kernel.org
From: steamraven <steamraven@yahoo.com>
Subject: Re: KVM on top of BTRFS
Date: Tue, 12 Jun 2012 20:33:37 +0000 (UTC)
Message-ID: <loom.20120612T222541-400@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org> <20120612133311.58af9d8f@natsu> <loom.20120612T162801-407@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> Seems a little unfair on btrfs to just to look at absolutes in this context.
> Prior reports said that the fs ground to a halt,
> it isn't doing that by any stretch.


I agree.  What I am mostly looking for is the best setup 
for using KVM snapshots: 

KVM qcow2 on top of something like ext4  or
raw on top of btrfs


> 
> I haven't let any of these installs complete and used it as intended.
> So that's what I intend to do next; after all one doesn't install every day.
> 

I am going to try to benchmark a couple variations and flags
qcow2 on ext4  (noatime)
raw on btrfs (defaults)
raw on btrfs (noatime,space_cache)
raw on btrfs (noatime,nospace_cache)
raw on btrfs (noatime,nodatacow)

Any other options that might be good to try?


