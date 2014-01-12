Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60875 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaALVqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 16:46:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2Srd-0003te-2s
	for linux-btrfs@vger.kernel.org; Sun, 12 Jan 2014 22:46:37 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 22:46:37 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 22:46:37 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Moving subvolumes across disks
Date: Sun, 12 Jan 2014 16:46:26 -0500
Message-ID: <87a9f0naa5.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I currently have a disk with a btrfs volume dedicated to backups.  All
of these backups are snapshotted volumes that were sent to this disk via
btrfs send/receive).  Moreover the disk has had deduplication processes
run on it a time or two.

I wish to re-format this disk using a larger metadata block (so it can
better handle large numbers of snapshots).  So I want to move all
existing data to another disk.  Is there a way to copy/move a volume
with all subvolumes to another disk, maintaining shared extents (from
deduplication)?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

