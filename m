Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:56622
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab3ACTSI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 14:18:08 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CO8iwyguCXB@helmut.hullen.de>
Date: Thu, 3 Jan 2013 12:18:06 -0700
Message-Id: <DF59971D-A5F2-4664-A4A7-2095CD8382DB@colorremedies.com>
References: <CO8iwyguCXB@helmut.hullen.de>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device can mean more than one thing, physical device, partition, md device, logical volume, etc.

Label is more narrowly defined to that of filesystems.

MBR has no mechanism for labeling the disk itself or the partitions. So /dev/sda cannot have a label or a name. Whereas with GPT, there is a field for each partition to have a name, completely independent of the file system used. So if you really want physical devices given a name, the closest thing you have to that is GPT.


On Jan 3, 2013, at 12:08 PM, Hullen@t-online.de (Helmut Hullen) wrote:

> Labelling via "btrfs filesystem label <device> <label>" works well.

It's a bug. I'm able to reproduce it as well. The command language itself indicates its the fs that's to be labeled. "device" in this case maps a /dev/X device to a fs UUID. It always should apply to the file system. If you want to name your partitions, use GPT.


Chris Murphy