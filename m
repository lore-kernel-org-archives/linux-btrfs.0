Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34681 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbbL2PRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 10:17:13 -0500
Date: Tue, 29 Dec 2015 06:15:12 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151229061512.79a41f31@gmail.com>
In-Reply-To: <20151229133907.GA4227@suse.cz>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<20151229133907.GA4227@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 14:39:07 +0100
David Sterba <dsterba@suse.cz> wrote:

> The stripe size depends on how the filesystem was made, at the moment
> the stripesize parameter is missing from mkfs. The kernel module
> should support all sizes at runtime, so it's not a compile-time
> option.

No good? I will try and re-implement it as a runtime option.

Thanks
