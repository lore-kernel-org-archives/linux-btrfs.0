Return-Path: <SRS0=WB35=N5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B059DC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 00:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F6620685
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 00:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40F6620685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbeKRKsv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Nov 2018 05:48:51 -0500
Received: from mout.gmx.net ([212.227.15.18]:40659 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725734AbeKRKsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Nov 2018 05:48:51 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lp3x6-1flWlq18Qm-00esRO; Sun, 18
 Nov 2018 01:30:19 +0100
Subject: Re: bad tree block start, want 705757184 have 82362368
To:     Stephan Olbrich <stephanolbrich@gmx.de>,
        linux-btrfs@vger.kernel.org
References: <1758973.r4I5FPff6i@chaos-desktop>
 <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
 <3061596.RPKkM7PgOY@chaos-desktop>
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
Message-ID: <e65c8b2a-e337-6c9c-6fbc-839d810353df@gmx.com>
Date:   Sun, 18 Nov 2018 08:30:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <3061596.RPKkM7PgOY@chaos-desktop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YfGD05adEaHsKgiCX3hfKyE7LL2HUKCYq"
X-Provags-ID: V03:K1:+IcSkF/YUPDX83etOJeUYB/nkuLGvZ1hTNZfBfHQns7ibIpUqs/
 Zi8sdGRsHb6qbNa2G0Oij5f7NdWwT0yJgd+rk1r7qV2x5NtTq4PnMerO7W/Rrg/Pn6/g6A7
 EjywdyCGrMg2SpRWvrYANj9Vej3yeonCS3LEQ3ympdPOlHzWcPPKipYMc1tpp1MW19rzw/3
 5+7NgVmdOYBWHvrHsoKQg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:6brnRZQllq4=:tV1r9tkBdGgRR3j+I1m8Xe
 BwHM/cNiGBAAv2DQ5ptQzTlZUIixfNrz/pS8J1LlWJbOmSnDjgD7CKR1ZTvcbBAaQDtjKKRz/
 1HgNzArMDMLKYpClSot5f8aPmgti/rqIeBsunVdTAisct9Vj4p6Rz4Gi6gcw3mSE+W3E8UGkp
 g8TIVI9EQ31Yy+eM2BOsLE+10stA+a0B10ps0TFktbYnX4C5jhJggtsgsbmJzOqbOjwFq8Gbr
 yeqkl6M0nqarDnF/hA/zOXEg9IgWbnp7u3bVM7Gvl5k2UPdi496ZA0hTm10vKvLv917Ulsc/B
 MqT+XlZojFxPlwfz7t7DuBkZlq1sAS1DVEmGThFBecCA7uRsUlg0Ep1OQKFxxOMdR2eDQvwRl
 YxMEIOGzB4ZEWCKGC5dCck4qfp5Hu0iQlqZmXV2TChQYctn0TBRs8RMMOBKdq7r7fxm9W33Xq
 yGL4Bn9PmJnYUkaeJEdYmKLec5KCqYxjo47f1ItIlPhvkUMQxXyNhpHiiIXVszB+wF6h3Jb2h
 zlyt2hdTDTGqzNHpps1dYLCABLcmscHJup9nwBhw2/Bv30GopAnEsBbGggRDTSjV1xY+MFu0h
 338cE8LSvxNWzSSyLGDBhN1C0on1ZvF3GA731wmLEiszomnctkNdbU/etEjTzLhodxMQPszX+
 Yas2+z5PAnUTr4Gi+cOpXpqLOuWp+LHFJ9bHK5hBgst6MOlVnwsZt375FryZUhAvjM0tX+ATR
 +UKUKPkVKhGygJLgXVCNlBsQ1j+8rYktWWlKA6ZTkWYnmv/MnASLEl1KINiPUxQHwxELZrmSQ
 TSZjqNQ6leDBcNODXepAYbW5ReL+anVrdpDUV+4P6ENJ1FStzZrB5M12Boj8rFxpu+VVBPk9K
 wTkYJx1err1AEG0qlH2CPKH2mL8xg/9KeEvsAteYbXqBRPo3BPJf5QpY02g+QD
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YfGD05adEaHsKgiCX3hfKyE7LL2HUKCYq
Content-Type: multipart/mixed; boundary="ct5TEvKdpubuE9qRT5TIU5CozQmGrInX7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Stephan Olbrich <stephanolbrich@gmx.de>, linux-btrfs@vger.kernel.org
Message-ID: <e65c8b2a-e337-6c9c-6fbc-839d810353df@gmx.com>
Subject: Re: bad tree block start, want 705757184 have 82362368
References: <1758973.r4I5FPff6i@chaos-desktop>
 <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
 <3061596.RPKkM7PgOY@chaos-desktop>
In-Reply-To: <3061596.RPKkM7PgOY@chaos-desktop>

--ct5TEvKdpubuE9qRT5TIU5CozQmGrInX7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/18 =E4=B8=8A=E5=8D=884:28, Stephan Olbrich wrote:
> Am Samstag, 17. November 2018, 09:03:04 CET schrieb Qu Wenruo:
>> On 2018/11/17 =E4=B8=8A=E5=8D=8812:17, Stephan Olbrich wrote:
>>> Hi,
>>>
>>> a few days ago my root file system (simple btrfs on a SSD, no RAID or=

>>> anything) suddenly became read only. Looking at dmsg, I found this:
>>>
>>> [   19.285020] BTRFS error (device sda2): bad tree block start, want
>>> 705757184 have 82362368
>> Does this only occurs once?
>>
>> If only once, are you using SINGLE metadata profile (default for SSD)?=

>> If using DUP/RAID1 it may have a chance to recover.
> It shows up once after reboot for each partition.
> I'm using SINGLE metadata.
>=20
>>
>>> [   19.285042] BTRFS: error (device sda2) in __btrfs_free_extent:6804=
:
>>> errno=3D-5 IO failure
>> The problem is in extent tree.
>=20
> I checked my logs again, the __btrfs_free_extent error is missing for t=
he /home partition:
>=20
> [ 3154.066544] BTRFS error (device sda4): bad tree block start, want 56=
0119808 have 4330389667183373366
> [ 3154.066558] BTRFS: error (device sda4) in btrfs_run_delayed_refs:293=
4: errno=3D-5 IO failure
> [ 3154.066561] BTRFS info (device sda4): forced readonly
> [ 3154.066904] BTRFS error (device sda4): pending csums is 360448
>=20
>>
>> If there is no other problem, your data should be OK.
>>
>> You could still try to mount the fs RO to salvage data.
>=20
> I'm not so much worried about salvaging data, as I have a current backu=
p. I'm more worried=20
> how reliable the backup is, as I'm not sure, when the errors first star=
ted. But if the data is
> OK, then the backup (snapshots on another drive) should be OK as well I=
 guess.
>=20
>>> [   19.285048] BTRFS info (device sda2): forced readonly
>>> [   19.285051] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2=
934:
>>> errno=3D-5 IO failure [   19.287213] BTRFS error (device sda2): pendi=
ng
>>> csums is 41889792

Still extent tree.

>>>
>>> Late on I got the same errors for my /home partition (on the same dri=
ve)
>>> as well. I have snapshots of all partitions on another drive made by
>>> btrbk. To get a working system, I made new (rw) snapshots of the most=

>>> recent backup and setup grub and fstab, so my system would boot from =
the
>>> other drive. Unfortunately now I got the "bad tree block start" error=

>>> again at least once in dmesg but I didn't save it and it's not in sys=
log
>>> :-( What I remember is, that it was followed by other btrfs error
>>> messages saying something about correcting something. And the filesys=
tem
>>> was still read/write this time.
>>> At the moment I can't reproduce it.
>>>
>>> Is there any way to find out, which files are affected by the errors
>>> above?
>>
>> No files are affected, but an essential tree, extent tree, is corrupte=
d.
>>
>> Normally this may prevent RW mount, and even it mounts it can still
>> cause problem when doing any write.
>> It could even prevent RO mount if the corrupted leaf contains block
>> group item.
>>
>> But your data should be OK if there is no other corruption, and in tha=
t
>> case btrfs-restore should work well.
>>
>>> I don't really trust the data on the drive I'm using at the
>>> moment, as it has shown errors as well, but I have a less current bac=
kup
>>> on yet another drive but at it is a few weeks old, I don't want to us=
e it
>>> to setup the system on the SSD again, but just copy the relevant file=
s if
>>> possible. Or is it possible to repair the original file system?
>>
>> At least we need "btrfs check" output.
> I updated btrfs-progs and run btrfs check for / and /home
> No errors are found on / (sda2), but there are errors on /home ??
>=20
> $ btrfs --version
> btrfs-progs v4.19
>=20
> $ btrfs check /dev/sda2
> Opening filesystem to check...
> Checking filesystem on /dev/sda2
> UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> [5/7] checking only csums items (without verifying data)
> [6/7] checking root refs
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 64816218112 bytes used, no error found
> total csum bytes: 59518732
> total tree bytes: 2180268032
> total fs tree bytes: 1965965312
> total extent tree bytes: 123289600
> btree space waste bytes: 478665777
> file data blocks allocated: 151083261952
>  referenced 76879990784

This fs is completely fine, including your data.

>=20
> $ btrfs check /dev/sda4
> Opening filesystem to check...
> Checking filesystem on /dev/sda4
> UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> root 257 inode 7970563 errors 100, file extent discount
> Found file extent holes:
>         start: 0, len: 20480
> root 257 inode 7970564 errors 100, file extent discount
> Found file extent holes:
>         start: 0, len: 77824
> ERROR: errors found in fs roots

These are just minor errors, won't even causing any data mismatch.

So all your fses should be mostly OK.

Would you please try to use v4.19-rc* to see if it changes anything?

Thanks,
Qu

> found 303386652672 bytes used, error(s) found
> total csum bytes: 289501272
> total tree bytes: 2336227328
> total fs tree bytes: 1766473728
> total extent tree bytes: 202014720
> btree space waste bytes: 519245278
> file data blocks allocated: 6851730792448
>  referenced 533348069376
>=20
> Thanks,
> Stephan
>=20
>>
>>> Some information about my system:
>>> Kubuntu 18.04
>>> Kernel 4.19.1 when the problem occured, now 4.19.2
>>> btrfs-tools 4.15.1
>>
>> And "btrfs check" should be executed using latest version.
>>
>> Thanks,
>> Qu
>>
>>> Regards,
>>> Stephan
>=20
>=20
>=20
>=20


--ct5TEvKdpubuE9qRT5TIU5CozQmGrInX7--

--YfGD05adEaHsKgiCX3hfKyE7LL2HUKCYq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvwspcACgkQwj2R86El
/qjIuAf/QWQ0WVWZQIYqOmiQRyRQOlma882BVaG0ighSLdPFTsiGyA+PlecQPiFW
sbYDWsHTCLcWWF0mUY+3qEZEL9/HHNr8BQxAD1dgRqIJWRnasrMWVXY2ICYJgD+L
4asY/wpCueNP/E5TnFZOqlX2oUGswi1XU0iAhI5gLlIc7Z4ZhMUzOzE3WHPr0AYS
fEkEVEKMdAnw73aog9Tn2VR9RqZklNQ50Dlwrot8DYHSV/vU0PG1u0v81gIR3AN+
BMEDAzXH7r13otUbjMgkJNu6bhz9RdB7Bo/UVbAiWX0l9PFLAyNgBaHr3FwUuMjv
/53Gcwu7ChTs04Ese1jvhBceC6QPjw==
=XsS1
-----END PGP SIGNATURE-----

--YfGD05adEaHsKgiCX3hfKyE7LL2HUKCYq--
