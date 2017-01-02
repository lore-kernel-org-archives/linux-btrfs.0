Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39279 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756130AbdABVCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 16:02:25 -0500
Subject: Re: Will fstrim discard unused parts of chunks?
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>
Date: Mon, 2 Jan 2017 16:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LNTuaeSPax4aIITMA12733VNul0uaT7dF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LNTuaeSPax4aIITMA12733VNul0uaT7dF
Content-Type: multipart/mixed; boundary="rDj0JcbMER6fJeWB0jTBRPeMV9XA2UBlM";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>
Subject: Re: Will fstrim discard unused parts of chunks?
References: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
In-Reply-To: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>

--rDj0JcbMER6fJeWB0jTBRPeMV9XA2UBlM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 1/2/17 4:55 AM, Andrei Borzenkov wrote:
> I try to understand what exactly is trimmed in case of btrfs. Using
> installation in QEMU I see that host file size is about 9GB, allocated
> size in guest approximately matches it and used space in guest is 7.6GB=
=2E
> After some experimenting it looks like host size follows "Device
> allocated" value in "btrfs filesystem usage" which leads me to believe
> trim only considers space outside of allocated chunks. Is it correct?

It should consider all available space.  The code iterates over all
block groups and trims free space and then iterates over free dev
extents, which is all of the unallocated space.

Which kernel version are you using?  This stuff was broken for a while
but was fixed in 4.3.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--rDj0JcbMER6fJeWB0jTBRPeMV9XA2UBlM--

--LNTuaeSPax4aIITMA12733VNul0uaT7dF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJYar/dAAoJEB57S2MheeWyBCIQAIMR7loKksGVAzdod1u1JrdP
NBDD4VCf0J/brdpvwa/Gv5bAvm/V6/Pn9W/GKMw2CcVUUOP5t5xP2NGhkYAh1OVz
2ilCvOCX445aHRfsK4Uc9cZPcpQ9MIXSGso2olZDVAT1uXYQbqoryoBEv8lTqxDB
Jp767zEcnoRlBYPbyl729HdCxikiR3lAqqIfURhZ7WFH6waWPzYxBtjqMhKmcext
InAufGCzDqLK+jK1nG6DQ+D/feS2rtPMcXz0qkUjhHdeUOD8z0wXiM6jOtSQ1soN
HL0Otj7qSlEnvPmFQMT7mW7Rr4U9SA9ir/icVq4OMHVyd80nLXxMV1yjL8P6UUcO
nhut6ADkXF6rPtqRFWEA9/p+OqIuAZVxSU+NiAzqBYO89b5J93L983Xl80TCiBXL
3HoYPQFKr294MMQezyTcZNeQhzfaAR282ifA64WQ2ogCqY/QrrfVFXGfpo+aC2E1
oAmS4Uqg38mZ77X+PHMhvDJv9ysc2Ucill6WaiCcGqHWlt80lsnfkjLyU7SMuWfA
dIk7ia4REaVYOHFhWb64wPCfEVgViC4RUAMuSyMDUaeuWxnNzdqbYxq2rKOy2lxi
8r7X7r7rIE6Bgh++Byr0QogtBb4mJwZtYo1f4ppdygDYSVbnj42FhHwtfKHcvALv
KOB5TbCI0MvXvs+VKwl5
=pSMb
-----END PGP SIGNATURE-----

--LNTuaeSPax4aIITMA12733VNul0uaT7dF--
