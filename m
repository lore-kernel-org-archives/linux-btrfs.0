Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A773F0A9F
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 03:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780456762; cv=none; b=uPHGaFPQgApv/4oi5C4OxJRZ3VyN1s85Q5XSuL/68/Czwb4Lfld43QeXP/znmomf1+wWzHIlNFjXNcb3r9XueqULvgxttS6m093cVuu84mZxdlspotVOwDj5Mzworo5nZRMYH/28P/Irs2fzNNCLqIDZ+exqKzCY9Fp1LtxrCwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780456762; c=relaxed/simple;
	bh=Y5SqZQPgZtY7NbeconARk5AGOaoyqu7RRaSduzn4sYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NqFtW7djpTdWLBw4NcMKHc9vFtdpnEYwCvtpTwUQYWu7EDkeeoVjrG7G37FGJ/iFWsugEnEh0Rh/pxQ6ltxk8h2qvFdPnCilQ0H8+KdyerSjn1dORqyvLluMzmwOZ9hs4OYghQcDaO2EYrQen6GfkgeA1uBryMwS59yj5eHb7ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=o2MvGnHI; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="o2MvGnHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780456753; x=1781061553; i=quwenruo.btrfs@gmx.com;
	bh=gXjIrMRghTt7dYoN5eA8BbvPpKDFsSTwwYfY4JPtSds=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=o2MvGnHIB5p6mRf6OOCeusAem6sis/m8PVcWR91vw93mMF1jlAxWaUoRzX7D4YTe
	 rNKRAWJT7BoakLxbStG9GFCAsYMuA4SSAdhL17yXNzeVJWTZVgJF3jMGcKUDcgJeE
	 nsKoTLRRbxCKfn7uPVK0G7sS0oVQPxsslC4TuHk5N3U20boXgGYMpxk+6Z8kpYMxY
	 2Z9uW8VlFzQngEeGsKipw76+aW1HC30RkpiwFWrQC7T3ef6tp68K+J/K3PE+9FX6d
	 riqssOHSAQ8braeddZuL408eyVCq+DWXGAvGhRN0YT1PQje+q+OiF58AdO1xziNPw
	 5an3bnOh+3ZjJKoeSA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MGhyS-1wYU0R0Aja-00CGpG; Wed, 03
 Jun 2026 05:19:13 +0200
Message-ID: <9bbb5862-1d6c-4980-8979-a4cf635bf642@gmx.com>
Date: Wed, 3 Jun 2026 12:49:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
 <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
 <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
 <abdefca9-5e72-4f63-bc7d-958b9ec50468@gmx.com>
 <F839ACDA-E61B-4E38-8188-9D431C3D669E@bluemole.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <F839ACDA-E61B-4E38-8188-9D431C3D669E@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JUP///0vbn8bC0Jx8EdIzdKvZBGi12b8NHfidYcSPRsizy61cVz
 jYcJFxq9hVjT00okB6VJP+x6uAPcY6T3zpKL400JABz22zeMFMUmdTJPu8+ZJBB9sr7ZU8W
 6bK6oCGuRtYExiM1+VhRf9FW+/mLu7n9Qcci6A+DsQAr1P5cTOesrYuHF6dzgLcsBAmWJJV
 JaVwx72QnI7qqpC067xsw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kYHagRGI5lA=;6hIiqih9g7yCEefJcaSZlgSQzCa
 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



=E5=9C=A8 2026/6/3 09:38, Michael Zacherl =E5=86=99=E9=81=93:
> On 01.06.2026, at 00:48, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> In theory, as long as the ssd/firmware/controller properly respect FUA/=
FLUSH commands, it should not cause any corruption.
>> But we live in the real world, sometimes bugs can sneak in between (and=
 include) btrfs and lower storage stack.
>=20
> I read multiple statements claiming =E2=80=98some=E2=80=99 nvme units ha=
ve a =E2=80=98weak=E2=80=99 power management consequently causing problems=
.
> Since this is the only mobile unit with an exchangeable mass storage dev=
ice I can=E2=80=99t really speak of experience.
>=20
>=20
> I switched back to using the laptop, renamed /etc/gai.conf to keep the b=
roken file and reinstalled glibc.
> Later I initiated a scrub:
>=20
> $ sudo btrfs scrub start -B /
> Starting scrub on devid 1
> scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
> Scrub started:    Tue Jun  2 11:42:55 2026
> Status:           finished
> Duration:         0:20:44
> Total to scrub:   891.70GiB
> Rate:             734.01MiB/s
> Error summary:    csum=3D1
>    Corrected:      0
>    Uncorrectable:  1
>    Unverified:     0
> ERROR: there are 1 uncorrectable errors
>=20
> Before, while being booted from the live-iso the other day, there was th=
is one unresolvable logical 20316160.
>=20
> [35844.925130] BTRFS info (device dm-0): scrub: started on devid 1
> [35844.970219] BTRFS error (device dm-0): scrub: unable to fixup (regula=
r) error at logical 20316160 on dev /dev/mapper/lukspart physical 20316160
> [35844.973565] BTRFS warning (device dm-0): scrub: checksum error at log=
ical 20316160 on dev /dev/mapper/lukspart, physical 20316160 root 256 inod=
e 20372640 offset 0 length 4096 links 1 (path: usr/include/clang/AST/Exter=
nalASTMerger.h)
> [35844.973606] BTRFS error (device dm-0): bdev /dev/mapper/lukspart errs=
: wr 0, rd 0, flush 0, corrupt 5342, gen 0
> [35884.964320] BTRFS warning (device dm-0): scrub: skipping scrub of blo=
ck group 26873954304 due to active swapfile

