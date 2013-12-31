Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32726 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3LaDS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 22:18:58 -0500
Date: Tue, 31 Dec 2013 11:18:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20131231031835.GA30107@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
 <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
 <10456749.stdChJhbpX@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <10456749.stdChJhbpX@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 12:34:42PM +0100, Martin Steigerwald wrote:
> Am Montag, 30. Dezember 2013, 16:12:55 schrieben Sie:
> > This adds deduplication subcommands, 'btrfs dedup command <path>',
> > including enable/disable/on/off.
> 
> Nice. Looking forward to test it.

Well, I just got a report from another user, Marcel, who still got ENOSPC errors with this
around of patch set, so it seems that I don't really fix that bug, I guess I
have to work harder on this :-(

>  
> > - btrfs dedup enable
> > Create the dedup tree, and it's the very first step when you're going to use
> > the dedup feature.
> > 
> > - btrfs dedup disable
> > Delete the dedup tree, after this we're not able to use dedup any more
> > unless you enable it again.
> 
> So if deduplication has been switched on for a while, btrfs dedup disable will 
> cause BTRFS to undo the deduplication (and thus require more space for the 
> same amount of data)?

No, it remains unchanged, and the data is independent of dedupe, so you can read
them without any problems.

Happy new year.

Thanks,
-liubo
