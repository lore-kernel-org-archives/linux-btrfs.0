Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54405 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbeHINtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 09:49:22 -0400
Subject: Re: [PATCH v2] btrfs: qgroup: Dirty all qgroups before rescan
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180809070857.7456-1-wqu@suse.com>
 <CAL3q7H4P3h-hT_rtXQnLMePu2GrmRMa=M7nqbJ9FUxhCfvF89A@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cafc79c2-fdc2-51de-185a-b91809f9b39e@gmx.com>
Date: Thu, 9 Aug 2018 19:24:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4P3h-hT_rtXQnLMePu2GrmRMa=M7nqbJ9FUxhCfvF89A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S6qZ7hgEnXj7WyMkCHctm2lBiempQcwhK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S6qZ7hgEnXj7WyMkCHctm2lBiempQcwhK
Content-Type: multipart/mixed; boundary="qqP18aLcrTIz7L7CkSTxb7lXKDq8ujXnt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <cafc79c2-fdc2-51de-185a-b91809f9b39e@gmx.com>
Subject: Re: [PATCH v2] btrfs: qgroup: Dirty all qgroups before rescan
References: <20180809070857.7456-1-wqu@suse.com>
 <CAL3q7H4P3h-hT_rtXQnLMePu2GrmRMa=M7nqbJ9FUxhCfvF89A@mail.gmail.com>
In-Reply-To: <CAL3q7H4P3h-hT_rtXQnLMePu2GrmRMa=M7nqbJ9FUxhCfvF89A@mail.gmail.com>

--qqP18aLcrTIz7L7CkSTxb7lXKDq8ujXnt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/9/18 5:17 PM, Filipe Manana wrote:
> On Thu, Aug 9, 2018 at 8:08 AM, Qu Wenruo <wqu@suse.com> wrote:
>> [BUG]
>> In the following case, rescan won't zero out the number of qgroup 1/0:=

>> ------
>> $ mkfs.btrfs -fq $DEV
>> $ mount $DEV /mnt
>>
>> $ btrfs quota enable /mnt
>> $ btrfs qgroup create 1/0 /mnt
>> $ btrfs sub create /mnt/sub
>> $ btrfs qgroup assign 0/257 1/0 /mnt
>>
>> $ dd if=3D/dev/urandom of=3D/mnt/sub/file bs=3D1k count=3D1000
>> $ btrfs sub snap /mnt/sub /mnt/snap
>> $ btrfs quota rescan -w /mnt
>> $ btrfs qgroup show -pcre /mnt
>> qgroupid         rfer         excl     max_rfer     max_excl parent  c=
hild
>> --------         ----         ----     --------     -------- ------  -=
----
>> 0/5          16.00KiB     16.00KiB         none         none ---     -=
--
>> 0/257      1016.00KiB     16.00KiB         none         none 1/0     -=
--
>> 0/258      1016.00KiB     16.00KiB         none         none ---     -=
--
>> 1/0        1016.00KiB     16.00KiB         none         none ---     0=
/257
>>
>> so far so good, but:
>>
>> $ btrfs qgroup remove 0/257 1/0 /mnt
>> WARNING: quotas may be inconsistent, rescan needed
>> $ btrfs quota rescan -w /mnt
>> $ btrfs qgroup show -pcre  /mnt
>> qgoupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
>> --------         ----         ----     --------     -------- ------  -=
----
>> 0/5          16.00KiB     16.00KiB         none         none ---     -=
--
>> 0/257      1016.00KiB     16.00KiB         none         none ---     -=
--
>> 0/258      1016.00KiB     16.00KiB         none         none ---     -=
--
>> 1/0        1016.00KiB     16.00KiB         none         none ---     -=
--
>>            ^^^^^^^^^^     ^^^^^^^^ not cleared
>> ------
>>
>> [CAUSE]
>> Before rescan we call qgroup_rescan_zero_tracking() to zero out all
>> qgroups' accounting numbers.
>>
>> However we don't mark all qgroups dirty, but rely on rescan to mark
>> qgroups dirty.
>>
>> If we have any high level qgroup but without any child (orphan group),=

>=20
> That sentence is confusing. An orphan, by definition [1], is someone
> (or something in this case) without parents.
> But you mention a group without children, so that should be named
> "childless" or simply say "without children".

Makes sense, I'll correct the commit message in next version.

Thanks,
Qu

> So one part of the sentence is wrong, either what is in parenthesis or
> what comes before them.
>=20
> [1] https://www.thefreedictionary.com/orphan
>=20
>> it
>> won't be marked dirty during rescan, since we can not reach that qgrou=
p.
>>
>> This will cause QGROUP_INFO items of orphan qgroups never get updated =
in
>> quota tree, thus their numbers will stay the same in "btrfs qgroup sho=
w"
>> output.
>>
>> [FIX]
>> Just mark all qgroups dirty in qgroup_rescan_zero_tracking(), so even =
we
>> have orphan qgroups their QGROUP_INFO items will still get updated dur=
ing
>> rescan.
>>
>> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Fix some grammar errors in commit message.
>> ---
>>  fs/btrfs/qgroup.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 48c1c3e7baf3..5a5372b33d96 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2864,6 +2864,7 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info=
 *fs_info)
>>                 qgroup->rfer_cmpr =3D 0;
>>                 qgroup->excl =3D 0;
>>                 qgroup->excl_cmpr =3D 0;
>> +               qgroup_dirty(fs_info, qgroup);
>>         }
>>         spin_unlock(&fs_info->qgroup_lock);
>>  }
>> --
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--qqP18aLcrTIz7L7CkSTxb7lXKDq8ujXnt--

--S6qZ7hgEnXj7WyMkCHctm2lBiempQcwhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltsJHwACgkQwj2R86El
/qhHiQf/WPFhayevNQOH/TcAS/yuOyvBiQBqBw1n5h0or2pukLqHFa6FGIy0P6u3
gw0+I02risN8Nhmrfxy9UI574ZiWkN/FeSXtxO6VqsCvwLVo3yzpmVU58pJkmNoq
Ohamoo2wAxwvPekCP6rlgxhvRBDQiiT7YHswkMUw5CtDT17xSk8wgS700AOQ0ojQ
cw+/fQjuKs5yUzqsQNMIJPZ6Tqpq6WO/pblZS5T1TpjlXHBuJfylYpTrnYQuReio
qIvhtwF6MYLKVe7z9E0sGJvs0wWzcQ6F6M362mzAgMNrxmKViCmta8u2+r4AreZe
6RGB2jpBJROSDS1jwYj+FR5dpjbADQ==
=/kS3
-----END PGP SIGNATURE-----

--S6qZ7hgEnXj7WyMkCHctm2lBiempQcwhK--
