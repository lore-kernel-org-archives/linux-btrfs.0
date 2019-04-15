Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D180AC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC2F20693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CGl75Wwa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfDOIpp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:45:45 -0400
Received: from mout.gmx.net ([212.227.17.20]:37323 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbfDOIpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555317937;
        bh=PK8hcfucOy/5e5QfWq9fQIgH0icraP02VRLTuICvfpo=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=CGl75WwaZ+iCSqWcf1/1PFZjg7ObVDzsjxeL+L8k129iCzLUAlKXXsxI0F1QbWDpg
         vbC2Qg40dnFQu943lSfdP27uxZKlgC0BtIEM7kZ8ERyvZGADooEAc4biiy5lIGLqMW
         J1AMIrt2Q8B2V5HLVOpPyA4CgXZ9CtYcWYiK0qr4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIyCj-1hIRHl04vh-002VSN; Mon, 15
 Apr 2019 10:45:36 +0200
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20190415082900.2023-1-fdmanana@kernel.org>
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
Message-ID: <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
Date:   Mon, 15 Apr 2019 16:45:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415082900.2023-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SCNbpV0K7yTUTfaXgEtjFFWAwHY3pwXVN"
X-Provags-ID: V03:K1:3E6T31kDHsYuR1wz8du8Z/YAyI0H0MljOIwUJ5Z7+/cxy+xH1lb
 GER4ZsJu40PHYm5qpDByfXi5ljrL3RtvCgRd1FbSf6LVlNRldus/RbLmSYMXjT/fEwtTXev
 ofTUOJsstO+dzuSpgTea8v2H7coImHcr+YlmfOTQzLFIrxmuuyMTXvZGIa+Da5pJk5Y5/M4
 D917H/Rt4iA/bwVw51d9Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+OLrAhReCHI=:48n+OKPPT6JFnsJtQd7FIA
 Ti0sssO/Yop84m4Zt1GYyKDMybhQ/8I8tUcUzn5Wb4x+5Cd8c7RDy5HVp2aHKLBydhOoP+znI
 7wpvvS/KGk5O9aGkTWGlLH7wdB0OQt4kZOh9Ntryds2hYOepreJt+kUaw35FKS93omTSney4q
 3EdizETYdjVb21LSInRCgbdf0cNhVLHS0yI4XItaT/HRdohYgz2jzXIPH0ZEUv99KqcKB15/B
 KjG5H5CyZEhP9LdRZHr30IliZ6wWFtPkUggYHT+749tvnDjP/ObmfwcBMrP7AH9qJplyT6Njn
 Oj0PecAZNNFoUyJIdpz5fe2DZ7i32FMTcB9f81s+F667peI+vkO6Vj4fX816Y/8d1sTDCCKPa
 OkQyRNV+MGiJtlHmudQ5MD41NBuMQjsWhDd3FudW/y0yb/y0i4Pp7XqRYYgqpldyS6yYHwaTR
 gaBVBtSz2p8CIty1qQxV7dlruacZXFYAWob/gUZIFre8cb552ANx5ujqor5lJzMex7FXpGno1
 s1XbeTXqCUXNNzfAA4zEtdPv87VFBXbnMma8xnl5LAcUGsZmQQin/4j6V9GW/XLHRMqmT/Zgp
 VFV4+1lNmyEVTcnOqG5v3ibeXv7ze6wpPhJ+SIkiFf159aFbx2ia8hmdLX3RmwY/fImJy0+2E
 PLOsBslUSJfcsoOgdPvJIL9sq5L1Iw23KpW42/JJdeoFbndXvZMWgX5QQm1yVsfkN6vL7ud1B
 oprsyjC/xH9iQn7hjcZGyq/NQNHUu5bUY7NDUwVFgRpf1YThxS3F4oWbTEje/Q5yCXoi22Fa1
 JDlo1m9i8gL/CGE4+ELW2VO7W1cEdEUb13V/3aYKoARcwDYS1aKVzUCbWc5yIovpJbf/3C5LR
 AzNnkpQPAhjKZdLBqfCE21L71wENxTXvaotRVTcqb6pr1OTDJT+/8Cb2tRA3zS
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SCNbpV0K7yTUTfaXgEtjFFWAwHY3pwXVN
Content-Type: multipart/mixed; boundary="aEUwmFHVK3XaX8msESVSPdOGqlwH223xh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
References: <20190415082900.2023-1-fdmanana@kernel.org>
In-Reply-To: <20190415082900.2023-1-fdmanana@kernel.org>

--aEUwmFHVK3XaX8msESVSPdOGqlwH223xh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/15 =E4=B8=8B=E5=8D=884:29, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> During fiemap, for regular extents (non inline) we need to check if the=
y
> are shared and if they are, set the shared bit. Checking if an extent i=
s
> shared requires checking the delayed references of the currently runnin=
g
> transaction, since some reference might have not yet hit the extent tre=
e
> and be only in the in-memory delayed references.
>=20
> However we were using a transaction join for this, which creates a new
> transaction when there is no transaction currently running. That means
> that two more potential failures can happen: creating the transaction a=
nd
> committing it. Further, if no write activity is currently happening in =
the
> system, and fiemap calls keep being done, we end up creating and
> committing transactions that do nothing.
>=20
> In some extreme cases this can result in the commit of the transaction
> created by fiemap to fail with ENOSPC when updating the root item of a
> subvolume tree because a join does not reserve any space, leading to a
> trace like the following:
>=20
>  heisenberg kernel: ------------[ cut here ]------------
>  heisenberg kernel: BTRFS: Transaction aborted (error -28)
>  heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tree.c:1=
36 btrfs_update_root+0x22b/0x320 [btrfs]
> (...)
>  heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not tainted =
4.19.0-4-amd64 #1 Debian 4.19.28-2
>  heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS =
Version 1.21 03/19/2018
>  heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrfs]
> (...)
>  heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
>  heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 RCX: 00=
00000000000006
>  heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ff=
ff8ed6bda166a0
>  heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R09: 00=
00000000000007
>  heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ff=
ff8ed63396a078
>  heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R15: ff=
ff8ed6bd03d068
>  heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda00000(000=
0) knlGS:0000000000000000
>  heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 CR4: 00=
000000003606f0
>  heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00=
00000000000000
>  heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00=
00000000000400
>  heisenberg kernel: Call Trace:
>  heisenberg kernel:  commit_fs_roots+0x166/0x1d0 [btrfs]
>  heisenberg kernel:  ? _cond_resched+0x15/0x30
>  heisenberg kernel:  ? btrfs_run_delayed_refs+0xac/0x180 [btrfs]
>  heisenberg kernel:  btrfs_commit_transaction+0x2bd/0x870 [btrfs]
>  heisenberg kernel:  ? start_transaction+0x9d/0x3f0 [btrfs]
>  heisenberg kernel:  transaction_kthread+0x147/0x180 [btrfs]
>  heisenberg kernel:  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
>  heisenberg kernel:  kthread+0x112/0x130
>  heisenberg kernel:  ? kthread_bind+0x30/0x30
>  heisenberg kernel:  ret_from_fork+0x35/0x40
>  heisenberg kernel: ---[ end trace 05de912e30e012d9 ]---
>=20
> Since fiemap (and btrfs_check_shared()) is a read-only operation, do no=
t do
> a transaction join to avoid the overhead of creating a new transaction =
(if
> there is currently no running transaction) and introducing a potential
> point of failure when the new transaction gets committed, instead use a=

