Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbcAEKSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 05:18:21 -0500
Date: Tue, 5 Jan 2016 11:16:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Sanidhya Solanki <jpage.lkml@gmail.com>, calestyo@scientia.net,
        clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160105101601.GQ4227@twin.jikos.cz>
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
 <56847AEC.8080409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56847AEC.8080409@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 08:46:36AM +0800, Qu Wenruo wrote:
> > Let me note that a good reputation is also built from patch reviews
> > (hint hint).
> 
> I must admit I'm a bad reviewer.
> As when I review something, I always has an eager to rewrite part or all 
> the patch to follow my idea, even it's just a choice between different 
> design.

Yeah that's natural, but even if one does not completely agree, it's
still possible to verify that the implementation is correct.

The reviews also help to find and share some common style of
implementation so the maintainers don't scream when they see a patch and
developers and are not suprised that the patches take several rounds.
