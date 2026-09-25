Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C240B0E6
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 22:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376211; cv=none; b=A4WGVxvkqpuu22f1BisGQv6Ks5tAaNWsV8ugsvb6UdDqCIeIO66mT1ptoWR58Hf4EOVDLU3RVXWhucufdaoJFXHdCYE0VxlPTO17cuN3HjGR/6PSQy2titlwVizFW60Ybp3KiexsRy9S2/uk5II9n45S1QaCWI26E4smFTtUqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376211; c=relaxed/simple;
	bh=YCq5HoM4Rpeqk1ofxEI2sJFT2vxUWkNGrVvT1uNxpyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BtXIhvM/jIcDgs5oZtrJVJE5lf4kBQih7qr3AY+084+okEvMZIez/REGfgnCrwW/8hm7ktNrAUxU9laoiS3jOCEKETTeRZVCjceOaYegnjJ1yAppYzdByRB3E+SqE3eMz5vU8ryrBTYP2dmIjwIUuM02kU7R7987o613QKiUgFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=nk1WAAO2; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="nk1WAAO2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790376206; x=1790981006; i=quwenruo.btrfs@gmx.com;
	bh=/tpRHL8IP4JQnGegB+kYIPj4cjYxvPx/VqZ8EkKcQ2Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nk1WAAO2ykNPnuYfUOzCQo3Ge8epgatRFQrc49ND7Kb+nMgc61+dBq2ZVB4jR8tu
	 A3u0iABDK0naAtGGjpV+EK2pxGN0L91NpiXYlUEPh7nVCoCipnON+64QMXCkeePuO
	 RIy4gekt8YcFApxsaAEZZ9m8RH/ANekOP+eJMEGILfrJSDUdkociVfPUeE3GA35o7
	 3MWx3LMw6c5i1mthrrJH8OqQS+u46oyT9MjoQdV0SOo/VKocGTude6FLzjgyaDawe
	 zzWbOf2RBfey5SZUq07n828MwuH2lC7FXLKYfYyC0v83sXhoPeOoQOcMh0yHMD+Td
	 sgvrADR4koaf5hbEWA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mlw7f-1wRnDK2Nt5-00pilQ; Sat, 26
 Sep 2026 00:43:26 +0200
Message-ID: <013c5082-9b2a-41d2-b2ea-a1b2ffd81757@gmx.com>
Date: Sat, 26 Sep 2026 08:13:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix xattr replace when multiple xattrs are packed
 in the same item
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <221fd918f8e67d418ef8ebb242cac76dc34c3b9f.1790350388.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <221fd918f8e67d418ef8ebb242cac76dc34c3b9f.1790350388.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BrChMZv96nbzL8v3gvmgerlIficyu85PF5TZlMM5xptJ++FPoFH
 1IyGBZiv0T6I12vRzGwnauypeWtY2aTOCdEvU/rN+3OyuimJFOU7Tnlsq3iNNzlBWKfu+Lb
 kPdm2u0gwmkISRem9mgxzgiTU65hXBNwG8h2UUOK+jM+QVW3ZroULxcLl/k+Se+aajykjPw
 ihI5otG3cUN3rknIBZleQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vZL/dm3bpCE=;rkSkXOKlzVMIffGXtGZnhgO2kS4
 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



