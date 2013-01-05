Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:53172 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3AEVRc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 16:17:32 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130105211731.MGPC2891.eastrmfepo101.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>; Sat, 5 Jan 2013 16:17:31 -0500
Message-ID: <50E8986A.2050002@czarc.net>
Date: Sat, 05 Jan 2013 16:17:30 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: /boot as a btrfs subvolume
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of the latest updates to anaconda and grub2 for Fedora 18, it is now 
possible to install with /boot as a btrfs subvolume.  The way that grub2 
is handling this is the "reach down" to the files it needs as if the 
subvolume was a directory.

Is this OK?

At this point I am not worried about snapshots or any other 
complexities.  If the subvolume name is known. should grub2 be able to 
reliably "reach down" as if that subvolume was a directory?  It needs 
some of its configuration files and, of course, the linux kernel.

Point:   it seems to work OK so far ;}

Gene
