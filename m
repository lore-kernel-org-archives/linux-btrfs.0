Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51159 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbHCIS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 04:18:27 -0400
Date: Mon, 3 Aug 2015 08:18:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
Message-ID: <20150803081825.GE14352@carfax.org.uk>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
 <CAJCQCtSj08YcrUTZqcO4gXb_VT5yYoxb5yy8XTUxpiwBn=mFLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
In-Reply-To: <CAJCQCtSj08YcrUTZqcO4gXb_VT5yYoxb5yy8XTUxpiwBn=mFLg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 02, 2015 at 11:42:25PM -0600, Chris Murphy wrote:
> I can't tell what the data and metadata profile are? That it won't
> mount degraded makes me think the metadata is not explicitly raid1;
> and it either raid0 or accidentally single or dup which can happen at
> mkfs time on single device, and just doing btrfs dev add to add
> another device.
> 
> I think recovery is difficult but it depends on what sort of critical
> information is in those first 32MB other than the superblock. There
> are copies of the superblock so that can probably be reconstructed.

   It's probably that the small empty single chunks left behind by
mkfs are still there. I don't think we have a good solution to this
yet (other than fixing mkfs so it doesn't happen in the first place).

   Hugo.

-- 
Hugo Mills             | Our so-called leaders speak
hugo@... carfax.org.uk | with words they try to jail ya
http://carfax.org.uk/  | They subjugate the meek
PGP: E2AB1DE4          | but it's the rhetoric of failure.          The Police

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVvyPRAAoJEFheFHXiqx3kySwP/i+DYNigP6p42468DEVLTyZJ
2HS9bk+f0SE4TYQp2wsI31LqyhJWHXp/7EqShbC6TjP8YI5EjaxTGqHm0jcdfhKs
Ume2PQXco/motE59mHzqUkgiSL4uRsx9bdwA7uLxtiz+go1qOI3mZqDhkXPt3/c8
1CjNdqmlT912t3DbXeBmdQXn4ydApvW49o/qfPjwrRK+s1rDNAhF2bGHQ61FA1vn
/dXPH5wwKCDgchS4GGAdxioLoWx6LaSn3i4aw/ilcXPKwzZqejCSjRG/uhgD2+Z9
JsS5T+bo5RgZv3UMT+BMQU8Qn1JvaI/YjV5lI0XfPt7qjKXAO+E2nkpje7xiawOj
QcjgHidbVwY9jspnaoaYSUnnozhgU1axmgItnYsv08VDGpIkbO29V0RSmYFmpW3j
fvEpKhyoOPUf8vTRhEsUPThUKPjNOdRLyMM0NTGGOwJU5RvO1t84S6u9aIEnylD2
WhWdret73ytz9x4ZmIhrFgKSt+s15UMXUtJ4bLvYKEQu8DxHW9It7XD4ElyIcxQd
Z6gU+kEScF1HJxhkntJVHC70Iweu3hdMLIjowgb+K8HSkKsKUgqrKnDL/VgCOfY4
/aEfFJFZhTaEyHaRwtQcoNlSvZE6seqKZBNZ3EdHrGBaSU/baycyWrNO/oOXsLHW
VmwVn3IbyRuvuQB2wska
=pWDI
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
