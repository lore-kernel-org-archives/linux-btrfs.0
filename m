Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab3FRRZG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 13:25:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UozeS-0003pV-AF
	for linux-btrfs@vger.kernel.org; Tue, 18 Jun 2013 19:25:04 +0200
Received: from 97-83-132-254.dhcp.eucl.wi.charter.com ([97.83.132.254])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 19:25:04 +0200
Received: from jnelson+btrfs by 97-83-132-254.dhcp.eucl.wi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 19:25:04 +0200
To: linux-btrfs@vger.kernel.org
From: Jon Nelson <jnelson+btrfs@jamponi.net>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Tue, 18 Jun 2013 17:19:04 +0000 (UTC)
Message-ID: <loom.20130618T190955-784@post.gmane.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130618163706.GC19183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik <at> fusionio.com> writes:

> 
> On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
> > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this 
> > is a known problem?  In this case there is no powercycling; just a regular 
> > ceph-osd workload.

..


I'm able to cause a complete kernel hang by defrag'ing even one 
file on 3.9.X (3.9.0 through 3.9.4, so far).



