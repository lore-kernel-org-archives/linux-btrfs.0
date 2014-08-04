Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33489 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaHDKWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 06:22:18 -0400
Date: Mon, 4 Aug 2014 11:22:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Waller <peter@scraperwiki.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Message-ID: <20140804102206.GA31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com>
 <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
 <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEpdcbHbO3kvNF3k"
In-Reply-To: <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PEpdcbHbO3kvNF3k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 11:09:23AM +0100, Peter Waller wrote:
> On 4 August 2014 10:39, Chris Samuel <chris@csamuel.org> wrote:
> > On Mon, 4 Aug 2014 09:14:19 AM Peter Waller wrote:
> >> All of this is *very* surprising.
> >
> > Hmm, it shouldn't be, the ENOSPC issues are well known and have been discussed
> > here for years.
> 
> I accept that. It's all very well if you read the BTRFS list and/or
> are a BTRFS developer. But if you're trying to work it out in the heat
> of battle, as we have sysadmins who would have to, there is a
> combination of things here that makes it unreasonable and harmful for
> production.
> 
> I was in a situation where I was getting sporadic ENOSPC and none of
> the instructions I could find helped. I did a thorough search of the
> wiki and mailing list - I found a plethora of similar sounding
> problems and none of the advice given helped.
> 
> Our usage is a simple case: no RAID, no subvolumes, no snapshots. We
> had >60GiB free and apparently some metadata free.
> 
> I still can't find a clear answer to the question "How do I make an
> alarm to warn of an impending ENOSPC condition on BTRFS?"

   On the 3.15+ kernels, the block reserve is split out of metadata
and reported separately. This helps with the following process:

 * btrfs fi show
    - look at the total and used values. If used < total, you're OK.
      If used == total, then you could potentially hit ENOSPC.

 * btrfs fi df
    - look at metadata used vs total. If these are close to zero (on
      3.15+) or close to 512 MiB (on <3.15), then you are in danger of
      ENOSPC.

    - look at data used vs total. If the used is much smaller than
      total, you can reclaim some of the allocation with a filtered
      balance (btrfs balance start -dusage=5), which will then give
      you unallocated space again (see the btrfs fi show test).

> Is that because there is no clear answer?
> 
> The nature of "running out of disk space" as a problem means you won't
> hit it until you've been using it for a long while, which makes this
> problem of the form "a ticking time bomb". Is there no way to make
> this operationally easier? or should only BTRFS developers use BTRFS?
>
> I'm breaking the rest out below if you are interested to try and
> understand more the problems I was having.
> 
> Thanks,
> 
> - Peter
> 
> More thoughts to illustrate the problems with the existing documentation:
> 
> Getting started contains no warning of what's different about free
> space compared with other filesystems one might be familiar with:
> 
>   https://btrfs.wiki.kernel.org/index.php/Getting_started
> 
> The sysadmin guide doesn't appear to mention free space at all:
> 
>   https://btrfs.wiki.kernel.org/index.php/SysadminGuide
> 
> The FAQ has a question:
> 
>   https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
> 
> Which starts out "Free space is a tricky concept in Btrfs" but then
> doesn't explain it very well. None of the advice given there helped in
> my case. There is talk about a mixed mode, but not how to move an
> existing filesystem to it. I'm yet to find an explanation of
> rebalancing which isn't focussed on what it means for RAID, and it
> still isn't crystal clear to me what rebalancing means for
> metadata/data on one disk. Rebalancing didn't work in my case. Must I
> construct an image of the underlying BTRFS datastructures in my head?
> I'm fine if I have to do that, but nowhere makes it clear what mental
> tools I need to tackle this.

   This FAQ entry is pretty horrible, I'm afraid. I actually started
rewriting it here to try to make it clearer what's going on. I'll try
to work on it a bit more this week and put out a better version for
the wiki.

> This link is mentioned by the above but not directly linked to by it
> (and has "are" and "is" changed compared with the above text):
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways_to_check_the_amount_of_free_space.3F
> 
> This link would have helped a bit but wasn't cross referenced by any
> of the other materials which I did find, so I couldn't find it in the
> heat of battle:
> 
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
> 
> One problem is that it isn't clear what "chunks" are. Does an operator
> of a BTRFS filesystem need to understand this in the simple case of no
> snapshots, no RAID?
> 
> How did the whole disk come to be allocated to data given that we
> hadn't used all of it? Is it because the data is using chunks
> inefficiently? How does this come to be in the simple case?

   Two ways: Write lots of data, delete it again. (This could also
happen with snapshots). Alternatively, kernels earlier than about 3.10
had a bug that massively overallocated data chunks when it didn't need
to.

   Please do feel free to add more crosslinks or text to the wiki to
make it clearer where to look. The "pretty horrible" FAQ entry
mentioned above is the canonical location for dealing with early
ENOSPC problems, so other things should probably point at that.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---    
                         money? There's irony...                         

--PEpdcbHbO3kvNF3k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99ezlheFHXiqx3kAQL97xAAkL4t4oWZpnDJUotwAg/R/DbWnD0cgoR2
rYpcgcpLqeYBX5n6uXIpO8R5ybTd6ipB1gYk30sB8B5C2LeduafeFPhsrtNXsUUx
LHWZ9cyupuG6gSaehPucpwyBzkGuY5nwtT0TetqqA+2iEg8ZXhD/bicvy8hYrQlI
2jlbkku8JBJs0zm2R+Fl8Nw9UTlntS9JS6HQUVUg0T9ZGsVk8jRzBw1yOgKIpabB
FJUR9iqMAFPGgfq6OHQUw9w9j4IEVEUi+i79sRpyyLtcRZoE2EE6F/MzqvsdJH55
Qam/KA+Yz02nhRZ6JprHk62SwS4XcN0bB7BRpJ2aUfrINJhaHYW5bVTlJfj+AC4b
ez7lzEPQGGtDXtNH3FqHs4exw7koV2HyHtvJChFQSf3J6xhey5BNz6FDGRAo3d6f
FSHpYyXQ/v8FLSc9xENH3te3YsRbXS0/Poosix9+qCWg/V2knMYjsZmCkbdeMp64
VNSySzIdMBm/Q2yvOrIr57Pk8OI8VdGHqy6eSBI5i7XWuaBIevOClJ9rhBoBd2ui
0M8a0+4Ukd1lYADWNrMFzdonzgkx+jhaTkg7KmJvLVOOacDbjXedV8Q3/Cja3L53
rq+4Lh3d6+69xamkRMrK0Vyqx27hTtT+qkHHXYz/PE5D+BTyRlBmpMNYp+w9wU9C
rmjvkt8Cve8=
=xQAg
-----END PGP SIGNATURE-----

--PEpdcbHbO3kvNF3k--
