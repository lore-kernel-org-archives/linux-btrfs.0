Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50423 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbbDQGYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 02:24:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YizhD-0003v6-Rt
	for linux-btrfs@vger.kernel.org; Fri, 17 Apr 2015 08:24:12 +0200
Received: from 168.159.160.54 ([168.159.160.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 08:24:11 +0200
Received: from toyours_sridhar by 168.159.160.54 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 08:24:11 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: how many chunk trees and extent trees present
Date: Fri, 17 Apr 2015 06:24:05 +0000 (UTC)
Message-ID: <loom.20150417T081705-332@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have below queries. Could somebody help me in understanding.

1)
As per my understanding btrfs file system uses one chunk tree and one 
extent tree for entire btrfs disk allocation.

Is this correct?

In, some article i read that future there will be more chunk tree/ extent 
tree for single btrfs. Is this true.
If yes, I would like to know why more than one chunk / extent tree is 
required to represent one btrfs file system.

2)

Also I would like to know for a subvolume / snapshot , is there a 
provision to ask btrfs , represent all blocks belongs to that 
subvolume/snapshot should handle with a separate chunk tree and extent 
tree?

I am looking for a way to traverse a subvolume preferably a snapshot and 
identify all disk blocks (extents) allocated for that particular subvolume 
/ snapshot.



