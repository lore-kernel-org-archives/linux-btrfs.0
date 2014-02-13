Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47692 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaBMTTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE1p6-0002fA-Dg
	for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:48 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 20:19:48 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 20:19:48 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Possible to wait for snapshot deletion?
Date: Thu, 13 Feb 2014 20:02:43 +0100
Message-ID: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Is it technically possible to wait for a snapshot completely purged from 
disk? I imagine an option like "--wait" for btrfs delete subvolume.

This would fit some purposes I'm planning to implement:

* In a backup scenario have a subprocess which deletes snapshots one by one,
  starting with the oldest. If free space raises above a certain threshold,
  pause the subprocess. If number of kept snapshots falls below a certain
  threshold, exit the subprocess. When the backup job finished, it joins the
  subprocess to wait for a pending subvolume deletion if any, then syncs the
  filesystem and waits some grace time for uncommitted writes, then shuts
  the system down or hibernates it.

* Wait for pending background subvolume deletion before putting the system
  to sleep.

* Get better control of cron jobs working with subvolumes so jobs either do
  not overlap or do not put too much parallel work on the file system.

Scrubbing does allow that. Why don't snapshots do? At least I found no 
options for it.

Background information: If btrfs is shut down improperly, already deleted 
subvolume entries may reappear in their directories. The deletion is not 
gracefully resumed. Since deletion of subvolumes/snapshots can take hours, 
this is a problem for systems that are not guaranteed to be up all the time 
or suffer from disconnected power, especially if multiple snapshots are 
being deleted at once. With an option to wait, a script managing snapshot 
deletion could more gracefully resume its job.

-- 
Replies to list only preferred.

