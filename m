Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbbL3QTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 11:19:39 -0500
Date: Wed, 30 Dec 2015 17:17:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Sanidhya Solanki <jpage.lkml@gmail.com>, David Sterba <dsterba@suse.cz>,
        calestyo@scientia.net, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230161722.GF4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz>
 <20151229061512.79a41f31@gmail.com>
 <20151229170611.GB4227@suse.cz>
 <20151230013946.7c1f0e12@gmail.com>
 <5683C714.4040705@gmx.com>
 <20151230045449.7a6c14db@gmail.com>
 <5683E5E4.5010006@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5683E5E4.5010006@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 10:10:44PM +0800, Qu Wenruo wrote:
> Now I am on the same side of David.
> Which means a runtime interface to change them. (along with mkfs option)
> 
> If provide some configurable features, then it should be able to be 
> tuned at both right time and mkfs time.
> Or, just don't touch it until there is really enough user demand.
> (In stripe_len case, it's also a possible choice, as configurable stripe 
> length doesn't really affect much except RAID5/6)

I think that we need configurable stripe size regardless. The
performance drop is measurable if the stripe size used by filesystem
does not match the hardware.

> I totally understand that implement will cost you a lot of more time, 
> not only kernel part but also user-tool part.
> 
> But this also means more patches.
> No matter what the motivation for you to contribute to btrfs, more 
> patches (except the more time spent) are always good.
> 
> More patches, more reputation built in community, and more patches also 
> means better split code structures for easier review.

Let me note that a good reputation is also built from patch reviews
(hint hint).
