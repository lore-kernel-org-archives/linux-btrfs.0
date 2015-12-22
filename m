Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33045 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbbLVCeg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:34:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBCmY-0001N4-9h
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 03:34:34 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 03:34:34 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 03:34:34 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: safety of journal based fs (was: Re: still kworker at 100%
 =?UTF-8?B?Y3B14oCmKQ==?=
Date: Tue, 22 Dec 2015 03:34:24 +0100
Message-ID: <20151222033424.0dea705f@jupiter.sol.kaishome.de>
References: <8336788.myI8ELqtIK@merkaba>
	<5373860.W0QrVGf34G@merkaba>
	<566E827A.2020604@cn.fujitsu.com>
	<1936131.2NX0AhU8Tu@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 14 Dec 2015 10:10:51 +0100
schrieb Martin Steigerwald <martin@lichtvoll.de>:

> > But the problem is, when recovering journal, there is no journal of
> > journal, to keep journal recovering safe from power loss.  
> 
> But the journal should be safe due to a journal commit being one
> sector? Of course for the last changes without a journal commit its:
> The stuff is gone.

This may not be true for disks having write caching enabled and write
barriers of. Then there's no barrier at a journal checkpoint.

Next thing is: At least for ext4, journal is meta-data only.

But I think what was meant here: The case of powerloss during
log-replay... Tho I think the journal should simply be fully replayed
again if it wasn't marked clean before.

Which turns us back to write barriers and write caching... ;-)

It could be that the checkpointing (or marking the journal clean after
replay) could make it do disk before the actual data made it to disk,
due to write-reordering of the hard disk - which can be effectively
circumvented by disabling write caching and enabling write barriers
(the latter should be default while I would always check the former).

-- 
Regards,
Kai

Replies to list-only preferred.

