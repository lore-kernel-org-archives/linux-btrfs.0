Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:6280 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754457Ab3JGTH3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 15:07:29 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: minor wiki bug, check_int mount options description
Date: Mon, 7 Oct 2013 13:07:25 -0600
Message-Id: <7079166B-32D5-4AA5-BC38-9A792AF2369E@colorremedies.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think the wiki has descriptions for check_int and check_int_data reversed:

check_int (since 3.3)
Switch on integrity checker for data and metadata (if compiled in)

check_int_data (since 3.3)
Switch on integrity checker for data (if compiled in)

https://btrfs.wiki.kernel.org/index.php/Mount_options


Where as here: http://lwn.net/Articles/466493/ it's described as
Example #1, apply integrity checks to all metadata:
mount /dev/sdb1 /mnt -o check_int

Example #2, apply integrity checks to all metadata and
to data extents:
mount /dev/sdb1 /mnt -o check_int_data


Chris Murphy
