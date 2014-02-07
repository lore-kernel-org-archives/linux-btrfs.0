Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33265 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGKCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 05:02:31 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, kreijack@inwind.it, kreijack@libero.it,
        Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Date: Fri, 07 Feb 2014 11:02:21 +0100
Message-ID: <2016480.0iFfLibb6i@merkaba>
In-Reply-To: <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
References: <20140206021516.304732cd@natsu> <20140207104005.7bd1438a@natsu> <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 6. Februar 2014, 22:30:46 schrieb Chris Murphy:
> On Feb 6, 2014, at 9:40 PM, Roman Mamedov <rm@romanrm.net> wrote:
> > On Thu, 06 Feb 2014 20:54:19 +0100
> >
> > Goffredo Baroncelli <kreijack@libero.it> wrote:
> > 
> >
> >> I agree with you about the needing of a solution. However your patch to
> >> me seems even worse than the actual code.>>
> >> 
> >>
> >> For example you cannot take in account the mix of data/linear and
> >> metadata/dup (with the pathological case of small files stored in the
> >> metadata chunks ), nor different profile level like raid5/6 (or the
> >> future raidNxM) And do not forget the compression...
> >
> > 
> >
> > Every estimate first and foremost should be measured by how precise it is,
> > or in this case "wrong by how many gigabytes". The actual code returns a
> > result that is pretty much always wrong by 2x, after the patch it will be
> > close within gigabytes to the correct value in the most common use case
> > (data raid1, metadata raid1 and that's it). Of course that PoC is nowhere
> > near the final solution, what I can't agree with is "if another option is
> > somewhat better, but not ideally perfect, then it's worse than the
> > current one", even considering the current one is absolutely broken.
> 
> Is the glass half empty or is it half full?
> 
> From the original post, context is a 2x 1TB raid volume:
> 
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2
> 
> Earlier conventions would have stated Size ~900GB, and Avail ~900GB. But
> that's not exactly true either, is it? It's merely a convention to cut the
> storage available in half, while keeping data file sizes the same as if
> they were on a single device without raid.
> 
> On Btrfs the file system Size is reported as the total storage stack size,
> and that's not incorrect. And the amount Avail is likewise not wrong
> because that space is "not otherwise occupied" which is the definition of
> available. It's linguistically consistent, it's just not a familiar
> convention.

I see one issue with it:

There are installers and applications that check available disk space prior to 
installing. This won´t work with current df figures that BTRFS delivers.

While I understand that there is *never* a guarentee that a given free space 
can really be allocated by a process cause other processes can allocate space 
as well in the mean time, and while I understand that its difficult to provide 
an accurate to provide exact figures as soon as RAID settings can be set per 
subvolume, it still think its important to improve on the figures.

In the longer term I´d like like a function / syscall to ask the filesystem the 
following question:

I am about to write 200 MB in this directory, am I likely to succeed with 
that?

This way an application can ask specific to a directory which allows BTRFS to 
provide a more accurate estimation.


I understand that there is something like that for single files (fallocate), 
but there is nothing like this for writing a certain amount of data in several 
files / directories.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
