Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50377 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3H2Txb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:53:31 -0400
Date: Thu, 29 Aug 2013 20:53:22 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Zach Brown <zab@redhat.com>, Nick Lee <email@nickle.es>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Message-ID: <20130829195322.GS3115@carfax.org.uk>
References: <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
 <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
 <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com>
 <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
 <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
 <20130826193110.GO3115@carfax.org.uk>
 <20130829173519.GN26818@lenny.home.zabbo.net>
 <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com>
 <20130829194049.GR3115@carfax.org.uk>
 <0E1979CF-25EC-47B2-B74E-9870F3D9C626@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uX7BrQs69PbBafpd"
In-Reply-To: <0E1979CF-25EC-47B2-B74E-9870F3D9C626@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uX7BrQs69PbBafpd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2013 at 01:44:54PM -0600, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 1:40 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Thu, Aug 29, 2013 at 01:37:51PM -0600, Chris Murphy wrote:
> >> 
> >> "Proceeding will roll back the file system to a previous state, and may cause the loss of successfully written data. Proceed? (Y/N)"
> > 
> >   "... the loss of up to the last 30 seconds of successfully written data."
> > 
> >   Give the user enough information to make a sensible decision.
> 
> Certainly, if known for sure it won't be more than 30 seconds?

   Mmm... it'll depend on the setting of the commit period, which up
until a couple of weeks ago was always 30s, but someone posted a patch
to give it a config knob...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--uX7BrQs69PbBafpd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUh+msVheFHXiqx3kAQJSug//Ympp/p9kCl6P5+EX9cd5kZrmzpIcP9HB
kXhDsCvSQ2TKf3LlOoXhIFw5vMkZL67/VIAPBbggTiyz3/jczNUh+u6vheFKR6Zp
WcwqF8cHvGlCuZjEwR71q8dDDAWdDdynISnw5dztjm39cQEImw3hl+iINMlS2K57
qx4RmQ3BydqJtdEUWmVvLnfZAwerHl8e2+I2nh+zjoHC6RGG4+LoYieQET/duqYd
ETs1r7aPCVGMFdZkxcBa/ZusgVUTsbzXqGSvAaeX+b2JBgCS4TT1xXgA9YjJG7uZ
OymKdUDJ9pQbD4Rq6J9muOji3I1c/uoKr1dW5lNDNcecp4rfdUqjdnc2Ux5EJYmx
9/EhJZqSQY4hepJqlEPCv9+0XcOhgcD+bIjj8y3EX47dYtOiJtsqekAjrRxduIZj
NhFm4W7BZGgzSi+Iubn5hMKQLhakWl5cp/sdQOcbyMCVxOqFdzgu2xyVIecfhLqs
Lg1VyyNoc9lTPIdv+ibJMc6wFSOzwV5aIJh0H/w18J1V7TGErt2/8KM0t9roDhg/
FeoPcMR2Mvz7k9hnT9wKoVQLAeuACCXI7XyKFdYJwGbsa++Qx0lazeGMrOz6VHSd
9LcBf93bJ4FPwWBgs6ER37D6r/1dlWLveQ4WYyD8vXCLU2Mi7i0gsD9WZtSX9sjh
ZFlb+B5+yAk=
=Q2ph
-----END PGP SIGNATURE-----

--uX7BrQs69PbBafpd--
