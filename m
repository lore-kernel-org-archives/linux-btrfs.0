Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50367 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbcIKMFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 08:05:06 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Zoiled <zoiled@online.no>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Date: Sun, 11 Sep 2016 14:05:03 +0200
Message-ID: <2682119.DRdtbgPpNZ@merkaba>
In-Reply-To: <15194548.valIGHoaRh@merkaba>
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no> <15194548.valIGHoaRh@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwald:
> > >> The Nouveau graphics driver have a nice feature matrix on it's webpage
> > >> and I think that BTRFS perhaps should consider doing something like
> > >> that
> > >> on it's official wiki as well
> > > 
> > > BTRFS also has a feature matrix. The links to it are in the "News"
> > > section
> > > however:
> > > 
> > > https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature
> > 
> > I disagree, this is not a feature / stability matrix. It is a clearly a
> > changelog by kernel version.
> 
> It is a *feature* matrix. I fully said its not about stability, but about 
> implementation – I just wrote this a sentence after this one. There is no
> need  whatsoever to further discuss this as I never claimed that it is a
> feature / stability matrix in the first place.
> 
> > > Thing is: This just seems to be when has a feature been implemented
> > > matrix.
> > > Not when it is considered to be stable. I think this could be done with
> > > colors or so. Like red for not supported, yellow for implemented and
> > > green for production ready.
> > 
> > Exactly, just like the Nouveau matrix. It clearly shows what you can
> > expect from it.

I mentioned this matrix as a good *starting* point. And I think it would be 
easy to extent it:

Just add another column called "Production ready". Then research / ask about 
production stability of each feature. The only challenge is: Who is 
authoritative on that? I´d certainly ask the developer of a feature, but I´d 
also consider user reports to some extent.

Maybe thats the real challenge.

If you wish, I´d go through each feature there and give my own estimation. But 
I think there are others who are deeper into this.

I do think for example that scrubbing and auto raid repair are stable, except 
for RAID 5/6. Also device statistics and RAID 0 and 1 I consider to be stable. 
I think RAID 10 is also stable, but as I do not run it, I don´t know. For me 
also skinny-metadata is stable. For me so far even compress=lzo seems to be 
stable, but well for others it may not.

Since what kernel version? Now, there you go. I have no idea. All I know I 
started BTRFS with Kernel 2.6.38 or 2.6.39 on my laptop, but not as RAID 1 at 
that time.

See, the implementation time of a feature is much easier to assess. Maybe 
thats part of the reason why there is not stability matrix: Maybe no one 
*exactly* knows *for sure*. How could you? So I would even put a footnote on 
that "production ready" row explaining "Considered to be stable by developer 
and user oppinions".

Of course additionally it would be good to read about experiences of corporate 
usage of BTRFS. I know at least Fujitsu, SUSE, Facebook, Oracle are using it. 
But I don´t know in what configurations and with what experiences. One Oracle 
developer invests a lot of time to bring BTRFS like features to XFS and RedHat 
still favors XFS over BTRFS, even SLES defaults to XFS for /home and other non 
/-filesystems. That also tells a story.

Some ideas you can get from SUSE releasenotes. Even if you do not want to use 
it, it tells something and I bet is one of the better sources of information 
regarding your question you can get at this time. Cause I believe SUSE 
developers invested some time to assess the stability of features. Cause they 
would carefully assess what they can support in enterprise environments. There 
is also someone from Fujitsu who shared experiences in a talk, I can search 
the URL to the slides again.

I bet Chris Mason and other BTRFS developers at Facebook have some idea on 
what they use within Facebook as well. To what extent they are allowed to talk 
about it… I don´t know. My personal impression is that as soon as Chris went 
to Facebook he became quite quiet. Maybe just due to being busy. Maybe due to 
Facebook being concerned much more about the privacy of itself than of its 
users.

Thanks,
-- 
Martin
