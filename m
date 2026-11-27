Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795811444;
	b=M+6fAy0reii7i9mVKg55hftOERrPNTqecWtYYbxauWS943MB4JJ6j5BI9AW+PrI6XWH4
	 EpWTbQ3hFBQcxozRitZyigchmxGjsjJ+gE0qUH6LFOt6GFjnRnZRuKBL3OYg2vcF2UVO1
	 xzvaJ3W9w39h57afUq4wHKIMHRZpZ3mBqSBjMvinSdE799okXL3uLV2IcwY/byrSF+I/V
	 AN5kfDNqYpGMs2EQSnv7RhcjakUOzQbqBJOJ6a8VTaKubJaHJIqLo5ErwDF/PRq0BWqto
	 kmUR6IWoHQx6iYOApOuOu7kgYs2GY+PZwjVSSRsNdYzYHMTKNpfkLbGjT7pf0M/R8LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795811444;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=QvGi1roCwsOwAulRgkDrJWg1h3sRB1IEX46BbTwobyI=;
	b=Q4OrxBrDAP5QRmGyHFWv+luWvOmg9oxjavSABQ43ZSd5fjl+wFwtUcHtRlyq6DVY9f8e
	 +4Ib3sewzqYO7Z7PAgA8dGMty6Ie590bB62XCITmmbseu7DVUCu5DoiKHR9lTNz7pLcfK
	 1VYH6Z9C5rTGxLFfBQy7MUkL9XsGq29N+sbdxQUbBQN6yFXX3oNZ+DUg8K893NQ4nBIcv
	 h5xvpt5FZes5oC0cTYc+l8wJegLE9cjFVA2c66vItUuCGCc56lvdXVmPPA+hXRNuNpAsb
	 b6n3fbPVh7l0NaZ4h7ul7rZ+96A6jGK7bYEgeiZfLsYQ6XHmyP9KCAZSYvLrjAZu7dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=AK1YUoAO;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAAB606A329
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 20:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EAAB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=AK1YUoAO
DKIM2-Signature:  i=1; m=1; t=1795811441;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:AsrePduNM6ObAeyHtc6ATq0efl08
   V412vCqzhn0ZgmjGaMTzjJrFTGG1aWGFY8ysBbyDUCQLLnV2kOFpqkpVLeEWw1Oxon9Fp8JBdXT
   iOcDlYTfpHvZW+Ngq6IiUUTB5TwrYfulytkrR/+3/OAhqpZZvTpMOH0Uf7DN00A0xybIiMnPSPE
   elQWfn0Eb8O0qlYYipc6NDf/TVKjrXrNDSat7FsxIx/C0Kz7Hu0nFUyUuJS2nzqQYeYJQyVnkJv
   MOclcpMfi3g5mS5T5UZKycYwZ5yT0Y4MDvkoOHVBW14LKzWy+kMqDKvla2anjocGweeRkBBpJg2
   Z0gIc+g1wKki6w==;
Message-Instance:  m=1;
 h=sha256:
   xNXWHajh/J3qW7pU9tm375lcQGGw89WwjYQ8BdqCTig=:
   FJ++gcsypbeUFt7/6qba7kn1FjCxwVM1aisguus1qN0=,
  sha512:
   5W0Hp/cQYesWt2QpyfBI1P5Gadv1b1lnLLme+sDk/vTP6SaoFE9QYLN1Lsr5EzDI5oPewnagYM57v06X8xbpjA==:
   HHY+2uHuXNXVnP7IlUmWJ21HkQJ0W2F31buUSfXkWwF3WRda5NpsbXdsyTzKC+ZrcBrq298tMIfv/W5oel5uOg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795811425; x=1796416225; i=quwenruo.btrfs@gmx.com;
	bh=QvGi1roCwsOwAulRgkDrJWg1h3sRB1IEX46BbTwobyI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=AK1YUoAOOH3Lt3QZWq2qb3qrufameXEVeHCdlnVtmmZcDVA/vNL1QDPbMd8kp2Me
	 fjoeAjPCXKjYhtmwL9ODZJjHBuCaCkRNuWZ2c8nI/CQtH8rWvOwHTx3CeZzLleWq9
	 UzbQAXuQMB30SY3z9a35bVGDLEvN4FjSKZQupPK3vKwvIMIex6rhp97BbN0ALl1it
	 lUWylwn4WqsnDPYZ60NioaJbkzzVFz3DBvouCpn8WskplPJVGDpNdhMLcf8fIwtM4
	 lACFoEgnznEDb8ymzNyAuWjVWyI1ZlyPv5uwoVphEyxPjTF4sH2Nqxg9mzhbhA/7c
	 srKrmWxN2UCmw6jZLg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MnJhU-1yFyFA42eC-00qGZo; Fri, 27
 Nov 2026 21:30:25 +0100
