Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99F26D4E5
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779749856; cv=none; b=YSdjBcMuzqp3d5c7FEJXVvMMhB2z5315sRnYtoOJK/DrJbhusxL1e4dPH4Wuhe++OT+cKDR1vSNrmYPYhxsgjDlEoTs9EtdeCNz3cjvGskKCsh2nQLZmTzMTJPo52qCe9c04pLBhzW5NitGLfHvA9B8F7ajK8C+NMOrLGr2ynBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779749856; c=relaxed/simple;
	bh=f7JKPXhcpE30TluM91YEKW1CuFhEW/XnorhhiTR41Zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYep1hRFgLJjlwa2eDJYWltqzm7ojA3n6Hpo9G4CYXzd2YDvt6Fd77us+SKll5kKVNSu+FQxXL5qPx9Q/lxfhiyF1b2A4H1yrUXVSaJAll2BC2udkpNd9M0Suktks4SHqKpLtgkFmUYZowewn/eACSEQsllfuN/EYFwIHpIBeMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UBEATqcY; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UBEATqcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779749851; x=1780354651; i=quwenruo.btrfs@gmx.com;
	bh=DtBkm1KqaRLCdpnDZBA2+aGNwQrJVGGLF2MRQzFLl0c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UBEATqcYhFUq+TmztBCi+ji/TGjQczJxTt4/du+TXROFp8vAqDZJBRvMdTzCZ8rq
	 audW9W5/dhS1LVBk6wHOaGM9jhqN/dKcWTfa2WDd628MTx3n/JtpEqy1XD00F7qV5
	 22q5T2gUp7aboj9NddpE8SK6/gL7KuRSo3zYjplbW92Bk6VgH1oHb8nIHm4iCfaog
	 7lcUbjM7dXI7v7tin85gmyzuPYHhjrXtaxTdlr/6FtJw6jn3S9hogkL3BYKQs2Oji
	 x/CyzxejVfbXuIEycQMxvOOUyTuodRmmEC1xgfBSxdeO2qEo1DLbOXSyISzF+0IV/
	 hQjqvycRax0p9GyofA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MKsnF-1wkZ420RWX-00TBi5; Tue, 26
 May 2026 00:57:31 +0200
Message-ID: <cb30d23c-95b6-49f8-a885-cdf872a16adc@gmx.com>
Date: Tue, 26 May 2026 08:27:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: I Need help. can't open btrfs drive after power outage while
 copying files
To: Brian Thompson <brianbthompson@gmail.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <CADcHvwfwQJRHEK1YWx_R9npK-eUwkVCHyPtt5f8BvvpR+UwEMQ@mail.gmail.com>
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
In-Reply-To: <CADcHvwfwQJRHEK1YWx_R9npK-eUwkVCHyPtt5f8BvvpR+UwEMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nyJp7hiH8Fvg6NTjTtW73/Nsg+F5l0cSLuTbEn5kV1ALHApSadp
 xx8B/cjwYsSELMm15JRvKssfyOalteTe3pSpc6ABkyiwTD5u2z7rC7tP6p1DzNpTY/mLCU2
 OGJxUfEJg90YqD4nufN/13ls2ncYg0qyYJkV+BYeKSTOURCumtla8al6a58AZfS7/u74bPd
 ZIyA6H3NS5prSFd4PR6hw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ruyRelKV84A=;DHdIjGQWITHLdmDPLKsDJ81XjqY
 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



=E5=9C=A8 2026/5/26 08:15, Brian Thompson =E5=86=99=E9=81=93:
> Hi, thanks for replying so fast. yes, some writes didn't reach the
> disk. Again, I had paused the transfer of files and then i accidently
> cut the power to the drive... Whoops...

Sorry, I don't mean "data" writes, I mean "metadata" writes, which is=20
fully protected by barriers.

Normally a power loss should only lost what is not yet committed, but=20
the previous transaction should be perfectly fine.

All metadata are protected by COW, and after every metadata is written,=20
the super block is updated to point to the latest metadata.

