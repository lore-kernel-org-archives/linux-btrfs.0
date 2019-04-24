Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7742C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F9B5218D2
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="bODr3/XL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfDXMvB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 08:51:01 -0400
Received: from mout.gmx.net ([212.227.15.18]:36427 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbfDXMvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 08:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556110254;
        bh=FSMw0rcChOLw8t4LUxAH7m5+F2A1ZAb6Ox7P12tzr98=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=bODr3/XLOq4uTyXodumHTnvFzqay+gCwZjntW7ZUpgf42MEbUWh4bzdgoyKGGgJZj
         XaOBwlZ9jgShbQwUo+gghDF0bGj1avF/Yh0FqC/8QWgMK3PO6YGmJD7YVCLY7F0+aU
         DshUg0//zph710K0zx+YUBr9069awMf9SM5OxG+A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M3lY1-1hK6JD4Azr-000tuO; Wed, 24
 Apr 2019 14:50:54 +0200
Subject: Re: kernel BUG at fs/btrfs/ctree.c:3230!
To:     Gregory Malloff <gregory.malloff@silvernetworks.ca>,
        linux-btrfs@vger.kernel.org
References: <1497429336.5464.1556108913480.JavaMail.gregory.malloff@wks-2>
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
Message-ID: <77f4a7b5-7cb5-9802-1ecc-aaf64665ae0e@gmx.com>
Date:   Wed, 24 Apr 2019 20:50:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1497429336.5464.1556108913480.JavaMail.gregory.malloff@wks-2>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tq6vkGuX8dnfrCc6wIllqJJOTcaGIifmd"
X-Provags-ID: V03:K1:2Gnqn5oAJgw6t3Q/uAhvE6bfGGFEwQ8LDTwJQyIED/XFZHZu1mf
 liAv/jBU31MVbwG2H7ZVt2wTCilZDVdHAYl5qsG2QA23Sub9UotvFatchyip+6E9bSCH7Uh
 x6vpOG8yPp8FNRmeJ9A/R/c3nkYQenfUqP0lIhg817cVnUYzKFps6xH8KpRRlrx2BTiSVBl
 rMMtzHMjKNTq1qpJROUGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JbEMyE4c37w=:MLkEHExY5MeK3iCAhi9dEO
 MCSW140BGhDlad0VGoiRfIdMKvgYwbIC77tkz5wNblz3wweKQrhSiL2qflm2FpWu6v/1LkP/n
 c0KQIiCm/wAiasILGUsv3ofADb7eAOYAPI7aRoQCrV6snvu+4jeoaCRDxvmRT2H051ge4W81o
 j8ronbixjz6nkEWVknZHnNMUZTFNfNgjLEz/uIiUL+wHNgRPH9iBF1tOvbcFI6ZLd3Fgpq3U/
 whqstE+Y4nv+J2YE7K97FqdVjYrCet8y1Evu8g+tutziRdPUOcFRADA/I7/KaxJun9ewAM3t/
 nFdAtc3zj+IQO8crBFbp5qNR6Z50NNeFf++oxGmVtKbJxatC/FnTIG3IGoq+6Y4P90BQZLx7D
 Pf8CQMrOCip1O4ygEeQ+mGSKcHns5LhmNfvH3AHYLVyUAUg9pURrglv5xGM+SDv7DalNQYT3W
 xtX1ZEOPZ1kL/mbZ9eTwEnWB4hgLQoLccE+mUs/z6X2L8lXX5sLcJTF3bCQrFK71NFVEuCg5z
 7TFSsgLR9zmNkVqRJVjggSREkLUhxZjGa1vEdaA/78E7x9XmeosrtWppq4fCeAIxG2B30brzR
 pt7M5F6x0h8H92Id7PsVz3ZoAKzB4ghFcScYS6+16C5LDXPnrII9aUstjkFOo4eK0UrOSTZGk
 fmJFhlkkrBniK1Z4PoF2ny9n4iEZMkVqVjo801dDSqJP/A/7Iwb7sNt9p1Yjeilrp03U8cACM
 UKrtr0TRYZ5OgrKHpj1nhcBgXjM4nrT7PC8wBAGszUmYLK9HqzIwv64Gg8FQLyMVcqTbNUj/M
 s5tactbSl59ba/MN2N2+Uw75N8qD83FkYoLrRVLqqO76Epn4l+ymwQ3Lcn/WotgqhBJ2hE6X8
 zFPfYLyIQPTQEFa1XYnAl3awl/U6KkQ3A8y+rWS+uAFE/Dd+ZJZLKCxrisLFrN
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tq6vkGuX8dnfrCc6wIllqJJOTcaGIifmd
Content-Type: multipart/mixed; boundary="XQICSbrWZTbBnCL4k8ijiiHIwCcYlAqfD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gregory Malloff <gregory.malloff@silvernetworks.ca>,
 linux-btrfs@vger.kernel.org
Message-ID: <77f4a7b5-7cb5-9802-1ecc-aaf64665ae0e@gmx.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:3230!
References: <1497429336.5464.1556108913480.JavaMail.gregory.malloff@wks-2>
In-Reply-To: <1497429336.5464.1556108913480.JavaMail.gregory.malloff@wks-2>

--XQICSbrWZTbBnCL4k8ijiiHIwCcYlAqfD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/24 =E4=B8=8B=E5=8D=888:28, Gregory Malloff wrote:
>=20
> Hello,=20
>=20
> After 7 days, BTRFS crashed again with the same error:=20
>=20
> [Tue Apr 23 21:59:40 2019] ------------[ cut here ]------------=20
> [Tue Apr 23 21:59:40 2019] kernel BUG at fs/btrfs/ctree.c:3230!=20
> [Tue Apr 23 21:59:40 2019] invalid opcode: 0000 [#1] SMP PTI=20
> [Tue Apr 23 21:59:40 2019] CPU: 0 PID: 526 Comm: nfsd Not tainted 4.19.=
0-4-amd64 #1 Debian 4.19.28-2=20
> [Tue Apr 23 21:59:40 2019] Hardware name: VMware, Inc. VMware Virtual P=
latform/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015=20
> [Tue Apr 23 21:59:40 2019] RIP: 0010:btrfs_set_item_key_safe+0x116/0x19=
0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44=
 24 0e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f =
8f 46 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48=
 98 48 8d=20
> [Tue Apr 23 21:59:40 2019] RSP: 0018:ffffb23fc082f6a0 EFLAGS: 00010246 =

> [Tue Apr 23 21:59:40 2019] RAX: 0000000000000000 RBX: 000000000000008d =
RCX: 000000000c71b000=20
> [Tue Apr 23 21:59:40 2019] RDX: 000000000003996e RSI: ffffb23fc082f795 =
RDI: ffffb23fc082f6b7=20
> [Tue Apr 23 21:59:40 2019] RBP: ffff9e9ec6bc95b0 R08: 0000000000001000 =
R09: 0000000000004000=20
> [Tue Apr 23 21:59:40 2019] R10: 0000000000000000 R11: 00000000ffffffff =
R12: ffff9e9e90957000=20
> [Tue Apr 23 21:59:40 2019] R13: ffffb23fc082f795 R14: 0000000000000000 =
R15: 000000000d007000=20
> [Tue Apr 23 21:59:40 2019] FS: 0000000000000000(0000) GS:ffff9e9efda000=
00(0000) knlGS:0000000000000000=20
> [Tue Apr 23 21:59:40 2019] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033=20
> [Tue Apr 23 21:59:40 2019] CR2: 00007f8bddd7fae4 CR3: 00000000735de000 =
CR4: 00000000000406f0=20
> [Tue Apr 23 21:59:40 2019] Call Trace:=20
> [Tue Apr 23 21:59:40 2019] __btrfs_drop_extents+0x7ae/0xcf0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] btrfs_log_changed_extents.isra.24+0x391/0x99=
0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] btrfs_log_inode+0xb54/0x1240 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] ? __schedule+0x2aa/0x870=20
> [Tue Apr 23 21:59:40 2019] ? __switch_to_asm+0x34/0x70=20
> [Tue Apr 23 21:59:40 2019] btrfs_log_inode_parent+0x2a1/0xac0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] ? wait_current_trans+0x2f/0xf0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] ? refcount_inc_checked+0x5/0x30=20
> [Tue Apr 23 21:59:40 2019] ? join_transaction+0xec/0x410 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] btrfs_log_dentry_safe+0x4a/0x70 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] btrfs_sync_file+0x1cb/0x3d0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] btrfs_file_write_iter+0x495/0x590 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] ? apparmor_cred_prepare+0x4c/0x60=20
> [Tue Apr 23 21:59:40 2019] do_iter_readv_writev+0x13a/0x1b0=20
> [Tue Apr 23 21:59:40 2019] do_iter_write+0x80/0x190=20
> [Tue Apr 23 21:59:40 2019] nfsd_vfs_write+0xe6/0x450 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] ? do_dentry_open+0xd1/0x330=20
> [Tue Apr 23 21:59:40 2019] nfsd_write+0x88/0x170 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] ? _cond_resched+0x15/0x30=20
> [Tue Apr 23 21:59:40 2019] nfsd3_proc_write+0xc3/0x170 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] nfsd_dispatch+0x9e/0x210 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] svc_process_common+0x4a5/0x720 [sunrpc]=20
> [Tue Apr 23 21:59:40 2019] ? nfsd_destroy+0x50/0x50 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] svc_process+0xb7/0xf0 [sunrpc]=20
> [Tue Apr 23 21:59:40 2019] nfsd+0xe3/0x140 [nfsd]=20
> [Tue Apr 23 21:59:40 2019] kthread+0x112/0x130=20
> [Tue Apr 23 21:59:40 2019] ? kthread_bind+0x30/0x30=20
> [Tue Apr 23 21:59:40 2019] ret_from_fork+0x35/0x40=20
> [Tue Apr 23 21:59:40 2019] Modules linked in: vmw_vsock_vmci_transport =
vsock coretemp crct10dif_pclmul crc32_pclmul vmwgfx ttm ghash_clmulni_int=
el ppdev drm_kms_helper vmw_balloon intel_rapl_perf joydev evdev drm pcsp=
kr serio_raw sg vmw_vmci parport_pc parport button ac nfsd auth_rpcgss nf=
s_acl lockd grace sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jb=
d2 fscrypto ecb btrfs xor zstd_decompress zstd_compress xxhash raid6_pq l=
ibcrc32c crc32c_generic sd_mod sr_mod cdrom ata_generic crc32c_intel aesn=
i_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse ata_piix mptspi=
 mptscsih mptbase libata vmxnet3 scsi_transport_spi scsi_mod i2c_piix4 fl=
