Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53475 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2GVUzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 16:55:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1St3BA-0005Fv-4T
	for linux-btrfs@vger.kernel.org; Sun, 22 Jul 2012 22:55:04 +0200
Received: from hsi-kbw-46-223-84-239.hsi.kabel-badenwuerttemberg.de ([46.223.84.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2012 22:55:04 +0200
Received: from jochen3941 by hsi-kbw-46-223-84-239.hsi.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2012 22:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: Jochen <jochen3941@gmail.com>
Subject: btrfs-convert complains that fs is mounted even if it isn't
Date: Sun, 22 Jul 2012 22:51:51 +0200
Message-ID: <juhp57$5aq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to run btrfs-convert on a system that has three raid 
partitions (boot/md1, swap/md2 and root/md3). When I boot a rescue 
system from md1, and try to run "btrfs-convert /dev/md3", it complains 
that /dev/md3 is already mounted, although it definitely is not. The 
only partition mounted is /dev/md1 because of the rescue system. When I 
replicate the setup in a local VM, booting the rescue system from 
another disk (no /dev/md1 mounted) helps, btrfs-convert runs. However, 
I cannot do this on the server.

Is there anything I can do about this?

Regards,
Jochen


