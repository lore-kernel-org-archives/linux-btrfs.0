Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:47624 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871Ab2GBVwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 17:52:09 -0400
Date: Mon, 2 Jul 2012 14:46:11 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: linux-btrfs@vger.kernel.org
cc: dsterba@suse.cz
Subject: no dev_stats entry found / OK on first mount after mkfs
Message-ID: <alpine.DEB.2.01.1207021441450.5568@trent.utfs.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

after upgrading from 3.4.0 to 3.5.0-rc5 on this powerpc machine, the 
following is printed during bootup:

  [   18.630750] device fsid ce8c9df5-0a93-47c6-adf6-25084f352a4f devid 1 transid 11061 /dev/hda7
  [   18.637193] btrfs: disk space caching is enabled
  [   18.706423] btrfs: no dev_stats entry found for device /dev/hda7 (devid 1) (OK on first mount after mkfs)

The btrfs on hda7 has been created many months ago and has been mounted 
several times since then. Assuming "first mount after mkfs" does not apply 
here, is it then NOT OK that no dev_stats entry has been found?

IOW: should I worry about this message?

Thanks,
Christian.
-- 
BOFH excuse #313:

your process is not ISO 9000 compliant
