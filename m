Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474AbcGKKvz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:51:55 -0400
Date: Mon, 11 Jul 2016 12:51:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: can't use btrfs on USB-stick (write errors)
Message-ID: <20160711105157.GV13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <85480401635e3cc778b7ab1d241072e8@admin.virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <85480401635e3cc778b7ab1d241072e8@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:54:57PM +0900, Tomasz Chmielewski wrote:
> I've tried to use btrfs on USB-stick, but unfortunately it fails with 
> write errors.
> 
> The below is for kernel 4.4; I've tried with 4.6.2, and it fails in a 
> similar way.
> 
> 
> I'm not sure how to reliably reproduce it, but it seems to me it has 
> something to do with:
> 
> - plenty of random writes
> 
> - USB stick sometimes "very slow to reply" (may be USB-stick dependent)
> 
> 
> The closest thing to reproduce pretty much within an hour was launching 
> ktorrent and downloading a couple of Linux isos.
> 
> ext4 does not fail under similar load. USB stick is brand new, writing 
> data with dd is successful, reading data with dd is successful (whether 
> it's ext4, btrfs or raw partition); it only seems to fail with btrfs and 
> plenty of random writes.

I think it's the write pattern that does not go well with the usb stick.
>From the logs provided, it's an EIO during transaction commit, that's
usually fatal so the filesystem switches to read-only.

The dd write pattern (and consecutive writes) do not stress the flash
translation layer or it's internal block allocation and reclaim. As you
say it's not easy to reproduce, I'm more inclined to blame the usb
stick.
