Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38976 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaAKLiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 06:38:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1wtT-0006pz-7I
	for linux-btrfs@vger.kernel.org; Sat, 11 Jan 2014 12:38:23 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 12:38:23 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 12:38:23 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Status of self-healing features in btrfs
Date: Sat, 11 Jan 2014 12:32:37 +0100
Message-ID: <lnm7qa-2i7.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

What is the status of btrfs' self-healing capabilities?

On my backup btrfs device I am currently facing back-reference errors that 
neither btrfs can deal with online, nor btrfsck is able to repair it (it 
bails out with an assertion). I'm going to post this as a separate post.

So in this post it comes down to the question about self-healing.

I imagine btrfs should support the following features (just a few thoughts, 
I did not take a scientific exercise, and I am no filesystem dev):

  * error resilience: fix simple structure errors silently but inform the
    admin about the problem (by logging to klog so it can be watched by
    a process to send a notification to the admin)

  * data integrity: I think this is almost done by checking for a good
    copy of the data block in the other devices using checksums,
    automatically rebuild the bad blocks during this process, notify the
    admin

  * zero-downtime guarantees: Try to avoid to take the volume offline nor
    force read-only remount, instead log the error within the fs structures
    and deny access to the data being accessed, inform the admin that an
    offline/mount-time check/repair is needed

  * transparent self-healing: If the data being accessed is currently
    repaired or scanned (because this has been triggered by some process),
    block the accessing process until that fixing has finished. Of course
    this means we either need to guarantee really short time periods needed
    for self-healing or have a timeout on blocking the process so processes
    do not pile up and can bail-out with an error if blocked for too long.
    Actually, this is similar to auto-remount ro with the difference it only
    affects parts of the filesystem.

  * fast automatic scan and repair: At mount-time, check for logged errors
    and run a scanning/fixing thread (either offline or online) to check
    only the device areas marked as faulty. Ideally, it should only take a
    few seconds so downtime is minimized

  * Forced full online filesystem scan: Allow running a full online scan for
    errors triggering the above mentioned methods in case errors are found

  * Forced full offline filesystem scan: As a last resort or when errors
    cannot be fixed with any of the above methods, allow running a full
    offline scan and fix for errors. The above methods can trigger to notify
    the admin that this scan is actually needed because the found errors are
    too extensive to be fixed online or by self-healing

I think all these capabilities are really needed with todays device sizes (a 
full filesystem scan can take hours, maybe even days) and requirements in 
productive systems (desktop and servers).

Regards,
Kai