But in your case, your super block is updated, but the metadata is not=20
fully written to disk.

>=20
> Anyway here is the dump-super
>=20
> superblock: bytenr=3D65536, device=3D/dev/sdc1
[...]
>=20
>         backup 3:
>                 backup_tree_root:       1064026112      gen: 568        =
level: 0
>                 backup_chunk_root:      27344896        gen: 568        =
level: 1
>                 backup_extent_root:     1063796736      gen: 568        =
level: 1
>                 backup_fs_root:         1063567360      gen: 568        =
level: 1
>                 backup_dev_root:        1063108608      gen: 568        =
level: 1
>                 csum_root:      1063600128      gen: 568        level: 2
>                 backup_total_bytes:     12000136527872
>                 backup_bytes_used:      632383324160
>                 backup_num_devices:     1
>=20
[...]
>=20
> =E2=9D=AF sudo btrfs check --readonly -r 1064026112  /dev/sdc1
> [sudo] password for brian:
> Opening filesystem to check...
> parent transid verify failed on 1064026112 wanted 569 found 568
> parent transid verify failed on 1064026112 wanted 569 found 568
> parent transid verify failed on 1064026112 wanted 569 found 568
> Ignoring transid failure
> Checking filesystem on /dev/sdc1
> UUID: 170f86c7-972d-4493-b13b-1046a34b5281
> [1/8] checking log skipped (none written)
> [2/8] checking root items
> [3/8] checking extents
> Chunk[256, 228, 637833052160]: length(1073741824),
> offset(637833052160), type(1) is not found in block group
> Chunk[256, 228, 637833052160] stripe[1, 637841440768] is not found in de=
v extent
> metadata level mismatch on [27344896, 16384]
> ref mismatch on [27344896 16384] extent item 1, found 0
> tree extent[27344896, 16384] root 3 has no tree block found
> incorrect global backref count on 27344896 found 1 wanted 0
> backpointer mismatch on [27344896 16384]
> owner ref check failed [27344896 16384]
> ref mismatch on [27361280 16384] extent item 1, found 0
> tree extent[27361280, 16384] root 3 has no tree block found
> incorrect global backref count on 27361280 found 1 wanted 0
> backpointer mismatch on [27361280 16384]
> owner ref check failed [27361280 16384]
> ref mismatch on [27377664 16384] extent item 1, found 0
> tree extent[27377664, 16384] root 3 has no tree block found
> incorrect global backref count on 27377664 found 1 wanted 0
> backpointer mismatch on [27377664 16384]
> owner ref check failed [27377664 16384]
> metadata level mismatch on [27394048, 16384]
> ref mismatch on [27394048 16384] extent item 0, found 1
> tree extent[27394048, 16384] root 3 has no backref item in extent tree
> backpointer mismatch on [27394048 16384]
> ref mismatch on [27410432 16384] extent item 0, found 1
> tree extent[27410432, 16384] root 3 has no backref item in extent tree
> backpointer mismatch on [27410432 16384]
> ref mismatch on [27426816 16384] extent item 0, found 1
> tree extent[27426816, 16384] root 3 has no backref item in extent tree
> backpointer mismatch on [27426816 16384]
> ERROR: errors found in extent allocation tree or chunk allocation
> [4/8] checking free space tree
> [5/8] checking fs roots
> [6/8] checking only csums items (without verifying data)
> [7/8] checking root refs
> [8/8] checking quota groups skipped (not enabled on this FS)
> ERROR: transid errors in file system
> found 632383373312 bytes used, error(s) found
> total csum bytes: 616936656
> total tree bytes: 640188416
> total fs tree bytes: 1736704
> total extent tree bytes: 4210688
> btree space waste bytes: 11417620
> file data blocks allocated: 631743135744
> referenced 631743098880
>=20
>=20
> Please let me know what I can try next. Thanks again
>=20

So far 1064026112 is the second newest working one, and it looks fine.

Please use that number for btrfs-restore.
In fact that looks everything is fine except the bad root tree block.

Thanks,
Qu

