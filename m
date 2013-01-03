Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout02.t-online.de ([194.25.134.17]:46846 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3ACUgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 15:36:05 -0500
Date: 03 Jan 2013 20:59:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8jDbu9CXB@helmut.hullen.de>
In-Reply-To: <DF59971D-A5F2-4664-A4A7-2095CD8382DB@colorremedies.com>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 03.01.13:

> Device can mean more than one thing, physical device, partition, md
> device, logical volume, etc.

> Label is more narrowly defined to that of filesystems.

> MBR has no mechanism for labeling the disk itself or the partitions.
> So /dev/sda cannot have a label or a name.


Sure?

   btrfs filesystem label /dev/sdb mylabel

works, and then

   btrfs filesystem label /dev/sdb

shows "mylabel".
Also:

        findfs LABEL=mylabel

shows "/dev/sdb"

        blkid /dev/sdb

shows (among other data) "LABEL=mylabel"

Except for the "btrfs" command: same behaviour as with other  
filesystems. Especially with CDs and DVDs (which normally don't use  
partitions).

Viele Gruesse!
Helmut