Message-ID: <f08871d9-4d6b-480c-bfb6-7844b3d4cba7@gmx.com>
Date: Sat, 28 Nov 2026 07:00:22 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject rename exchange operations with subvolume
 stubs
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <db82ae780edd7572f150da6b25f2fb73af1e31a9.1795798503.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <db82ae780edd7572f150da6b25f2fb73af1e31a9.1795798503.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JgFnzdtaBMHKyowRR1JdOVDOVtA+K/Hw1IqzscasMxHdmpcFPVY
 ierg9QD0RknRkSCV0BtCVDulhJjefaD28ii+pq4ZwoGTBnbxrsUj1RW9vSByq2R26LUaEzI
 wD4fAeh89QNFsseSt/r3KJ34x0/oEpZ54R/TnRiC8NvYPV8tSkfoNKuSLoRtxgslt+yNHK+
 36Akkhp4LufzvMC0Nvnqg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ClN0j0T988g=;2rMLG/yfr76dOkGbO5rHpNK5Xal
 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
 CjfcUfPf5gPqyJy/V/w==



=E5=9C=A8 2026/11/28 03:41, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Currently we are allowing rename exchange operations when one of the pat=
hs
> points to a subvolume stub (created with new_simple_dir(), due to creati=
ng
> a snapshot of a subvolume that has subvolumes inside it). This results i=
n
> a transaction abort, turning the filesystem into RO mode, since the stub=
s
> are mockup dentries that have no underlying inode, so attempting to sear=
ch
> and delete inode ref items fails during the rename exchange, leading to =
a
> transaction abort with -ENOENT:
>=20
>    $ cat test.sh
>    #!/bin/bash
>=20
>    DEV=3D/dev/sdi
>    MNT=3D/mnt/sdi
>=20
>    mkfs.btrfs -f $DEV
>    mount $DEV $MNT
>=20
>    btrfs subvolume create $MNT/subvol
>    btrfs subvolume create $MNT/subvol/inner_subvol
>=20
>    touch $MNT/subvol/file
>=20
>    btrfs subvolume snapshot $MNT/subvol $MNT/snap
>=20
>    mv --exchange -T $MNT/snap/file $MNT/snap/inner_subvol
>=20
>    umount $MNT
>=20
> Running it:
>=20
>    $ ./test.sh
>    (...)
>    Create subvolume '/mnt/sdi/subvol'
>    Create subvolume '/mnt/sdi/subvol/inner_subvol'
>    Create snapshot of '/mnt/sdi/subvol' in '/mnt/sdi/snap'
>    mv: cannot exchange '/mnt/sdi/snap/file' and '/mnt/sdi/snap/inner_sub=
vol': No such file or directory
>=20
> And dmesg shows a transaction abort:
>=20
>    $ dmesg
>    [277913.996925] BTRFS critical (device sdi): failed to delete referen=
ce to inner_subvol, root 258 inode 2 parent 256
>    [277913.996950] ------------[ cut here ]------------
>    [277913.996951] WARNING: fs/btrfs/inode.c:4399 at __btrfs_unlink_inod=
e+0x3a8/0x420 [btrfs], CPU#0: mv/1549646
>    [277914.001156] Modules linked in: btrfs dm_dust loop (...)
>    [277914.016365] CPU: 0 UID: 0 PID: 1549646 Comm: mv Tainted: G       =
 W           7.4.0-rc4-btrfs-next-252+ #1 PREEMPT(full)
