Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cahost.average.org ([72.55.133.117]:35443 "EHLO
	cahost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2LRPaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 10:30:30 -0500
Message-ID: <50D08C0A.4010003@average.org>
Date: Tue, 18 Dec 2012 19:30:18 +0400
From: Eugene Crosser <crosser@average.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs in the kernel 2.6.31
References: <50D079AB.2030805@average.org> <20121218143521.GN19051@carfax.org.uk> <20121218143759.GO19051@carfax.org.uk> (sfid-20121218_183805_520610_34744205)
In-Reply-To: <20121218143759.GO19051@carfax.org.uk> (sfid-20121218_183805_520610_34744205)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig626159A078878821B979F2C2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig626159A078878821B979F2C2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks Hugo!

The idea to bring the hardware support forward to the current kernel was =
my
first thing to check. It seems that a few people (more experienced than m=
yself)
tried this and could not make it work reliably. Tweaking btrfs in 2.6.31 =
was my
"plan B". Now it looks like both endeavours are beyond my knowledge/resou=
rce
budget. Oh well.

Generally, the idea of using btrfs on a home NAS is very attractive: fast=

initialization of raid1 and especially filesystem-level snapshots are exa=
ctly
what I want from my file server.

Thanks again,

Eugene

On 12/18/2012 06:37 PM, Hugo Mills wrote:
> On Tue, Dec 18, 2012 at 02:35:21PM +0000, Hugo Mills wrote:
>> On Tue, Dec 18, 2012 at 06:11:55PM +0400, Eugene Crosser wrote:
>>> I have a board based on PLX7821 aka OX820 ARM SoC. It is not
>=20
>    Oh, I forgot to mention -- there's some problems with the btrfs
> userspace tools on ARM, related to unaligned accesses. You will need
> to get hold of the patch (from Arne, in October this year, on this
> mailing list, shout if you can't find it) which fixes those issues.
> It's not made it to the upstream btrfs-progs repo yet.
>=20
>    Hugo.
>=20
>>> supported in the mainline kernel; the vendor supplied the source of
>>> the kernel 2.6.31 with necessary updates for this platform, and it
>>> works. I understand that there have been no successful attempts to
>>> bring support of this platform to newer kernels.
>>
>>> I would like to use btrfs on this system, but it is labelled
>>> "experimental" in the kernel. My question is: is it "safe" to use
>>> btrfs as it is in 2.6.31? In other words, where there "data
>>> destroying" bugs found and fixed since then? If the answer is yes,
>>> then is it possible (and how difficult) to compile newer btrfs code
>>> against this kernel, or backport the fixes?
>>
>>    2.6.31 is *insanely* old in btrfs terms, and definitely contains
>> serious filesystem-corrupting bugs that have been fixed since. You
>> should be looking at running 3.7 (right now) or 3.8-rc1 (when that
>> comes out next week), from a btrfs point of view. I really wouldn't
>> recommend running the btrfs code from 2.6.31.
>>
>>    Backporting current btrfs code to a kernel that old is likely to be=

>> a difficult proposition, simply because other things (in the VFS and
>> block layers) will have changed underneath it. Similarly, if the
>> patches for your board haven't been updated as the kernel progressed,
>> you're going to have a hard time forward-porting them. Given the
>> option of where to put in the work, I'd recommend forward-porting the
>> hardware support to a more recent kernel, and getting that pushed to
>> mainline, as it's more likely to be useful in the future, and useful
>> to more people.
>>
>>    Hugo.
>>
>>
>=20



--------------enig626159A078878821B979F2C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iD8DBQFQ0IwKfrw/cIw6UWkRAl62AJ49c6Q7IOhef5AoN2TdZ3Ejh11U9wCgizkb
wMBgEOfZP1OuSngs4rhgT7Y=
=Acr+
-----END PGP SIGNATURE-----

--------------enig626159A078878821B979F2C2--
