Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48343 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbcCDICD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 03:02:03 -0500
Subject: btrfs_get_token_64() alignment problem on ARM (was: Re: DWord
 alignment on ARMv7)
To: Will Deacon <will.deacon@arm.com>
References: <56D8BA3F.7050508@pengutronix.de> <20160303235426.GA11237@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
From: Marc Kleine-Budde <mkl@pengutronix.de>
Message-ID: <56D940E8.2030202@pengutronix.de>
Date: Fri, 4 Mar 2016 09:01:44 +0100
MIME-Version: 1.0
In-Reply-To: <20160303235426.GA11237@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="A1X7NICVprpuxB8I84xTv6I6qp0LJUUUA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A1X7NICVprpuxB8I84xTv6I6qp0LJUUUA
Content-Type: multipart/mixed; boundary="VuB4BHW3VKW1UwFeSCKCcfQ3lr0ovER96"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, linux-btrfs@vger.kernel.org,
 Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>
Message-ID: <56D940E8.2030202@pengutronix.de>
Subject: btrfs_get_token_64() alignment problem on ARM (was: Re: DWord
 alignment on ARMv7)
References: <56D8BA3F.7050508@pengutronix.de> <20160303235426.GA11237@arm.com>
In-Reply-To: <20160303235426.GA11237@arm.com>

--VuB4BHW3VKW1UwFeSCKCcfQ3lr0ovER96
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

On 03/04/2016 12:54 AM, Will Deacon wrote:
> Hi Marc,
>=20
> On Thu, Mar 03, 2016 at 11:27:11PM +0100, Marc Kleine-Budde wrote:
>> I'm using btrfs on am ARMv7 and it turns out, that the kernel has to
>> fixup a lot of kernel originated alignment issues.
>>
>> See /proc/cpu/alignment (~4h of uptime):
>>> System: 22304815 (btrfs_get_token_64+0x13c/0x148 [btrfs])
>>
>> For example, when compiling the kernel on a btrfs volume the counter
>> increases by 100...1000 per second.
>>
>> The function shown "btrfs_get_token_64()" is defined here:
>>> http://lxr.free-electrons.com/source/fs/btrfs/struct-funcs.c#L53
>> ...it already uses get_unaligned_leXX accessors.
>>
>> Quoting a comment in arch/arm/mm/alignment.c:
>>
>>          * ARMv6 and later CPUs can perform unaligned accesses for
>>          * most single load and store instructions up to word size.
>>          * LDM, STM, LDRD and STRD still need to be handled.
>>
>> But on a 32bit ARMv7 64bits are not word-sized.
>>
>> Is the exception and fixup overhead neglectable? Do we have to introdu=
ce
>> something like HAVE_EFFICIENT_UNALIGNED_64BIT_ACCESS?
>=20
> Ouch, that trap/emulate is certainly going to have an effect on your
> performance. I doubt that HAVE_EFFICIENT_UNALIGNED_ACCESS applies to
> types bigger than the native word size on many architectures, so my
> hunch is that the btrfs code should be checking BITS_PER_LONG or simila=
r
> to establish whether or not to break the access up into word accesses.

I've added the btrfs maintainers on Cc.

> A cursory look at the network layer indicates that kind of trick is don=
e
> over there.

I stumbled over this, too.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--VuB4BHW3VKW1UwFeSCKCcfQ3lr0ovER96--

--A1X7NICVprpuxB8I84xTv6I6qp0LJUUUA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJW2UDoAAoJED07qiWsqSVqI3wIAIZN3NV1G5Zlb/wwawANGwpE
Z6KkQNG4NY8wCUKRodsJ5HrCZGtOYQZWlG/qkrIxcR2VCaMi+J7UKrwr/RbeKGuY
DCyB/+1es2kwxAzzRyKCTt0IHJHdziflBIfivRCpkBRF9VdIewtGnb0dQ+vWGO8a
DTSbZZGCq11mK4RLw9kT4/72QNcNxW84O36oal8sKqwFwE38J+RsB7PMGusUJwKJ
GvLpagayrOsIq004I5E+6gxHnTZvB85zuLCovxpoIIAlPrx441CoKH2/20ETqUHz
9KBJ9HoJdZXNTNR/JKvlLQH65TbMcXBJs8zVj18cH8dx1kSyHQFpLS/usodU8kU=
=g/Dk
-----END PGP SIGNATURE-----

--A1X7NICVprpuxB8I84xTv6I6qp0LJUUUA--
