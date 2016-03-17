Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32998 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030920AbcCQOLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 10:11:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agYde-0001KW-Ax
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 15:10:58 +0100
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 15:10:58 +0100
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 15:10:58 +0100
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Blocks changed since previous snapshot of subvolume
Date: Thu, 17 Mar 2016 14:10:49 +0000 (UTC)
Message-ID: <loom.20160317T145003-730@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I Would like to know between 2 snapshots of a subvolume, can we identify 
what all blocks modified particular to that subvolume ?

there can be many subvolume and snapshots present on the btrfs but i want 
only blocks modified since first snapshot for the specific subvolume.

blocks should include metadata and data blocks. 


