Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FAEECDE42
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B7E204EC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64B7E204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbeJRIq2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 04:46:28 -0400
Received: from mout.gmx.net ([212.227.17.20]:51121 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbeJRIq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 04:46:28 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MfBsk-1g1Igm3tEo-00OmFq; Thu, 18
 Oct 2018 02:48:07 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MfBsk-1g1Igm3tEo-00OmFq; Thu, 18
 Oct 2018 02:48:07 +0200
Subject: Re: Urgent: Need BTRFS-Expert
To:     Michael Post <michael_post@web.de>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
 <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
 <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <c35d0b80-ba1f-5c4b-c886-c3b17c717c5b@gmx.com>
Date:   Thu, 18 Oct 2018 08:48:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NXDhUaFZr2CKEMaKhAYMQvpwlJgdQm2em"
X-Provags-ID: V03:K1:8Zynq9g0qDlYZZDMAaWS/xd0P/1xz0rOd7oQ23UXvEmOcEeSo8w
 jf7R9FN9T3hAuvHFkfxw82hPS9U5Eq/zNOPXwRUQx6PgB+wMPiexQKm7ZrfDavXUjk0gjE5
 f2IptUs6xp+2gPlt/s1QUmZg89DaRQXw2BuP1TxHHCW7nZzddl4SR9+uQQ9GL17J2TfNF6L
 P2Ql+moijL7+ITprLgyRQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:WkN7lqRCrN8=:hwizM6pr8FYPQz35zFdDLO
 lp95fcR3u6tzHQx/2yuWSC2wxJ9CHks+yD0lLY6KlrsDXF6MbRTdopzMuNkwpqSDpuPkVqhoJ
 blEmUW6bQjTPdU5Tci61SiBanpVO0GbXRVGEEalVfOve5n+OSx1I5zVj0vzz+KrmoumYcwjQS
 +PedF0Ivc1zTxibtFU5k/mgxpzuXDC3p2k1cKbZ5MCosxz8qLBcnlECez8mgB7zI2RC1JxXSF
 Py5wMW0TFQeRSx/Cg/1f1CnJo50c+JR+iKpXG+qcquNTsUuUfySewBfWQh3qpkiGD2khxYqPo
 OdC6jPK6WVfc5HKHNE2TjR+nC4q/VRyhLNcfzgOBLl42XiRolcQls+sOb1mAJeGfIuCV5CnXP
 ayNq7zPf0PQpP1Tf/OpTtxPinFHqO+Z9xFZsTBkajg36wpKVHuDGVdpf3eaaBlO3XzgjyHg5u
 VNaOseduULT8JCslHPHnd2onl0F7IqG1+/qRRW9Yr8Rfko+e/o6y+J/Qaq6bcN3YFqivYOGg8
 lD3RuhFGIQbS1i6Hm9JSOPOYAhSBmsn4xxgBG4pNNbhneznhP6jR9XOHsr0Ent2jI84uNTxYq
 hdsA3KCIckROFqbrdSPJaf5kjzY1wMaPC2LpTciOTtko3nSdx/9QcInnJoQagBU/8lZwbDtdW
 /9QUxhpBpbpvPzgnKf2s0IlOr0IFOUcNwR50FDsAMt2MzMeQAw/yoIIMDBON2hZrCWuSjNY5a
 OP0C7jibIBhKcR26diKyqdHCqBcduRxhnhZLFZdeYD+IxANey51xzfBlPqxegnxMmW0jXHvX2
 t6JQhu3RSndNdT1ZMXQGzhTO8R2uw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NXDhUaFZr2CKEMaKhAYMQvpwlJgdQm2em
Content-Type: multipart/mixed; boundary="gQsMMKupx9UozNq5XBHs67Uw15dKyZFeE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Post <michael_post@web.de>, Hugo Mills <hugo@carfax.org.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <c35d0b80-ba1f-5c4b-c886-c3b17c717c5b@gmx.com>
Subject: Re: Urgent: Need BTRFS-Expert
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
 <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
 <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>
In-Reply-To: <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>

--gQsMMKupx9UozNq5XBHs67Uw15dKyZFeE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/17 =E4=B8=8B=E5=8D=8811:50, Michael Post wrote:
> Hello Qu,
> Hello Hugo,
>=20
> i got this result when i try to recover the chunk tree.
>=20
> # btrfs check /dev/mapper/vg0-virtualbox
> bytenr mismatch, want=3D1263835381760, have=3D0
> ERROR: cannot open file system

This means some essential trees get corrupted.
I remember latest btrfs-progs should prompt which tree is corrupted.

Would you please use latest btrfs-progs and try again?

Also would you please paste the following output?

 # btrfs ins dump-super <device>
 # btrfs ins dump-tree -t chunk <device>

Thanks,
Qu

>=20
>=20
> # btrfs rescue chunk-recover -y  /dev/mapper/vg0-virtualbox
> Scanning: DONE in dev0
> open with broken chunk error
> Chunk tree recovery failed
>=20
> Did you any clue?
>=20
>=20
> Michael
>=20


--gQsMMKupx9UozNq5XBHs67Uw15dKyZFeE--

--NXDhUaFZr2CKEMaKhAYMQvpwlJgdQm2em
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvH2EMACgkQwj2R86El
/qj85QgAgn8x+t+5mEKx/QrXNoDLl1Psiv9ivQfCdGVB3MCMppAaujwz/U2x7E9W
iVoi89BBy784qLTC0bhfKQSpmiVMDKGARNkHDBizdlaV5qid1JbPcmM+QV4ZIhLk
+BZUdFM7+zBQZQvsdKr3rwXlPX8Iyt24IbrpH4s0jwoRbG+jKxG3DdYWzb/ayaJV
tOdH2LlvuVnZ9Fg+1bSoDzIE3Z0p7tRY+SedZYL98w75SBhQ7jqc25NFMpzWpmWp
+5/J7uNbIxiSO4osZaTe88WdIvY7dv15BNaOohEl08UnoPTifzwlhyLFt+cdZDo7
v/ptSbGdpDE7nVFoJBZAgciy47gdPQ==
=O0Hc
-----END PGP SIGNATURE-----

--NXDhUaFZr2CKEMaKhAYMQvpwlJgdQm2em--
