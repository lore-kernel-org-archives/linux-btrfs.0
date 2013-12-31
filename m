Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48064 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3LaDMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 22:12:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vxpl7-00007Z-Hw
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 04:12:45 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:12:45 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:12:45 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: A question about btrfs_ioctl_file_extent_same
Date: Mon, 30 Dec 2013 22:12:34 -0500
Message-ID: <871u0togrh.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A simple question about btrfs_ioctl_file_extent_same...

Is there any check before btrfs_cmp_data is called that short-circuits
things if the extents being compared are already the same extent?  I was
looking and could not find such a check, but I don't really know the
btrfs source code that well.  If there is no such check, would it not
make sense to add one?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

