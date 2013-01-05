Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:35302
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889Ab3AEVcU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jan 2013 16:32:20 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50E8986A.2050002@czarc.net>
Date: Sat, 5 Jan 2013 14:32:18 -0700
Message-Id: <C4D7AC34-9841-4E58-BE5D-FF30C85FBD34@colorremedies.com>
References: <50E8986A.2050002@czarc.net>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2013, at 2:17 PM, Gene Czarcinski <gene@czarc.net> wrote:

> As of the latest updates to anaconda and grub2 for Fedora 18, it is now possible to install with /boot as a btrfs subvolume.  The way that grub2 is handling this is the "reach down" to the files it needs as if the subvolume was a directory.

Also for what it's worth, it also works for multiple device Btrfs volumes, all profiles supported by GRUB2. For me GRUB fails to navigate Btrfs for RAID0 if there are 5+ devices. Single still works, oddly RAID10 still works. So some regression is needed to figure out what's going on there. May be a bug, but honestly it's still pretty cool.

Also to test is if installing grub to each device, in a multiple device raid1 or raid10 volume, still allows it to be bootable with any one device removed from the volume. I think it'll work.

Chris Murphy