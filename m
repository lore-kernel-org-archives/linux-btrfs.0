Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbbL2RI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 12:08:26 -0500
Date: Tue, 29 Dec 2015 18:06:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151229170611.GB4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz>
 <20151229061512.79a41f31@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151229061512.79a41f31@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 06:15:12AM -0500, Sanidhya Solanki wrote:
> On Tue, 29 Dec 2015 14:39:07 +0100
> David Sterba <dsterba@suse.cz> wrote:
> 
> > The stripe size depends on how the filesystem was made, at the moment
> > the stripesize parameter is missing from mkfs. The kernel module
> > should support all sizes at runtime, so it's not a compile-time
> > option.
> 
> No good? I will try and re-implement it as a runtime option.

So you want to make the stripe size configurable? The stripesize is
sotred in the superblock but as the hardcoded value is 64k through the
BTRFS_STRIPE_LEN define, the superblock value is not honored in the
code. I don't know about all implications from changing the define to
sb->stripesize, also we want to define the allowed range etc. It would
be better to add more description to the patch.
