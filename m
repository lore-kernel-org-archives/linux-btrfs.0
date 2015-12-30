Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34527 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbbL3PRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 10:17:16 -0500
Date: Wed, 30 Dec 2015 06:15:23 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.cz>, calestyo@scientia.net, clm@fb.com,
        jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230061523.1d442f54@gmail.com>
In-Reply-To: <5683E5E4.5010006@gmx.com>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<20151229133907.GA4227@suse.cz>
	<20151229061512.79a41f31@gmail.com>
	<20151229170611.GB4227@suse.cz>
	<20151230013946.7c1f0e12@gmail.com>
	<5683C714.4040705@gmx.com>
	<20151230045449.7a6c14db@gmail.com>
	<5683E5E4.5010006@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Dec 2015 22:10:44 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Understood now.

Good.

> I totally understand that implement ... to polish your
> skill.

That has got to be the most hilarious way I believe I have seen someone
delegate a task. But it was effective.

Only one problem. I do not run BTRFS on my systems nor do I have a
RAID setup, due to possessing a limited number of free drives. So, while
I may be able to code for it, I will not be able to test it. I will need
the community's help to do the testing.

I will get started tomorrow.

To-do (so far):
- Implement RAID Stripe length as a compile and runtime option.
- Implement a way to do an in-place Stripe Length change.
- Debugging & testing for the above additions.

Thanks.
