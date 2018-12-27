Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C625DC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9624C214AE
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbeL0HbS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:31:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:36586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727007AbeL0HbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:31:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC77CAE26;
        Thu, 27 Dec 2018 07:31:12 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs-progs: uuid: Port kernel
 btrfs_uuid_tree_lookup()
To:     Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-2-wqu@suse.com>
 <2a24d1cf-41b4-b4db-7aae-33c836c9a6b0@gmx.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <e47163cf-390f-d12a-35bc-7cc5d9900661@suse.de>
Date:   Thu, 27 Dec 2018 15:31:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <2a24d1cf-41b4-b4db-7aae-33c836c9a6b0@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uJKYqAm43efgEc32nFBhOBtNveNzp8a7U"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uJKYqAm43efgEc32nFBhOBtNveNzp8a7U
Content-Type: multipart/mixed; boundary="7O7FkBjsFIj17zMlaYxrtxzvub1KnnLBx";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <e47163cf-390f-d12a-35bc-7cc5d9900661@suse.de>
Subject: Re: [PATCH 1/3] btrfs-progs: uuid: Port kernel
 btrfs_uuid_tree_lookup()
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-2-wqu@suse.com>
 <2a24d1cf-41b4-b4db-7aae-33c836c9a6b0@gmx.com>
In-Reply-To: <2a24d1cf-41b4-b4db-7aae-33c836c9a6b0@gmx.com>

--7O7FkBjsFIj17zMlaYxrtxzvub1KnnLBx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/27 =E4=B8=8B=E5=8D=883:37, Su Yue wrote:
>=20
>=20
> On 12/27/18 3:13 PM, Qu Wenruo wrote:
>> Although we have btrfs_uuid_tree_lookup_any(), it's an online function=

>> utilizing tree search ioctl, not an offline search function.
>>
>> This patch will port kernel btrfs_uuid_tree_lookup() into btrfs-progs
>> for later proper uuid tree initialization.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> One nitpick bellow.
>=20
> Reviewed-by: Su Yue <damenly_su@gmx.com>
>> ---
>> =C2=A0 uuid-tree.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++--
>> =C2=A0 1 file changed, 69 insertions(+), 2 deletions(-)
>>
>> diff --git a/uuid-tree.c b/uuid-tree.c
>> index 320eb67e1404..b9190103c355 100644
>> --- a/uuid-tree.c
>> +++ b/uuid-tree.c
>> @@ -23,6 +23,7 @@
>> =C2=A0 #include "transaction.h"
>> =C2=A0 #include "disk-io.h"
>> =C2=A0 #include "print-tree.h"
>> +#include "utils.h"
>> =C2=A0 =C2=A0 =C2=A0 static void btrfs_uuid_to_key(const u8 *uuid, u64=
 *key_objectid,
>> @@ -32,8 +33,11 @@ static void btrfs_uuid_to_key(const u8 *uuid, u64
>> *key_objectid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *key_offset =3D get_unaligned_le64(uuid=
 + sizeof(u64));
>> =C2=A0 }
>> =C2=A0 -
>> -/* return -ENOENT for !found, < 0 for errors, or 0 if an item was
>> found */
>> +/*
>> + * Search uuid tree of a *MOUNTED* btrfs (online)
>> + *
>> + * return -ENOENT for !found, < 0 for errors, or 0 if an item was fou=
nd
>> + */
>> =C2=A0 static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u=
8 type,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 *s=
ubid)
>> =C2=A0 {
>> @@ -103,3 +107,66 @@ int btrfs_lookup_uuid_received_subvol_item(int
>> fd, const u8 *uuid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_=
UUID_KEY_RECEIVED_SUBVOL,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 subvol=
_id);
>> =C2=A0 }
>> +
>> +/*
>> + * Search uuid tree of an *UNMOUNTED* btrfs (offline)
>=20
> For consistency of btrfs_uuid_tree_lookup_any(), I'd like to add
> "> + * return -ENOENT for !found, < 0 for errors, or 0 if an item was
> found"
> here too :).

Indeed, this return value isn't the normal >0 for !found and in fact the
comment is from kernel.

I'll update the github version without a resend.

Thanks,
Qu

>=20
>> + */
>> +static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8
>> *uuid,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 type, u64 subid)
>> +{
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path *path =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb;
>> +=C2=A0=C2=A0=C2=A0 int slot;
>> +=C2=A0=C2=A0=C2=A0 u32 item_size;
>> +=C2=A0=C2=A0=C2=A0 unsigned long offset;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!uuid_root) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
>> +=C2=A0=C2=A0=C2=A0 if (!path) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 btrfs_uuid_to_key(uuid, &key.objectid, &key.offset=
);
>> +=C2=A0=C2=A0=C2=A0 key.type =3D type;
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_search_slot(NULL, uuid_root, &key, p=
ath, 0, 0);
>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 } else if (ret > 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 eb =3D path->nodes[0];
>> +=C2=A0=C2=A0=C2=A0 slot =3D path->slots[0];
>> +=C2=A0=C2=A0=C2=A0 item_size =3D btrfs_item_size_nr(eb, slot);
>> +=C2=A0=C2=A0=C2=A0 offset =3D btrfs_item_ptr_offset(eb, slot);
>> +=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(item_size, sizeof(u64))) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warning("uuid item with il=
legal size %lu!",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u=
nsigned long)item_size);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 while (item_size) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 data;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read_extent_buffer(eb, &da=
ta, offset, sizeof(data));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (le64_to_cpu(data) =3D=3D=
 subid) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D 0;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset +=3D sizeof(data);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item_size -=3D sizeof(data=
);
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +out:
>> +=C2=A0=C2=A0=C2=A0 btrfs_free_path(path);
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>>
>=20


--7O7FkBjsFIj17zMlaYxrtxzvub1KnnLBx--

--uJKYqAm43efgEc32nFBhOBtNveNzp8a7U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwkf70ACgkQwj2R86El
/qixFQf/Q1LVAgfo3CHGDRQ9PBbULahyiOo8aVEVvNtnHAOZuZL5IR6db8qrruOg
dUFiBg3Cn2100UvTc2rjjSuMWsNMoteIt/65nLUyAr9DGBC1ogCcny9k016FI6HY
nI0tjjLW9LVgY00Ywa9LN1s7KrNtteKgnq5iooAU690NdTVnDu3Rs/MAg/sW5Jcg
WSIEkMf7yNkFxlGqvAOhRmlEhD03O3/Av1UvkiUo0f8KRTprI5sW6t7tr01fQGFR
N/P8L2MEN4kS1253BouDFwOrwyKREO4NNq/g/1AFbor33Tf6CzXqknumqJUWIpgS
WKX4ztYAsevmu4s+RiyZo5m4Hsqilg==
=/+5I
-----END PGP SIGNATURE-----

--uJKYqAm43efgEc32nFBhOBtNveNzp8a7U--
