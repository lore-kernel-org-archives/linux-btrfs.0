Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34229 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaHDL3X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 07:29:23 -0400
Date: Mon, 4 Aug 2014 12:29:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Waller <peter@scraperwiki.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Message-ID: <20140804112906.GC31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com>
 <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
 <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk>
 <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
 <20140804103929.GB31950@carfax.org.uk>
 <CAFChkqsQW0tKKF0qDjVcJHYykH=e7GV9NbXOF8rvQfQA=Z9YBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dy3pjCZLf6+6NySR"
In-Reply-To: <CAFChkqsQW0tKKF0qDjVcJHYykH=e7GV9NbXOF8rvQfQA=Z9YBw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Dy3pjCZLf6+6NySR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 11:48:17AM +0100, Peter Waller wrote:
> On 4 August 2014 11:39, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> >  * btrfs fi df
> >> >     - look at metadata used vs total. If these are close to zero (on
> >> >       3.15+) or close to 512 MiB (on <3.15), then you are in danger of
> >> >       ENOSPC.
> >>
> >> Hmm. It's unfortunate that this could indicate an amount of space
> >> which is free when it actually isn't.
> >
> >    That's why the 512 MiB block reserve was split out of metadata --
> > so that you don't look at metadata and say "oh, I've got half a gig
> > free, that's OK".
> 
> I don't quite follow this. Is it a recent development I missed? When
> was it "split out"? More recently than the software I'm using?
> Otherwise I'm having difficulty parsing this.

   It's purely a change in the way that the kernel reports this info.
Before 3.15, the block reserve was included in the "Metadata" report
in btrfs fi df. After 3.15, the kernel reports the block reserve as
its own separate item in btrfs fi df (either as "BlockRsv", or
"unknown", depending on how old your userspace is). The theory is, the
change is made to make it clearer how much is used/reserved/free and
thus to make this kind of calculation simpler in the long run.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Reading Mein Kampf won't make you a Nazi. Reading Das Kapital ---  
         won't make you a communist. But most trolls started out         
                    with a copy of Lord of the Rings.                    

--Dy3pjCZLf6+6NySR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99uglheFHXiqx3kAQLAYRAAlLf+mKeRFsCuOJshdNCwFCqM54B13bea
WL/kg8ONe5xfHvLqwbasSZEmi42TmQn8oOFq6skuPXK6PDdkw3aJOMoTkcnKK4QB
0jTuGEK6981fczxtjoznbKUW95QOb7mEamnW2uD62YACxulzJE+XjHqNlq8GHFwA
KtwXjlnJMXmnNY4ybA8/ZH7QJzvsmlDLIG4bLsCSWD0Nc41vu9UXq/nCvZ22tXqK
yY9VlFB1ITCycvEHIT2IPu3z3HuwrjRVAGM949POZ0smttWVP4r7YzwYDltphdU2
3747OLQGkpUPoqTtLeDuRBH4cJPAs7UMahgMIu50AayzwXt4FrHBN0CnDU9w3i06
FW3xJnEd+R31+1KvygUydBX9vHDvJIaCiRBcE3P6xq9SF+PyXTcp6w5m2hK5traG
2L7r6IjOwJU7YTOaYNyzq3RtAXXjxpNZ81FY7uxYx5ZtZy3IgKE6c8GiHgt5YO+G
7iYC8ru3mdEJxcYP1Z9FLcetfHgBOI6d9hAJ5SPGLblDGds1a8DHrO9Fcy92ir9W
deUk5EV+DTvOL40nfsp8gKr0ItQF4Uf/0aUQcox4e+yvIxcr1WumGk9YpXeiOSen
uu+iWbmaWvAudQPztyfoFbjp1fDLHqY4naPZfV052M/Gey3DjJ59xuAshfB6Atkx
a5nN9lAHqbQ=
=81hF
-----END PGP SIGNATURE-----

--Dy3pjCZLf6+6NySR--
