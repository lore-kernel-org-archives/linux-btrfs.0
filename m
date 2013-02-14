Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab3BNMog (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 07:44:36 -0500
Date: Thu, 14 Feb 2013 13:44:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Include the device in most error printk()s
Message-ID: <20130214124433.GJ12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <E1U5jyl-00045e-Hm@peace.netnation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1U5jyl-00045e-Hm@peace.netnation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 13, 2013 at 03:25:31PM -0600, Simon Kirby wrote:
> With more than one btrfs volume mounted, it can be very difficult to find
> out which volume is hitting an error. btrfs_error() will print this, but
> it is currently rigged as more of a fatal error handler, while many of
> the printk()s are currently for debugging and yet-unhandled cases.

Please use btrfs_printk(fs_info, format, ...) for that purpose. That way
we can tune the message output format at one place. Also please do not
split format strings to more lines, this breaks grep when looking for
error messages in the sources.

david
