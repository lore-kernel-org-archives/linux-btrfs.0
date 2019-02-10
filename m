Return-Path: <SRS0=C9fc=QR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C0DC282CC
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 13:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA56207E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 13:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfBJNwi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 08:52:38 -0500
Received: from mout.gmx.net ([212.227.17.21]:52969 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfBJNwh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 08:52:37 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMXVC-1h15OM3SaE-008HzT; Sun, 10
 Feb 2019 14:52:29 +0100
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
To:     STEVE LEUNG <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
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
Message-ID: <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
Date:   Sun, 10 Feb 2019 21:52:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5mqf3bhwwRM8TyvGWRfjHNY3DDgafsTId"
X-Provags-ID: V03:K1:1yCsA1cIonhpCM3oGIZQAGZowpAqFU8tH4tivumu6/RCzorOM2O
 HBtF6eqAX6TFA5p1HVuQMPIDruq51u7+Vy/5ZcBKJYR3Ta5vfXXH3pdo5AdUa/ubjU9LjQ7
 PcjyaC4NiukPmftU0TOZ/ZkjjxM+/JM+dZNR9j2rZip2yGnyaSQc3KK9kNu+HEL4q6dc1uN
 9cfuWqbR8MkwWg9blvZ+w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fFarGOlx4AQ=:y6NMmhN91o8Gyd0uYfBdA1
 SjeEpTP0vswy+irYCvL1zE+RNE6j8Mz/VI17vn+6m+ILn2SPbaeSeQ58gCOnlzIzjnXhAjjns
 CNGijJe6TMzAQKYAvuruMk/h/qdh6HLKVLhAWBT73v47bLafZJmOyb/4jt/+N6hEvC6hczs7w
 MhyVYg87i6Vc01gMrXW+W4qHfeqW3sXb8hPxyp5WffjewT1etuesXOVZYrgCaTeaI528F1Das
 GYuIkFQZZZ8VrSK5wsQL603fxSbyblctVle5W30TyKcaUfUkLEfSumq8eKtGNvDtIP7TMq4Ed
 sHZVEwXcwQRYZ2r+1D0n1Nxb/Byj8v/9IMWk74hNU/QnOEp2m8bP02ebctTlrrT0lY6QGhtdT
 DZd/HIr0A7TtmauZ2edo1Kis8qZro9puHD+faQn0uR1l+zMnw2H/kHU43C/tTE+UwRVIpzPmo
 FQz5qr2ZTCxeBIcgUNk8F3VPXHnH+rZcqdcHIJwcAFrnQOc1pX2D0zLhO+PHQtH1PkeY2pdhm
 8BM/ad1cG8W+4htqeoHRAbu8rEzYxmnMWktcjK51SQxknmjOfJTM1BZEjzpSaau4HEYETa5no
 1mgjjzU5Fy2i7AR3QdwHlyBUyeLMSYkdeRMuPCRX2ex8Lx+A6Kt+HjUW4HrcERMZxT4HKD9Pf
 MxuQTH1uwt0O8A0cP5grMDnT+/qLfKfB1OHtf/8xK1h9VLr0dynF5WyWrwJNnQtYmFVZ1Xg2R
 S1fEc09rzedCS3kBS60LtzlgxWS5hM2Q1anH8hExIBFAr+15aFGRHldvmgC/Iy4XYvD6VUadI
 gohWELbMt1jrNVS2WMgUJW1V47SirEki8aJzPne48oVQYhE8zw3YnGGEawkgiRfzNGrehajTh
 5GUAoI42xLymHR027KlAMzqcmZ1iJa5r8J4DHx13iiQO+WAN9vv+sbWJCqiU6M
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5mqf3bhwwRM8TyvGWRfjHNY3DDgafsTId
Content-Type: multipart/mixed; boundary="FUFmEccNdwePAQUtT3gdYlrq07Ptyx2jr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: STEVE LEUNG <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
In-Reply-To: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>

--FUFmEccNdwePAQUtT3gdYlrq07Ptyx2jr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/10 =E4=B8=8B=E5=8D=882:56, STEVE LEUNG wrote:
> Hi all,
>=20
> I decided to try something a bit crazy, and try multi-device raid1 btrf=
s on
> top of dm-crypt and bcache.  That is:
>=20
>   btrfs -> dm-crypt -> bcache -> physical disks
>=20
> I have a single cache device in front of 4 disks.  Maybe this wasn't
> that good of an idea, because the filesystem went read-only a few
> days after setting it up, and now it won't mount.  I'd been running
> btrfs on top of 4 dm-crypt-ed disks for some time without any
> problems, and only added bcache (taking one device out at a time,
> converting it over, adding it back) recently.
>=20
> This was on Arch Linux x86-64, kernel 4.20.1.
>=20
> dmesg from a mount attempt (using -o usebackuproot,nospace_cache,clear_=
cache):
>=20
>   [  267.355024] BTRFS info (device dm-5): trying to use backup root at=
 mount time
>   [  267.355027] BTRFS info (device dm-5): force clearing of disk cache=

>   [  267.355030] BTRFS info (device dm-5): disabling disk space caching=

>   [  267.355032] BTRFS info (device dm-5): has skinny extents
>   [  271.446808] BTRFS error (device dm-5): parent transid verify faile=
d on 13069706166272 wanted 4196588 found 4196585
>   [  271.447485] BTRFS error (device dm-5): parent transid verify faile=
d on 13069706166272 wanted 4196588 found 4196585

When this happens, there is no good way to completely recover (btrfs
check pass after the recovery) the fs.

We should enhance btrfs-progs to handle it, but it will take some time.

>   [  271.447491] BTRFS error (device dm-5): failed to read block groups=
: -5
>   [  271.455868] BTRFS error (device dm-5): open_ctree failed
>=20
> btrfs check:
>=20
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4=
196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4=
196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4=
196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4=
196585
>   Ignoring transid failure
>   ERROR: child eb corrupted: parent bytenr=3D13069708722176 item=3D7 pa=
rent level=3D2 child level=3D0
>   ERROR: cannot open file system
>=20
> Any simple fix for the filesystem?  It'd be nice to recover the data
> that's hopefully still intact.  I have some backups that I can dust
> off if it really comes down to it, but it's more convenient to
> recover the data in-place.

However there is a patch to address this kinda "common" corruption scenar=
io.

https://lwn.net/Articles/777265/

In that patchset, there is a new rescue=3Dbg_skip mount option (needs to
be used with ro), which should allow you to access whatever you still
have from the fs.

=46rom other reporters, such corruption is mainly related to extent tree,=

thus data damage should be pretty small.

Thanks,
Qu

>=20
> This is complete speculation, but I do wonder if having the single
> cache device for multiple btrfs disks triggered the problem.
>=20
> Thanks for any assistance.
>=20
> Steve
>=20


--FUFmEccNdwePAQUtT3gdYlrq07Ptyx2jr--

--5mqf3bhwwRM8TyvGWRfjHNY3DDgafsTId
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxgLJcACgkQwj2R86El
/qhxbAf/SBPd7wLokqYz6Ysyc1v7BKl/kiASrD+gvG7eLdQFwEmMGTW61uw9vmM6
by504VthiQfB2sG//oihlle0SaiN4dMdo2sof5H/+WHrXsIGxOYXMI4SwkN/F4pV
mfAle46fV5JcNmvNxY1FQc/CG11CY/KT5r7PoNUh+mDRWLb6AwngFO9XsNGzQTCd
yjmEgt0ylk6/Hbe7dyvmPly+jMA8ab2qWe26faWlwh4r6FFt3ga/fO2XObDzcOjk
3lnf1Jhx48iQa6d8SWPYc+MhmokrubOJlYPBgQMns/+manndKDal1b3g4rMOXhCf
UHBsCtxEAviyodmi/78WJVJoF12Z0Q==
=Q8jF
-----END PGP SIGNATURE-----

--5mqf3bhwwRM8TyvGWRfjHNY3DDgafsTId--
