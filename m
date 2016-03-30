Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59688 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbcC3N6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 09:58:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1alGdR-0000OW-VK
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 15:58:14 +0200
Received: from 168.159.160.57 ([168.159.160.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 15:58:13 +0200
Received: from toyours_sridhar by 168.159.160.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 15:58:13 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: good documentation on btrfs internals and on disk layout
Date: Wed, 30 Mar 2016 13:58:03 +0000 (UTC)
Message-ID: <loom.20160330T155403-473@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I could find very limited documentation related to on disk layout of btrfs 
and how all trees are related to each other. Except wiki which has very 
specific top level details I couldn't able to find more details on btrfs.

FSs such as zfs, ext3/4 and XFS there are documents which explains ondisk 
layout of the file systems.

Could anybody please provide pointers for the same for better 
understanding of btrfs on disk layout and how each tree interacts provided 
multiple disks are configured for btrfs.

Thank you in advance

