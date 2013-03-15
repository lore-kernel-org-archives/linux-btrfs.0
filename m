Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab3COPW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 11:22:26 -0400
Date: Fri, 15 Mar 2013 16:22:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Swapfile on btrfs
Message-ID: <20130315152224.GH7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <kgjad5$7kt$1@ger.gmane.org>
 <20130227175226.GM27541@twin.jikos.cz>
 <kglrn1$cdu$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kglrn1$cdu$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 12:52:50PM -0800, Alex Elsayed wrote:
> Also, in talking on IRC with Hugo Mills he helped me realize another issue - 
> specifically, that a.) DIO to compressed data falls back to buffered IO, and 
> b.) (at least according to the wiki) the compress_force mount option takes 
> precedence over the NOCOMPRESS file flag.
> 
> Thinking about it further, I realized that individual extents could be 
> compressed, at which point this could get rather onerous on swapon since we 
> might well need to check each and every extent to make sure it isn't 
> compressed.

There are a few limitations I can think of:

* the file has to be nocow (stable block ranges)
* no compression for the swap file (due to nocow)

* snapshot of the swapfile would work probably the same way as in any
other nocow file, but may imply unexpected or unwanted locking and
interfering with swap.

* relocation must not move the file extents, which makes balance
still possible, but it may not be able to satisfy the filter
requirements (the 1G chunks are basically pinned until the swap file
is active)
  - this affects 'device remove', 'fi resize'
  - depends on the raid profile used for the file, raid 0 is likely to
    pin all devices

david
