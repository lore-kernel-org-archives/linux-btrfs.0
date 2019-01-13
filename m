Return-Path: <SRS0=FrL0=PV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B30EC43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 11:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BDB20657
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 11:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfAMLCy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 06:02:54 -0500
Received: from mout.gmx.net ([212.227.15.19]:51289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfAMLCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 06:02:53 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LeMij-1h3PZF2Zsj-00q6va; Sun, 13
 Jan 2019 12:02:50 +0100
Subject: Re: Retrieving
To:     Tobias Reinhard <trtracer@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
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
Message-ID: <a0e58490-8610-2b86-751f-772625fdf0ca@gmx.com>
Date:   Sun, 13 Jan 2019 19:02:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VtdJRruZ8mYNlgW7WoiJqZrzgFRdsOOaI"
X-Provags-ID: V03:K1:0QiXi+Mxx0HGzG73rXRaC1RcUu2aGpxdGtccjBOjpIJEaVx7v1Y
 XJOZc2W183yG8lnHsdTLE3dwTFtH6E6eSr9gNgVKw3XyR1OJl7T/aO7tZe0gIdLrnRhF6FP
 jPUV2n5kjJkwa3Wf0cVEvUCuzyy21twLpIRklTeQFPrMmatqujl8ycTJ4AlLW5QbkNCiX6g
 V2oX6N5psRpiBDXLdSg9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WmKyjwHtKEg=:WrlmoH+IFRAymykrhWRWec
 /2icUVy0ZxBh25OCcVc8CCKn4nh3QgvoxOhqVFGfNRS74IlsPgNUBOIMiEV6c+DcGEEdpVlEt
 nWEFyaT7QcId65Rv2vf51iXh45nAA3PDgfx3h8PPIH2ehv5nMbt0Qy33fhTo6sm3OqFOWaWuN
 g96UQuWUoZFnO74HLHq48j+t2OZdgoc/Kg6jgatuwXth7aAKRzh/Wr3+gzxD3Avu7iAHZXq2O
 E4hE0C+pRXyfcW+u3T/Nry5ncqK1Y3ZjPwm3Q0X+xPeIl12RoTvlELm9GyUQvih3KnPdyRo/t
 UwrcLC4ZA/DDwGP/jFoDVGmPAFTyLsvIkmnnZn7lM8L3NZYVGxSE8mADicDyfmAK5pGQG19cV
 AdB65589xOXb0+GSq6Ug4B3NRFxluRZspQlC1H12opKoykqKG6hINOQTxD+f0d2S+a3eDJqOk
 48kNfSVvhUfMITR2SzXvaqQchryulrYRw6YeD7MMqe1708gLOAveOY3O9sWY/A2sBsgoN2Zs0
 meJ0P52lpwTR9GRnK8aN4R5ZacyMTFVxLN/ewdYJLGDrFpivcisMx05S7Ie78/c2vWmFmLw0+
 BMrMVrf0GNVaYKKrxAdiJL65+cszhB1Y7TEg9DtTGNliAJX/ZBRsLZbr3/xoVmo1WWSo5/X9k
 58K8o89Qn1UfhYDy0MMu7IDee9TqZ8GiPhMKaxuqLTBjJIXxsMe1tl/cufWhihHGG8cFcBmGX
 C9VA0b5NiM2g9DuQkAj8n/s01GO4gBzAqyq43q8+GD5mdHC4yAePzR1UEIbamh7RpiQKj5Eb6
 JBgZmtD5TSMN+2sd2o0clxGH0Rv1ro56ATXouK/AcDszbjl25vI1m7foBhvgwIbnNxeUdxk2D
 18aKuyDGF56yBduOYPjdR2DDvpdWaFSeIehOHF25BUtBM3unkasP4KHIhElyqU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VtdJRruZ8mYNlgW7WoiJqZrzgFRdsOOaI
Content-Type: multipart/mixed; boundary="25v8I3auaY00RyWoUIIujV6tI6w8T5TEE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tobias Reinhard <trtracer@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <a0e58490-8610-2b86-751f-772625fdf0ca@gmx.com>
Subject: Re: Retrieving
References: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
In-Reply-To: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>

--25v8I3auaY00RyWoUIIujV6tI6w8T5TEE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/13 =E4=B8=8B=E5=8D=886:19, Tobias Reinhard wrote:
> Hi,
>=20
> I want to read the complete CSUM-Tree from userspace. I tried it via th=
e
> ioctl. This is what the code looks like:
>=20
> struct btrfs_sv2_args sv2_args;
> int fd =3D open(filename, O_RDONLY);
> sv2_args.key.tree_id =3D BTRFS_CSUM_TREE_OBJECTID;
> sv2_args.key.min_objectid =3D 0;
> sv2_args.key.max_objectid =3D -1;
> sv2_args.key.min_offset =3D 0;
> sv2_args.key.max_offset =3D -1;
> sv2_args.key.min_transid =3D 0;
> sv2_args.key.max_transid =3D -1;
> sv2_args.key.min_type =3D BTRFS_CSUM_ITEM_KEY;
> sv2_args.key.max_type =3D BTRFS_CSUM_ITEM_KEY;
> sv2_args.key.nr_items =3D -1;
> sv2_args.buf_size =3D sizeof(sv2_args.buf);
> ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, &sv2_args);
>=20
> But the device is not small and I hit the limit of the
> btrfs_sv2_args.buf which seems to be 16 MB.
>=20
> How can I get the *complete* CSUM-Tree?
>=20
> Limiting to offset does not work (My first idea was to do it this way
> and get it in chunks).

That's strange.

Are you still using 0~-1 objectid and 0~-1 type, just last_offset~-1?

Have tried searching using the following parameters?
min_objectid =3D max_objectid =3D BTRFS_EXTENT_CSUM_OBJECTID
min_type =3D max_type =3D BTRFS_CSUM_ITEM_KEY;
min_offset =3D last_found_csum_offset
max_offset =3D -1

Thanks,
Qu

>=20
> Limiting to a single transid does not work as well because even one
> transid is larger than the limit.
>=20
> Kernel is 4.15.
>=20
> Any help would be appreciated.
>=20
> Best Regards
>=20
> Tobias
>=20


--25v8I3auaY00RyWoUIIujV6tI6w8T5TEE--

--VtdJRruZ8mYNlgW7WoiJqZrzgFRdsOOaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw7Gs4ACgkQwj2R86El
/qgRYQgAkrLVrEEzTAvh4K2x7RVU/WvPO17th/JI1FAN6HoeG7P8U581K/5l5ziQ
z95b73Qj8BJhslUzcKbVLvIBLOMLNIP4iLxUldwp0mA6cV57CIj8XypSiOBsDmkz
7YxphIcsywKNn2lnkdf8rdjCPUt4lrr+YVVTRTYZ3NymfcE9t6LziWXa6hgPn6EB
bkgVkyfomI0gvWFP8FiKfL81hJyb+Fiat/BFhq6vb55ka5do2JOxvyWR2mo3MPE1
JVUvI9CsdHVTxIGioKlOSruLd/rli4rCzxrgHu7jymSrpJqmua1aceTXoyF6FSa6
grYtH+vf3/UWvWjE9u+J5cAJPDUgEA==
=GbtJ
-----END PGP SIGNATURE-----

--VtdJRruZ8mYNlgW7WoiJqZrzgFRdsOOaI--
