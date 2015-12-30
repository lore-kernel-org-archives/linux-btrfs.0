Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbbL3QAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 11:00:21 -0500
Date: Wed, 30 Dec 2015 16:58:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>,
        calestyo@scientia.net, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230155805.GE4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz>
 <20151229061512.79a41f31@gmail.com>
 <20151229170611.GB4227@suse.cz>
 <20151230013946.7c1f0e12@gmail.com>
 <5683C714.4040705@gmx.com>
 <20151230045449.7a6c14db@gmail.com>
 <5683E5E4.5010006@gmx.com>
 <20151230061523.1d442f54@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151230061523.1d442f54@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 06:15:23AM -0500, Sanidhya Solanki wrote:
> Only one problem. I do not run BTRFS on my systems nor do I have a
> RAID setup, due to possessing a limited number of free drives. So, while
> I may be able to code for it, I will not be able to test it. I will need
> the community's help to do the testing.

Multiple devices can be simulated by loop devices or one physical device
partitioned. I'd expect at least some testing on your side, the
community will help with testing, but that's nothing specific to this
patch. This happens all the time.

> I will get started tomorrow.
> 
> To-do (so far):
> - Implement RAID Stripe length as a compile and runtime option.

I was trying to explain that it's not a compile time option.

> - Implement a way to do an in-place Stripe Length change.

How are you going to implement that? I've suggested the balance filter
style of conversion, which is not in-place so I'm curious what do you
mean by in-place.
