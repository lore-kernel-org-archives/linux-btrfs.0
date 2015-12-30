Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38151 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbL3Klb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 05:41:31 -0500
Date: Wed, 30 Dec 2015 01:39:46 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>, calestyo@scientia.net
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230013946.7c1f0e12@gmail.com>
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

> So you want to make the stripe size configurable?...

As I see it there are 3 ways to do it:
-Make it a compile time option that only configures it for a single
system with any devices that are added to the RAID.
-Make it a runtime option that can change based on how the
administrator configures it.
-A non-user facing option that is configurable by someone like a
distribution maintainer for all systems using the Binary Distribution.

As I see it, DS would like something like the third option, but CAM
(ostensibly a SysAdmin) wants the second option.

On the other hand, I implemented the first option. 

The first and third option can co-exit, the second is an orthogonal
target that needs to be setup separately.

Or we can make all options co-exist, but make it more complicated.

Please let me know which implementation is preferable, and, if you just
want me to expand the description (as DS' mail asked for) or redo the
entire setup.

Thanks
