Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:16062 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756236Ab3BRRIH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 12:08:07 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: "Fixing" mount points
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5121DC0D.8060305@gmail.com>
Date: Mon, 18 Feb 2013 10:08:05 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C36BE313-EE1C-43CD-8A8A-D595586974DD@colorremedies.com>
References: <5121DC0D.8060305@gmail.com>
To: Bob McGowan <ramjr0915@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 18, 2013, at 12:45 AM, Bob McGowan <ramjr0915@gmail.com> wrote:

> 

> Even though things look OK from the command line, logging in through the
> window system fails (actually, just hangs).
> 
> I assume this means I should be doing something to "clean up" the
> subvolume?  Or maybe there's something in the Window system
> configuration to change?
> 
> I'm running Linux Mint 14 KDE.  My fstab for the parts in question looks
> like:
> 
> # / was on /dev/sde2 during installation
> UUID=1a...9 /     btrfs   defaults,subvol=@     0       1
> # /home was on /dev/sde2 during installation
> UUID=1a...9 /home btrfs   defaults,subvol=@home 0       2
> 
> What I want is something like:
> # / was on /dev/sde2 during installation
> UUID=1a...9 /     btrfs   defaults              0       1
> # /home is on /dev/sda1
> UUID=7f...3 /home btrfs   defaults              0       2

The 2nd fstab implies a completely different disk, the first partition is btrfs, mounted as /home. So long as the contents are user folders, i.e. the same thing found in sde2 subvol @home, then it's functionally the same as what you had before.

Also, btrfs doesn't need fs_passno set.


Chris Murphy