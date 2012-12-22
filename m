Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:53746 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LVNoP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Dec 2012 08:44:15 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121222134413.KTVG2891.eastrmfepo101.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 22 Dec 2012 08:44:13 -0500
Message-ID: <50D5B92D.105@czarc.net>
Date: Sat, 22 Dec 2012 08:44:13 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: fsck.btrfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am new to btrfs and have begun exploring and testing it.  One of these 
tests is to install Fedora 18 into a btrfs volume only leaving /boot and 
swap on regular partitions.  BTW, this is on qemu/kvm/libvirt virtuals.

I discovered an error was occurring during bootup because systemd was 
attempting to start fsck.btrfs and it was missing.

1. Would btrfsck be the appropriate program to run at bootup?  If it is, 
with what parameters?

2.  Should there be a fsck.btrfs but it has not been written yet?

3. Does btrfs even need a "fsck.btrfs"?

I get the distinct impression that "btrfs is not your father's 
filesystem" and thus need to be looked at very differently.

Gene