> transaction attach to grab a handle for the currently running transacti=
on
> if any.
>=20
> Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> Link: https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926=
f622b3f03a4.camel@scientia.net/
> Fixes: afce772e87c36c ("btrfs: fix check_shared for fiemap ioctl")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/backref.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 11459fe84a29..876e6bb93797 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1460,8 +1460,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handl=
e *trans,
>   * callers (such as fiemap) which want to know whether the extent is
>   * shared but do not need a ref count.
>   *
> - * This attempts to allocate a transaction in order to account for
> - * delayed refs, but continues on even when the alloc fails.
> + * This attempts to attach to the running transaction in order to acco=
unt for
> + * delayed refs, but continues on even when no running transaction exi=
sts.
>   *
>   * Return: 0 if extent is not shared, 1 if it is shared, < 0 on error.=

>   */
> @@ -1489,8 +1489,12 @@ int btrfs_check_shared(struct btrfs_root *root, =
u64 inum, u64 bytenr)
>  		return -ENOMEM;
>  	}
> =20
> -	trans =3D btrfs_join_transaction(root);
> +	trans =3D btrfs_attach_transaction(root);
>  	if (IS_ERR(trans)) {
> +		if (PTR_ERR(trans) !=3D -ENOENT) {
> +			ret =3D PTR_ERR(trans);
> +			goto out;
> +		}

My concern is, if at this timing there is no running transaction, so we
continue with trans =3D=3D NULL.

But before we continue, some one started a transaction and
increased/decreased the extent reference number, this doesn't look as saf=
e.

Or did I miss something?

Thanks,
Qu
>  		trans =3D NULL;
>  		down_read(&fs_info->commit_root_sem);
>  	} else {
> @@ -1523,6 +1527,7 @@ int btrfs_check_shared(struct btrfs_root *root, u=
64 inum, u64 bytenr)
>  	} else {
>  		up_read(&fs_info->commit_root_sem);
>  	}
> +out:
>  	ulist_free(tmp);
>  	ulist_free(roots);
>  	return ret;
>=20


--aEUwmFHVK3XaX8msESVSPdOGqlwH223xh--

--SCNbpV0K7yTUTfaXgEtjFFWAwHY3pwXVN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly0RKwACgkQwj2R86El
/qhL2wf/fYB9R87v4aEMrwexI6fj7EjFDRr7XOV1Kw/u3KUZQRZzXxYYV9VexM2K
fYOxjO+NPPhhxyrv8Pit4zQLeSQl1Ph1emBV2/THxiEO5kQdexs0goZMZqoY8j+v
MwtHK+a2PGYkYy2Ym8CvjM5ZHLwiEdQO1vTvzw+FAYQhbqLMep8XjiTBtxLtiDOK
pBNACurIzWp8eehpAPGwHDq1FODXOhBmr61NkeG4jkHQKKSqXF+uEKe+VH9IOf2b
AdE6LzKP84xXFGquUmbnpqdnJ4zzo5mFHnqQSD5MSppD+FXKnt40qeDw3vgun2Cc
NTgz/0gXp5i5rjUkrukUoRfZqY3beg==
=QONx
-----END PGP SIGNATURE-----

--SCNbpV0K7yTUTfaXgEtjFFWAwHY3pwXVN--
