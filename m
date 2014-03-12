Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56788 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbaCLHy6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 03:54:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WNe08-0000NR-HP
	for linux-btrfs@vger.kernel.org; Wed, 12 Mar 2014 08:54:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 08:54:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 08:54:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: warn at fs/btrfs/extent-tree.c:5748
 __btrfs_free_extent+0x9ce/0xa20
Date: Wed, 12 Mar 2014 07:54:30 +0000 (UTC)
Message-ID: <pan$160f2$a0461d09$c8460df4$fac5305e@cox.net>
References: <alpine.DEB.2.00.1403111642350.5511@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sage Weil posted on Tue, 11 Mar 2014 16:44:40 -0700 as excerpted:

> Is this something you guys have seen before?  This is from v3.13-rc2.
> 
> [49432.777445] CPU: 3 PID: 26411 Comm: ceph-osd
> Tainted: GF         I  3.14.0-rc5-ceph-00016-gf31a96a #

v3.13-rc2?

1) That's a bit old as there's actually several 3.13 stable releases now.

2) It doesn't appear correct anyway, since the trace reports 3.14-rc5+

(Meanwhile, I'm not a dev so no comment on the root question.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

