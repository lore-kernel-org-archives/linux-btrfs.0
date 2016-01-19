Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:36038 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbcASLMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 06:12:34 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id 3BAEF125B9
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 12:12:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 2978011DB8
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 12:12:31 +0100 (CET)
Received: from [194.8.193.239] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 569e1a1f-0b41-7f0000012729-7f000001a787-1
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 12:12:31 +0100
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 12:12:30 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Christian Rohmann <crohmann@netcologne.de>
Subject: Improve detail regarding distribution of RAID-stripes on "btrfs
 device usage" output (btrfs-progs 4.4)
Message-ID: <569E1A1E.8080700@netcologne.de>
Date: Tue, 19 Jan 2016 12:12:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I am currently running a balance on a RAID6 with former 8 devices (4TB
each) to which I added 4 more (1TB each) and it now has a total 12. The
balancing is still running but looking at "btrfs device usage" already
gives some hint on the gradually changing data distribution of the RAID6:


--- cut ---
btrfs device usage $btrfsfilesystem

/dev/sdb, ID: 1
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,single:         8.00MiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,single:           4.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.78GiB

/dev/sdc, ID: 2
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdd, ID: 3
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sde, ID: 4
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdf, ID: 5
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdg, ID: 6
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdh, ID: 7
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdi, ID: 8
   Device size:             3.64TiB
   Data,RAID6:              3.37TiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:          6.34GiB
   Metadata,RAID6:        448.00MiB
   System,RAID6:            2.00MiB
   Unallocated:           161.79GiB

/dev/sdj, ID: 9
   Device size:           931.00GiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:        448.00MiB
   Unallocated:           828.64GiB

/dev/sdk, ID: 10
   Device size:           931.00GiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:        448.00MiB
   Unallocated:           828.64GiB

/dev/sdl, ID: 11
   Device size:           931.00GiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:        448.00MiB
   Unallocated:           828.64GiB

/dev/sdm, ID: 12
   Device size:           931.00GiB
   Data,RAID6:            101.92GiB
   Metadata,RAID6:        448.00MiB
   Unallocated:           828.64GiB

--- cut ---


The old disks now show two lines with RAID6 data. Likely it's the old,
8-device stripes vs. the new 12-device stripes. But there seems to be no
detail available to show what the difference of those two lines might
be. Maybe adding the number of stripes next to the data storage style
could help i.e.

--- cut ---
/dev/sdi, ID: 8
Device size: 3.64TiB
Data,RAID6,8-way-striped: 3.37TiB
Data,RAID6,12-way-striped: 101.92GiB
Metadata,RAID6,8-way-striped: 6.34GiB
Metadata,RAID6,12-way-striped: 448.00MiB
System,RAID6: 2.00MiB
Unallocated: 161.79GiB
--- cut ---




Regards


Christian
