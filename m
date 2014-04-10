Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47217 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbaDJIWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 04:22:51 -0400
Received: from mfilter7-d.gandi.net (mfilter7-d.gandi.net [217.70.178.136])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id A60741720B1
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 10:22:49 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter7-d.gandi.net (mfilter7-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id n9fuTmMISRXV for <linux-btrfs@vger.kernel.org>;
	Thu, 10 Apr 2014 10:22:18 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 8A2641720C5
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 10:22:17 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Using noCow with snapshots ?
Date: Thu, 10 Apr 2014 10:22:15 +0200
Message-ID: <3839313.LSaoXm11Qk@zafu>
In-Reply-To: <pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net>
References: <1541415.olHfkWYf4R@zafu> <pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Duncan for the perfect explanations.

>From this, I understand that I might get both better performance by setting my 
akonadi dir to "nocow", and still be able to take a snapshot from time to 
time, which is exactly what I need.

Besides this, I'm still wondering about the changes in data security that 
turning a database to "NoCow" would bring, i.e. would the data still be well 
protected in case of a system crash or power failure ?

I have precious data in there and wouldn't like to jeopardize its security for 
a performance gain...

Kind regards.


Le mercredi 9 avril 2014 11:56:20 Duncan a écrit :
> Good questions. =:^)
> 
> #2. That's from one of the devs when the question came up perhaps a 
> couple months ago.
> 
> On a NOCOW file the first write to a fileblock (4096 bytes) after a 
> snapshot must still be COW, because the snapshot locks the old version in 
> place, and now the fileblock has changed, so it MUST be written elsewhere 
> despite the NOCOW in ordered to keep the snapshot as it was.  However, 
> the file does retain the NOCOW attribute and additional writes to the 
> same fileblock will be in-place... until the next snapshot of course.
> 
> This is why on filesystems with scripted snapshots as close as a minute a 
> part (I even saw one guy say he was doing them every 30 seconds!!), 
> setting NOCOW has very little value -- they aren't NOCOW on the first 
> write after a snapshot, and with snapshots happening every minute...,  
> Hourly snapshots are still likely to be a problem on a regularly changing 
> file, tho with daily snapshots you'd probably save some fragmentation 
> over the fairly short term anyway, but it'd still be a problem longer 
> term.
> 
> Which is why I suggest putting such files on a separate subvolume and not 
> snapshotting that subvolume, since snapshots stop at the subvolume 
> boundary.  That gives NOCOW a chance to actually *BE* NOCOW.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

