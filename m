Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58651 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3EAHvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 03:51:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXRp1-0008Ea-OZ
	for linux-btrfs@vger.kernel.org; Wed, 01 May 2013 09:51:27 +0200
Received: from 212.71.117.90 ([212.71.117.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 09:51:27 +0200
Received: from alexanders.mailinglists+nospam by 212.71.117.90 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 09:51:27 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Best Practice - Partition, or not?
Date: Wed, 1 May 2013 07:51:12 +0000 (UTC)
Message-ID: <loom.20130501T094600-451@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

If I want to manage a complete disk with btrfs, what's the "Best Practice"? 
Would it be best to create the btrfs filesystem on "/dev/sdb", or would it be 
better to create just one partition from start to end and then do "mkfs.btrfs 
/dev/sdb1"?

Would the same recomendation hold true, if we're talking about huge disks, 
like 4TB or so?

Cross platform compatibility (OS X, Windows, FreeBSD, …) is of no matter to 
me.


Thanks,
Alexander

