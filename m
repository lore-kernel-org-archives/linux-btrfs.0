Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A71CC0044C
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 00:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A981320666
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 00:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A981320666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbeKBJbt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 05:31:49 -0400
Received: from mout.gmx.net ([212.227.15.19]:50049 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbeKBJbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 05:31:48 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M23zf-1fOTcP1ZkZ-00u2rL; Fri, 02
 Nov 2018 01:26:35 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M23zf-1fOTcP1ZkZ-00u2rL; Fri, 02
 Nov 2018 01:26:35 +0100
Subject: Re: btrfs partition is broken, cannot restore anything
To:     Attila Vangel <vangel.attila@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
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
Message-ID: <9b5a27c9-561c-2f76-c19f-4ab5af33e541@gmx.com>
Date:   Fri, 2 Nov 2018 08:26:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RIFJopafQHA9A4ERcn12wwSQK9UkKlwV9"
X-Provags-ID: V03:K1:31tbDzyMXYbe/TZX18pnm5W5CG2z1rYLWToryTZc+9iNFq1iWKC
 Gmlu+U3LFMS5inSjj4sEr2t50N1LnatX4/LCU88DfuAm5/I0j1uCVBAacWfuEynwrSHJ2gM
 xx7eRkepdc+/BWTd0tvei1UlUzJexq1sX2dehDOM3AyqfeDL8XgiiDR9FGupVPdJoqF0ZYu
 VknlRrzlWO3N9NtbbnU2g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:s0+va1Cy2io=:+Bt8fOOS5N/LkwB+VxT79O
 0mNT+YV6ZzUXKl7LYa/mblXwS8UTDKZ5zKMiyt/sAyAK4WJVeMpW3TDo98oHmec4xOsPDfm/5
 +L3+44Hks/wy/TuSi4eIJLS5Ec7vPfbZDHb0LscLmQbszgMsnjKLUI4obJoJ+ikF/Mvoj4rR9
 W9gBeOVrN/ryQM2ORPoUItZkjiX8ZofCnp9N2toV9O77eD03p5DR84Ahhb8NnpHLSMRX/P4Ze
 1v4pVBjdcIiInYRyS49kX7rwGkqdSvslVxE1X/0MYUqeoflJVq0LhT4t6Gl4ExY/cVrkzQkrp
 iiz1mY9OcL/pS+M/qJfwMU698O8WaVzaj5pkp3hO++73DplRHmuh0Ss53JlD1cLTofEcnvuhe
 N+9aTV7JcBu5r18XL1P7bbnoKkWkxU25Cx6kmWrhto4uZfARYvD6pao230PVBkwtEwN6HXOjf
 uaObYi5pQSglNpPNvdea/dxZ8qMQooI1Z3vQFWV2olg0ETicA8PK0Q9CrmERnIVxe/sF8b/Pp
 8PGtx3uZ42cCxQh1osTPYoGY8obkYrVihthIFJ4Bq2n/JsASkzk+ByLppPPX63dhY4sfcIZSW
 YAMymAUu4yTS93waxnDQ6CH9zvjDpKJW8a1nDKMEWs5PAKXsIfNcUdt/Tz1rAD5sxujxXVPfq
 QJ0gGc8YhLiwzrGgfa5iS/0CXtXjO2hDaY1WUBNMS7tjzvaDY5S0HPai9IJBfhK0CIKOvfFfm
 MJQPZjso4+Nj6Pg+UCdk9UJkfINIAwkTNjrCSd/09uAlf4GlnRmM5UzMj3auJ3lTyHrmShytg
 95HkfTCTxOXi0tGOj8CjG6qhaOLyQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RIFJopafQHA9A4ERcn12wwSQK9UkKlwV9
Content-Type: multipart/mixed; boundary="YIDcJwmHnSrYHUM81EB8dl0aUiybvwBZU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Attila Vangel <vangel.attila@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <9b5a27c9-561c-2f76-c19f-4ab5af33e541@gmx.com>
Subject: Re: btrfs partition is broken, cannot restore anything
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
In-Reply-To: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>

--YIDcJwmHnSrYHUM81EB8dl0aUiybvwBZU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/2 =E4=B8=8A=E5=8D=884:40, Attila Vangel wrote:
> Hi,
>=20
> Somehow my btrfs partition got broken. I use Arch, so my kernel is
> quite new (4.18.x).
> I don't remember exactly the sequence of events. At some point it was
> accessible in read-only, but unfortunately I did not take backup
> immediately. dmesg log from that time:
>=20
> [ 62.602388] BTRFS warning (device nvme0n1p2): block group
> 103923318784 has wrong amount of free space
> [ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
> space cache for block group 103923318784, rebuilding it now
> [ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0 18=
812026880
> [ 108.039227] BTRFS: error (device nvme0n1p2) in
> __btrfs_free_extent:7010: errno=3D-5 IO failure

Normally we shouldn't call __btrfs_free_extent() during mount.
It looks like it's caused by log tree replay.

You could try to mount the fs with -o ro,nologreplay to see if you could
still mount the fs RO without log replay.

If it goes well, at least you could access the files.

> [ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
> [ 108.039250] BTRFS: error (device nvme0n1p2) in
> btrfs_run_delayed_refs:3076: errno=3D-5 IO failure
>=20
> At the next reboot it failed to mount. Problem may have been that at
> some point I booted to another distro with older kernel (4.15.x,
> 4.14.52) and unfortunately attempted some checks/repairs (?) e.g. from
> gparted, and at that time I did not know it could be destructive.>
> Anyway, currently it fails to mount (even with ro and/or recovery),
> btrfs check results in "checksum verify failed" and "bad tree block"
> errors,

Full btrfs check result please.

> btrfs restore resulted in "We have looped trying to restore
> files in" errors for a dozen of paths then exit.

So at least btrfs-restore is working.

This normally means the fs is not completely corrupted, and essential
trees are at least OK.

Still need that "btrfs check" output (along with "btrfs check
--mode=3Dlowmem") to determine what to do.

Thanks,
Qu
>=20
> Is there some hope to save data from the filesystem, and if so, how?
>=20
> BTW I checked some diagnostics commands regarding my SSD with the nvme
> client and from that it seems there are no hardware problems.
>=20
> Your help is highly appreciated.
>=20
> Cheers,
> Attila
>=20


--YIDcJwmHnSrYHUM81EB8dl0aUiybvwBZU--

--RIFJopafQHA9A4ERcn12wwSQK9UkKlwV9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvbmbcACgkQwj2R86El
/qichgf7BZmRWYylcuIbxnPgwLMz8pByFvD4N+XnDBDQBL6nLoLJLDGtUsS3XTNn
paQS3IzObE+zuVnHZB+QD3L4jUtXBEKkkddrw73G1AUc6Ppm4N78nWWvQ8yGRe3+
TiEGcsbNNtkGmb+q1MgzNMJ+N+DGcn+6AOK7bH7iRWOK4bBLVmjuft1RJzcWnMVG
fCvw2YCnlO8reZ5fv5krmB0Pre3MpO02FZmoFa1r/H878VxVTCdtv4wrI/d6x0MX
eigc5gB4riJOIWhVOHFEgFfRTj9CVo7pWEbaAJ/CLDmMB1//DJz6OOxZx3tzBG8A
0eebW16zOKIFCOpD7mlMUtj+sNf4Yw==
=Bbcx
-----END PGP SIGNATURE-----

--RIFJopafQHA9A4ERcn12wwSQK9UkKlwV9--
