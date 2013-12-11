Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43721 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab3LKRvT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 12:51:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VqnwK-0004Qo-GX
	for linux-btrfs@vger.kernel.org; Wed, 11 Dec 2013 18:51:16 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 18:51:16 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 18:51:16 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: BTRFS extended attributes mounted on a non-extended-attributes compiled
 kernel
Date: Wed, 11 Dec 2013 17:51:06 +0000
Message-ID: <l8a8lv$mk7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What happens if...

I have a btrfs that has utilised posix ACLs / extended attributes and I
then subsequently mount that onto a system that does not have the kernel
modules compiled for those features?


Crash and burn?

Or are the extra filesystem features benignly ignored until remounted on
the original system with all the kernel modules?


Thanks,
Martin

