Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38380 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaASBNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 20:13:16 -0500
Date: Sat, 18 Jan 2014 17:13:11 -0800
From: Marc MERLIN <marc@merlins.org>
To: Sir Civit <sircivit@yahoo.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-convert destroyed my system
Message-ID: <20140119011311.GC20097@merlins.org>
References: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 17, 2014 at 07:30:49PM -0800, Sir Civit wrote:
> 
> 
> To start off, I have an encrypted LVM setup with a root logical volume and a home 
> logical volume. Today decided to upgrade my home LV to btrfs for 
> compression. I installed btrfs-progs, unmounted /home, and ran
> btrfs-convert /dev/MyVolumeGroup/home
> and it completed with no errors reported. I rebooted my system, and I got a "Welcome to emergency mode!" message. I rebooted into a live CD and 
> found that all of my logical volumes were showing up, but almost all of 
> them showed status "NOT available". I ran vgck and lvck, both of which 
> found no 
> errors. I ran lvscan and still /dev/MyVolumeGroup/ (and 
> /dev/mapper/MyVolumeGroup-*) contains only one of the LVs.

What's the kernel verion?
What's the version of btrfs-tools?

For what it's worth I also tried a btrfs convert on ubuntu precise with
their stock kernel and old btrfs-tools and it mostly destroyed the
filesystem too, but at the same time I figured I got what I deserved for
running tools and a kernel that old on that machine (not mine, hence the
issue).

Marc
 
> It seems that btrfs-convert possibly overwrote the LVM metadata somehow, but I have no idea how 
> since the argument was a logical volume. Even if I had accidentally 
> typed /dev/MyVolumeGroup, I would think that btrfs-convert should have 
> realized that it was not an ext2/3/4 filesystem.
> 
> I tried mounting one of the "available" LVs, and got
> mount: /dev/MyVolumeGroup/root is write-protected, mounting read only.
> mount: special device /dev/MyVolumeGroup/root does not exist.
> 
> I've already 
> started a fresh installation due to time constraints, but I'd like to 
> find out why this happened and let everyone know about a potential bug.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
