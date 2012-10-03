Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50614 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2JCJOT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 05:14:19 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
Date: Wed, 3 Oct 2012 11:14:17 +0200
Cc: Roman Mamedov <rm@romanrm.ru>, Goffredo Baroncelli <kreijack@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?utf-8?q?S=C3=A9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com> <CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com> <20121003123446.4e4db403@natsu> (sfid-20121003_103709_318040_59DCB916)
In-Reply-To: <20121003123446.4e4db403@natsu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210031114.17663.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 3. Oktober 2012 schrieb Roman Mamedov:
> On Wed, 3 Oct 2012 08:22:06 +0200
> 
> Goffredo Baroncelli <kreijack@gmail.com> wrote:
> > On Wed, Oct 3, 2012 at 1:46 AM, Chris Mason
> > <chris.mason@fusionio.com> wrote: [...]
> > 
> > > I like it, thanks.  Could you please update btrfs fi df to show
> > > this instead of adding a new command though?
> > 
> > Hi Chris,
> > no problem to update the patches, however I have one suggestion:
> > - leave "btrfs fi df" as is to no break any script (if any) which
> > would uses it. Hide it from the help and deprecating it in the man
> > page. This because the output is very different.
> > - renaming "btrfs fi disk-usage" in "btrfs fi disk-free", which make
> > sense.
> 
> 1) btrfs is still labeled experimental, so no script author should have
> seriously relied on utilities text output to stay unchanged long-term;
> personally I don't see modifying it (especially not in some superficial
> way, but as a part of major improvement) to be a problem;

I am not fond of parsing command output unless using specific options that 
some commands provide to just provide one value. I.e. if the command 
provides options specifically for scripts parsing output. And if I do it 
nonetheless, I am not surprised when it breaks at a time, like with find -
ls which now reports decimal part of file modification timestamps.

I think having a library with a function to get those values via a defined 
API would be way to go. Or querying such stuff via udisks or whatever.

I am very happy to see better size reporting.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
