Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47619 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3L3Lep (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 06:34:45 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Date: Mon, 30 Dec 2013 12:34:42 +0100
Message-ID: <10456749.stdChJhbpX@merkaba>
In-Reply-To: <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com> <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 30. Dezember 2013, 16:12:55 schrieben Sie:
> This adds deduplication subcommands, 'btrfs dedup command <path>',
> including enable/disable/on/off.

Nice. Looking forward to test it.
 
> - btrfs dedup enable
> Create the dedup tree, and it's the very first step when you're going to use
> the dedup feature.
> 
> - btrfs dedup disable
> Delete the dedup tree, after this we're not able to use dedup any more
> unless you enable it again.

So if deduplication has been switched on for a while, btrfs dedup disable will 
cause BTRFS to undo the deduplication (and thus require more space for the 
same amount of data)?

Thanks and happy new year,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
