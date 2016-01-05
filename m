Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbcAEKfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 05:35:21 -0500
Date: Tue, 5 Jan 2016 11:33:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        calestyo@scientia.net, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160105103300.GR4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz>
 <20151229061512.79a41f31@gmail.com>
 <20151229170611.GB4227@suse.cz>
 <20151230013946.7c1f0e12@gmail.com>
 <5683C714.4040705@gmx.com>
 <20151230045449.7a6c14db@gmail.com>
 <5683E5E4.5010006@gmx.com>
 <20151230161722.GF4227@twin.jikos.cz>
 <20151230162147.7b95c7a7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151230162147.7b95c7a7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 04:21:47PM -0500, Sanidhya Solanki wrote:
> On Wed, 30 Dec 2015 17:17:22 +0100
> David Sterba <dsterba@suse.cz> wrote:
> 
> > Let me note that a good reputation is also built from patch reviews
> > (hint hint).
> 
> Unfortunately, not too many patches coming in for BTRFS presently.
> Mailing list activity is down to 25-35 mails per day. Mostly feature
> and bug requests.
> 
> I will try to pitch in with patch reviews where possible.

It was not meant specifically to you, but I won't discourage you from
doing reviews of course. The period where a review is expected can vary
and is bound to the development cycle of kernel. At the latest, they
should come before the integration branch is put togheter (before the
merge window), and for the rc's it's before the next schedule (less than
a week).

The reviewed-by tag has a real meaning and weight in the community

http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L552

and besides that, subscribes the person to the blame game and can cause
bad feelings if the code turns out to be buggy later on.
