Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34330 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935770AbcCQUkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 16:40:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ageiD-0004hd-4M
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 21:40:05 +0100
Received: from ipbcc01ae2.dynamic.kabel-deutschland.de ([188.192.26.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 21:40:05 +0100
Received: from eye1tm by ipbcc01ae2.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 21:40:05 +0100
To: linux-btrfs@vger.kernel.org
From: Henk Slager <eye1tm@gmail.com>
Subject: Re: Blocks changed since previous snapshot of subvolume
Date: Thu, 17 Mar 2016 20:36:54 +0000 (UTC)
Message-ID: <loom.20160317T213216-965@post.gmane.org>
References: <1458211640-13106-1-git-send-email-dsterba@suse.com> <loom.20160317T145003-730@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sri <toyours_sridhar <at> yahoo.co.in> writes:

> 
> Hi,
> 
> I Would like to know between 2 snapshots of a subvolume, can we identify 
> what all blocks modified particular to that subvolume ?
> 
> there can be many subvolume and snapshots present on the btrfs but i want 
> only blocks modified since first snapshot for the specific subvolume.
> 
> blocks should include metadata and data blocks. 

Not directly diff blocks, rather files, you could do something like this:

btrfs subvolume find-new <newer_snapshot> `btrfs subvolume show 
<older_snapshot> | grep Generation | awk '{print $2}'` |  awk '{ print $17 }' 
| sort | uniq


