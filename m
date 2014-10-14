Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:49277 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbaJNXC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 19:02:56 -0400
Message-ID: <543DAB9F.3050403@pobox.com>
Date: Tue, 14 Oct 2014 16:02:55 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Wishlist Item :: re/setable "Snapshot" property
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 From what I can tell the status of a subvolume as a "snapshot" or not 
is a persistent property that has exactly one effect... determining if 
the subvolume is listed when using "-s" on btrfs subvol list. That is 
the status as "snapshot" or not seems to be largely cosmetic.

It would be useful if that property could read and modified with the 
property subcommand. In particular using "btrfs subvol list / -s" as to 
track and roll backups is great... until you decide to use one of those 
backups to replace a damaged or misused partition.

So lets say you have /home and you make /home_BACKUP_disambiguator_here 
snapshots every day and you want to keep the two most recent monthly and 
the five most recent daily. The most obvious solution is to get the 
current status with the -s option to snapshot list.

Then someone totally trashes home and you want to do the following fast 
recovery from snapshot:

btrfs subvol delete /home
btrfs subvolume snapshot /home_BACKUP_relevant_tail /home

__OR__

btrfs subvol delete /home
mv /home_BACKUP_relevant_date /home
btrfs property set /home ro false


At this point there is no way to remove /home from the listing produced 
by "btrfs subvol list / -s". This basically breaks the most (only?) 
obvious use for the -s filter anyway.

Being able to do a "btrfs property set /home snapshot false" would then 
prevent complications in the system maintenance scripts.

At present the only way get a "non-snapshot" subvolume back in place of 
/home would be to create a new subvolume with "btrfs subvolume create 
/home" and then copy the files out of the backup snapshot long-hand. /Blarg.

The other major use would be copying a complete system using 
send/receive and then promoting the received subvolumes out of snapshot 
status for the exact same reason in terms of automated backups.

There needs to be a way to manipulate this attribute.

If this attribute has any other purpose, I can't figure out what it is.
