Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47117 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab3EER12 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 13:27:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZ2iX-0000gi-Ah
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 19:27:21 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 19:27:21 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 19:27:21 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient backups
Date: Sun, 05 May 2013 19:22:48 +0200
Message-ID: <64hi5a-9rq.ln1@hurikhan.ath.cx>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <km5ksq$p15$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gabriel de Perthuis <g2p.code@gmail.com> schrieb:

> There's no deep reason read-only snapshots should keep their storage
> immutable, they can be affected by raid rebalancing for example.

Sounds logical, and good...

> The current bedup restriction comes from the clone call; Mark Fasheh's
> dedup ioctl[3] appears to be fine with snapshots.  The bedup integration
> (in a branch) is a work in progress at the moment.  I need to fix a scan
> bug, tweak parameters for the latest kernel dedup patch, remove a lot of
> logic that is now unnecessary, and figure out the compatibility story.

I'd be eager to test as soon as the patches arrived in the official kernel 
distribution.

Do you plan to support deduplication on a finer grained basis than file 
level? As an example, in the end it could be interesting to deduplicate 1M 
blocks of huge files. Backups of VM images come to my mind as a good 
candidate. While my current backup script[1] takes care of this by using 
"rsync --inplace" it won't consider files moved between two backup cycles. 
This is the main purpose I'm using bedup for on my backup drive.

Maybe you could define another cutoff value to consider huge files for 
block-level deduplication?

Regards,
Kai

[1]: https://gist.github.com/kakra/5520370

