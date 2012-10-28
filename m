Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab2J1WUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 18:20:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TSbDv-0000h4-Ow
	for linux-btrfs@vger.kernel.org; Sun, 28 Oct 2012 23:20:51 +0100
Received: from cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com ([81.97.59.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 23:20:51 +0100
Received: from samtygier by cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 23:20:51 +0100
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: warnings for silly/pointless raid levels
Date: Sun, 28 Oct 2012 22:20:32 +0000
Message-ID: <k6kb3g$ae4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I recently got into a stick situation because i had a btrfs volume with data in raid1 but metadata as dup. when i removed one of the drives i could not mount as degraded. This was my error as i did not convert the metadata when i converted it from a single/dup volume.

But i wonder if there should be a warning for raid combinations that are probably mistakes. raid1/dup, provides no protection against a failed disk, but uses as much space as if it did. so maybe the tools could have refused to allow it without a --force. 

sam

