Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:35689
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbcCKUJB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 15:09:01 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2BK3va9017495
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 20:03:57 GMT
To: linux-btrfs@vger.kernel.org
From: Pete <pete@petezilla.co.uk>
Subject: Snapshots slowing system
Message-ID: <56E324AD.6010002@petezilla.co.uk>
Date: Fri, 11 Mar 2016 20:03:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I though I would post this in case it was useful info for the list.  No
help needed as I have a fix (sort of).

I've an PC with a 3 core Phenom 720 CPU, 8GB of RAM.  / is in a RAID0
SSD btrfs file system and data, home directories, various bits of data
etc, on 2x3TB disks at btrfs RAID1.  The data file system contains the
data spread across about 5 or 6 subvolumes for ease of management.
Kernel 4.0.4.

I wrote a script which performs snapshots for appropriate subvolumes on
each file system.  Hourly snapshots were taken and kept for 24 hours
before deletion.  Daily ones 30 days and weekly ones about a year.  So
each sub-volume had approx 86 snapshots.  This worked well with the odd
sluggish response from the file system, but these were infrequent and I
was happy to accept them given the benefits of subvolumes & snapshots.


Over the past few weeks I had noticed a degradation in performance to
the point where it paused with busy disks when trying to do anything
that might involve disks until it got to an unacceptable state.  Not
sure that anything had changed, but the slowness came on over a period
of a couple weeks.

I fixed this by disabling the hourly snapshots and deleting them.
System is back to normal.  Though I would share in case there is any
value in this info for the devs.

Kind regards,

Pete
