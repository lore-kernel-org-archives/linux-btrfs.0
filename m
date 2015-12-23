Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.banditt-management.com ([176.28.28.35]:49121 "EHLO
	mail.banditt-management.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbbLWUV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:21:29 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.banditt-management.com (Postfix) with SMTP id CD78E14E0611
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:21:27 +0100 (CET)
Message-ID: <567B0245.5000902@gmx.de>
Date: Wed, 23 Dec 2015 21:21:25 +0100
From: Neuer User <auslands-kv@gmx.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs und lvm-cache?
References: <n5du09$9rn$1@ger.gmane.org>	<1527885.5NheBqth0k@merkaba>	<n5e139$r1h$1@ger.gmane.org> <CAJCQCtStdF=JU11LOjJ_xLXir_CPzJ7GaQRRqsROEE0eOADFWA@mail.gmail.com>
In-Reply-To: <CAJCQCtStdF=JU11LOjJ_xLXir_CPzJ7GaQRRqsROEE0eOADFWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.12.2015 um 20:49 schrieb Chris Murphy:
> Seems to me if the LV's on the two HDDs are exposed, the lvmcache has
> to separately keep track of those LVs. So as long as everything is
> working correctly, it should be fine. That includes either transient
> or persistent, but consistent, errors for either HDD or the SSD, and
> Btrfs can fix up those bad reads with data from the other. If the SSD
> were to decide to go nutty, chances are reads through lvmcache would
> be corrupt no matter what LV is being read by Btrfs, and it'll be
> aware of that and discard those reads. Any corrupt writes in this
> case, won't be immediately known by Btrfs because it (like any file
> system) assumes writes are OK unless the device reports a write
> failure, but those too would be found on read.

What corrupt write do you mean? The "nuts" SSD is not going to write to
the HDDs, that will be done by lvmcache. So the HDDs should get the
correct data, only the SSD will be bad, right?

And that would become obvious with the next reads, in which case btrfs
probably would throw an error as it gets crazy data from apparently both
LVs (but only coming from the SSD). So, that could be fixed by removing
the SSD without any data loss from the HDDs, right?

> 
> The question I have, that I don't know the answer to, is if the stack
> arrives at a point where all writes are corrupt but hardware isn't
> reporting write errors, and it continues to happen for a while, once
> you've resolved that problem and try to mount the file system again,
> how well does Btrfs disregard all those bad writes? How well would any
> filesystem?
> 
Hmm, again the writes to the HDDs should be ok. Only the SSD would have
pretty corrupt data, right? In such a case it might depend on how much
bad data is read back from the SSDs and what the filesystem does in
raction to these?

P.S.: Of course, one other possibility would be to use a second SSD, so
that each LV has a separate caching SSD. In this case, there would
always be a valid source (given that not both SSDs go nuts the same
time...).

But I would need another slot for this. If the pros are very high,
that's ok. If it works nicely with just one SSD, then even better.

