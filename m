Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33552 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaHKRzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 13:55:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGtoG-0006PX-Rz
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 19:55:05 +0200
Received: from 75-129-110-40.dhcp.aldl.mi.charter.com ([75.129.110.40])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 19:55:04 +0200
Received: from gmane by 75-129-110-40.dhcp.aldl.mi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 19:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: Ames Cornish <gmane@pub.cornishes.net>
Subject: Announcement: buttersink - like rsync for btrfs snapshots
Date: Mon, 11 Aug 2014 17:49:54 +0000 (UTC)
Message-ID: <loom.20140811T193907-62@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've written a utility to help me with using btrfs send and receive for 
backups or other synchronization, and I'd love to get feedback on it.  

As of this release, buttersink will synchronize a set of read-only snapshots 
in a btrfs filesystem to an Amazon S3 bucket, and vice-versa.  It 
intelligently picks parent snapshots to "diff" from, so that a minimal amount 
of data needs to be sent over the wire and stored in the backend.  

The utility is on PyPi as "buttersink", and the GitHub page is here: 
  https://github.com/AmesCornish/buttersink.  

Thanks in advance for any feedback!

- Ames