oppy=20
> [Tue Apr 23 21:59:40 2019] ---[ end trace 9153b7dc6f042f19 ]---=20
> [Tue Apr 23 21:59:40 2019] RIP: 0010:btrfs_set_item_key_safe+0x116/0x19=
0 [btrfs]=20
> [Tue Apr 23 21:59:40 2019] Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44=
 24 0e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f =
8f 46 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48=
 98 48 8d=20
> [Tue Apr 23 21:59:40 2019] RSP: 0018:ffffb23fc082f6a0 EFLAGS: 00010246 =

> [Tue Apr 23 21:59:40 2019] RAX: 0000000000000000 RBX: 000000000000008d =
RCX: 000000000c71b000=20
> [Tue Apr 23 21:59:40 2019] RDX: 000000000003996e RSI: ffffb23fc082f795 =
RDI: ffffb23fc082f6b7=20
> [Tue Apr 23 21:59:40 2019] RBP: ffff9e9ec6bc95b0 R08: 0000000000001000 =
R09: 0000000000004000=20
> [Tue Apr 23 21:59:40 2019] R10: 0000000000000000 R11: 00000000ffffffff =
R12: ffff9e9e90957000=20
> [Tue Apr 23 21:59:40 2019] R13: ffffb23fc082f795 R14: 0000000000000000 =
R15: 000000000d007000=20
> [Tue Apr 23 21:59:40 2019] FS: 0000000000000000(0000) GS:ffff9e9efda000=
00(0000) knlGS:0000000000000000=20
> [Tue Apr 23 21:59:40 2019] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033=20
> [Tue Apr 23 21:59:40 2019] CR2: 00007f8bddd7fae4 CR3: 00000000735de000 =
CR4: 00000000000406f0=20
> [05:24 AM] root@nas-201-b:~> uptime=20
> 05:24:56 up 7 days, 15:05, 1 user, load average: 16.07, 16.03, 15.85=20
>=20
> Please let me know if you need any other details to help me resolve thi=
s issue.=20

