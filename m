Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaDSPb1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 11:31:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WbXEk-0004fV-7m
	for linux-btrfs@vger.kernel.org; Sat, 19 Apr 2014 17:31:26 +0200
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 17:31:26 +0200
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 17:31:26 +0200
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: Fixing a degraded RAID
Date: Sat, 19 Apr 2014 11:31:14 -0400
Message-ID: <87fvl9bakd.fsf@maru2.md5i.com>
References: <87y4z2avvz.fsf@maru2.md5i.com> <87ppkeato3.fsf@maru2.md5i.com>
	<20140419132335.05c96c1f@renoir.lan>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xavier Bassery <xavier@bartica.org> writes:

> On Fri, 18 Apr 2014 23:23:56 -0400
> Michael Welsh Duggan <mwd@md5i.com> wrote:
>
>> Michael Welsh Duggan <mwd@md5i.com> writes:
>> 
>> root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi df /mnt/
>> Data, RAID1: total=353.00GiB, used=328.24GiB
>> System, single: total=32.00MiB, used=56.00KiB
>> Metadata, RAID1: total=4.00GiB, used=1.43GiB
>
> As Chris Murphy noted, your "System" chunk still reported as "single"
> is likely the issue here.  This reminds me of a bug i stumbled upon
> once: https://bugzilla.kernel.org/show_bug.cgi?id=60594
>
> Have you converted your fs from SINGLE to RAID-1 profile by running a
> balance?

Yes, I did.  And I think I was still on 3.10 or 11 when this happened.

> This conversion bug should no longer occur with the patch "Btrfs: stop
> refusing the relocation of chunk 0" which has been merged since 3.12.
> But chances are that you've converted your fs with an older kernel
> without that patch.  While Ilya Dryomov investigated the issue on my
> system, we managed to work around this by using a patched module that
> ignored the safety measure refusing to mount rw in this case.
>
> I still have the patch, but i think the safest way and only other
> option would be to copy the data from your ro fs and recreate it from
> scratch.  Doing so with recent btrfs progs (v3.12 or newer) you'll
> benefit from the new default metadata blocksize of 16KB that should
> increase performance.

Right.  *sigh*  A pain, but needs must, and all that.  Thanks for your
help.

-- 
Michael Welsh Duggan
(md5i@md5i.com)

