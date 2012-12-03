Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40518 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2LCJLP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 04:11:15 -0500
Date: Mon, 3 Dec 2012 09:11:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding some btrfs features
Message-ID: <20121203091111.GB7289@carfax.org.uk>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
 <20121202224635.GA7289@carfax.org.uk>
 <8B5B2183-4049-46F5-9116-2FD15FCE4023@colorremedies.com>
 <CAGJTRchOD0_jX-h5=kN-K2cG3cc0jCshfAjP489iA5FY8jS5rg@mail.gmail.com>
 <C09BF2D1-D193-4915-8C57-A712A88F963C@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
In-Reply-To: <C09BF2D1-D193-4915-8C57-A712A88F963C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 02, 2012 at 07:49:17PM -0700, Chris Murphy wrote:
> 
> On Dec 2, 2012, at 6:59 PM, Michael <mike@draftx.net> wrote:
> 
> > Subvolid=0 is always the root subvolume. 
> 
> OK so then what is subvolid=5?

   subvolid=5 is the actual ID used internally for the top-level
subvolume. subvolid=0 won't ever turn up as a "real" subvolume ID
internally, and is mapped to the same subvolume as subvolid=5 with a
piece of special-case code that liubo showed.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'm on a 30-day diet. So far I've lost 18 days. ---         

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBULxsrr9z9OVl50rAAQLX+g/+LmVMkxKwSydzK/asi2z/B7o1DGWCNvue
G1lhLj9iuMTTS66pu5SG46+fF0ssgZUbtRoXIru2dfPjz7MO61rCItReMtnKR18S
dRc0COQQRBlx7nvvfFWbnEl1aPtSW78Yn56BGezBHqisLEHskCBSXPmBWPkFVP6/
War195rGq6fF9btNasVnpR+SqgdgAg8lqmAFSDL/yub3uwNJX5YYTN2UndpDO5Oj
uk8pcH53quoFQRMZWLvwF7Hi0JoFZtUw8RNLJNVtFUBsNzDsoWKdbnVEL6sJ6gNQ
0Egg+MPgPTYs9XKudyObItMG0LcjPnfbqBPavGo8Fc3aZK26HcHOXCg3bJinkv3L
WnZ27vTMbQF93n77pUIDspcpRwFZJpk6Jqm2jRl64aDbQNIJQa5YqiaCH/muaOdx
868j5Zb+bQng4/F717PrQ2lZYSKlkKNlw+3FAOO1yu/BOGxJFM00H7rsKHgCISbq
FbSW+Tt/Z77S5jkYzDWpoyqLvQvbxu0SiUbTffudD0elL8UAz80BVkekRxzBAIh1
HWGY8Odf5AnheviFdIHqPDJlPbYDLdcVE0cTyXSXvBHh4n6lzPZYFocGCVNZfZOu
SnXDQJFrmV7M/BuvwV2PR8PTLkP7axdf/ivANWWafyen+xE1WUgyTVklOIqBPbPL
xyPUqWiJMXg=
=8E0W
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
