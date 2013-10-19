Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3JSXUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 19:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VXfoR-0000PO-Tm
	for linux-btrfs@vger.kernel.org; Sun, 20 Oct 2013 01:20:04 +0200
Received: from 63-245-179-205.ip.mtelco.net ([63-245-179-205.ip.mtelco.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Oct 2013 01:20:03 +0200
Received: from jgoerzen by 63-245-179-205.ip.mtelco.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Oct 2013 01:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: John Goerzen <jgoerzen@complete.org>
Subject: Lots of trouble hanging when rm files with many extents
Date: Sat, 19 Oct 2013 23:12:19 +0000 (UTC)
Message-ID: <loom.20131020T010912-136@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello folks,

I reported a bug here:

https://bugzilla.kernel.org/show_bug.cgi?id=63071

but I am not sure if that was the right thing to do.  This is producing OOM
issues and leading to system crashes (including eventual panics) with such
alarming frequency that I wonder if perhaps there is something different
about my setup than others.

In a nutshell, I originally made the mistake of storing a VirtualBox 40G
.vdi file on a btrfs partition (kernel 3.10).  I  managed to copy it to a
file marked chattr +C (I read the wiki *NOW*), but I couldn't delete the
original file -- rm hangs the system.

(I actually have the original file and another made with cp --reflink of it,
while trying to diagnose the issue.  I need to rm both of them)

rm starts out with lots of hard disk activity, then that stops.  I
eventually get the attached kernel BUG, then a little bit later it panics
due to out of memory.

But later I had the virtually identical problem on another system, this one
on just a 5GB file with about 25,000 extents (it was the restoresymtable
from restore(8) from the e2fs dump/restore pair).   That took down my
server, trying to delete it.

I would have expected btrfs to be more resilient by this point.  Any ideas?

Thanks,

John

