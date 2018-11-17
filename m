Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461D4C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 08:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046AD2084A
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 08:03:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 046AD2084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbeKQSTC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 13:19:02 -0500
Received: from mout.gmx.net ([212.227.17.22]:52259 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbeKQSTC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 13:19:02 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MM0bQ-1gP2Ya0LJk-007pZa; Sat, 17
 Nov 2018 09:03:08 +0100
Subject: Re: bad tree block start, want 705757184 have 82362368
To:     Stephan Olbrich <stephanolbrich@gmx.de>,
        linux-btrfs@vger.kernel.org
References: <1758973.r4I5FPff6i@chaos-desktop>
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
Message-ID: <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
Date:   Sat, 17 Nov 2018 16:03:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1758973.r4I5FPff6i@chaos-desktop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BpqEQSMnZM4rdzkOH0LWYEwY1EXPwVjPN"
X-Provags-ID: V03:K1:WLTud6bOWiwp/umu3HQvv+ugmIFbUHBqQ66l9KsP3C12hqhAxYt
 r8SZ2t4Alv0Rhz0cxadFU4Mr5W+7m/dI2Je7yuVPGGkypG2L6K9/snXJ1fUKgr8rKVvfj93
 wxFn0jvbRkxMWayUV9vgsqySSt9HpM23GjIA0Jr7Me5H+8UO2pa2uZ6ejqTg3bOJi0Pz7ib
 v26HBVAQHuTWYFx1TbNbA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:6uA8D6ysx8A=:VnzbIhvcrDLHLcSMwxqTcy
 tbaJwe0/9J4LMXojuhbjBXIMiW2/gI4nzVY8Y+nbp36cLzFKCJHeB9o7YpivKEa2rWXol0ln/
 jkS4wCSSqks9EO2HqEoWbc+1xC06pdrjgTWHkngcRTQswpzGjs8L07vVggbsGvITfJvB9xRXe
 s2diyAQYAfTGsO0CBChZZFWYrjexVIKh6lcsm2dO5zO7K9CpztpFbL6dl8hvCIatINGpuTNFx
 paTF9On5ZStp+SKkN5BYJ3EtVOpwnDPb1m/HYRaPaJ4RYFfpSAWQVa8WffDS73R30UsGtoISL
 NZBBQETwQ//L8ZLSj9YX9LixVnsaiyt410sLorhmWl7/sVHHw3yBf2BFCMBxHRtS+HPm8kcFz
 skAaQ73Hwnxv9YJNRtxy66N50WlCvpynrE/nfCRYKtDkuzKjz948sGiHKT8m8mtuU94nAHLWB
 kUKDcPKlXsFkSI8U2iTydYmXqK1krA8PXs1vPgfitLk0QrDaT6IPNHPrnzeu31wL14pp8ydIc
 R8+vygOQCBc2YApe4IiMxTX0HFz36wAwk1vCSxnYY33B137PKpk5kz7skv85+g9f4qddiqzd6
 +S7jWIPN84MxzLx1ywOXrYdyQJIkmSSjgH0g5/NH/QW4o9L/JoScONBP+CgE6pamj3YznVm3b
 p/SYOxRg1KffLZMjWziw0J80uZI7eXNP6Dm2a15Efd282d0Maq5lBp5uN9yw2TZW4gvZyXBYc
 1hsMEH9hb/Q+TGh2y1i9FOs2WJOjFpHWvjUllZfgi0zxK2bBCHpYkX1XFafuSzYEkg8YZSaP7
 nnLzX8YLEFNureMr5h3bjGirMji9dJn7pbbJkQV9M9KEZnO9Hiy1r+CbA/Z3SXEUhJZp37SNh
 LZFcFK8DH0k0NdNlTTwP80VldGwDpCO2TpLWNoIXQvpU9PjO+SgoankjxH7tVg
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BpqEQSMnZM4rdzkOH0LWYEwY1EXPwVjPN
Content-Type: multipart/mixed; boundary="YBgKPjpy71s0zS8TDl5BgzAuJGD47Teof";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Stephan Olbrich <stephanolbrich@gmx.de>, linux-btrfs@vger.kernel.org
Message-ID: <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
Subject: Re: bad tree block start, want 705757184 have 82362368
References: <1758973.r4I5FPff6i@chaos-desktop>
In-Reply-To: <1758973.r4I5FPff6i@chaos-desktop>

--YBgKPjpy71s0zS8TDl5BgzAuJGD47Teof
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/17 =E4=B8=8A=E5=8D=8812:17, Stephan Olbrich wrote:
> Hi,
>=20
> a few days ago my root file system (simple btrfs on a SSD, no RAID or a=
nything) suddenly became read only.=20
> Looking at dmsg, I found this:
>=20
> [   19.285020] BTRFS error (device sda2): bad tree block start, want 70=
5757184 have 82362368

Does this only occurs once?

If only once, are you using SINGLE metadata profile (default for SSD)?
If using DUP/RAID1 it may have a chance to recover.

> [   19.285042] BTRFS: error (device sda2) in __btrfs_free_extent:6804: =
errno=3D-5 IO failure

The problem is in extent tree.

If there is no other problem, your data should be OK.

You could still try to mount the fs RO to salvage data.

> [   19.285048] BTRFS info (device sda2): forced readonly
> [   19.285051] BTRFS: error (device sda2) in btrfs_run_delayed_refs:293=
4: errno=3D-5 IO failure
> [   19.287213] BTRFS error (device sda2): pending csums is 41889792
>=20
> Late on I got the same errors for my /home partition (on the same drive=
) as well.
> I have snapshots of all partitions on another drive made by btrbk. To g=
et a working system, I made new (rw) snapshots
> of the most recent backup and setup grub and fstab, so my system would =
boot from the other drive.
> Unfortunately now I got the "bad tree block start" error again at least=
 once in dmesg but I didn't save it and it's not in syslog :-(
> What I remember is, that it was followed by other btrfs error messages =
saying something about correcting something.
> And the filesystem was still read/write this time.
> At the moment I can't reproduce it.
>=20
> Is there any way to find out, which files are affected by the errors ab=
ove?

No files are affected, but an essential tree, extent tree, is corrupted.

Normally this may prevent RW mount, and even it mounts it can still
cause problem when doing any write.
It could even prevent RO mount if the corrupted leaf contains block
group item.

But your data should be OK if there is no other corruption, and in that
case btrfs-restore should work well.

> I don't really trust the data on the drive I'm using at the
> moment, as it has shown errors as well, but I have a less current backu=
p on yet another drive but at it is a few weeks old, I don't
> want to use it to setup the system on the SSD again, but just copy the =
relevant files if possible.
> Or is it possible to repair the original file system?

At least we need "btrfs check" output.

>=20
> Some information about my system:
> Kubuntu 18.04
> Kernel 4.19.1 when the problem occured, now 4.19.2
> btrfs-tools 4.15.1

And "btrfs check" should be executed using latest version.

Thanks,
Qu

>=20
> Regards,
> Stephan
>=20
>=20
>=20
>=20
>=20


--YBgKPjpy71s0zS8TDl5BgzAuJGD47Teof--

--BpqEQSMnZM4rdzkOH0LWYEwY1EXPwVjPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvvyzgACgkQwj2R86El
/qiK1wf/axpGEfxU7FgBgEfrpv1LbFhO3uiaBh+qKRtp+p5x2S8UMRiz/ZQMnStt
QIHbeN/wgECABK5M6B+hOUD9qv7Ax+1BL3yDNHqqzovJGA3HU61KIMf/qohYBmlg
Z2Y+5CUa8Ik1At648NFfjkVxYZq2N46vV/gUFV/sJeIx4asIF3/rXdKf4Pa7b855
S9m6Rx0Cseku0YrkJ1xJgySAJMXyjSnOSdrYlDxl1GTmOSO0ajlz30Tdbe5J1NQu
sPj5kGHWAN7oZfn8+Xwz5L6rVOFXDRTnPBgimANuGmhAjaGC2HljKrjSBWx5+i2q
sjSnC+Av3JnzBl5gB5KHv9NVg7Jh2g==
=J12m
-----END PGP SIGNATURE-----

--BpqEQSMnZM4rdzkOH0LWYEwY1EXPwVjPN--
