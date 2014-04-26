Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:47705 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDZOSz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 10:18:55 -0400
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id 453B012032
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 16:09:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 40C3C11D96
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 16:09:16 +0200 (CEST)
Received: from [84.44.147.88] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.2)
	(envelope-from <s.schumacher@netcologne.de>)
	id 535bbe0c-0bef-7f0000012729-7f000001a925-1
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 16:09:16 +0200
Received: from mars.solar.net (xdsl-84-44-147-88.netcologne.de [84.44.147.88])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 16:09:15 +0200 (CEST)
Date: Sat, 26 Apr 2014 16:09:15 +0200
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
To: linux-btrfs@vger.kernel.org
Subject: Confusing output of btrfs fi df
Message-ID: <20140426140915.GA12958@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Yesterday I created a btrfs-filesystem on two disk, using raid1 for
data and metadata. I then mounted it and rsynced several TB of data
onto it.

mkfs.btrfs -m raid1 -d raid1 /dev/sdf /dev/sdg

The command btrfs fi df /mnt/btrfs result in the following output:

Data, RAID1: total=2.64TiB, used=2.22TiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=380.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=4.00GiB, used=2.94GiB
Metadata, single: total=8.00MiB, used=0.00

I am a bit confused because of the "single"-entries. They are not
shown in the UseCases-example on the btrfs-website and I wonder if I
did something wrong.

I also would like to know if its possible to label a multi-disk
filesystem after creation. 

For your information, I am using Btrfs v3.12+20131125 and kernel
3.11.10-7 64bit. My distribution is an openSUSE 13.1.

Yours
Stefan
