Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40993 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967698Ab3DSDGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 23:06:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UT1eI-0002nl-4I
	for linux-btrfs@vger.kernel.org; Fri, 19 Apr 2013 05:06:06 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 05:06:06 +0200
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 05:06:06 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: RAID device nomination (Feature request)
Date: Thu, 18 Apr 2013 20:05:58 -0700
Message-ID: <kkqcaj$9o2$1@ger.gmane.org>
References: <kkotdg$o1e$1@ger.gmane.org> <20130418140604.GL7639@carfax.org.uk> <kkpilp$kdd$1@ger.gmane.org> <kkq3qu$t2q$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin wrote:

<snip>

> Or perhaps include the same Ceph code routines into btrfs?...

That's actually what I was thinking. The CRUSH code is actually already 
pretty well factored out - it lives in net/ceph/crush/ in the kernel source 
tree, and is treated as part of 'libceph' (which is used by both the Ceph 
filesystem in fs/ceph/ and the RBD block device in drivers/block/rbd.c).

