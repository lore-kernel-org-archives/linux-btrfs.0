Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA05AC6786F
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 00:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3092081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 00:03:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A3092081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbeJaI7a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 04:59:30 -0400
Received: from mout.gmx.net ([212.227.15.18]:50469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbeJaI73 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 04:59:29 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrvBu-1fYs5S16is-013fdK; Wed, 31
 Oct 2018 01:03:49 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrvBu-1fYs5S16is-013fdK; Wed, 31
 Oct 2018 01:03:49 +0100
Subject: Re: Salvage files from broken btrfs
To:     Mirko Klingmann <m.klingmann@gmx.de>, linux-btrfs@vger.kernel.org
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
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
Message-ID: <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
Date:   Wed, 31 Oct 2018 08:03:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xn8yf19lMSVfRPENLqmy7vJZX6RhycP24"
X-Provags-ID: V03:K1:owL7gYkTmsfZC6plg/2cgLhBFn+cSXHRQfhckxCjVZXT55o1d1g
 lxbGjq1yIwsdxG/k6LvLKhREBnza4gx5NOMN9ae31HbnVi6WrNraw6JZy6Eh9Wu+SmeKF/A
 FTupNfQc28aS99ngT2w3SwDL+SOe+fy8w8WmgEn62QrMOcW2wsp9LEyYFRkivpLmr7b5AIb
 vHhFnzrjzLZI7urTRlQUQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:7qnbA0liXRU=:CegVJkB9+gEFELqJufBB8n
 Sjzh11ylJUzhQMYTiulOIUrfzVX7b2sNX7Sdyw6rlFds4jtEb4dWTN7lz/SwjaDTV9AjPqsUP
 VOuQ0DoyAzuZcvl47QsUznzEHroUNMT3xXVy4dMkCKtVqq3oscptorXyRRKpqpC5clbUJ9dqg
 JDbsA+vD4oMSqVPsAO6wpEhrW4llGaJGGAsUgprx0a0Eli6q2mccOFQATxlftitF3kYNk7dmA
 en8xbjsTu4vKPpXDhd/R/k4SFRQXyLeLLFDyGTpIx76sqO1v9DA4DhDv+7Gto2VRXAgOfIOw5
 SqTJrkCh7eGbvsmDTPW+UaIfjHvrOgYAm9tu4WWY9LFWf5J8t1QM0CQQGSeOrvifWuwgsnJRa
 CybFnnFsygxXf2+NqBXAZon3KllODu+XEls0lzaV752oJS48S77BeFt2BHhYAfZIbfsvD0sRX
 TP/D76fqvJoSwCxK7r1nA0ZBBacMhcSwGhXuAybL4YyJny9r/i4WyweQAiuUddhDbYrtqFhN6
 132oGanH+PRYikPz3Ihn+fo1yHjhzDyVoAUhM5azqlixvsm5hFnYKvMAmoBngLyvqEw4sCcKq
 SuV8MutOYrFrt83hfrW//RI3I0MVpmkBPYjnVlKZOH2bVMn3+tZiGzup4QXp57Lb4XwRdQ8aV
 109MqrTxdniDmpUjmrAYIM0dE3GSJIaNnCKJ+iO2in/iR+T4MmFgCIFaNqGqpRss1y9GsdfOx
 fiA4ZortoZqyKiyaqsDST1sLBptW+whB6I9vmal3arCX95QSXUnnKXe7vutNWWmLKxF/KKWna
 PDk+sj+xBhWp+hS/Kv2ckx1sU9HzestKW/b45iwXl39aNhIZaiuz+jLExb0nPX6Gr49bjpIGM
 9p8rVCuPZFul0Qr2D4ZvC9f7s/rBV+6uHOTuUD+BbCxK+xw+rBQoz3C9UZ7Jjs
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xn8yf19lMSVfRPENLqmy7vJZX6RhycP24
Content-Type: multipart/mixed; boundary="VrrFrPuKRYnLsX0EUruzYrsgFRjiwB1H4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mirko Klingmann <m.klingmann@gmx.de>, linux-btrfs@vger.kernel.org
Message-ID: <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
Subject: Re: Salvage files from broken btrfs
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
In-Reply-To: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>

--VrrFrPuKRYnLsX0EUruzYrsgFRjiwB1H4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/31 =E4=B8=8A=E5=8D=884:11, Mirko Klingmann wrote:
> Hi all,
>=20
> my btrfs root file system on a SD card broke down and did not mount any=
more.
>=20
> In retrospective, I think it reached its endurance, so I know that ther=
e
> is nothing to repair. All I want to do is to salvage some configuration=

> and data files from the remains left in my ISO file copy. The SD card i=
s
> no longer readable, so all I have is the 30GB "dd" copy of the btrfs
> partition.
>=20
> I also tried some things on the ISO file I later found I shouldn't have=

> done with the "btrfs" tools, which I think broke the file system in it
> even more.

Not exactly.

For your case, your best friend would be btrfs-restore + some way to
recover chunk tree.
Unless you want to do all salvage manually.

>=20
> So at this stage, this is the "dmesg" output when trying to mount the
> ISO file, which then fails:
>=20
> [=C2=A0 249.239883] BTRFS: device fsid 4235aa4f-7721-4e73-97f0-7fe0e9a3=
ce9c
> devid 1 transid 1757933 /dev/loop2
> [=C2=A0 249.241504] BTRFS info (device loop2): disk space caching is en=
abled
> [=C2=A0 249.275950] BTRFS error (device loop2): bad tree block start 0 =
20987904
> [=C2=A0 249.280936] BTRFS error (device loop2): bad tree block start 0 =
20987904
> [=C2=A0 249.280946] BTRFS error (device loop2): failed to read chunk ro=
ot
> [=C2=A0 249.336291] BTRFS error (device loop2): open_ctree failed
>=20
> Output of "uname -a":
>=20
> Linux desinfect 4.13.0-39-generic #44~16.04.1-Ubuntu SMP Thu Apr 5
> 16:43:10 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Output of "btrfs --version":
>=20
> btrfs-progs v4.4
>=20
> When reading the ISO file with "Active@ Disk Editor" (a hex file editor=
)
> I find a super block at offset 0x10000 that looks like this:

That's the primary super block.

BTW, you could use just 'grep' to locate btrfs superblock:

  # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" <device>

It's better to use "btrfs ins dump-super -fFa" to show the superblock
info in a human readable way.
>=20
> B8E15DD7000000000000000000000000000000000000000000000000000000004235AA4=
F77214E7397F07FE0E9A3CE9C000001000000000001000000000000005F42485266535F4D=
EDD21A00000000000040FF3400000000004040010000000000000E3500000000000000000=
00000000000E02307000000006092F1030000000600000000000000010000000000000000=
100000004000000040000000100000E2000000A6380E00000000000000000000000000000=
00000000000006100000000000000000000000001000000000000000000E0230700000000=
00E0230700000000100000001000000010000000000000000000000000000000000000000=
000000000000000000000000090185CF6B93749BBB19191D08677EE224235AA4F77214E73=
97F07FE0E9A3CE9C
>=20
> The super block at offset 0x4000000 is zeroed out.
>=20
> When looking at the addresses of chunk root (0x1404000), root of tree
> root (0x34FF4000) and log tree root (0x350E0000) in the first super
> block they are all zeroed out as well. So I think I understand why the
> error "failed to read chunk root" crops up.

Not a big problem really.

We can still find the chunk root just using the system chunk array (and
some time) easily, since normally system chunks are small and we can
afford checking all tree blocks in that range.

That's why I'm recommended to use "btrfs ins dump-super" to inspect the
superblock, as that allow us to inspect system chunk array.

IIRC btrfs-find-root is pretty good at such job, if that works.


>=20
> If I try to "restore" using "btrfs restore sdcard.iso /outdir" I get
> this output:
>=20
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=3D20987904, have=3D0
> Couldn't read chunk root
> Could not open root, trying backup super
> No valid Btrfs found on sdcard.iso
> Could not open root, trying backup super
> Superblock bytenr is larger than device size
> Could not open root, trying backup super

My plan for such recovery is:

1) btrfs ins dump-super to make sure system chunk array is valid
2) btrfs-find-root to find any valid chunk tree blocks
3) pass that chunk tree bytenr to btrfs-restore
   Unfortunately, btrfs-restore doesn't support specifying chunk root
   yet. But it's pretty easy to add such support.

