Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36854 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaLPB7J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 20:59:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y0hPf-0004i7-GK
	for linux-btrfs@vger.kernel.org; Tue, 16 Dec 2014 02:58:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 02:58:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 02:58:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 6/7] Print the summary
Date: Tue, 16 Dec 2014 01:58:45 +0000 (UTC)
Message-ID: <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
	<1418673780-22000-7-git-send-email-kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 15 Dec 2014 21:02:59 +0100 as
excerpted:

> +	printf("  Total disks size:                          %10s\n",
> +		pretty_size(total_block_count));

I really like this patch series. Makes mkfs.btrfs much nicer to use. =:^)

I'm not a dev and won't attempt a technical review, but three very minor 
and quick nits:

* Please s/disk/device/, here and possibly elsewhere.  I know I'm not the 
only one who is trying to make the switch in my own usage, as it looks a 
bit foolish (and/or marks the user as an old fogey who's likely to start 
lecturing about how a GiB isn't "small", as I'm known to do at times! 
=:^) already, as it's only going to be more so over time.

* patch title typo and omission, patch 7:  There's a good chance you 
already caught it, but just in case, for the next version, s/-o/-q/, and 
please mention it's /documentation/ that's patched here (patch 1 adds the 
switches to the code).

* Also in patch 7, first chunk, -q|--quiet is added twice...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

