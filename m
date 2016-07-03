Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50804 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbcGCKeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jul 2016 06:34:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bJeim-00032O-RZ
	for linux-btrfs@vger.kernel.org; Sun, 03 Jul 2016 12:33:52 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jul 2016 12:33:52 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jul 2016 12:33:52 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs defrag questions
Date: Sun, 3 Jul 2016 12:33:41 +0200
Message-ID: <20160703123341.7c297efa@jupiter.sol.kaishome.de>
References: <5776CF08.5040601@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 1 Jul 2016 22:14:00 +0200
schrieb Dmitry Katsubo <dma_k@mail.ru>:

> Hello everyone,
> 
> Question #1:
> 
> While doing defrag I got the following message:
> 
> # btrfs fi defrag -r /home
> ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
> total 1 failures
> 
> I feel that something went wrong, but the message is a bit misleading.
> 
> Provided that Dropbox is running in the system, does it mean that it
> cannot be defagmented?

That is probably true. Files that are mapped into memory (like running
executables) cannot be changed on disk. You could make a copy of that
file, remove the original, and rename the new into place. As long as
the executable is running it will stay on disk but you can now
defragment the file and next time dropbox is started it will use the
new one.

> Question #2:
> 
> Suppose that in above example /home/ftp is mounted as another btrfs
> array (not subvolume). Will 'btrfs fi defrag -r /home' defragment it
> (recursively) as well?

Yes, last time I tried the command crossed file system boundaries. It
will simply report ioctl errors if it operates on incompatible files
and continue its way.

-- 
Regards,
Kai

Replies to list-only preferred.

