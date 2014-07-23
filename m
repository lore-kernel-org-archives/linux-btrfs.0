Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40743 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932847AbaGWUKb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 16:10:31 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:58178 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XA2ru-00454b-Rs
	for linux-btrfs@vger.kernel.org; Wed, 23 Jul 2014 14:10:31 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: feature request: consider rw subvols ro for send when volume is mounted ro
Message-Id: <EAC867F7-CBB2-4714-9917-A29566167A21@colorremedies.com>
Date: Wed, 23 Jul 2014 14:10:29 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The use case is when it's possible to mount a Btrfs volume ro, but not rw. Example, a situation where

# mount -o degraded /dev/sdb /mnt
[   71.064352] BTRFS info (device sdb): allowing degraded mounts
[   71.064812] BTRFS info (device sdb): enabling auto recovery
[   71.065210] BTRFS info (device sdb): disk space caching is enabled
[   71.072068] BTRFS warning (device sdb): devid 2 missing
[   71.097320] BTRFS: too many missing devices, writeable mount is not allowed
[   71.116616] BTRFS: open_ctree failed

Yet this works:
# mount -o degraded,ro /dev/sdb /mnt

It would be great if it were possible to send/receive subvolumes to a different btrfs volume. Currently it's not possible because those subvols aren't ro, and because the mount is ro I can't make ro snapshots first.


Chris Murphy