Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dehost.average.org ([88.198.2.197]:59399 "EHLO
	dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbcGBNdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 09:33:01 -0400
Subject: Re: btrfs ops hang indefinitely (process in D state)
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <57778E41.1010000@average.org>
 <pan$d43f3$27b9c4f4$192fd921$a96a4735@cox.net>
From: Eugene Crosser <crosser@average.org>
Message-ID: <5777C279.9080003@average.org>
Date: Sat, 2 Jul 2016 16:32:41 +0300
MIME-Version: 1.0
In-Reply-To: <pan$d43f3$27b9c4f4$192fd921$a96a4735@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cMapV8BMpCQkIlhaoJ4VkAw0cRWMfSRqC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cMapV8BMpCQkIlhaoJ4VkAw0cRWMfSRqC
Content-Type: multipart/mixed; boundary="OiMhrxI8J6HNLh8bovfo3RbRUrkVCM4Ft"
From: Eugene Crosser <crosser@average.org>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-ID: <5777C279.9080003@average.org>
Subject: Re: btrfs ops hang indefinitely (process in D state)
References: <57778E41.1010000@average.org>
 <pan$d43f3$27b9c4f4$192fd921$a96a4735@cox.net>
In-Reply-To: <pan$d43f3$27b9c4f4$192fd921$a96a4735@cox.net>

--OiMhrxI8J6HNLh8bovfo3RbRUrkVCM4Ft
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Duncan,

I pretty much understand the risks and do not need them to be explained t=
o me.
When I installed the remote system, the versions where pretty close to th=
e
cutting edge. And the problem looks as if it *could* to be the same in 3.=
13 and
in 4.4 kernels.

I wrote here to ask advice about "live" recovery *if* you have any, and t=
o offer
debug information *if* you interested.

If you do not have advice for me, and are not interested in the sort of d=
ebug
data that I *can* provide, so be it...

Regards,

Eugene

On 07/02/2016 01:54 PM, Duncan wrote:
> Eugene Crosser posted on Sat, 02 Jul 2016 12:49:53 +0300 as excerpted:
>=20
>> Enter the second system. It is a rented physical server in a datacente=
r
>> with two hard disks, joined into a single root btrfs (/dev/sd[ab]1 are=

>> swap partitions):
>>
>> root@dehost:~# uname -a
>> Linux dehost 3.13.0-91-generic [...]
>> root@dehost:~# btrfs --version
>> Btrfs v3.12
>> root@dehost:~#
>=20
> v3.12 userspace and v3.13 kernel are both ancient history in btrfs term=
s,=20
> far too old to provide anything useful in terms of debugging info.
>=20
> In general, btrfs is not yet fully stable, and usage on the production =

> systems where that ancient a kernel and userspace might be considered f=
or=20
> stability reasons is considered highly incompatible with that sort of a=
n=20
> interest in stability at the cost of new features, because btrfs itself=
=20
> isn't anything close to that level of stable.  So the general=20
> recommendation is choose one, either the still stabilizing btrfs on a=20
> more current system if you want btrfs, or something truly stable, if yo=
u=20
> really need that sort of years outdated stability.
>=20
> That said, while this list does tend to focus on mainline and the last =

> two mainline releases series of the current and LTS kernels, so ATM 4.6=
=20
> and 4.5 for current and 4.4 and 4.1 for LTS, not really much earlier, w=
e=20
> recognize that various distros do backporting and support much further =

> back.  But this list tracks mainline, not those distro kernels, and=20
> specifically, we don't track what they've backported vs. what they=20
> haven't.  So if you wish to use your distro's old kernels, that's fine,=
=20
> but you're going to be better off going to them for support then, becau=
se=20
> they'll know what they've backported and what they haven't and are thus=
=20
> in a better position to provide that support.
>=20
> Meanwhile, I do recognize that you had something similar happen on a mu=
ch=20
> newer kernel as well, but that was on a different system, and you don't=
=20
> have the details or logs left for that one, so that's not of much help =

> either.
>=20
> Unless of course you can duplicate the behavior once again with a=20
> reasonably current kernel within the two-release series either LTS or=20
> current range, as specified above, and can provide the logs, etc, from =

> it...
>=20



--OiMhrxI8J6HNLh8bovfo3RbRUrkVCM4Ft--

--cMapV8BMpCQkIlhaoJ4VkAw0cRWMfSRqC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXd8J5AAoJEHykB8ORnUWMF1cIAIZl8pRIzD3J7AqrB/66UWke
VmtY0ILIKUIzdtj0aQvkdHPnz1hj36GY3b3rWwH2w9kdC+KBDVurMdKonds5vbxG
t6F68aZmzITH0Ua/9cI49mbHiSKZBNLaXA5aTynwzkU/HAjnfam+fPyvvhn/RV6o
PyHmQYTbT4pO8mnAgvgA7Pt/HCeQadEX6o8UsLCX4SGATJySGNd8MaLq6n3R71v0
c5pjQfLH9qe06JI3xBAAEFN+IbxOnKhdysqfc1c0n+QeS1m1XJuzV/hIDFVBIFMA
UdB5Oqts2ncVUO9tqAQeuDrsdyqpUODoG1EUc1q+JubCSfZrvNqo10gDtBDreNs=
=0p5R
-----END PGP SIGNATURE-----

--cMapV8BMpCQkIlhaoJ4VkAw0cRWMfSRqC--
