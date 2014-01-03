Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58465 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaACAaR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 19:30:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VyseT-00057a-Lo
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 01:30:13 +0100
Received: from p5b006437.dip0.t-ipconnect.de ([91.0.100.55])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:30:13 +0100
Received: from holger.hoffstaette by p5b006437.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:30:13 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Question about ext4 conversion and leaf size
Date: Fri, 3 Jan 2014 00:29:51 +0000 (UTC)
Message-ID: <pan.2014.01.03.00.30.03@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Conversion from ext4 works really well and is an important step for
adoption. After recently converting a large-ish device I noticed
dodgy performance, even after defragment & rebalance; noticeably
different from the quite good performance of a newly-created btrfs
with 16k leaf size, as is the default since recently.

So I went spelunking and found that the btrfs-convert logic indeed
uses the ext4 block size as leaf size (from #2220):
https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/tree/btrfs-convert.c#n2245

This is typically 4096 bytes and explains the observed performance.

So while I'm basically familiar with btrfs's design, I know nothing
about the details of the conversion (I'm amazed that it works so well,
including rollback!) but can/should this not be updated to the new default
of 16k, or is there a strong necessary correlation between the ext4 block
size and the newly created btrfs?

thanks!
Holger