BTW, swapfile on btrfs is not really recommended.

It causes quite some burden for things like balance, and scrub.
It doesn't only mean the swapfile itself can not be balanced/scrubbed,=20
but also anything else inside the same block group.

This means even a very small swapfile can prevents tons of block groups=20
from being scrubbed/balanced, which are all very important for btrfs=20
maintenance.
> < .. snip .. >
> [35884.964461] BTRFS warning (device dm-0): scrub: skipping scrub of blo=
ck group 48348790784 due to active swapfile
> [37088.403196] BTRFS info (device dm-0): scrub: finished on devid 1 with=
 status: 0
>=20
> Despite it being shown in the log anyway, I tried and I now could perfor=
m a
> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /
> which revealed the file as
> //usr/include/clang/AST/ExternalASTMerger.h
>=20
> This didn=E2=80=99t work when the system was booted from the iso:
>=20
>> On 31.05.2026, at 02:13, Michael Zacherl <ubu@bluemole.com> wrote:
>>
>> I did
>> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt
>> which returned
>> ERROR: logical ino ioctl: No such file or directory
>=20
>=20
> I was getting I/O errors when doing a cat on this file and I can=E2=80=
=99t see while my na=C3=AFve search using cat didn=E2=80=99t reveal this c=
orrupt file the other day?
>=20
> Also, the broken gai.conf file still doesn=E2=80=99t show up in the scru=
b log. Not sure if it should?

It should, but I guess there is some bug in backref code.
Will take a look when there is spare time.

>=20
> So back to square one and testing from the live-iso, rw-mounted the fs o=
n /mnt .
>=20
> A scrub shows the same error and the filename but the file checks out fi=
ne!
> I now can view it (cat) without errors!   What=E2=80=99s going on?
>=20
> A new scrub didn=E2=80=99t show anything different than being booted fro=
m this fs before:
>=20
> Jun 02 13:38:07 EndeavourOS kernel: BTRFS info (device dm-0): scrub: sta=
rted on devid 1
> Jun 02 13:38:07 EndeavourOS kernel: BTRFS error (device dm-0): scrub: un=
able to fixup (regular) error at logical 20316160 on dev /dev/mapper/crypt=
root physical 20316160
> Jun 02 13:38:07 EndeavourOS kernel: BTRFS warning (device dm-0): scrub: =
checksum error at logical 20316160 on dev /dev/mapper/cryptroot, physical =
20316160 root 256 inode 20372640 offset 0 length 4096 links 1 (path: usr/i=
nclude/clang/AST/ExternalASTMerger.h)
> Jun 02 13:38:07 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5345, gen 0
> Jun 02 13:48:41 EndeavourOS kernel: BTRFS info (device dm-0): scrub: fin=
ished on devid 1 with status: 0
> Jun 02 13:50:06 EndeavourOS kernel: BTRFS warning (device dm-0): csum fa=
iled root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 =
mirror 1
> Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5346, gen 0
> Jun 02 13:50:06 EndeavourOS kernel: BTRFS warning (device dm-0): csum fa=
iled root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 =
mirror 1
> Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5347, gen 0
>=20
> Curiously enough after being back, booted from this fs, the ExternalASTM=
erger.h file looked fine! No more I/O error!

Maybe even LUKS is involved?

Unfortunately with another layer involved, it's not any easier to pin=20
down exactly the problem is.

So for now, my only recommendations are:

- Disable swapfile on btrfs
   Using a dedicated partition is always a better/simpler solution

- Delete any files reported by scrub
   And since most of them are managed by package manager, just
   reinstalling the package should restore the file.

- Keep an eye on the routine scrub result
   To see if the errors suddenly change.

Thanks,
Qu

>=20
> I can=E2=80=99t see any difference other than Kernel versions?
> Then again on the iso the kernel is newer (6.19.14-arch1-1) than the its=
 I=E2=80=99m running usually (6.19.14-arch1-1), so what gives?
>=20
> Meanwhile I=E2=80=99m not sure if I=E2=80=99m reading too much into this=
 details?
>=20
> Thanks a lot, Michael.
>=20
>=20
>=20
>=20
>=20

