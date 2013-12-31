Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44984 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3LaDaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 22:30:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vxq1s-0005pc-5Q
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 04:30:04 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:30:04 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:30:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Date: Tue, 31 Dec 2013 04:24:21 +0100
Message-ID: <60q9pa-hvn.ln1@hurikhan77.spdns.de>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com> <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com> <10456749.stdChJhbpX@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald <Martin@lichtvoll.de> schrieb:

>> - btrfs dedup disable
>> Delete the dedup tree, after this we're not able to use dedup any more
>> unless you enable it again.
> 
> So if deduplication has been switched on for a while, btrfs dedup disable
> will cause BTRFS to undo the deduplication (and thus require more space
> for the same amount of data)?

>From my intention I would guess it just looses track of what the content is 
in "content based storage" - so when re-enabling it will have to "learn" 
from beginning. It should not unshare data as sharing extents is a feature 
of btrfs disting from the function of online dedup itself.

At least that would sound reasonable to me.

Regards,
Kai

