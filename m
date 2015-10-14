Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:50580 "EHLO
	walhalla.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbbJNUTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 16:19:55 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by walhalla.sjomar.eu (Postfix) with ESMTPSA id 3C2981DFB9C
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 22:19:51 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: RAID6 stable enough for production?
Date: Wed, 14 Oct 2015 22:19:50 +0200
Message-ID: <2402569.dCkKzGyGNU@hoefnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Is RAID6 still considered unstable so I shouldn't use it in production?
The latest I could find about a test scenario is more than a year ago 
(http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html)

I want to build a new NAS (6 disks of 4TB) on RAID6 and prefer to use btrfs 
over zfs, but the latter is proven stable and I am unsure about btrfs...
Main usage for me would be to able to replace 1 or 2 failing (or going to 
fail) drives and be able to extend it in the future with more disks. The data 
on it shouldn't get corrupted unless the building were it's in is destroyed ;)

So should I go for btrfs?

NB: I am running happily a RAID5 btrfs with 4x2TB disks in it, but you'll just 
know the value of the filesystem when something goes wrong. Yes I know RAID5/6 
is not a backup ;)

Cheers,
Sjoerd

