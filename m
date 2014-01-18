Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm40.bullet.mail.ne1.yahoo.com ([98.138.229.33]:23977 "EHLO
	nm40.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbaARDdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 22:33:35 -0500
Message-ID: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com>
Date: Fri, 17 Jan 2014 19:30:49 -0800 (PST)
From: Sir Civit <sircivit@yahoo.com>
Reply-To: Sir Civit <sircivit@yahoo.com>
Subject: btrfs-convert destroyed my system
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



To start off, I have an encrypted LVM setup with a root logical volume and a home 
logical volume. Today decided to upgrade my home LV to btrfs for 
compression. I installed btrfs-progs, unmounted /home, and ran
btrfs-convert /dev/MyVolumeGroup/home
and it completed with no errors reported. I rebooted my system, and I got a "Welcome to emergency mode!" message. I rebooted into a live CD and 
found that all of my logical volumes were showing up, but almost all of 
them showed status "NOT available". I ran vgck and lvck, both of which 
found no 
errors. I ran lvscan and still /dev/MyVolumeGroup/ (and 
/dev/mapper/MyVolumeGroup-*) contains only one of the LVs.

It seems that btrfs-convert possibly overwrote the LVM metadata somehow, but I have no idea how 
since the argument was a logical volume. Even if I had accidentally 
typed /dev/MyVolumeGroup, I would think that btrfs-convert should have 
realized that it was not an ext2/3/4 filesystem.

I tried mounting one of the "available" LVs, and got
mount: /dev/MyVolumeGroup/root is write-protected, mounting read only.
mount: special device /dev/MyVolumeGroup/root does not exist.

I've already 
started a fresh installation due to time constraints, but I'd like to 
find out why this happened and let everyone know about a potential bug.

