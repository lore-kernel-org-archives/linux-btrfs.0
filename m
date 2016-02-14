Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49903 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbcBNJZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 04:25:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aUsvP-0006EQ-9a
	for linux-btrfs@vger.kernel.org; Sun, 14 Feb 2016 10:25:03 +0100
Received: from x4d030424.dyn.telefonica.de ([77.3.4.36])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 10:25:03 +0100
Received: from benpicco by x4d030424.dyn.telefonica.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 10:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Benjamin Valentin <benpicco@googlemail.com>
Subject: Re: One disc of 3-disc btrfs-raid5 failed - files only partially readable
Date: Sun, 14 Feb 2016 08:40:05 +0000 (UTC)
Message-ID: <loom.20160214T072657-687@post.gmane.org>
References: <20160207182841.0d749ea7@redPill> <CAPmG0jaRphE4jWi4aGUk_tV2OYyddVUXjwcNtuN+A97PTWtYVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager <eye1tm <at> gmail.com> writes:

> You could use 1-time mount option clear_cache, then mount normally and
> cache will be rebuild automatically (but also corrected if you don't
> clear it)

This didn't help, gave me

[  316.111596] BTRFS info (device sda): force clearing of disk cache
[  316.111605] BTRFS info (device sda): disk space caching is enabled
[  316.111608] BTRFS: has skinny extents
[  316.227354] BTRFS info (device sda): bdev /dev/sda errs: wr 180547340, 
rd 592949011, flush 4967, corrupt 582096433, gen 
26993

and still

[  498.552298] BTRFS warning (device sda): csum failed ino 171545 off 
2269560832 csum 2566472073 expected csum 874509527
[  498.552325] BTRFS warning (device sda): csum failed ino 171545 off 
2269564928 csum 2566472073 expected csum 2434927850

> > Do you think there is still a chance to recover those files?
> 
> You can use  btrfs restore  to get files off a damaged fs.

This however does work - thank you!
Now since I'm a bit short on disc space, can I remove the disc that 
previously disappeared (and thus doesn't have all the 
data) from the RAID, format it and run btrfs rescue on the degraded array, 
saving the rescued data to the now free disc?



