Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34202 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbaBJN2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 08:28:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCqum-0005yF-Fe
	for linux-btrfs@vger.kernel.org; Mon, 10 Feb 2014 14:28:48 +0100
Received: from 212.44.20.129.ip.redstone-isp.net ([212.44.20.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 14:28:48 +0100
Received: from frank by 212.44.20.129.ip.redstone-isp.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 14:28:48 +0100
To: linux-btrfs@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: btrfs send runs out of memory and file handles
Date: Mon, 10 Feb 2014 13:28:38 +0000
Message-ID: <52F8D406.7000207@kingswood-consulting.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm attempting to back up a btrfs subvolume with

   $ btrfs send /path/to/subvol | nc

and the receiving end does

   $ nc -l | btrfs receive /path/to/volume

This subvolume holds ~250 GB of data, about half full, and uses RAID1.

Doing so runs out of file descriptors on the sending machine (having 
over 100k files open) and eventually runs out of memory and gets killed 
by the OOM killer.

What are the memory requirements of btrfs send?
This is the initial send so the entire volume must be transferred. Are 
later send operations equally memory-intensive?

Is it possible to do an incremental send, or send partial snapshots and 
combine them later on?

Thanks,

Frank

