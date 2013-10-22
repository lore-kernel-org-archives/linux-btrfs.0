Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56109 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3JVR7A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:59:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VYgEN-0005XK-AE
	for linux-btrfs@vger.kernel.org; Tue, 22 Oct 2013 19:58:59 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 19:58:59 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 19:58:59 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: 8 days looped? (btrfsck --repair --init-extent-tree)
Date: Tue, 22 Oct 2013 18:58:48 +0100
Message-ID: <l46ece$pi4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I've been trying to recover a 2TB single disk btrfs from a good few days
ago as already commented on the list. btrfsck complained of an error in
the extents and so I tried:

btrfsck --repair --init-extent-tree /dev/sdX


That was 8 days ago.

The btrfs process is still running at 100% cpu but with no disk activity
and no visible change in memory usage.

Looped?

Is there any way to check whether it is usefully doing anything or
whether this is a lost cause?


The only output it has given, within a few seconds of starting, is:


parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
Ignoring transid failure


Any comment/interest before abandoning?

This all started from trying to delete/repair a directory tree of a few
MBytes of files...


Regards,
Martin

