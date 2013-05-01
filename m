Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:35732 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3EAIrL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 04:47:11 -0400
Date: 01 May 2013 10:46:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CW2IaniPCXB@helmut.hullen.de>
In-Reply-To: <loom.20130501T094600-451@post.gmane.org>
Subject: Re: Best Practice - Partition, or not?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Alexander,

Du meintest am 01.05.13:

> If I want to manage a complete disk with btrfs, what's the "Best
> Practice"? Would it be best to create the btrfs filesystem on
> "/dev/sdb", or would it be better to create just one partition from
> start to end and then do "mkfs.btrfs /dev/sdb1"?

> Would the same recomendation hold true, if we're talking about huge
> disks, like 4TB or so?

I've tested both versions on a 3 disk bundle of 3 TByte disks (data  
raid0, meta raid1).

  mkfs.btrfs ... /dev/sdb /dev/sdc /dev/sdd

made some more problems, especially when recognizing or deleting the  
disk(s). Maybe that's a problem more related to "util-linux" (especially  
"wipefs" and "blkid").

Partitioning first with gdisk and then

  mkfs.btrfs ... /dev/sdb1 /dev/sdc1 /dev/sdd1

runs better (perhaps without problems).

Viele Gruesse!
Helmut
