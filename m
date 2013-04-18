Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41687 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965366Ab3DRNpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 09:45:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USp9W-0008GP-CO
	for linux-btrfs@vger.kernel.org; Thu, 18 Apr 2013 15:45:30 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 15:45:30 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 15:45:30 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: RAID device nomination (Feature request)
Date: Thu, 18 Apr 2013 14:45:24 +0100
Message-ID: <kkotdg$o1e$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Devs,

I have a number of esata disk packs holding 4 physical disks each where
I wish to use the disk packs aggregated for 16TB and up to 64TB backups...

Can btrfs...?

1:

Mirror data such that there is a copy of data on each *disk pack* ?

Note that esata shows just the disks as individual physical disks, 4 per
disk pack. Can physical disks be grouped together to force the RAID data
to be mirrored across all the nominated groups?


2:

Similarly for a mix of different storage technologies such as
manufacturer or type (SSD/HDD), can the disks be grouped to ensure a
copy of the data is replicated across all the groups?

For example, I deliberately buy HDDs from different
batches/manufacturers to try to avoid common mode or similarly timed
failures. Can btrfs be guided to safely spread the RAID data across the
*different* hardware types/batches?


3:

Also, for different speeds of disks, can btrfs tune itself to balance
the read/writes accordingly?


4:

Further thought: For SSDs, is the "minimise heads movement" 'staircase'
code bypassed so as to speed up allocation for the "don't care"
addressing (near zero seek time) of SSDs?



And then again: Is 64TBytes of btrfs a good idea in the first place?!

(There's more than one physical set of backups but I'd rather not suffer
weeks to recover from one hiccup in the filesystem... Should I partition
btrfs down to smaller gulps, or does the structure of btrfs in effect
already do that?)

Thanks,
Martin

