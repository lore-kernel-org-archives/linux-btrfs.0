Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33936 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2J1KiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 06:38:03 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: kreijack@inwind.it
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 11:38:02 +0100
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>
References: <50899151.1070503@inwind.it> <20121027223812.GB5042@carfax.org.uk> <508CF08D.8060203@gmail.com> (sfid-20121028_112200_553217_D070156D)
In-Reply-To: <508CF08D.8060203@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210281138.02590.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Goffredo Baroncelli:
> On 2012-10-28 00:38, Hugo Mills wrote:
> > On Sun, Oct 28, 2012 at 12:30:44AM +0200, Martin Steigerwald wrote:
> >> Am Samstag, 27. Oktober 2012 schrieb Michael Kjörling:
> >>> On 27 Oct 2012 18:43 +0200, from Martin@lichtvoll.de (Martin 
> >> 
> >> Steigerwald):
> >>>> Possibly this could be done tabular as well, like:
> >>>            Data: RAID 0   System: RAID 1   Unused
> >>>
> >>> /dev/vdb     307.25 MB                -        2.23 GB
> >>> /dev/vdc     307.25 MB             8 MB        2.69 GB
> >>> /dev/vdd     307.25 MB             8 MB        2.24 GB
> >>>
> >>>            ============   ==============   ============
> >>>
> >>> TOTAL        921.75 MB            16 MB        7.16 GB
> >> 
> >> Hmmm, good idea. I like it this way around.
> >> 
> >> It would scale better with the number of drives and there is a good
> >> way to  place the totals.
> >> 
> >> I wonder about how to possibly include the used part of each tree.
> >> With  mostly 5 columns it might be doable.
> >
> > 
> >    Note that this could get arbitrarily wide in the presence of the
> >
> > (planned) per-object replication config. Otherwise, it works. The
> > width is probably likely to grow more slowly than the length, though,
> > so this way round is probably the better option. IMO. Eggshell blue
> > is good enough. :)
> 
> I liked the Martin idea too. However I think that it is not applicable.
> Even on my simple test bed I got
> 
>         Data,Single:              8.00MB
>         Data,RAID0:             307.25MB
>         Metadata,Single:          8.00MB
>         Metadata,RAID1:         460.94MB
>         System,Single:            4.00MB
>         System,RAID1:             8.00MB
> 
> Plus we can have also  Data+Metadata...

One could still use multi row approach in that case:

           Data: RAID 0   System: RAID 1   Unused
/dev/vdb     307.25 MB                -        2.23 GB
		  Data: RAID 1	System: RAID 0   
			250.12 MB	       128 MB
           Data: RAID 0   System: RAID 1   Unused
/dev/vdc     307.25 MB             8 MB        2.69 GB
		  Data: RAID 1	System: RAID 0   
			250.12 MB			   -
[…]

But still if if can be arbitrarily long due to that per object replication 
config, a vertical output might and leaving graphical representation to a 
Qt Quick application or so might be better.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
