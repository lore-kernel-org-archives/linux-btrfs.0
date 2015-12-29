Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbbL2NlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 08:41:23 -0500
Date: Tue, 29 Dec 2015 14:39:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151229133907.GA4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 07:24:11AM -0500, Sanidhya Solanki wrote:
> An option to select the RAID Stripe size is made
> available in the BTRFS Filesystem, via an option
> in the BTRFS Config setup, with minimal change
> to the existing code base.

The stripe size depends on how the filesystem was made, at the moment
the stripesize parameter is missing from mkfs. The kernel module should
support all sizes at runtime, so it's not a compile-time option.
