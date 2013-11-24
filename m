Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49562 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3KXUuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 15:50:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VkgdK-0008U5-DK
	for linux-btrfs@vger.kernel.org; Sun, 24 Nov 2013 21:50:22 +0100
Received: from dyndsl-178-142-093-173.ewe-ip-backbone.de ([178.142.93.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 21:50:22 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-093-173.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 21:50:22 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Clean crash...
Date: Sun, 24 Nov 2013 21:50:52 +0100
Message-ID: <ce5ama-6he.ln1@hurikhan77.spdns.de>
References: <CAK-xaQbp8Yfgpu-Tx5CV2yhACxku6_8Zv0cXFCudyFKqoq0D=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Andrea Gelmini <andrea.gelmini@gmail.com> schrieb:

>   and thanks a lot for your work.
>   I have an USB drive with BTRFS, on which I write with different
> kernel release.
>   Anyway, today I made a copy of one big file, and than powered off
> the computer with a clean shutdown (Ubuntu 13.10 - 32bit).
>   Now it's impossible to me to mount it (even with kernel 3.12).

Some init systems are not clever enough to cleanly unmount filesystems under 
some circumstances, you usually see a log message similar to this then:

"Unable to unmount filesystem. Shutting down anyway. Good luck"

I don't remember the exact phrasing. What it essantially means is that a 
sync was issued, the init systems waits another few seconds, then shuts 
down.

For your USB connected btrfs these "few seconds" could probably not be 
enough. Btrfs tends to do a lot of background work from time to time which 
makes it lag on unmount for a few minutes sometimes especially for USB 
drives. The underlying problem could also be mounting through the device 
mapper. I'm not sure how it plays into the problem but it may introduce some 
sort of write behavior that btrfs is not aware of. I'm pretty sure I've read 
something about device mapper and write barriers not working correctly which 
are needed for btrfs being able to rely on transactions working correctly.

Either find an init system which handles this in a more sane way or simply 
unmount manually before shutting the system down and wait for the unmount to 
complete and return to command line (so do it from command line, not GUI). 
Maybe try to avoid the device mapper.

BTW, this is only guessing. And I'm sorry it doesn't help for the particular 
situation you are in currently.

Did you try to mount in recovery mode? This may, however, mount an older 
version of your superblock which does not refer to your latest additions of 
files on the disk but it may be newer than what you got in your backup.

HTH
Kai

