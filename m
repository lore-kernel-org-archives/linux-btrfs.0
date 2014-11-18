Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:50764 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbaKRKw3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 05:52:29 -0500
Message-ID: <546B24E9.2020705@pobox.com>
Date: Tue, 18 Nov 2014 02:52:25 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: BUG :: btrfs resize should require mount point not just /some/path
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So here's a thing...

If you've got a BTRFS root file system and you mount go to resize a 
removable media and you make a typo you can easily resize your root 
instead of a target.

mkdir /media/vol1 /media/vol2
mount /dev/sdz1 /media/vol2 # intended vol1
btrfs resize -32G /media/vol1
umount /dev/sdz1
#proceed to fark up /dev/sdz1 with partitioning tools

Since resize will accept _any_ existing directory (or even filename?) as 
the target of a resize instead of limiting the targets to known 
mount-points it pretty much invites mistakes.

The system _should_ error out on any path thats not a mount point in the 
name of safety alone.

A message like "/some/path not a mounted file system" would be less 
surprising than operating on a file system when any arbitrary directory 
is named.
