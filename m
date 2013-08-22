Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54126 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3HVJ5q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 05:57:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCReD-0006w6-3z
	for linux-btrfs@vger.kernel.org; Thu, 22 Aug 2013 11:57:45 +0200
Received: from 88.211.42.58 ([88.211.42.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 11:57:45 +0200
Received: from mark by 88.211.42.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 11:57:45 +0200
To: linux-btrfs@vger.kernel.org
From: Mark Ridley <mark@backupsystems.co.uk>
Subject: Samba strict allocate  = yes stops btrfs compression working
Date: Thu, 22 Aug 2013 09:57:24 +0000 (UTC)
Message-ID: <loom.20130822T115349-248@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

If i set strict allocate = yes in samba to speed up the transfer
of a mssql database dump,
then btrfs does not compress the file. 
I have tried it also by just copying a small file in Windows to the 
samba share and the same.
I have tried btrfs mount options autodefrag and then
 btrfs fi defrag -c and the file still does not get compressed.

I have tried kernels 3.6.11, 3.8 and 3.10.7 on FC16 and FC18.

Any help, much appreciated. 

Thanks.

Mark

