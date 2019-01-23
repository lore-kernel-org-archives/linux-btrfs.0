Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E370C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 06:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E5B21726
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 06:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfAWGBW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:01:22 -0500
Received: from mout.gmx.net ([212.227.17.20]:46199 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfAWGBW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 01:01:22 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4CB5-1h4oVn10ux-00roVT; Wed, 23
 Jan 2019 07:01:13 +0100
Subject: Re: [PATCH v4 3/7] btrfs: relocation: Delay reloc tree deletion after
 merge_reloc_roots()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-4-wqu@suse.com> <20190122163258.GM2900@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <62862a9b-561a-aa72-794c-b9fe89a81e56@gmx.com>
Date:   Wed, 23 Jan 2019 14:01:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122163258.GM2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3nkQpI7QwlmEkegpZkI3f8VAsWOP9IrUW"
X-Provags-ID: V03:K1:172vP3ofc37pcJcTTtZ5mpH02a8/W9cXb9mdM34qw+Xv8hzG8tD
 Q9fTY54frF2fw8xC6+r9LhDTc1FjNdKXNKbVTPYw9ic8b6QzDbRloZCF1J4R9e7LxNLqHXj
 JN1zmvCoexjafjeeUKJpOqYd15AEEfOoPaW1DzZmmob9AQS1MBkL2qbl8U2lq3FevOYijs7
 456AdzakyxJljS3m8xXyg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Uci9Nfn1OnM=:CyrqKnmxtFVtHjwxitONpp
 TxmP0dg/zVNVVAxlo4nZgPzScx/F/pHZGrS+5ByU1wnQFWnoAt4QuVYh/eu2ou8L6krh/gjdQ
 roUJ97HEWNYCe761Orb1MVyVSUH1Pls4UK/FQPpe+NytUoP8YUS5QF/tAMdNE/4rLLQ5yJUBD
 nYOAeJtzS8pJNL21hynaTY+WMpfMGRf8A6+YYAHTN9bnIboWfwk7SlHlNDn7+hLr4+DwzxDAM
 F4eQgeIkU2FsAk78i+U7YmKq6CoAS4SBVe4QMxhWptUQrNKPdbBaWdF8ex+3J+ecem+2+axlb
 fURim2JiwZIebeJMMaCR0Sdm4MTLJ2+3lW/qkgvitmxRbSzsoGh4PhMcBl5/G1Mne35a9HEzo
 gTejsw6MC3zqnAHk022OT1uVkQGBQHsik1rf3GZz0pbkwm8d+euJEMLcL9W/jJQNToM/yI7f7
 q3KnZizfOjPpiWtB8ersM52UcRt/6MeE3rwiq5tL0jjx1588qohlyGsFHPv1zNzgt6W4Bxar5
 SqF+E5CgFJ3lWp7MxaN/ore5aKauLt1AutQ+U9fCpKIvcf/cSr/GTaPTUVaTg4ZvvmCpBUv3Z
 WYsOukzQj1ZMJELL1WFxIeO1Z1IxlS6Y3xhmQvNa3OxkrDNWK8xKsnZAgvK9e4ZPNrzRNvRFT
 tSobSB27GuMqaK/dGHGffgT63128HN0jtI6J3n5Z8H+sWosFHIly0Ad4el3gg9SDSKamlzHnw
 UcphNug43WjAuBm7TpucYVXxpWfXFui6JtcN1EwS+uBd2+33tlf66U/gsosEHoCtoF6+wWior
 Vy/vWTSiQ/FHxulZySn9fFJTKvBhWzjiuhT1d6p1/D/Hn6o9LdT/M5GzriC9T1S8Xa0k+Ghwq
 1uJkKVMapQ4Ls1a+pKSH2MW9FbQHMvWVdTN/sDN60qOgVVBR+DG6GumA8qOPJs
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3nkQpI7QwlmEkegpZkI3f8VAsWOP9IrUW
Content-Type: multipart/mixed; boundary="30jdb3iUHGm8wCjkrvsd9ynsq7wRR4HG8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <62862a9b-561a-aa72-794c-b9fe89a81e56@gmx.com>
Subject: Re: [PATCH v4 3/7] btrfs: relocation: Delay reloc tree deletion after
 merge_reloc_roots()
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-4-wqu@suse.com> <20190122163258.GM2900@twin.jikos.cz>
In-Reply-To: <20190122163258.GM2900@twin.jikos.cz>

--30jdb3iUHGm8wCjkrvsd9ynsq7wRR4HG8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8A=E5=8D=8812:32, David Sterba wrote:
> On Tue, Jan 15, 2019 at 04:16:00PM +0800, Qu Wenruo wrote:
>> And to co-operate this, also delayed btrfs_drop_snapshot() call on rel=
oc
>> tree, btrfs_drop_snapshot() call will also be delayed to
>> clean_dirty_subvs().
>=20
> Can you please rephrase this paragraph?
>=20
>> This patch will increase the size of btrfs_root by 16 bytes.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
>> +static int clean_dirty_subvs(struct reloc_control *rc)
>> +{
>> +	struct btrfs_root *root;
>> +	struct btrfs_root *next;
>> +	int err =3D 0;
>> +	int ret;
>> +
>> +	list_for_each_entry_safe(root, next, &rc->dirty_subv_roots,
>> +				 reloc_dirty_list) {
>> +		struct btrfs_root *reloc_root =3D root->reloc_root;
>> +
>> +		clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>> +		list_del_init(&root->reloc_dirty_list);
>> +		root->reloc_root =3D NULL;
>> +		if (reloc_root) {
>> +			ret =3D btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
>> +			if (ret < 0 && !err)
>> +				err =3D ret;
>> +		}
>> +		btrfs_put_fs_root(root);
>> +	}
>> +	return err;
>=20
> Please dont use the err/ret style but 'ret' that matches function retur=
n
> type and for the temporary return values ret2 etc.

For this policy, the primary objective is to avoid the confusion between
err and ret, right?

Then I'd prefer tmp_ret over ret2, although it's just a personal taste.

Thanks,
Qu

>=20
>> +}


--30jdb3iUHGm8wCjkrvsd9ynsq7wRR4HG8--

--3nkQpI7QwlmEkegpZkI3f8VAsWOP9IrUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxIAyMACgkQwj2R86El
/qiVNQf9E1b1H9gmXAgW9uu7kDja5qAFxvXceyGdn7Z1FBbRCOHbgwvZP4abV3aa
Rc54GowVacIIe5SoySD4P5bVaEGFKvUXeC+AscjBsKTqb1CWUewkpMj86IQVCUkR
2OHfCdJ0/sK3VqRqrEiXRazZLAzdGJNmDNrDgeehDGsEbBg9o5MlBzhovaXnNxOK
/0VKZ3I3QjiOWf8c/M0V0p5Ru7d+d5TADqyaeKhOHPcRBWGr39NQAJfTlopE1clj
JXK39paM6h+Lp8e54WIPfU4VAbbFZ6yyz4KjQQ+JJocOinTgWHl3w3qIbnCDdH2a
UfrJdG2RD1kuCpG1tkdZZgGOLDtODA==
=5F+V
-----END PGP SIGNATURE-----

--3nkQpI7QwlmEkegpZkI3f8VAsWOP9IrUW--