So, please provide the "btrfs ins dump-super -Ffa" output to start with.

>=20
> And, finally, I can see "/etc" someplace near "fstab" in the ISO which
> looks like a directory listing as well as content of files I remember,
> which tells me, that the data I still in there somewhere.
>=20
> So, what can I do to get the files I need out of this blob. I am willin=
g
> to follow data pointers as described in
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format in the hex edito=
r
> and copy the data from there.

If there is something that a hex editor is really needed, it means we
should add a new function in btrfs-progs. :)

Thanks,
Qu

>=20
> Can anyone give me any pointers into the ISO file (maybe starting from
> the super block) to help me extract the data I need?
>=20
> Cheers,
>=20
> Mirko
>=20
>=20


--VrrFrPuKRYnLsX0EUruzYrsgFRjiwB1H4--

--xn8yf19lMSVfRPENLqmy7vJZX6RhycP24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvY8WEACgkQwj2R86El
/qhBpAf/dbB9Oewh9sNJfOzUSatbdgHEqPB4DtGVUQG2htNVbIgWCfRczBamRTyN
cCZPkb8+LB7akkUkKPlEfFHx7/vaCuOWbZMqnDaQnySfZ6oP12d002rSdgs/Hjus
lHa6BY12rlbjOrhWDY9K1lpyIYcmSxyLMlbn/bmTOapm4mQpBLa4lejBd08bA/CA
BS1DFxaOqw5pgy//e8GXoihw+fLi3CEYjqd+bsQIpXzYp9tgbeNsLvkr9nZqcqkl
WynWKN5JpaQeON7dG2iFZLZwmLi7upPLc6lcgMUg0AvNjnm7LGWHwJczOBxrg1xV
eTH9oGV8jB4UMYV8KLvlygThAUVqlw==
=zCe9
-----END PGP SIGNATURE-----

--xn8yf19lMSVfRPENLqmy7vJZX6RhycP24--
