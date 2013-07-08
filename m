Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3GHVgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 17:36:32 -0400
Date: Mon, 8 Jul 2013 23:36:27 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: Scrub causes oom after removal of failed disk (linux 3.10)
Message-ID: <20130708213627.GG18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51D46F04.6010301@skagestad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51D46F04.6010301@skagestad.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 03, 2013 at 08:35:48PM +0200, Torbjørn wrote:
> Hi btrfs devs,
> 
> I have a btrfs raid10 array consisting of 2TB drives.
> 
> I added a new drive to the array, then balanced.
> The balance failed after ~50GB was moved to the new drive.
> The balance fixed lots of errors according to dmesg.
> 
> Server rebooted
> 
> The newly added drive were no longer detected as a btrfs disk.
> The array was then mounted -o recovery
> I ran btrfs dev del missing, and everything seemed to be fine.
> 
> After this I ran a scrub on the array.
> The scrub was soon stopped by the oom-killer.
> 
> After another reboot I started a new scrub.
> About 3TB into the scrub over 10 GB of memory was being consumed.
> The scrub had then fixed roughly 3,000,000 errors.
> 
> Canceling the scrub and resuming it frees the 10 GB of memory.

Thanks for the report.

This looks like the same problem that was fixed by
https://patchwork.kernel.org/patch/2697501/
Btrfs: free csums when we're done scrubbing an extent

but I don't see it included in the current for-linus branch. We want
this in the 3.10.x stable series and according to stable tree policy it
has to be merged into Linus' tree first.

david
