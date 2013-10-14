Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:21701 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750997Ab3JNTVk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 15:21:40 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53704 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VVnhx-003gAd-6l
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 13:21:38 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: boot on btrfs, GRUB usage of subvolume set-default breaks boot
Message-Id: <58D806F1-00EB-4B38-982E-0BB4716827CD@colorremedies.com>
Date: Mon, 14 Oct 2013 13:21:35 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When /boot is on btrfs, and the default subvolume is changed, it makes the system unbootable. The basic configuration is subvolumes: boot, root, home, on one btrfs volume single device. The installer doesn't change the default subvolume, it remains ID 5.

If I change the default subvolume and reboot, I get a grub rescue prompt. This means core.img in the MBR gap was found, but /boot/grub/i386-pc/normal.mod could not be found. What's interesting is, at the grub rescue prompt, 'set' returns:

prefix=(hd0,msdos1)/boot/grub2
root=hd0,msdos1

This appears to be a full path name, so it should always start from top level regardless of the set-default subvolume, correct? Yet it's behaving relative to the default subvolume. If I use 'ls (hd0,msdos1)' I'm returned the contents of the subvolume I've set as default, which explains why bootability is broken.


Chris Murphy