Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54952 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751187Ab3ELVwG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 May 2013 17:52:06 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49259 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1UbeBY-002yYv-RA
	for linux-btrfs@vger.kernel.org; Sun, 12 May 2013 15:52:04 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: Btrfs resize reliability
Message-Id: <8B0E24F9-99A9-4A51-AB0D-FCCA3807D62A@colorremedies.com>
Date: Sun, 12 May 2013 15:52:04 -0600
To: Btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


RHBZ Bug 962143.
Summary: The installer doesn't support resizing Btrfs volumes, and also doesn't support placing /boot on Btrfs.

The consequence is that the "guided" path for the installer (i.e. the more automated, non-custom path) is unable to perform an installation of Fedora 19 along side Fedora 18. My question is, resize Btrfs has been in btrfs-progs since 0.16 which dates back to 2008. So I'm wondering how reliable Btrfs shrinking is?

Is it mature enough for a major distribution's installer to actively allow the shrinking of the volume by 500MB-1000MB to make room for a new /boot on ext4?

It seems less risky to default to /boot in a new subvolume on the existing Btrfs volume, but only GRUB2 supports and comes with another consequence (grubby bug, will post separately).


Chris Murphy

