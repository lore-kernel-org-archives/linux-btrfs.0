Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37993 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbL3Bd5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 20:33:57 -0500
Date: Tue, 29 Dec 2015 16:32:04 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151229163204.72fd775f@gmail.com>
In-Reply-To: <20151229170611.GB4227@suse.cz>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<20151229133907.GA4227@suse.cz>
	<20151229061512.79a41f31@gmail.com>
	<20151229170611.GB4227@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 18:06:11 +0100
David Sterba <dsterba@suse.cz> wrote:

> I don't know about all implications from changing the define to
> sb->stripesize, also we want to define the allowed range etc. It would
> be better to add more description to the patch.

So, is the patch atleast somewhat usable and you just need me to expand
the description, or should I write the whole patch from scratch,
modifying superblock size as a runtime configurable option?

Thanks
