Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44140 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759739AbaJ3QAF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 12:00:05 -0400
Date: Thu, 30 Oct 2014 12:00:04 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: luvar@plaintext.sk
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs deduplication and linux cache management
Message-ID: <20141030160004.GK17395@hungrycats.org>
References: <1589590871.231414660858286.JavaMail.root@shiva>
 <650272300.271414661167523.JavaMail.root@shiva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr6OvWOSyJed8q4v"
In-Reply-To: <650272300.271414661167523.JavaMail.root@shiva>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yr6OvWOSyJed8q4v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 10:26:07AM +0100, luvar@plaintext.sk wrote:
> Hi,
> I want to ask, if deduplicated file content will be cached in linux kerne=
l just once for two deduplicated files.
>=20
> To explain in deep:
>  - I use btrfs for whole system with few subvolumes with some compression=
 on some subvolumes.
>  - I have two directories with eclipse SDK with slightly differences (sam=
e version, different config)
>  - I assume that given directories is deduplicated and so two eclipse ins=
tallations take place on hdd like one would (in rough estimation)
>  - I will start one of given eclipse
>  - linux kernel will cache all opened files during start of eclipse (I ha=
ve enough free ram)
>  - I am just happy stupid linux user:
>     1. will kernel cache file content after decompression? (I think yes)
>     2. cached data will be in VFS layer or in block device layer?

My guess based on behavior is the VFS layer.  See below.

>  - When I will lunch second eclipse (different from first, but deduplicat=
ed from first) after first one:
>     1. will second start require less data to be read from HDD?

No.

>     2. will be metadata for second instance read from hdd? (I asume yes)

Yes (how could it not?).

>     3. will be actual data read second time? (I hope not)

Unfortunately, yes.

This is my test:

1.  Create a file full of compressible data that is big enough to take
a few seconds to read from disk, but not too big to fit in RAM:

	yes $(date) | head -c 500m > a

2.  Create a "deduplicated" (shared extent) copy of same:

	cp --reflink=3Dalways a b

	(use filefrag -v to verify both files have same physical extents)

3.  Drop caches

	sync; sysctl vm.drop_caches=3D1

4.  Time reading both files with cold and hot cache:

	time cat a > /dev/null
	time cat b > /dev/null
	time cat a > /dev/null
	time cat b > /dev/null

Ideally, the first 'cat a' would load the file back from disk, so it
will take a long time, and the other three would be very fast as the
shared extent data would already be in RAM.

That is what happens on 3.17.1:

	time cat a > /dev/null
	real    0m18.870s
	user    0m0.017s
	sys     0m3.432s

	time cat b > /dev/null
	real    0m16.931s
	user    0m0.007s
	sys     0m3.357s

	time cat a > /dev/null
	real    0m0.141s
	user    0m0.001s
	sys     0m0.136s

	time cat b > /dev/null
	real    0m0.121s
	user    0m0.002s
	sys     0m0.116s

Above we see that reading 'b' the first time takes almost as long as 'a'.
The second reads are cached, so they finish two orders of magnitude
faster.

That suggests that deduplicated extents are read and cached as entirely
separate copies of the data.  The sys time for the first read of 'b'
would imply separate decompression as well.

Compare the above result with a hardlink, which might behave more like
what we expect:

	rm -f b
	ln a b
	sync; sysctl vm.drop_caches=3D1

	time cat a > /dev/null
	real    0m20.262s
	user    0m0.010s
	sys     0m3.376s

	time cat b > /dev/null
	real    0m0.125s
	user    0m0.003s
	sys     0m0.120s

	time cat a > /dev/null
	real    0m0.103s
	user    0m0.004s
	sys     0m0.097s

	time cat b > /dev/null
	real    0m0.098s
	user    0m0.002s
	sys     0m0.091s

Above we clearly see that we read 'a' from disk only once, and use the
cache three times.

--yr6OvWOSyJed8q4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRSYIQACgkQgfmLGlazG5x+jACeJp8yEa6Nhu94rM1GEjSUU/ks
aJwAn1oO6gBATWyZfldh6nerYwpMZnYT
=LEO1
-----END PGP SIGNATURE-----

--yr6OvWOSyJed8q4v--
