Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:52799 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HVLGA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 07:06:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 86C1915112
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 12:55:58 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id fIsStnD9LbIJ for <linux-btrfs@vger.kernel.org>;
	Wed, 22 Aug 2012 12:55:51 +0100 (BST)
Message-ID: <5034BD0D.8050706@pocock.com.au>
Date: Wed, 22 Aug 2012 13:05:49 +0200
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: interaction with hardware RAID?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




It is well documented that btrfs data recovery (after silent corruption)
is dependent on the use of btrfs's own RAID1.

However, I'm curious about whether any hardware RAID vendors are
contemplating ways to integrate more closely with btrfs, for example,
such that when btrfs detects a bad checksum, it would be able to ask the
hardware RAID controller to return all alternate copies of the block.

Is this technically possible within any hardware RAID device today, even
though not implemented in btrfs?

Has there been any suggestion that vendors would support this in future,
presumably for the benefit of btrfs, ZFS and other checksumming filesystems?
