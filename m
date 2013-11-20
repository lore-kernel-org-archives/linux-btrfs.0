Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47912 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab3KTUFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 15:05:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjE1H-0006ur-6B
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 21:05:03 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 21:05:03 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 21:05:03 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfsck --repair /dev/sdc (Was: [PATCH] Btrfs-progs: allow --init-extent-tree
 to work when extent tree is borked)
Date: Wed, 20 Nov 2013 20:03:13 +0000
Message-ID: <l6j4hn$a90$2@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org> <l5vq48$2dh$1@ger.gmane.org> <l65l0s$lpm$1@ger.gmane.org> <l6f0pb$m6h$1@ger.gmane.org> <l6hm4u$s02$1@ger.gmane.org> <pan$809d5$4354febd$5ff6e929$a8235336@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$809d5$4354febd$5ff6e929$a8235336@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/11/13 17:08, Duncan wrote:

> Which leads to the question of what to do next.  Obviously, there have 
> been a number of update patches since then, some of which might address 
> your problem.  You could update your kernel and userspace and try 
> again... /if/ you have the patience...


This is on kernel 3.11.5 and Btrfs v0.20-rc1-591-gc652e4e.

Can easily upgrade to the latest kernel at the expense of killing the
existing btrfsck run.

Regards,
Martin


