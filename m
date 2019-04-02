Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A63C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 00:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B7EB20857
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 00:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KBfnjwjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfDBAYf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 20:24:35 -0400
Received: from mout.gmx.net ([212.227.17.21]:39485 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfDBAYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 20:24:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554164669;
        bh=lppsugbVcQ0jiulcbEjR/XFBNiCuALj2wZkNShSOXPE=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=KBfnjwjO5jF8X/kary/+5l9FdrabCiyH2GsyuI6IqmfxOc8jkVIhPngWcMVc491h/
         oyA/Zze+jVdyGcrIxKFsytzwdMtQkfpu1gMoikd92qqck/a3/TATjuXd9ndn4M2pvy
         X8LfhGkwRcc0IWxaaqHX/cZtkSIeCdqPY4pzlzbA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LlDx4-1gcKdh3KQ2-00b7Gh; Tue, 02
 Apr 2019 02:24:28 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     btrfs@avgustinov.eu, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
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
Message-ID: <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
Date:   Tue, 2 Apr 2019 08:24:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="unlTe5MXKGKEgYQ93FgnhhhQHp6IEjhhL"
X-Provags-ID: V03:K1:eDnnEUzhSCOw0k5/6lBNta5K35Vl+FBG9HXJ3ih6k4NMxOag2hZ
 A/PweNVQH5bYRyTgzMT8/uVi6ZNnn5vK6d+43OID+VQQKU60eml6Gr8xjvF3djGy4D/9hLk
 TWcl553rBy/c8+cwXSBfQZW6PDsDODQzjh7LUMqpSQCm0fLKgCh3tRAKr64bRIu1Bc6f5GX
 hq5sDYrfOkLWloDcQJcYQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IiHXMnfi9F8=:6i35hbectbNOV8hKrJ4RNW
 25AK0xV5D0PIUgc/OscVDU/gWxDnQCrMLm6mK3/4vwNHPGbQUENNasYR1wNnBYxZognnsVVcQ
 QFwip09fQSe66nTU5bz7eGTU3gDWs1/jJPT6aR8ks5bhz1NK/MK+eCqqHzPh3qg/QBe0ipTsY
 KxkWkCZFK87QLj8nfgfA07h+jIS6n2EFBcJA5xzRfJefG9o6XJLsnHUHnGFNt4WpRneAqrJEp
 Q9xrckchUHbs8OMtzDByTqgWLNvzz0MpCra4UTbpNSqBlkeXLXzcv6IYILJcUik3w9lX0/c+V
 PlNSqI2tbOz1UGx+Gl6GVxj3jb0hZVrRnNG7Hr15dKyBviMnj3jvpDwQ4KcBZ35+ttDbbMxiJ
 tggfeZO5HEVMmAmhICo30nTO2mRAbCbM1JToMFDW/P4RN1d3vZnWBnYNoLJH75OUfI8gOIjRh
 3ua85OEPavlAwlwEGMeHx5UVCw9aOehXFZRyCnMN502Z1cl886F7uGYgfDs/s5NtNo3kc61G6
 SRXFlR7t2LVSaUgrEmbwFknDURWUoIEmQ+SvouNe222B8KVkk6ACg+aALaImRYnHSq/VTbylE
 wa4xreRGbTZlWMSz7b2gNCQ8SQd1/tFTpbtiLo1bhapMsRU6/T0VnTOAQjVBGegrOrUv8hvQT
 FCQM8IrZcHA8FAjXUdVEDQ2+Qi+SSNpeNBJvZRtlbe8UdolUe0R1yn7nS+1EDghqAizQ4Fm5a
 VPoWKuP3RfaQtOvdcyGZzdwjC0XX8fCDGAm2cn71gMXjwOGnyWTAWW3gOzWeeKstl25/fDuXG
 sCKu6KApI/N9ugjl/KOT0fV3jQOHDzHoJDryxCeuoYZewFXxsY2jm/LRfonVj1U9fZMIusRgr
 xVWbgZn0t108s5zTTp9eh/6swQWh33jNPh2d8Og+3YQcsR538DLbmF0V80emsJ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--unlTe5MXKGKEgYQ93FgnhhhQHp6IEjhhL
Content-Type: multipart/mixed; boundary="hig4fPV1ngClJqk3OjEP6XnJ8Y2rtbwjQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: btrfs@avgustinov.eu, linux-btrfs@vger.kernel.org
Message-ID: <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
In-Reply-To: <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>

--hig4fPV1ngClJqk3OjEP6XnJ8Y2rtbwjQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/1 =E4=B8=8A=E5=8D=882:44, btrfs@avgustinov.eu wrote:
> Dear all,
>=20
>=20
> I am a big fan of btrfs, and I am using it since 2013 - in the meantime=

> on at least four different computers. During this time, I suffered at
> least four bad btrfs-failures leading to unmountable, unreadable and
> unrecoverable file system. Since in three of the cases I did not manage=

> to recover even a single file, I am beginning to lose my confidence in
> btrfs: for 35-years working with different computers no other file
> system was so bad at recovering files!
>=20
> Considering the importance of btrfs and keeping in mind the number of
> similar failures, described in countless forums on the net, I have got
> an idea: to donate my last two damaged filesystems for investigation
> purposes and thus hopefully contribute to the improvement of btrfs. One=

> condition: any recovered personal data (mostly pictures and audio files=
)
> should remain undisclosed and be deleted.
>=20
> Should anybody be interested in this - feel free to contact me
> personally (I am not reading the list regularly!), otherwise I am going=

> to reformat and reuse both systems in two weeks from today.
>=20
> Some more info:
>=20
> =C2=A0 - The smaller system is 83.6GB, I could either send you an image=
 of
> this system on an unneeded hard drive or put it into a dedicated
> computer and give you root rights and ssh-access to it (the network lin=

> is 100Mb down, 50Mb up, so it should be acceptable).

I'm a little more interested in this case, as it's easier to debug.

However there is one requirement before debugging.

*NO* btrfs check --repair/--init-* run at all.
btrfs check --repair is known to cause transid error.


And, I'm afraid even with some debugging, the result would be pretty
predictable.

It will be 90% transid error.
And if it's tree block from future, then it's something barrier related.
If it's tree block from the past, then it's some tree block doesn't
reach disk.

We have being chasing the spectre for a long time, had several
assumption but never pinned it down.


But anyway, more info is always better.

I'd like to get the ssh access for this smaller image.

Thanks,
Qu

>=20
> =C2=A0 - The used space on the other file system is about 3 TB (4 TB
> capacity) and it is distributed among 5 drives, so I can only offer
> remote access to this, but I will need time to organize it.
>=20
> If you need additional information - please ask, but keep in mind that =
I
> have almost no "free time" and the answer could need a day or two.
>=20
> Kind regards,
>=20
> Nik.
>=20
> --=20
>=20
>=20


--hig4fPV1ngClJqk3OjEP6XnJ8Y2rtbwjQ--

--unlTe5MXKGKEgYQ93FgnhhhQHp6IEjhhL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyiq7cACgkQwj2R86El
/qg9Iwf7BK38iizM0HB10yBaTbAniGyZxYGup3CDe0wlX9JEDGz+BpYwlwtTBr+2
FcKUX9QB4/JQWA8fkfU0lCYWcS5hPzQAEshJfcisPb6J2iZxGtSdPNeFDVxxpOvL
jr2xr685Mp1G10nN9WCTVEGgyjF1RJcrLfBBW2W/ThL8e90nVaAWtb+Pm4ZF0Tao
vHXaAacI6OrfofhZEthbr3HoTrR/zA0Kvxh+WlwH2vxu9WPm7jaNdtyhrUC04MBm
6mo4Sh5ktbInlPFq1JxWowEOwHcbnDirB1mezjISG/yxf1N62AKRd3GRDGtwsMeX
tvk4zWCsF6zIEnQwb7kiPFcpjVA5Mw==
=jzRh
-----END PGP SIGNATURE-----

--unlTe5MXKGKEgYQ93FgnhhhQHp6IEjhhL--
