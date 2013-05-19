Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46152 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3ESRb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 13:31:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ue7SB-0005jE-2n
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 19:31:27 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:31:27 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:31:27 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs (general) raid for other filesystems?
Date: Sun, 19 May 2013 18:31:14 +0100
Message-ID: <knb28t$p9p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a random Sunday afternoon thought:

We've got some rather nice variations on the block-level RAID schemes
but instead being implemented at the filesystem level in btrfs...

Could the btrfs RAID be coded to be general so that a filesystem stack
could be set up whereby the filesystem level raids could be used for ANY
filesystem?


So for example, we could have the stack:


filesystem level RAID

 |
 V

filesystem

 |
 V

Block level


So, an interesting variation could be to have filesystem level raid
operating on ext4 or nilfs or whatever... Would that be a sensible idea?



Regards,
Martin

