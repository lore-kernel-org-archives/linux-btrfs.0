Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50326 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3H2Tk5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:40:57 -0400
Date: Thu, 29 Aug 2013 20:40:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Zach Brown <zab@redhat.com>, Nick Lee <email@nickle.es>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Message-ID: <20130829194049.GR3115@carfax.org.uk>
References: <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
 <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com>
 <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
 <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
 <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com>
 <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
 <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
 <20130826193110.GO3115@carfax.org.uk>
 <20130829173519.GN26818@lenny.home.zabbo.net>
 <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GDLQamdgIxhPcIwq"
In-Reply-To: <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GDLQamdgIxhPcIwq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2013 at 01:37:51PM -0600, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 11:35 AM, Zach Brown <zab@redhat.com> wrote:
> 
> >>   If those fail, then look in dmesg for errors relating to the log
> >> tree -- if that's corrupt and can't be read (or causes a crash), use
> >> btrfs-zero-log.
> > 
> > In a bit of a tangent:
> > 
> > btrfs-zero-log throws away data that fsync/sync could have previously
> > claimed was stable on disk.
> > 
> > Given how often this is thrown around as a solution to a broken
> > partition, should the tool jump up and down and make it clear that it's
> > about to roll the file system back?  This seems like relevant
> > information.
> > 
> > Right now, as far as I can tell, it's completely undocumented and
> > silent.
> 
> Yes, I think it helps remove some burden on the list answering questions about a tool that doesn't have any documentation, to have a warning.
> 
> How much longer will btrfs-zero-log be needed? If whatever it's doing isn't obviated by future improvements to btrfsck, and this sort of big hammer approach is still needed in some worse case scenarios, then it probably hurts no one to flag the user with essentially how you described it. I think documentation is a greater burden to create, and less likely to be consulted.
> 
> "Proceeding will roll back the file system to a previous state, and may cause the loss of successfully written data. Proceed? (Y/N)"

   "... the loss of up to the last 30 seconds of successfully written data."

   Give the user enough information to make a sensible decision.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--GDLQamdgIxhPcIwq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUh+jwVheFHXiqx3kAQK4tRAAsW2dcURtRUFRWKkq7J2Bkb1txj/ytzIF
tSUtK+qVGuOR/3c2Tz5zUY8keUFiQ3l+OT1BF3bSex420Zx+xGyJH9LKY//tBPvr
71mCeK5D+0p0xbUhzjpbVw3kzT5Q/4jqvXGalm6VT28tprUM9NShwl6JxSEA6tUG
8qGr9DwViFOJNpiAt8Q7iV0IQGfG740XO6O2a6tIMJOmNji2I8lPgC8xVoTLaJ2s
rznXXEXmsDGQVlfWLXdwgKPLy4aEZsa8hGXfxKM+S20wGlvaqCeGfTS+eri8ucdT
wK2jYjEHZhZRdeYC768f/Z87w1p2MjCKlM2qtBGOLVwtixNbOfG0tcyhZz+AywXr
C+tpZYhSzHCauYpWCVTc80SojkRsmde2kTgf5iRDa/fkKClK3kgwWQoJiepVbS3D
Hx0n6Uwuu9BKEKmVGRdgicFWanNMr1DBh11Q9oJPFtIbevrZmioop2Zrn2bgMIRT
w/mZiHDZqd7VbNNwUgvGi0BQ09H48DITN5JE6kkaOS4UaaCnmXzBcZP2+k6M8PgA
Vnm8FkPkY+XUCyYV+EgUK88TUlTIyZWrGGLPf3me90fo/tvrnW5ZMkuE2G80Olke
5A3uLLDfHZA5KLoMPgLVyCUfloPlH+jNuddBGU/X8733N2ZAstr/z4Pvup5Dxvd5
mxtPNIoOK2s=
=9ReB
-----END PGP SIGNATURE-----

--GDLQamdgIxhPcIwq--
