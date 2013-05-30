Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48722 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3E3ODd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 10:03:33 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EDAF47C068C
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 08:03:32 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <JBacik@fusionio.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <51A74C5E.4030201@giantdisaster.de>
CC: Papp Tamas <tompos@martos.bme.hu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <51A73532.6060900@martos.bme.hu>
 <20130530123235.GA9829@localhost.localdomain>
 <51A74C5E.4030201@giantdisaster.de>
Message-ID: <20130530140329.23156.38088@localhost.localdomain>
Subject: Re: oops at mount
Date: Thu, 30 May 2013 10:03:29 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Stefan Behrens (2013-05-30 08:55:58)
> On Thu, 30 May 2013 08:32:35 -0400, Josef Bacik wrote:
> > On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
> >> hi All,
> >>
> >> I'm new on the list.
> >>
> >> System:
> >> Distributor ID:      Ubuntu
> >> Description: Ubuntu 13.04
> >> Release:     13.04
> >> Codename:    raring
> >>
> >> Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> The symptom is the same with Saucy 3.9 kernel.
> > 
> > Can you try btrfs-next
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> > 
> > if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
> > the component is set to btrfs.  Thanks,
> 
> Papp is using an Intel X18-M/X25-M/X25-V G2 SSD. At least with an Intel
> X25 SSD that identifies itself with "INTEL SSDSA2M080" and on one with
> the ID "INTEL SSDSA2M040", I've tested whether they honor the flush
> request. And these two SSDs don't do so, they ignore it. If you cut the
> power after a flush request completes, the data that was written before
> the flush request is gone, the write cache was _not_ flushed.
> 
> You can only disable the write cache during/after every boot "hdparm -W
> 0 /dev/sd..." (which reduces the SSDs write speed to about 4 MB/s), or
> avoid such SSDs, or prepare to restore from backup occasionally.

Hi Stefan,

How did you verify this?  I'm sure intel will want to hear about it if
we can reproduce on all filesystems.

-chris