Not familiar with tree log code, but the following patch could provide
extra debug info:
https://patchwork.kernel.org/patch/10914687/

And, if your primary objective is to avoid such BUG_ON(), you can simply
disable tree log by "notreelog" mount option, if fsync() performance is
not your primary concern.

Thanks,
Qu

>=20
> ----- Original Message -----
>=20
> From: "Gregory Malloff" <gregory.malloff@silvernetworks.ca>=20
> To: linux-btrfs@vger.kernel.org=20
> Sent: Tuesday, April 16, 2019 12:53:20 PM=20
> Subject: kernel BUG at fs/btrfs/ctree.c:3230!=20
>=20
>=20
> Hello,=20
>=20
> Problem: On a Debian 9 or 10 system with an NFS share and heavy I/O, ab=
out every 5 days or so, I get the following:=20
>=20
> http://cwillu.com:8080/207.102.58.55=20
>=20
> 4,1352,538395169676,-;------------[ cut here ]------------=20
> 2,1353,538395169680,-;kernel BUG at fs/btrfs/ctree.c:3230!=20
> 4,1354,538395169742,-;invalid opcode: 0000 [#1] SMP PTI=20
> 4,1355,538395169767,-;CPU: 0 PID: 859 Comm: nfsd Not tainted 4.19.0-4-a=
md64 #1 Debian 4.19.28-2=20
> 4,1356,538395169802,-;Hardware name: VMware, Inc. VMware Virtual Platfo=
rm/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015=20
> 4,1357,538395169884,-;RIP: 0010:btrfs_set_item_key_safe+0x116/0x190 [bt=
rfs]=20
> 4,1358,538395169921,-;Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44 24 0=
e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f 8f 46=
 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48 98 4=
8 8d=20
> 4,1359,538395170000,-;RSP: 0018:ffffc08a41fbf6a0 EFLAGS: 00010246=20
> 4,1360,538395171003,-;RAX: 0000000000000000 RBX: 000000000000008f RCX: =
000000005baa2000=20
> 4,1361,538395171948,-;RDX: 0000000000031b05 RSI: ffffc08a41fbf795 RDI: =
ffffc08a41fbf6b7=20
> 4,1362,538395172882,-;RBP: ffff9d6b33ef3460 R08: 0000000000001000 R09: =
0000000000004000=20
> 4,1363,538395173774,-;R10: 0000000000000000 R11: 00000000ffffffff R12: =
ffff9d6c5a788c08=20
> 4,1364,538395174713,-;R13: ffffc08a41fbf795 R14: 0000000000000000 R15: =
000000005c01a000=20
> 4,1365,538395175761,-;FS: 0000000000000000(0000) GS:ffff9d6cb7a00000(00=
00) knlGS:0000000000000000=20
> 4,1366,538395176716,-;CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 =

> 4,1367,538395177582,-;CR2: 00007ffe8161dbe8 CR3: 000000022b3fa000 CR4: =
00000000000406f0=20
> 4,1368,538395178523,-;Call Trace:=20
> 4,1369,538395179418,-; __btrfs_drop_extents+0x7ae/0xcf0 [btrfs]=20
> 4,1370,538395180296,-; btrfs_log_changed_extents.isra.24+0x391/0x990 [b=
trfs]=20
> 4,1371,538395181233,-; btrfs_log_inode+0xb54/0x1240 [btrfs]=20
> 4,1372,538395182096,-; ? __kprobes_text_end+0xe5c68/0xe5c68=20
> 4,1373,538395182930,-; ? __switch_to_asm+0x34/0x70=20
> 4,1374,538395183747,-; ? __switch_to_asm+0x40/0x70=20
> 4,1375,538395184542,-; ? __switch_to_asm+0x34/0x70=20
> 4,1376,538395185320,-; ? __switch_to_asm+0x34/0x70=20
> 4,1377,538395186078,-; ? __switch_to_asm+0x40/0x70=20
> 4,1378,538395186859,-; btrfs_log_inode_parent+0x2a1/0xac0 [btrfs]=20
> 4,1379,538395187644,-; ? wait_current_trans+0x2f/0xf0 [btrfs]=20
> 4,1380,538395188379,-; ? refcount_inc_checked+0x5/0x30=20
> 4,1381,538395189254,-; ? join_transaction+0xec/0x410 [btrfs]=20
> 4,1382,538395190159,-; btrfs_log_dentry_safe+0x4a/0x70 [btrfs]=20
> 4,1383,538395190901,-; btrfs_sync_file+0x1cb/0x3d0 [btrfs]=20
> 4,1384,538395191826,-; btrfs_file_write_iter+0x495/0x590 [btrfs]=20
> 4,1385,538395192631,-; ? apparmor_cred_prepare+0x4c/0x60=20
> 4,1386,538395193334,-; do_iter_readv_writev+0x13a/0x1b0=20
> 4,1387,538395195201,-; do_iter_write+0x80/0x190=20
> 4,1388,538395195877,-; nfsd_vfs_write+0xe6/0x450 [nfsd]=20
> 4,1389,538395196537,-; ? do_dentry_open+0xd1/0x330=20
> 4,1390,538395197182,-; nfsd_write+0x88/0x170 [nfsd]=20
> 4,1391,538395197785,-; ? _cond_resched+0x15/0x30=20
> 4,1392,538395198386,-; nfsd3_proc_write+0xc3/0x170 [nfsd]=20
> 4,1393,538395198980,-; nfsd_dispatch+0x9e/0x210 [nfsd]=20
> 4,1394,538395199561,-; svc_process_common+0x4a5/0x720 [sunrpc]=20
> 4,1395,538395200128,-; ? nfsd_destroy+0x50/0x50 [nfsd]=20
> 4,1396,538395200682,-; svc_process+0xb7/0xf0 [sunrpc]=20
> 4,1397,538395201219,-; nfsd+0xe3/0x140 [nfsd]=20
> 4,1398,538395201742,-; kthread+0x112/0x130=20
> 4,1399,538395202263,-; ? kthread_bind+0x30/0x30=20
> 4,1400,538395202776,-; ret_from_fork+0x35/0x40=20
> 4,1401,538395203296,-;Modules linked in: vmw_vsock_vmci_transport vsock=
 coretemp crct10dif_pclmul crc32_pclmul vmwgfx vmw_balloon ttm ghash_clmu=
lni_intel ppdev drm_kms_helper intel_rapl_perf joydev pcspkr serio_raw dr=
m sg vmw_vmci evdev parport_pc parport button ac nfsd auth_rpcgss nfs_acl=
 lockd grace sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fs=
crypto ecb btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc=
32c crc32c_generic sd_mod sr_mod cdrom ata_generic crc32c_intel aesni_int=
el aes_x86_64 crypto_simd cryptd glue_helper psmouse mptspi mptscsih ata_=
piix mptbase scsi_transport_spi libata scsi_mod vmxnet3 i2c_piix4 floppy =

> 4,1402,538395207304,-;---[ end trace 4eda186227cc8ba6 ]---=20
>=20
> #uname -a=20
> Linux nas-201-b 4.19.0-4-amd64 #1 SMP Debian 4.19.28-2 (2019-03-15) x86=
_64 GNU/Linux=20
>=20
> #btrfs --version=20
> btrfs-progs v4.20.1=20
>=20
> #btrfs fi show=20
> Label: none uuid: 1388dd44-f704-42bd-bdfd-95f2b43af671=20
> Total devices 1 FS bytes used 2.95TiB=20
> devid 1 size 5.00TiB used 3.35TiB path /dev/sdb=20
>=20
> #btrfs fi df /data=20
> Data, single: total=3D3.33TiB, used=3D2.94TiB=20
> System, DUP: total=3D40.00MiB, used=3D416.00KiB=20
> Metadata, DUP: total=3D10.00GiB, used=3D7.21GiB=20
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B=20
>=20
> #btrfs check --readonly /dev/sdb=20
> Opening filesystem to check...=20
> Checking filesystem on /dev/sdb=20
> UUID: 1388dd44-f704-42bd-bdfd-95f2b43af671=20
> [1/7] checking root items=20
> [2/7] checking extents=20
> [3/7] checking free space cache=20
> [4/7] checking fs roots=20
> [5/7] checking only csums items (without verifying data)=20
> [6/7] checking root refs=20
> [7/7] checking quota groups skipped (not enabled on this FS)=20
> found 3244857946112 bytes used, no error found=20
> total csum bytes: 3160375372=20
> total tree bytes: 7738867712=20
> total fs tree bytes: 2187886592=20
> total extent tree bytes: 1546764288=20
> btree space waste bytes: 1368283474=20
> file data blocks allocated: 6333316149248=20
> referenced 6330266890240=20
>=20
> #btrfs scrub start /data=20
> scrub started on /data, fsid 1388dd44-f704-42bd-bdfd-95f2b43af671 (pid=3D=
887)=20
>=20
> #btrfs scrub status /data=20
> scrub status for 1388dd44-f704-42bd-bdfd-95f2b43af671=20
> scrub started at Tue Apr 16 11:06:49 2019 and finished after 01:27:55=20
> total bytes scrubbed: 2.96TiB with 0 errors=20
>=20
> #btrfs device stats /data=20
> [/dev/sdb].write_io_errs 0=20
> [/dev/sdb].read_io_errs 0=20
> [/dev/sdb].flush_io_errs 0=20
> [/dev/sdb].corruption_errs 0=20
> [/dev/sdb].generation_errs 0=20
>=20
> [dmesg.log file attached]=20
>=20
> Cheers,=20
> Greg=20
>=20


--XQICSbrWZTbBnCL4k8ijiiHIwCcYlAqfD--

--tq6vkGuX8dnfrCc6wIllqJJOTcaGIifmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzAW6YACgkQwj2R86El
/qg4Kgf9H0WTOmB2hB87LtHRSu83tVOMEnHzuz0lNAM0qF46lPBrkGvXpGnBs3fh
hta/lDmZlAY9dlDnZaDdYY7IfKl2qjqCbmePYSGUNz+iRLP4nCFctsx4Wt0rats8
TbOYyIUen9PggFtMl2HQUAWThz6+4NDO/vnV1ZspS/rbk4E7mlGHYgyylB3Yo/bE
dmMbzSvPIyaiac2W2Rcuk9DLjT/2X/d1wVDuk8wQCHqh3N7WfdOc+o8vwDbrej72
zAvTvFy76+gjeuABvl0iGXU/jtiLTHJxsp9wKlZwG+DnxobaGI6fzd1CmURVm8Uk
SWrmV0O+kGrEX4xiy4/HD6Sf5DnERA==
=vTV5
-----END PGP SIGNATURE-----

--tq6vkGuX8dnfrCc6wIllqJJOTcaGIifmd--
