Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:56714 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbbFPMJS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 08:09:18 -0400
Received: from smtp13.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp13.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 07D951006E5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 08:09:18 -0400 (EDT)
Received: from smtp13.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp13.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 03BBD100608
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 08:09:18 -0400 (EDT)
Received: from app26.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp13.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id EBE221006E5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 08:09:17 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app26.wa-webapps.iad3a (Postfix) with ESMTP id DB3DF380041
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 08:09:17 -0400 (EDT)
Date: Tue, 16 Jun 2015 08:09:17 -0400 (EDT)
Subject: RAID10 Balancing Request for Comments and Advices
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Message-ID: <1434456557.89597618@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a Centos 7 machine with the latest EPEL kernel-ml (4.0.5) with a 6-disk 4TB HGST RAID10 btrfs volume. With the following mount options :

noatime,compress=zlib,space_cache 0 2


"btrfs filesystem df” gives :


Data, RAID10: total=7.08TiB, used=7.02TiB
Data, single: total=8.00MiB, used=0.00B
System, RAID10: total=7.88MiB, used=656.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID10: total=9.19GiB, used=7.56GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


My first question is this : is it normal to have “single” blocks ? Why not only RAID10? I don’t remember the exact mkfs options I used but I certainly didn’t ask for “single” so this is unexpected.

My second question is : what is the best device add / balance sequence to use if I want to add 2 more disks to this RAID10 volume? Also is a balance necessary at all since I’m adding a pair?

My third question is: given that this file system is an offline backup for another RAID0 volume with SMB sharing, what is the best maintenance schedule as long as it is offline? For now, I only have a weekly cron scrub now, but I think that the priority is to have it balanced after a send-receive or rsync to optimize storage space availability (over performance). Is there a “light” balancing method recommended in this case?

My fourth question, still within the same context: are there best practices when using smartctl for periodically testing (long test, short test) btrfs RAID devices?

Thanks!

Vincent

