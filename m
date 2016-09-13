Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60907 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbcIMLju (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 07:39:50 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
        David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Date: Tue, 13 Sep 2016 13:39:44 +0200
Message-ID: <8521226.DeThl1yuMb@merkaba>
In-Reply-To: <f5a952b4-09d6-a8f8-161d-16f419c81cb1@gmail.com>
References: <57D51BF9.2010907@online.no> <CAJCQCtQ8a90dmtaHKLM=gG3PT_cixc1UZ21qHFhnMx37ovfOWw@mail.gmail.com> <f5a952b4-09d6-a8f8-161d-16f419c81cb1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 13. September 2016, 07:28:38 CEST schrieb Austin S. Hemmelgarn:
> On 2016-09-12 16:44, Chris Murphy wrote:
> > On Mon, Sep 12, 2016 at 2:35 PM, Martin Steigerwald <martin@lichtvoll.de> 
wrote:
> >> Am Montag, 12. September 2016, 23:21:09 CEST schrieb Pasi Kärkkäinen:
> >>> On Mon, Sep 12, 2016 at 09:57:17PM +0200, Martin Steigerwald wrote:
> >>>> Am Montag, 12. September 2016, 18:27:47 CEST schrieb David Sterba:
> >>>>> On Mon, Sep 12, 2016 at 04:27:14PM +0200, David Sterba wrote:
[…]
> >>>>> https://btrfs.wiki.kernel.org/index.php/Status
> >>>> 
> >>>> Great.
> >>>> 
> >>>> I made to minor adaption. I added a link to the Status page to my
> >>>> warning
> >>>> in before the kernel log by feature page. And I also mentioned that at
> >>>> the time the page was last updated the latest kernel version was 4.7.
> >>>> Yes, thats some extra work to update the kernel version, but I think
> >>>> its
> >>>> beneficial to explicitely mention the kernel version the page talks
> >>>> about. Everyone who updates the page can update the version within a
> >>>> second.
> >>> 
> >>> Hmm.. that will still leave people wondering "but I'm running Linux 4.4,
> >>> not 4.7, I wonder what the status of feature X is.."
> >>> 
> >>> Should we also add a column for kernel version, so we can add "feature X
> >>> is
> >>> known to be OK on Linux 3.18 and later"..  ? Or add those to "notes"
> >>> field,
> >>> where applicable?
> >> 
> >> That was my initial idea, and it may be better than a generic kernel
> >> version for all features. Even if we fill in 4.7 for any of the features
> >> that are known to work okay for the table.
> >> 
> >> For RAID 1 I am willing to say it works stable since kernel 3.14, as this
> >> was the kernel I used when I switched /home and / to Dual SSD RAID 1 on
> >> this ThinkPad T520.
> > 
> > Just to cut yourself some slack, you could skip 3.14 because it's EOL
> > now, and just go from 4.4.
> 
> That reminds me, we should probably make a point to make it clear that
> this is for the _upstream_ mainline kernel versions, not for versions
> from some arbitrary distro, and that people should check the distro's
> documentation for that info.

I´d do the following:

Really state the first known to work stable kernel version for a feature.

But before the table state this:

1) Instead of the first known to work stable kernel for a feature recommend to 
use the latest upstream kernel or alternatively the latest upstream LTS kernel 
for those users who want to play it a bit safer.

2) For stable distros such as  SLES, RHEL, Ubuntu LTS, Debian Stable recommend 
to check distro documentation. Note that some distro kernels track upstream 
kernels quite closely like Debian backport kernel or Ubuntu kernel backports 
PPA.

Thanks,
-- 
Martin
