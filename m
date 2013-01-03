Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:36914 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACPbl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 10:31:41 -0500
Date: 03 Jan 2013 16:14:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8iDgPPCXB@helmut.hullen.de>
Subject: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

please delete the option "-L" (for labelling) in "mkfs.btrfs", in some  
configurations it doesn't work as expected.

My usual way:

        mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...

One call for some devices.
Wenn I add the option "-L mylabel" then each device gets the same label,  
and therefore some other programs can't find the (one) device with the  
defined label.

Especially

     blkid
     findfs LABEL=mylabel

don't work.

     file -s /dev/sdb  (etc.)

shows the label (and the problem).

Other tries:

        mkfs.btrfs -L mylabel /dev/sdb

creates a new btrfs filesystem and overwrites prior tries.

What works:

        btrfs filesystem label /dev/sdb mylabel


Viele Gruesse!
Helmut