=E5=9C=A8 2026/9/26 02:20, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we have a btrfs_dir_item item that packs multiple xattrs and then we
> replace the value of one of them (with the setxattr(2) family of syscall=
s)
> with another value of a different size, we end up not having a fully
> initialized btrfs_dir_item, resulting in a corruption that the tree
> checker will detect at extent buffer writeback time.
>=20
> This is because in btrfs_setxattr() when we find a btrfs_dir_item with
> multiple xattrs (due to the crc32c hash of their name being the same)
> we delete one of the xattr items (btrfs_dir_item) and then insert a new
> one, but the deletion and insertion results in shifting existing data in
> the leaf and therefore when the new value of a xattr has a different siz=
e,
> the new btrfs_dir_item is placed in a leaf section that was not
> initialized and we only copy the value's data and set the value's length
> in the new btrfs_dir_item, without setting the name, the name's length,
> the key (which must be all zeroes for xattrs), flags (BTRFS_FT_XATTR) an=
d
> transaction ID.
>=20
> The following script reproduces the issue:
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
>    touch $MNT/testfile
>=20
>    # Add two xattrs that, on btrfs, have the same hash (crc32c) for thei=
r
>    # name and therefore are packed into the same btrfs_dir_item.
>    setfattr -n user.foobar -v 123 $MNT/testfile
>    setfattr -n user.WvG1c1Td -v qwerty $MNT/testfile
>=20
>    # Verify the xattrs are present.
>    echo "xattrs before:"
>    getfattr --absolute-names --dump $MNT/testfile
>=20
>    # Now replace the value of the foobar xattr with a significantly larg=
er
>    # value.
>    setfattr -n user.foobar -v abcdefghijklmnopqrstuvwxyz $MNT/testfile
>=20
>    # Check the xattrs have the expected values.
>    echo "xattrs after:"
>    getfattr --absolute-names --dump $MNT/testfile
>=20
>    umount $MNT
>=20
> Running it:
>=20
>    $ ./test.sh
>    (...)
>    xattrs before:
>    # file: /mnt/sdi/testfile
>    user.WvG1c1Td=3D"qwerty"
>    user.foobar=3D"123"
>=20
>    xattrs after:
>    # file: /mnt/sdi/testfile
>    user.WvG1c1Td=3D"qwerty"
>=20
> So the "user.foobar" xattr is missing and there was a transaction abort
> when unmounting the fs with the following traces in dmesg:
>=20
>    $ dmesg
>    [869800.159271] BTRFS warning (device sdi): access to eb bytenr 30474=
240 len 16384 out of range start 16015 len 25964
>    [869800.159293] ------------[ cut here ]------------
>    [869800.159296] WARNING: fs/btrfs/extent_io.c:4408 at report_eb_range=
+0x44/0x60 [btrfs], CPU#8: getfattr/2605179
>    [869800.168961] Modules linked in: btrfs dm_thin_pool (...)
>    [869800.190527] CPU: 8 UID: 0 PID: 2605179 Comm: getfattr Tainted: G =
       W           7.3.0-rc3-btrfs-next-244+ #1 PREEMPT(full)
>    [869800.193726] Tainted: [W]=3DWARN
>    [869800.194502] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [869800.197576] RIP: 0010:report_eb_range+0x44/0x60 [btrfs]
>    [869800.198985] Code: 48 8b 7b 18 (...)
>    [869800.203531] RSP: 0018:ffffce4541937d58 EFLAGS: 00010246
>    [869800.204609] RAX: 0000000000000000 RBX: ffff8dde054b8738 RCX: 0000=
000000000000
>    [869800.206137] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff=
ffffc04c92a0
>    [869800.207645] RBP: 0000000000003e8f R08: 0000000000000000 R09: 3fff=
ffffffefffff
>    [869800.226175] R10: ffffce4541937a88 R11: 0000000000000003 R12: 0000=
00000000656c
>    [869800.227594] R13: ffff8dde14be800f R14: 000000000000656c R15: 0000=
000000000069
>    [869800.229097] FS:  00007f59023bb780(0000) GS:ffff8de5788ed000(0000)=
 knlGS:0000000000000000
