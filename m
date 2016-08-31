Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36497 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbcHaBfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 21:35:45 -0400
Subject: Re: btrfs send extremely slow (almost stuck)
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57C6345E.5010006@suse.com>
Date: Tue, 30 Aug 2016 21:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="274wcNm061AOGD0DEQ3Bpica3Jk2sA1oq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--274wcNm061AOGD0DEQ3Bpica3Jk2sA1oq
Content-Type: multipart/mixed; boundary="L5oAOovJGF2mpTSHkJEmXRVjxFMcV381e"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Oliver Freyermuth <o.freyermuth@googlemail.com>, linux-btrfs@vger.kernel.org
Message-ID: <57C6345E.5010006@suse.com>
Subject: Re: btrfs send extremely slow (almost stuck)
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>
In-Reply-To: <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>

--L5oAOovJGF2mpTSHkJEmXRVjxFMcV381e
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/28/16 10:12 PM, Qu Wenruo wrote:
>=20
>=20
> At 08/29/2016 10:11 AM, Qu Wenruo wrote:
>>
>>
>> At 08/28/2016 11:38 AM, Oliver Freyermuth wrote:
>>> Dear btrfs experts,
>>>
>>> I just tried to make use of btrfs send / receive for incremental
>>> backups (using btrbk to simplify the process).
>>> It seems that on my two machines, btrfs send gets stuck after
>>> transferring some GiB - it's not fully halted, but instead of making
>>> full use of the available I/O, I get something < 500 kiB on average,
>>> which are just some "full speed spikes" with many seconds / minutes o=
f
>>> no I/O in between.
>>>
>>> During this "halting", btrfs send eats one full CPU core.
>>> A "perf top" shows this is spent in "find_parent_nodes" and
>>> "__merge_refs" inside the kernel.
>>> I am using btrfs-progs 4.7 and kernel 4.7.0.
>>
>> Unknown bug, while unfortunately no good idea to solve yet.
>=20
> Sorry, known bug, not unknown....

I'm working on a patch to replace the lists with a pair of trees that
get merged after filling in the missing parents.

The reflink xfstests don't complete, ever.  btrfs/130 triggers soft
lockups but do complete eventually -- and that's only with ~4k list
elements.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--L5oAOovJGF2mpTSHkJEmXRVjxFMcV381e--

--274wcNm061AOGD0DEQ3Bpica3Jk2sA1oq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXxjRhAAoJEB57S2MheeWyf5sP/A/y1U9/EHucpUQSIR6u5f/O
zquyxPsKzlUImi5gGwG5PfcfJdqXWoLrH7bjBPByKP4ozSiOGJR9PSZiCQNr9ixl
+TurZszCD0DSxEZ++Zs2Gkm8L+HGAM0X9J+tELlC0kqc2CFwY4V/FX580vNVvL+X
hW7kc5OmpUxGspqhaJ6tQrP+UBFsE0BVcTWYk+coSvjcIeJqEus6jY/+/BZALia1
GOO0qkgixPytG8C2b2I06+J/fx3tCuPk6JKAFSWw/bVqCmXc95myF5tHBnywt678
xh9nVGBSvZTFXmv7/c0xEJqMLghUPtDVN2A1J6Y1XpozEsy5QlybmplVYZUGR6Tf
yrdvoEqohnM9ZGIIZYNDs/RK/lbhUjpqv0UAestCMe/P+B/Y6nNJSV3AlKt9oELB
5kVw979me4H23vO7Mgl2gIVXMcQgKLxooqTcXGfDnVhuyp1dqIzez6NZ/45NoJku
7Ur+lu/ekN99tPWXCYochzBM2M/vIhDmC9UX7bnWhKH6hQBVKRwTS2BC1/XU++LT
Lcpstvfao9wRT8CoM4PmURvTmFuFZ5I0DZGVQKUeKBvo+egIXKitKz6Dx2tpOlCz
2IQ8Mcs3wB3ipvp8j2crzj0NsOCFhJChE7UjNy/Ud6Q8w8Oq+Hl7cbUE2SLoZvsw
JWNB+bNfYkpbucsDPCdR
=q6ae
-----END PGP SIGNATURE-----

--274wcNm061AOGD0DEQ3Bpica3Jk2sA1oq--
