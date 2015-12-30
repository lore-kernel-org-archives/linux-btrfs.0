Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36749 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbbL3N4x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 08:56:53 -0500
Date: Wed, 30 Dec 2015 04:54:49 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.cz>, calestyo@scientia.net, clm@fb.com,
        jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230045449.7a6c14db@gmail.com>
In-Reply-To: <5683C714.4040705@gmx.com>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<20151229133907.GA4227@suse.cz>
	<20151229061512.79a41f31@gmail.com>
	<20151229170611.GB4227@suse.cz>
	<20151230013946.7c1f0e12@gmail.com>
	<5683C714.4040705@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Dec 2015 19:59:16 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Not really sure about the difference between 2 and 3.

I should have made it clear before, I was asking the exact use case in
mind when listing the choices. Option 2 would be for SysAdmins running
production software and configuring it as they desire.
Option 3 is what we have in the Kernel now, before my patch, where the
option exists, but it is fixed by the code. You can change it, but you
need to be someone fairly involved in the upstream work (like a
distribution Maintainer). This is what my patch implements (well, this
and option 3).
Option 1 leaves it as a compile time option.

> When you mention runtime option, did you mean ioctl/mount/balance 
> convert option?

Yes, that is correct.

> And what's the third one? Default mkfs time option?
> If you can make it mkfs time option, it won't be really hard to make
> it configurable.

This would be ideal for all use-cases, but make the implementation
much larger than it would be for the other options. Hence, I asked
what the exact use case was for the end-user being targeted.
 
> I didn't consider David means something that.
> As far as I read, he means balance convert option along with mkfs
> option.

Hence, why I asked.

> At least from what I have learned in recent btrfs development,
He> He> either
> we provide a good enough interfaces (normally, balance convert ioctl
> with mkfs time option) to configure some on-disk fields.

Just confirming before starting the implementation.
> So fixed kernel value is not a really good idea, and should at least
> be replace by mkfs time option.

Will do after confirmation.

Thanks
