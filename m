Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2127C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C29C820C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C29C820C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbeJAV0e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:26:34 -0400
Received: from mout.gmx.net ([212.227.17.20]:35257 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbeJAV0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:26:33 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgGDK-1gKnHW00cY-00Nk8y; Mon, 01
 Oct 2018 16:48:20 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgGDK-1gKnHW00cY-00Nk8y; Mon, 01
 Oct 2018 16:48:20 +0200
Subject: Re: cross-fs copy support
To:     Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
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
Message-ID: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Date:   Mon, 1 Oct 2018 22:48:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH"
X-Provags-ID: V03:K1:qA3ZIRC7v3lHb7c5dIqjJ2Vb5YvCnpnNhfQaNnY9Oy8FwUcMX07
 Qv0mstN0xM1v+qghR2qLALVY9waG2hIfp1d8etQWr/V4k5QG8RMue7wmXZvEkAsIGgBOOhr
 YfFl6TD2IIIaB1xF1k0lewbHwbPb6mdaGTaFT3xjMU025/FTkfPp8KVNSBJxHXaJvVIpGiE
 6s2xH6iYgiiBexfdHqUMQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:12AbHgjWPp8=:iFig1gsVoErP+kY2yT+6Is
 adayOyRxCmdo8ooZwd3aDGC+NBYugNdjHy3vpZJB4FB2iHCKHAQuIOYHQgnKT9zyNVfrSQ09t
 J9aNa6GmMk8RmYdD3CsdkpHeKHmU/u+AvWsE42A+MS6UpgaKKDZ6bImao8HPceojomTOvVoiq
 YFGQZ6V64InkGKixbz6zlJ2yZVbMopBrnco2bPqIjscAgrySEPx/Bq2KPVnp4ABrz39Xa/jfw
 +J563zQ6w57iK3/3MaUp1+AQFv4i0D5R52Fz03fm3GlAuMihI+CdlpDi2mxM1yYsBjNBnZ7C2
 wY4DpaCDlkwlIHX8DbigCNxde6RaZUZxEjKJPVt7gAQLX0tVyQ4vDSujrfqqWn+yqZL/GiCFQ
 ZTXeli4KDHgX8qMu1gn+xplrf4c4Ao2PcfsEvllM2CMX2bBJPEjrTf09YgVgX9cOwuDaKPNjN
 qpYcyzHhLVk87uvWL5++xJIy2jgF3gazcBR1dyi7q3n8kdqRwwrojNdMNVuFNNJjL+v4mJFDN
 SD6j0/0J7ptP+TTXhCmett9HuvDgWQos0Yj5RaffZxJBPSQln0t6ejOerT72eVt9ynA2O3dKT
 gdfOC79AtJuCppkucSJRcqEna7+JPiWPsvPMiowRqApqo6s8xm1ecjE8M1UlImSlb12RFeYnW
 78d0pw3CLBC3fg4bLbiv4hWZ6/E+71//6aN14Sur7L1YyYhpEXbWI2ORGlQMcknfs3/Twrd84
 UWqF5vhY7qLrfpMv08cXAmsDh4tTaGQKub/po6qkXnYBNclaUXKg8c0u4ldFyMCoS35zXlySW
 e+QIxiHXEbUfkO2DtnsvnnM3LFPlQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH
Content-Type: multipart/mixed; boundary="ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org
Message-ID: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
In-Reply-To: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>

--ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
> I was wondering about the cross-fs copy through copy_file_range.

The term "cross-fs" looks pretty confusing.

If you mean "cross-subvolume", then it should work without problem in btr=
fs.

If you mean reflink across two different file systems (not matter the
same fs type or not).
Then it's impossible to work.

Reflink (clone_file_range) works by inserting data pointers into the
filesystem other than really copying the data.
Thus if the source is outside of the fs, it's really impossible to work,
as the source pointer/data is completely out of control of the dest fs.

> It seems current implement has below check, that disables such copy.
>=20
> 1577         /* this could be relaxed once a method supports cross-fs c=
opies */
> 1578         if (inode_in->i_sb !=3D inode_out->i_sb)
> 1579                 return -EXDEV;
>=20
> May I know what are the thoughts behind disabling cross-fs copy?
> Code has the comment "once a method supports", but that leaves me
> wondering exactly what 'method' is expected, and from whom.
>=20
> I disabled the check, and copy across volumes seemed to work fine. At
> least for a single file (1G size), with no data mismatch, and faster
> speed than regular copy.

Please provide the steps or script about how you did the reflink, in
case I misunderstand your "cross-fs" definition.

And just in case you're really doing cross filesystem reflink, please
also run "btrfs check" on both fs.

Thanks,
Qu



--ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG--

--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluyM68ACgkQwj2R86El
/qiZXQgAl42dvErkqnlBQaSinUyBBlH97d2zZW21MM3WE8kofldrlZwmBhtngGph
KtZX9YBuPVrmHY3h2dZ4tt+8BOn9c0HYiFK1g7hrSgsggzZnpyRgEHkqzH1QPUFV
F8b76taNajcoQnsrVfbjHHBWGARcsNvxUIu1gAW3JtmHiQUxKGqgvD3t3p4V0/+r
rgxdoPb6d+qSI1fAq01xcHQwyNTvsCmEXn9edauux9c1mqW2WhX7yXiEoeqHVnzc
GodbRlQBeURPwjhnmjEzH/3syeIqiu7uNKu1IBbKsDbacgXvmMWNtbt2cozz9wMG
z+kj2Dg17pO0MXAzbrznSEDj0cJNtA==
=iJnX
-----END PGP SIGNATURE-----

--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH--
