Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:60063 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab2JVFho convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 01:37:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5084D3F2.8030506@parallels.com>
Date: Sun, 21 Oct 2012 23:30:35 -0600
Message-Id: <3B556B53-DA37-49C6-B634-FF648FED3B0F@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <5084D3F2.8030506@parallels.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2012, at 11:04 PM, dima <dolenin@parallels.com> wrote:

> Might be you need to balance first after adding a new disk
> btrfs filesystem balance /mnt

Good idea, although I'd argue this is potentially a huge problem if a large file system needed to be rebalanced (could take days or weeks) before removing a device. It'd likely fail in a real scenario by then. But here is the attempt:


[root@f18v ~]# btrfs fi balance /mnt
ERROR: error during balancing '/mnt' - No space left on device
There may be more info in syslog - try dmesg | tail

[ 5860.532696] btrfs: relocating block group 11070865408 flags 18
[ 5860.557268] btrfs: found 1 extents
[ 5860.573295] btrfs: relocating block group 10996416512 flags 20
[ 5860.590275] btrfs: relocating block group 10694426624 flags 20
[ 5860.616739] btrfs: relocating block group 10576199680 flags 20
[ 5860.901766] btrfs: found 2690 extents
[ 5860.923053] btrfs: relocating block group 9706930176 flags 9
[ 5863.197821] btrfs: found 4 extents
[ 5864.066177] btrfs: found 4 extents
[ 5864.086322] btrfs: 8 enospc errors during balance


Chris Murphy