>    [277914.018964] Tainted: [W]=3DWARN
>    [277914.019622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [277914.021892] RIP: 0010:__btrfs_unlink_inode+0x3a8/0x420 [btrfs]
>    [277914.023185] Code: 85 c0 78 (...)
>    [277914.026865] RSP: 0018:ffffd33e801dfb80 EFLAGS: 00010206
>    [277914.028098] RAX: 00000000fffffffe RBX: ffff8c89cc89e000 RCX: 0000=
000000000000
>    [277914.030305] RDX: 000000000000001c RSI: 0000000000000001 RDI: ffff=
8c89c4bb12c0
>    [277914.031978] RBP: ffff8c8f542a9d80 R08: 3fffffffffefffff R09: 0000=
000000014b83
>    [277914.033448] R10: ffffd33e801df840 R11: 0000000000000002 R12: ffff=
8c8f543bf838
>    [277914.034891] R13: ffffd33e801dfca8 R14: ffff8c89defee000 R15: ffff=
8c89e4c31a10
>    [277914.036370] FS:  00007f709e183840(0000) GS:ffff8c913f2ce000(0000)=
 knlGS:0000000000000000
>    [277914.037984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [277914.039144] CR2: 00007f709e29ba80 CR3: 0000000524f02004 CR4: 0000=
000000370ef0
>    [277914.040585] Call Trace:
>    [277914.041107]  <TASK>
>    [277914.041584]  btrfs_rename_exchange+0x37b/0xbf0 [btrfs]
>    [277914.042734]  ? inode_set_ctime_current+0x3b/0x220
>    [277914.043690]  btrfs_rename2+0x53/0x60 [btrfs]
>    [277914.044648]  vfs_rename+0x5b4/0xe40
>    [277914.045371]  filename_renameat2+0x222/0x450
>    [277914.046256]  __x64_sys_renameat2+0x4e/0x70
>    [277914.047091]  do_syscall_64+0x8b/0x490
>    [277914.047902]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    [277914.048912] RIP: 0033:0x7f709e29ba8f
>    [277914.049717] Code: 44 00 00 (...)
>    [277914.054201] RSP: 002b:00007fff08b22438 EFLAGS: 00000202 ORIG_RAX:=
 000000000000013c
>    [277914.055699] RAX: ffffffffffffffda RBX: 00007fff08b242d2 RCX: 0000=
7f709e29ba8f
>    [277914.057110] RDX: 00000000ffffff9c RSI: 00007fff08b242d2 RDI: 0000=
0000ffffff9c
>    [277914.058534] RBP: 00007fff08b242e5 R08: 0000000000000002 R09: 0000=
000000000001
>    [277914.059942] R10: 00007fff08b242e5 R11: 0000000000000202 R12: 0000=
000000000002
>    [277914.061336] R13: 00000000ffffff9c R14: 00000000ffffff9c R15: 0000=
7fff08b22a90
>    [277914.062754]  </TASK>
>    [277914.063232] ---[ end trace 0000000000000000 ]---
>    [277914.064191] BTRFS error (device sdi state A): Transaction 10 abor=
ted (-ENOENT)
>    [277914.064195] BTRFS: error (device sdi state A) in __btrfs_unlink_i=
node:4399: errno=3D-2 No such entry
>    [277914.064197] BTRFS info (device sdi state EA): forced readonly
>    [277914.064199] BTRFS: error (device sdi state EA) in btrfs_rename_ex=
change:8458: errno=3D-2 No such entry
>=20
> Fix this by rejecting rename exchange operations against dentries that a=
re
> subvolume stubs.
>=20
> Reported-by: Tianyu Chen <chentianyu@microsoft.com>
> Link: https://lore.kernel.org/linux-btrfs/TY8P153MB237624AA8DAAC5323DE20=
B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM/
> Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_=
WHITEOUT")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/inode.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40dd87276cc9..69fda53ce340 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8271,6 +8271,14 @@ static int btrfs_rename_exchange(struct inode *ol=
d_dir,
>   	     new_ino !=3D BTRFS_FIRST_FREE_OBJECTID))
>   		return -EXDEV;
>  =20
> +	/*
> +	 * Subvolume stubs, created with new_simple_dir(), have no associated
> +	 * inode so we can not rename exchange.
> +	 */
> +	if (old_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
> +	    new_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
> +		return -EPERM;
> +
>   	ret =3D fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_=
fname);
>   	if (ret)
>   		return ret;

