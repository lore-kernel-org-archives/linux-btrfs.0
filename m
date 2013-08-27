Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab3H0VHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 17:07:21 -0400
Message-ID: <521D14FF.9090604@suse.com>
Date: Tue, 27 Aug 2013 17:07:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <521CFDD8.6030205@suse.com> <20130827205637.GM29654@localhost.localdomain>
In-Reply-To: <20130827205637.GM29654@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FrK2BeNp6OEHjmV54M6i4OtBpO3UWIVK8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FrK2BeNp6OEHjmV54M6i4OtBpO3UWIVK8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/27/13 4:56 PM, Josef Bacik wrote:
> On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
>> On 8/26/13 4:56 PM, Josef Bacik wrote:
>>> One of the complaints we get a lot is how many BUG_ON()'s we have.  S=
o to help
>>> with this I'm introducing a kconfig option to enable/disable a new AS=
SERT()
>>> mechanism much like what XFS does.  This will allow us developers to =
still get
>>> our nice panics but allow users/distros to compile them out.  With th=
is we can
>>> go through and convert any BUG_ON()'s that we have to catch actual pr=
ogramming
>>> mistakes to the new ASSERT() and then fix everybody else to return er=
rors.  This
>>> will also allow developers to leave sanity checks in their new code t=
o make sure
>>> we don't trip over problems while testing stuff and vetting new featu=
res.
>>> Thanks,
>>
>> I don't think the complaint is so much about the number of BUG_ONs, bu=
t
>> that there's no distinction between something that is supposed to be
>> impossible and something that is improbable. The BUG_ONs to keep code
>> correctness are good and are littered all over the kernel with positiv=
e
>> results. The BUG_ONs that are there in place of real error handling
>> served their purpose and need to be replaced.
>>
>> So, I don't know if it's a net win to compile the "good" BUG_ONs out o=
f
>> the code. Especially if a user runs into something strange yet familia=
r
>> and the first response is "oh, huh, can you rebuild with asserts enabl=
ed?"
>>
>=20
> Either I provide an option for it or distros do it themselves, this cut=
s out the
> middle man.  I'd really rather they just be on all the time since they =
aren't
> things we should hit anyway, but at least this way people have a choice=
=2E

Ok. With my distro hat on, I can tell you I'll be leaving them on. :)

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--FrK2BeNp6OEHjmV54M6i4OtBpO3UWIVK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSHRUCAAoJEB57S2MheeWy0bQP/A23Qkt+tsfBu8xPcVNqLPBi
XJUdBb3py1mhlRX3/oK2hr5wE9sdChdh3UJRFf0Lb7KAO0YgkGwNnfUPBP4VOGVA
CEWMlCu9lAqFUcHxUwlv/UgQL/dRGLqQ/mZCJUsps9oWk0nz4gby3fBwyV5cpG+y
50NrBTnIYsgC+FHRzCMHQjPr6s7wsjJkBYUaGA9NpCjAw9vkmx8JhDX+8tgPnuYU
htNVHH3Wwqe6FnQ/nAaw8GNkCc98ol/CyY8njU+chfIztlwXVErQWAiAVpB11Egk
FUAogEUtSgC1TXlPfeAWSfqCdQvGNKFU3XeONk5eLgrs6n+pr3s3m4/2j/wj5tMP
PhDBts0L7UzK5y4alt7g/4Pw7k1MA2/0AgR+l5HBUSJfdRYAwTIThtLfD+VF54ZZ
hTr2iqO/y+eWmrehIPvnSFjyCAyBtXRuNucYtKYpEWeznYlP1A62Bzrx0PcEE07b
23zWsO9OTFS0a8bPcE8jSg3imDNxuyReQFmZ3uJ7spFXZ9Tllp6eKzd2Fz2FwNzb
GQwcwNYUDSjWDO/lMmHDf3kUA6SUY8kHOy9NdFgAYc4umwfA8X6RSUBI33RBRmoV
4XfgMm0GMeQha7oiddIdeZ7JYDTMAXKu0wLRXrfUnaVVzquMfS/ctL1y1jhgochP
2zXHRHGV2lEpWJLBOH3E
=2xIa
-----END PGP SIGNATURE-----

--FrK2BeNp6OEHjmV54M6i4OtBpO3UWIVK8--
