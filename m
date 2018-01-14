Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58519 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbeANAhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Jan 2018 19:37:04 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
Date: Sun, 14 Jan 2018 08:36:41 +0800
MIME-Version: 1.0
In-Reply-To: <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6EvbNvHi0kPnig4Q2PF1ewMM1B3Y7q8XP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6EvbNvHi0kPnig4Q2PF1ewMM1B3Y7q8XP
Content-Type: multipart/mixed; boundary="NTYfBtREuC6kr4fcqBNnUookfNM6C806j";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
In-Reply-To: <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>

--NTYfBtREuC6kr4fcqBNnUookfNM6C806j
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 04:41, Sebastian Andrzej Siewior w=
rote:
> On 2018-01-13 08:56:24 [+0800], Qu Wenruo wrote:
>> 'Btrfs check' output please.
>=20
> ~# btrfs check --repair -p /dev/sdb4
> enabling repair mode
> Checking filesystem on /dev/sdb4
> UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
> Fixed 0 roots.
> checking extents [o]
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated=

> checkingunresolved ref dir 57648595 index 435 namelen 40 name 2f3f379b2=
a3d7499471edb74869efe-1948311.d filetype 1 errors 80, filetype mismatch
>         unresolved ref dir 57648595 index 1137 namelen 39 name 454bf066=
ddfbf42e0f3b77ea71c82f-878732.o filetype 1 errors 100, name too long

Now we know the affected dir (ino 57648595).
>=20
> checking csums
> checking root refs
> found 63691468800 bytes used, no error found
> total csum bytes: 61339388
> total tree bytes: 860536832
> total fs tree bytes: 688816128
> total extent tree bytes: 84545536
> btree space waste bytes: 224424238
> file data blocks allocated: 62890745856
>  referenced 62829219840
> ~#=20
>=20
>> And in fact, btrfs check --repair has the ability to move/re-link such=

>> file and keeps its content, as long as there is any info found in
>> DIR_INDEX/DIR_ITEM/INODE_REF.
>>
>> If repair can't handle it, the output could help us to craft such case=

>> and enhance btrfs-progs to repair it.
>=20
> Is the output enough or do you want me to do more?

Still needs more. (and maybe even more depending on the output)

The original mode doesn't report error clear enough, so it would help if
--mode=3Dlowmem can be used.

# btrfs check --mode=3Dlowmem /dev/sdb4

And the tree dump of the affected dir inode would help too:

# btrfs inspect dump-tree /dev/sdb4 | grep -C 20 \(57648595

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>=20
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--NTYfBtREuC6kr4fcqBNnUookfNM6C806j--

--6EvbNvHi0kPnig4Q2PF1ewMM1B3Y7q8XP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpaphkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qicBgf/V9IguY9arlKK/4V0dAkIw4UO
qRg4l06r/WpKlID3gwu1twFrMQiBD0N8E04NM1UfkrdJZUq4/4Zfcth1p3O6263v
e19oOflwRET6wkVEBVl/Nwdl4T5VrX56QC1I1ukrGDRSSPvvk8Abv+zCZgYTm44e
pRiaRWscDLPB/S64bpKsUbrVUiObFFY22IPp6t+iSt2mOSIVO4GrKlnjd9aPx7td
WFSvVo4A+1PmybDv/lvAEtg+lH+uPd8iJ5NZ+OIMWO3KLYuYvOOdE0zHpnk44+0Q
YHcjEj47ls4abbSa8RBMzDc07TYFOgAHfmnh81rxaakraU/Lo+LB7Ivwu5qJtg==
=H9dO
-----END PGP SIGNATURE-----

--6EvbNvHi0kPnig4Q2PF1ewMM1B3Y7q8XP--
