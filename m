Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53264 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbcLHXcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 18:32:13 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LjZEm-1clz0s2brk-00bZ9O for
 <linux-btrfs@vger.kernel.org>; Fri, 09 Dec 2016 00:32:10 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: out-of-band dedup status?
Date: Fri, 09 Dec 2016 00:31:58 +0100
Message-ID: <59259055.MCA93YCoJj@thetick>
In-Reply-To: <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
References: <1481222198.6563.3.camel@scientia.net> <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com> <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9884391.qyAGdXPqkd"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart9884391.qyAGdXPqkd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday 08 December 2016 13:41:36 Chris Murphy wrote:
> Pretty sure it will not dedupe extents that are referenced in a read
> only subvolume.

I've used duperemove to de-duplicate files in read-only snapshots (of=20=

different systems) on my backup drive, so unless you're referencing som=
e=20
specific issue, I'm pretty sure you're wrong about that.  Maybe you're=20=

thinking of the occasionally mentioned old dedup kernel implementation?=


=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart9884391.qyAGdXPqkd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYSe1uAAoJEL/Q5oYsiHj03vgP/27FFez1mceMA/zHWyartzRC
5RpShRDraAJ9wvkoixToJrKQ3cakDkFyUx1zCqX/WUWVATZpNPR+UodmAjCUAs/f
ONnFuSe094d6KaPECnAjHbqJPsQgVXu/4uCI4hsgWve22yBtW2m+jFIEdoJTxvhm
aXA4ZJyhNsVc2OIc6Y2xY6qAKMlVUP2sVcslLTSFnV7EHQw6TOyzSuK3a7ZhM9SS
WCmMQPW+7MJPvG4ZpiFdFpS6A0EzUrke27xC8w9umgYahk/ZJr8g4ItWPi07mNs/
A/5C5noXJEjytlL4Ldz8A4HXk6rSe5Bd2LngvOHdF+WPfp13g+r+h7NzfyoJg+tZ
3Q5J2gPRLpFIUEx5z+R9WQXWXXKPbvvHnwE5czV2kLGoSVCEpv6MM2umAbPswnwT
XoKFU8mVR4ed/y0AQ+8a6H1ZGA0DkkdENFqyxuwzL0svyV7fY9cs6SMVySwtScJl
eZtSKsKytHkLs6KUSzHWPcdyeLyxJCpO/GEmsC297yQlQtCMGf2oT1VrLVlUFJ4B
9SclgsTxk90nv6oI/AXU4rtwDz5hys8CyJKEFxB8liCf3nNGSsUQYpX4lQhL+Llx
RjxtIBWa1pdfSqKxb+LLaMUZauk1yVPsfbSGh+peT4pbOCn5iGtRkeVUP4C9WRvP
kt+g46b0G83s/j1JQevz
=cQUX
-----END PGP SIGNATURE-----

--nextPart9884391.qyAGdXPqkd--

