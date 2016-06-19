Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout016.mail.hostpoint.ch ([217.26.49.176]:18152 "EHLO
	mxout016.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbcFSRjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jun 2016 13:39:00 -0400
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
	by mxout016.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bEggT-000OaG-7J
	for linux-btrfs@vger.kernel.org; Sun, 19 Jun 2016 19:38:57 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp012.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bEggT-000OfD-5K
	for linux-btrfs@vger.kernel.org; Sun, 19 Jun 2016 19:38:57 +0200
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
Date: Sun, 19 Jun 2016 19:38:56 +0200
Message-Id: <6ECA5837-18AD-4DEF-A4FA-CF9B37DEBCA7@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For completeness here's the summary of my replacement of all four 6 TB drives (henceforth "6T") with 8 TB drives ("8T") in a btrfs raid1 volume.
I included transfer rates so maybe others can get a rough idea what to expect when doing similar things. All capacity units are SI, not base 2.

Filesystem usage was ~17.84 of 24 TB used when I started.

The first steps all happened while the machine was booted into emergency mode.

 1. Physically replaced 1st 6T with 1st 8T,
    without having done a logical remove beforehand.
    Should have done that to maintain redundancy.
 2. Mounted volume degraded and btrfs device remove missing.
    Took over 4 days, and 1.4 TB were still missing after.
    Also it was a close call: 17.84 TB of 18 TB used!
    (Two of the drives were completely full after this)
    Transfer rate of ~46 MB/s (~6 h/TB)
 3. Restored missing 1.4 TB onto the 1st 8T with btrfs replace -r
    Would have been more efficient to try and complete step 2.
    Transfer rate of ~159 MB/s (~1.75 h/TB)
 4. Resized to full size of 1st 8T
 5. btrfs device remove'd a 2nd 6T
 6. Physically replaced this 2nd 6T with 2nd 8T

At this point the machine was rebooted into normal mode.   

 7. Logically replaced 3rd 6T onto 2nd 8T with btrfs replace
    Transfer rate of ~140 MB/s (~1.98 h/TB)
 8. Resized to full size of 2nd 8T
 9. Physically replaced 3rd 6T with 3rd 8T

Another reboot for kernel update to 4.5.6. Also the machine received a few of the backups that were previously held back so it could restore in peace.

10. Logically replaced 4th 6T onto 3rd 8T with btrfs replace
    Transfer rate of ~151 MB/s (~1.84 h/TB)
11. Resized to full size of 3rd 8T
12. Physically replaced 4th 6T with 4th 8T (reboot)
13. Logically added 4th 8T to volume with btrfs device add
14. Ran a full balance (~18 TB used). Took about 2 days.
    Transfer rate of ~104 MB/s (~2.67 h/TB)