>    [869800.231137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [869800.232321] CR2: 0000558dc45e6a78 CR3: 0000000765b16004 CR4: 0000=
000000370ef0
>    [869800.233783] Call Trace:
>    [869800.234330]  <TASK>
>    [869800.234791]  read_extent_buffer+0x4d/0x100 [btrfs]
>    [869800.235898]  btrfs_listxattr+0x199/0x240 [btrfs]
>    [869800.236912]  vfs_listxattr+0x51/0xa0
>    [869800.237683]  listxattr+0x7e/0x100
>    [869800.238398]  path_listxattrat+0x9e/0x190
>    [869800.239117]  do_syscall_64+0x89/0x470
>    [869800.239877]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    [869800.240914] RIP: 0033:0x7f59024cdcb7
>    [869800.241686] Code: f0 ff ff 73 (...)
>    [869800.245353] RSP: 002b:00007ffd056dcdb8 EFLAGS: 00000246 ORIG_RAX:=
 00000000000000c2
>    [869800.246892] RAX: ffffffffffffffda RBX: 00007ffd056df2e2 RCX: 0000=
7f59024cdcb7
>    [869800.248853] RDX: 0000000000006600 RSI: 0000558dc45e0470 RDI: 0000=
7ffd056df2e2
>    [869800.250514] RBP: 00007ffd056df2e2 R08: 0000000000006600 R09: 0000=
000000006600
>    [869800.252295] R10: 0000000000000004 R11: 0000000000000246 R12: 0000=
0000ffffff9c
>    [869800.254105] R13: 0000558dc45e0470 R14: 0000000000006600 R15: 0000=
000000000000
>    [869800.255931]  </TASK>
>    [869800.256529] ---[ end trace 0000000000000000 ]---
>    [869800.260071] page: refcount:2 mapcount:0 mapping:000000007ccfc77f =
index:0x1d10 pfn:0x608c69
>    [869800.260075] memcg:ffff8dde00344d40
>    [869800.260076] aops:btree_aops [btrfs] ino:1
>    [869800.260151] flags: 0x17fffc00000402a(uptodate|lru|private|writeba=
ck|node=3D0|zone=3D2|lastcpupid=3D0x1ffff)
>    [869800.260154] raw: 017fffc00000402a fffff4adc773d4c8 fffff4adc48f3d=
88 ffff8de36504ba30
>    [869800.260155] raw: 0000000000001d10 ffff8dde054b8738 00000002ffffff=
ff ffff8dde00344d40
>    [869800.260156] page dumped because: eb page dump
>    [869800.260157] BTRFS critical (device sdi): corrupt leaf: root=3D5 b=
lock=3D30474240 slot=3D5 ino=3D257, invalid location key type, have 46, ex=
pect 132 or 1
>    [869800.260161] BTRFS info (device sdi): leaf 30474240 gen 9 total pt=
rs 6 free space 15629 owner 5
>    [869800.260163] BTRFS info (device sdi): refs 3 lock_owner 0 current =
2550294
>    [869800.260164] 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize=
 160
>    [869800.260165] 		inode generation 3 transid 0 size 0 nbytes 16384
>    [869800.260166] 		block group 0 mode 40755 links 1 uid 0 gid 0
>    [869800.260167] 		rdev 0 sequence 0 flags 0x0
>    [869800.260168] 		atime 1790340637.0
>    [869800.260169] 		ctime 1790340637.0
>    [869800.260169] 		mtime 1790340637.0
>    [869800.260170] 		otime 1790340637.0
>    [869800.260170] 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsiz=
e 12
>    [869800.260172] 		index 0 name_len 2
>    [869800.260172] 	item 2 key (256 DIR_ITEM 982728850) itemoff 16073 it=
emsize 38
>    [869800.260173] 		location key (257 1 0) type 1
>    [869800.260174] 		transid 9 data_len 0 name_len 8
>    [869800.260175] 	item 3 key (257 INODE_ITEM 0) itemoff 15913 itemsize=
 160
>    [869800.260176] 		inode generation 9 transid 9 size 0 nbytes 0
>    [869800.260177] 		block group 0 mode 100664 links 1 uid 0 gid 0
>    [869800.260177] 		rdev 0 sequence 0 flags 0x0
>    [869800.260178] 		atime 1790340638.38778502
>    [869800.260179] 		ctime 1790340638.38778502
>    [869800.260179] 		mtime 1790340638.38778502
>    [869800.260180] 		otime 1790340638.38778502
>    [869800.260180] 	item 4 key (257 INODE_REF 256) itemoff 15895 itemsiz=
e 18
>    [869800.260181] 		index 2 name_len 8
>    [869800.260182] 	item 5 key (257 XATTR_ITEM 751495445) itemoff 15779 =
itemsize 116
>    [869800.260183] 		location key (0 0 0) type 8
>    [869800.266052] 		transid 9 data_len 6 name_len 13
>    [869800.266053] 		location key (8243121639454149888 46 72294576039347=
78967) type 0
>    [869800.266055] 		transid 113 data_len 26 name_len 0
>    [869800.266056] 		location key (8608196880778817904 120 162425) type =
9
>    [869800.266057] 		transid 8391162079612502016 data_len 26982 name_len=
 25964
>    [869800.266058] BTRFS error (device sdi): block=3D30474240 write time=
 tree block corruption detected
>    [869800.266091] ------------[ cut here ]------------
>    [869800.266092] WARNING: fs/btrfs/disk-io.c:336 at btree_csum_one_bio=
+0x20b/0x220 [btrfs], CPU#7: kworker/u50:7/2550294
>    [869800.268392] Modules linked in: btrfs dm_thin_pool (...)
>    [869800.365851] CPU: 7 UID: 0 PID: 2550294 Comm: kworker/u50:7 Tainte=
d: G        W           7.3.0-rc3-btrfs-next-244+ #1 PREEMPT(full)
>    [869800.368937] Tainted: [W]=3DWARN
>    [869800.369834] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [869800.372778] Workqueue: writeback wb_workfn (flush-btrfs-3821)
>    [869800.374314] RIP: 0010:btree_csum_one_bio+0x20b/0x220 [btrfs]
>    [869800.375915] Code: 89 44 24 04 (...)
>    [869800.380639] RSP: 0018:ffffce4548e3f7d0 EFLAGS: 00010246
>    [869800.382008] RAX: 0000000000000000 RBX: ffff8dde054b8738 RCX: 0000=
000000000000
>    [869800.383850] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff=
8de091c2ddc0
>    [869800.385710] RBP: ffff8dde196a2000 R08: 0000000000000000 R09: 3fff=
ffffffefffff
>    [869800.387388] R10: ffffce4548e3f500 R11: 0000000000000003 R12: ffff=
ce4548e3f7d8
>    [869800.388973] R13: ffff8dde196a2000 R14: ffff8de36504b750 R15: ffff=
8dde4c497b00
>    [869800.390414] FS:  0000000000000000(0000) GS:ffff8de5788ad000(0000)=
 knlGS:0000000000000000
>    [869800.392002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [869800.393160] CR2: 000055cd6e92ad5c CR3: 00000007cb264001 CR4: 0000=
000000370ef0
>    [869800.394595] Call Trace:
>    [869800.395113]  <TASK>
>    [869800.395570]  btrfs_submit_bbio+0x872/0x890 [btrfs]
>    [869800.397284]  write_meta_extent_buffer+0x70/0x80 [btrfs]
>    [869800.398940]  btree_writepages+0x141/0x4f0 [btrfs]
>    [869800.400426]  ? get_random_u32+0x8a/0xf0
>    [869800.401417]  ? build_slab_freelist+0x47/0x130
>    [869800.402574]  ? preempt_count_add+0x6b/0xa0
>    [869800.403633]  ? _raw_spin_lock_irqsave+0x23/0x50
>    [869800.404807]  ? _raw_spin_unlock_irqrestore+0x22/0x40
>    [869800.406085]  ? alloc_from_new_slab+0x18f/0x330
>    [869800.407223]  do_writepages+0xc6/0x160
>    [869800.408191]  ? refill_objects+0xd8/0x300
>    [869800.409211]  __writeback_single_inode+0x42/0x350
>    [869800.410408]  writeback_sb_inodes+0x231/0x560
>    [869800.411511]  wb_writeback+0x8a/0x300
>    [869800.412440]  wb_workfn+0xbf/0x460
>    [869800.413291]  ? _raw_spin_unlock+0x14/0x30
>    [869800.414328]  ? finish_task_switch.isra.0+0xb9/0x380
>    [869800.415105]  process_one_work+0x1d1/0x3d0
>    [869800.416633]  worker_thread+0x1c4/0x330
>    [869800.417467]  ? __pfx_worker_thread+0x10/0x10
>    [869800.418452]  kthread+0xfc/0x130
>    [869800.419257]  ? __pfx_kthread+0x10/0x10
>    [869800.420089]  ret_from_fork+0x1f7/0x2c0
>    [869800.420863]  ? __pfx_kthread+0x10/0x10
>    [869800.421654]  ret_from_fork_asm+0x1a/0x30
>    [869800.422484]  </TASK>
>    [869800.422953] ---[ end trace 0000000000000000 ]---
>    [869800.424005] BTRFS error (device sdi state A): Transaction 9 abort=
ed (-EIO)
>    [869800.424010] BTRFS: error (device sdi state A) in __btrfs_run_dela=
yed_items:1162: errno=3D-5 IO failure
>    [869800.424011] BTRFS info (device sdi state EA): forced readonly
>    [869800.424013] BTRFS warning (device sdi state EA): Skipping commit =
of aborted transaction.
>    [869800.424014] BTRFS: error (device sdi state EA) in cleanup_transac=
tion:2076: errno=3D-5 IO failure
>=20
> Fix this by always setting all fields in the new btrfs_dir_item when we
> replace an existing xattr.
>=20
> Fixes: 5f5bc6b1e2d5 ("Btrfs: make xattr replace operations atomic")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/xattr.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index ab55d10bd71f..e8762e12f3e1 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -161,6 +161,7 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans,=
 struct inode *inode,
>   		const u16 old_data_len =3D btrfs_dir_data_len(leaf, di);
>   		const u32 item_size =3D btrfs_item_size(leaf, slot);
>   		const u32 data_size =3D sizeof(*di) + name_len + size;
> +		unsigned long name_ptr;
>   		unsigned long data_ptr;
>   		char *ptr;
>  =20
> @@ -189,8 +190,16 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans=
, struct inode *inode,
>   		ptr =3D btrfs_item_ptr(leaf, slot, char);
>   		ptr +=3D btrfs_item_size(leaf, slot) - data_size;
>   		di =3D (struct btrfs_dir_item *)ptr;
> +		memzero_extent_buffer(leaf, (unsigned long)ptr +
> +				      offsetof(struct btrfs_dir_item, location),
> +				      sizeof(struct btrfs_disk_key));
> +		btrfs_set_dir_flags(leaf, di, BTRFS_FT_XATTR);
> +		btrfs_set_dir_transid(leaf, di, trans->transid);
> +		btrfs_set_dir_name_len(leaf, di, name_len);
>   		btrfs_set_dir_data_len(leaf, di, size);
> +		name_ptr =3D (unsigned long)(di + 1);
>   		data_ptr =3D ((unsigned long)(di + 1)) + name_len;
> +		write_extent_buffer(leaf, name, name_ptr, name_len);
>   		write_extent_buffer(leaf, value, data_ptr, size);
>   	} else {
>   		/*

