Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50469 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161101Ab3FUBLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:11:40 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CFBB29A0406
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 19:11:39 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Jon Nelson <jnelson+btrfs@jamponi.net>, <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
 <loom.20130618T190955-784@post.gmane.org>
In-Reply-To: <loom.20130618T190955-784@post.gmane.org>
Message-ID: <20130621011137.4477.1347@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Thu, 20 Jun 2013 21:11:37 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Jon Nelson (2013-06-18 13:19:04)
> Josef Bacik <jbacik <at> fusionio.com> writes:
> 
> > 
> > On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
> > > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this 
> > > is a known problem?  In this case there is no powercycling; just a regular 
> > > ceph-osd workload.
> 
> ..
> 
> 
> I'm able to cause a complete kernel hang by defrag'ing even one 
> file on 3.9.X (3.9.0 through 3.9.4, so far).

I'm not able to reproduce this here.  Could you please capture the
output from sysrq-w during the hang?  (It will all go to your dmesg)

-chris

