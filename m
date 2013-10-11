Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42221 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab3JKHzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 03:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VUXYs-0001I1-Sv
	for linux-btrfs@vger.kernel.org; Fri, 11 Oct 2013 09:55:03 +0200
Received: from proxy4.verbund.com ([proxy4.verbund.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 09:55:02 +0200
Received: from daniel by proxy4.verbund.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 09:55:02 +0200
To: linux-btrfs@vger.kernel.org
From: Daniel <daniel@wagners.name>
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on /dev/sdb1
Date: Fri, 11 Oct 2013 07:52:52 +0000 (UTC)
Message-ID: <loom.20131011T095125-875@post.gmane.org>
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com> <5228A713.6060003@redhat.com> <20130905184453.GF15634@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

Josef Bacik <jbacik <at> fusionio.com> writes:

> 
> On Thu, Sep 05, 2013 at 10:45:23AM -0500, Eric Sandeen wrote:

[...]

> > This was a regression around July 3; there was no regression test at
> > the time.
> > 
> > [615f2867854c186a37cb2e2e5a2e13e9ed4ab0df] Btrfs-progs: cleanup similar 
code in open_ctree_* and close_ctree
> > 
> > broke it.
> > 
> > Patches were sent to the list to fix it on July 17,
> > 
> > https://patchwork.kernel.org/patch/2828820/
> > 
> > but they haven't been merged into the main repo.
> > 
> > I sent a regression test for it to the list on Aug 4, but nobody
> > reviewed it, so it hasn't been merged into the test suite, either.
> > 
> > Winning all around!
> 
> Alright, alright I'll review it, Jesus.  ;),

Is there any progress on this or can I help with solving this somehow?
 
> Josef

Daniel

