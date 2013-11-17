Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:61843 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751750Ab3KQXjg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 18:39:36 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Ubunutu scanning for a btrfs fs it will never find
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$78cfa$e66d0bd7$51d5f50d$ea952b6a@cox.net>
Date: Sun, 17 Nov 2013 16:39:33 -0700
Cc: Antonio Rodulfo <arodulfo@zignux.com>
Message-Id: <430877E8-344F-44AC-88C6-120117F4C0B8@colorremedies.com>
References: <5288B4CF.90703@zignux.com> <pan$78cfa$e66d0bd7$51d5f50d$ea952b6a@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Antonio Rodulfo posted on Sun, 17 Nov 2013 13:21:35 +0100 as excerpted:

> After upgrading one of my laptops from XUbuntu 12.04 to 12.10, I started
> to see a "Scanning for Btrfs filesystems" message after the initial grub
> menu and before the system issues its startup sequence of messages.

> The system hangs now there for several seconds (15, maybe?) and keeps
> going with no further reference to btrfs.

If none of your physical disks has ever had Btrfs on it, I'd say it's a bug and should be reported.

If the disk ever once had a Btrfs volume, then it might be a stale Btrfs superblock has been found and whatever is scanning found it's broken and is looking for others, and then times out. But I'd still say this should be rather fast, that it isn't also indicates a bug.


> I have read I could remove btrfs-tools module from my kernel and / or
> blacklist it in /etc/modprobe.d

OK if this is easiest for you fine, but I still think there's at least one bug somewhere and you shouldn't have to do this.


Chris Murphy