Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47192 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3ERBvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 21:51:51 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6D8CA9A067A
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 19:51:50 -0600 (MDT)
Date: Fri, 17 May 2013 21:51:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel 3.8.8: btrfs still crashes on boot when it can't replay a
 log
Message-ID: <20130518015146.GJ1765@localhost.localdomain>
References: <20130516150918.GB26762@merlins.org>
 <20130517154811.GA19176@merlins.org>
 <20130516150918.GB26762@merlins.org>
 <20130517165456.GH1765@localhost.localdomain>
 <20130518012512.GD28168@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130518012512.GD28168@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 17, 2013 at 07:25:12PM -0600, Marc MERLIN wrote:
> On Fri, May 17, 2013 at 12:54:56PM -0400, Josef Bacik wrote:
> > > If so, could you add this to the list of things to fix to make btrfs a bit
> > > less scary to others? :)
> > > (and of course more production ready, this repeated problem would kill any
> > > server it happens on)
> > 
> > This has been all fixed in 3.10.  Thanks,
> 
> This is fantastic news, thanks a lot for that.
> 
> One question left: How can I tell in a problem like below whether btrfs is
> having issues, or whether my hardware is hanging?
> When this happened below, I didn't get any SATA errors from the kernel, but
> I had to reboot to clear all those hangs (after reboot it was ok)
>

When this happens run sysrq+w so I can see everybody that is backed up, and then
file a bugzilla on bugzilla.kernel.org so I can track the issue.  Thanks,

Josef 
