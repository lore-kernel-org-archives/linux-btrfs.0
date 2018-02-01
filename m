Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63607 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbeBAFAr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 00:00:47 -0500
Subject: Re: [PATCH 00/16] btrfs-progs: Split lowmem mode check to its own
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180119053731.10795-1-wqu@suse.com>
 <20180131182654.GJ18553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1f2c5555-3159-c2aa-feb6-1a00ca0163a9@gmx.com>
Date: Thu, 1 Feb 2018 13:00:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180131182654.GJ18553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2i1Juq9JJB2upWrLeiMkBBbvvsIkSldVQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2i1Juq9JJB2upWrLeiMkBBbvvsIkSldVQ
Content-Type: multipart/mixed; boundary="h4LAgEPENfUJC4a0j06BCQj7gyHB7vFND";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <1f2c5555-3159-c2aa-feb6-1a00ca0163a9@gmx.com>
Subject: Re: [PATCH 00/16] btrfs-progs: Split lowmem mode check to its own
References: <20180119053731.10795-1-wqu@suse.com>
 <20180131182654.GJ18553@twin.jikos.cz>
In-Reply-To: <20180131182654.GJ18553@twin.jikos.cz>

--h4LAgEPENfUJC4a0j06BCQj7gyHB7vFND
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8801=E6=97=A5 02:26, David Sterba wrote:
> On Fri, Jan 19, 2018 at 01:37:15PM +0800, Qu Wenruo wrote:
>> The long planned cmds-check re-construction is finally here.
>>
>> As the original cmds-check.c is getting larger and larger (already ove=
r
>> 15K lines), it's always a good idea to split it into its own check/
>> directory.
>>
>> This patchset do the following work:
>> 1) Move cmds-check.c to check/main.c
>> 2) Put codes shared by both original and lowmem mode into
>>    check/common.[ch]
>> 3) Put lowmem code into check/lowmem.[ch]
>>    With minor renaming to get rid of unnecessary _v2 suffix.
>>
>> The modification looks scary, but no functional change at all.
>>
>> And considering how much the file structure changed, it's a good idea =
to
>> put PART1 as quick as possible, and there will be less pressure to
>> rebase new incoming fsck related codes.
>=20
> I agree with the way you split check, my attempts were going along the
> same lines. The question whether to split first and then add fixes shal=
l
> be resolved as I'm going to merge the split first. This would need
> refreshing the lowmem fixes but the other way around would not avoid th=
e
> merge conflicts anyway.
>=20
> The patch 15 does not apply cleanly to current devel, the conflict did
> not seem big, but I did not try to resolve it and merge the last patch.=

> So, 1-14 goes to devel, please refresh 15 and 16.

No problem.

Update under way.

>=20
>> The real move work happens in the 15th patch, which due to its size
>> (500KB+), it may not be able to reach mail list.
>> So please fetch the whole patchset from github:
>> https://github.com/adam900710/btrfs-progs/tree/split_check
>>
>> There will be a part 2, mostly moving original mode to its own
>> check/original.[ch], along with extra comment explaining how the two
>> different modes work.
>=20
> I'm going to do a few file renames, eg. original.c -> mode-original.c
> and similar.
> It would be better if you send part 2 after that.

Of course.
It would be a while for part 2.

> I'm
> expecting more patches that would do no functional change so we can
> settle down with the new check/ structure.
>=20
> As 'check' is the 1st level command, the cmds-check.c will need to be
> restored at some point, but it will be only a simple wrapper around the=

> commandline handling.

OK, I think it would be part of PART 2 to restore it.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--h4LAgEPENfUJC4a0j06BCQj7gyHB7vFND--

--2i1Juq9JJB2upWrLeiMkBBbvvsIkSldVQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpynvAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjpjQgApo3+yQgRovQzXIA0x3doUEDz
Vsij+V5XL2+CIh2qpMHDgB0ZXxz9o8XzZL3XYyZh/WiKJxzHqmc33UfOEXDQQE8V
g/m1aJSL+aT8n30Z3I8pRX0hcG22qLREVD6DnxF2VWW/OQ4F5ltUaQ/unm4xwc3z
D71q5F2Nl0rHipv2UUcYa1Q8VOXY7IbH6O9lUs83CXPq1BdscWsLLseS3HDOcUsr
/lSoTWsUQtCj0OpHVy26M4agkmPhornP6c7iIUpJZZ75/0gZnvRiNv4E2N9HIeL3
gVsX0J0DquDixX1jltlHDkzGUKsnhuEnYqHagGYZiTnupLYkimoFJmtv8mdbtw==
=uWC6
-----END PGP SIGNATURE-----

--2i1Juq9JJB2upWrLeiMkBBbvvsIkSldVQ--
