Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35036 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaKCGwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 01:52:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlBUy-00040R-IX
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 07:52:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 07:52:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 07:52:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 fails to recover chunk tree
Date: Mon, 3 Nov 2014 06:52:08 +0000 (UTC)
Message-ID: <pan$9eef8$ab1ab358$f95b3e8$941ea1a9@cox.net>
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com>
	<54517338.7090606@pobox.com> <54523D86.5040906@gmail.com>
	<58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com>
	<pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>
	<FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>
	<5455B25E.2070703@pobox.com> <20141102134855.33677567@natsu>
	<545610BE.1080508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Sun, 02 Nov 2014 03:08:46 -0800 as excerpted:

> Specifying none of -d -m and -s is the same as specifying all of them,
> so "btrfs balance /path" and "btrfs balance -d -m -s /path" are the same
> operation.

It's actually a bit more complicated than that.

The system type is a subset of the metadata type, so -m includes -s by 
implication.  Therefore, specifying -d -m is the same as specifying -d -s 
-m, is the same as not specifying any of them.

The normal way to balance system chunks is to balance metadata, which 
includes but is not limited to system chunks.  The -s makes it possible 
to do system chunks only, but to actually make it do it, you will need to 
pass -f, to force the balance, since normally you'd just balance 
metadata, and let system chunks be balanced as part of the metadata 
balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

