Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:43392 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2GIUG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 16:06:26 -0400
Date: Mon, 9 Jul 2012 22:06:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Hugo Mills <hugo@carfax.org.uk>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df won't show total=
In-Reply-To: <20120709192500.GG28701@carfax.org.uk>
Message-ID: <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr> <20120709192500.GG28701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Monday 2012-07-09 21:25, Hugo Mills wrote:
>On Mon, Jul 09, 2012 at 09:14:03PM +0200, Jan Engelhardt wrote:
>> 
>> On openSUSE_12.1 with Btrfs v0.19+20120406, the following can be
>> observed: after a change of the profiles, total=,used= is no
>> longer shown:
>> 
>> 20:49 mmsrv1:~ # btrfs fi df /top.srv/
>> Data, RAID10: total=152.00GiB, used=121.07GiB
>> System, RAID1: total=40.00MiB, used=44.00KiB
>> System: total=4.00MiB, used=0.00
>> Metadata, RAID1: total=112.00GiB, used=1.30GiB
>> Metadata: total=8.00MiB, used=0.00
>>[...]
>> 21:10 mmsrv1:~ # btrfs fi df /top.srv/
>> Data, RAID10: total=156.00GiB, used=124.35GiB
>> System, RAID10: total=128.00MiB, used=48.00KiB
>> System: total=4.00MiB, used=0.00
>> Metadata, RAID10: total=112.00GiB, used=1.38GiB
>
>   What's the problem here? You no longer have any RAID1 chunks, so
>it's not showing them.

Rather tha a 4-line output, I would have expected this 6-line output
that I would also get when mkfs'ing a new fresh btrfs volume with
raid10 from the start:

Data, RAID10: total=156.00GiB, used=124.35GiB
Data: total=foo, used=bar
System, RAID10: total=128.00MiB, used=48.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID10: total=112.00GiB, used=1.38GiB
Metadata: total=foo, used=bar
