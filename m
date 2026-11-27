Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795800052;
	b=dMW0KpmJSzyrkTZCM7LHsOiBp2YgDsaBMHBYS6izoQIEtQ6vY8xG/WF9SoMQpEzel7xQ
	 cWBIJXqEy34qtpMfaMApELgx8elQiGtmhmaN6AdNFYBmMq8j+AxeBS/R2Tb1QF/4byKiq
	 b4c5Wnh6/OVwLxBk1Nou60PRbrI+zTuVCbu1MLkMYxL17EfnOyvWlXIIscQQ1Rxk4UKWl
	 Hvcw17LxBBnW+rNj+Fha4UvYyyxfCiQWbSbQ4Mwa22HpIfJ30JpEopPx5gDeRWFUubJw0
	 UDSQxjYjUCOv/+Ys6cKaeAFoMcpcr0YFcpgRAldT8eQ1MiW7R2Bvd9DYzPJ9H0rkSsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795800052;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=5518uRaiYAcfgGomSLC/0QtXxuMjcu7WTODPF/FTBvE=;
	b=WTAOTL+oXO1Bqu55hoo1xlz+iJWiDTNL9OJZYVQROQVQ6cSHlogYgeTLLqQxhl3zDRkq
	 V1543gIzeAo/xgswLn08i1yZs23y2cEdNoLwAKjuhE9/mrxLBEO0EYs3Ok1KDLDQL9pYt
	 L7YXwNIZ2cemfWwTo5xm+reHoPAgxb7i7Z4L3okxMDIw76otd/ZppC5u+yK+ukSWOGm2Q
	 uqae6Ay0Fp8iCRf0VXdQomCsda4khYxK1dN4Rl/TzOrTeGmXi/A4nBVcTguzDf/wz0+nr
	 gUAdFmawY8rVmXy69aQwNtkzGEWYSod8+G9L2eqBkVuS0unfTo6fSKrDB9o58dB8yvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpuHiBJs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840CE606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpuHiBJs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189271F0092B
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795800052;
	bh=5518uRaiYAcfgGomSLC/0QtXxuMjcu7WTODPF/FTBvE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WpuHiBJsHsXaKsL6CRyL2gS44wpFKse8ahuNHpr5Wbo9s8kRvdrcW7ac4EAtGBHaL
	 kBandPZcZJpAYlgAxznNoz1f0pMrjeJF21e8XbNBDbZdfOlqZf/KbLaaSv0cEnGrbh
	 ntFLleKbz4FzklA8rL8vZDmsIFXpnFTs1YuUvqS0Jw4rAxRjxySWCCHVrri9A2iF7S
	 93JZLmWaGMqj5oJThOaiAVpcPz8hiyFSmxGYHoO+DAlTTv9pn5jW8DDhhg7BVmd8fv
	 71e/+QpU0XilclaL2W6mPe/k9VgXJ02X87HKUfzlAwtQ0zZ3QNtep+npFZwxqw/gYn
	 gf693ffUzaDRA==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5ee36376a0dso4571635e0c.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:20:52 -0800 (PST)
X-Gm-Message-State: APuU4Z/PnKIo/Hn/GnqKQsOf2fexf0huBwVzWokjIFpw3dhcfcVUI/db
	nTH+p/THqNtNO3j6lenXNt1IiTg87FFwEyJDfuv9BtXY7PDd5oLyfawXFO4FkSBQkLKQDt9f39+
	qsdk6gUZFU57Kxd9WYr9UQhQIAL0maO8=
X-Received: by 2002:a05:6122:c88:b0:5ca:f811:25ac with SMTP id
 71dfb90a1353d-5ee8aefbb61mr15829092e0c.14.1795800051199; Fri, 27 Nov 2026
 09:20:51 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <TY8P153MB237624AA8DAAC5323DE20B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <TY8P153MB237624AA8DAAC5323DE20B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 27 Nov 2026 17:20:14 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5OMMDJYzHsPiSqQ8pMMQM8rg2RksFncEb82yosKiBL_Q@mail.gmail.com>
X-Gm-Features: Aa3M54piqCF-CDxc5m15NPX1PLDzN8atOS_7AppjviKHHB6pnxHPr5wzAvtSNjs
Message-ID: <CAL3q7H5OMMDJYzHsPiSqQ8pMMQM8rg2RksFncEb82yosKiBL_Q@mail.gmail.com>
Subject: Re: [BUG] btrfs: RENAME_EXCHANGE with a snapshot's subvolume
 placeholder aborts the transaction
To: Tianyu Chen <chentianyu@microsoft.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, 
	"mason@kernel.org" <mason@kernel.org>, Ruize Tang <ruizetang@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 6:31=E2=80=AFAM Tianyu Chen <chentianyu@microsoft.c=
om> wrote:
>
> Dear BTRFS maintainer,
>
> I found a bug in Btrfs.
>
> Summary:
>
> renameat2(RENAME_EXCHANGE) between a file and the placeholder that a snap=
shot shows in place of a nested subvolume aborts the transaction with -ENOE=
NT and forces the filesystem read-only. No privileges are needed: any user =
who can create a subvolume and snapshot it can do this.
>
> The placeholder is not an ordinary empty directory. Its dir item points a=
t the nested subvolume's root item, and no root ref links that subvolume to=
 the snapshot, so lookup returns an in-memory stub directory with inode num=
ber 2 (BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) that has no inode item and no inode=
 ref.
>
> Reproduction (as attached):
>
>   btrfs subvolume create sv
>   btrfs subvolume create sv/inner
>   touch sv/f
>   btrfs subvolume snapshot sv snap    # snap/inner is the placeholder
>   python3 -c 'import ctypes, os; libc =3D ctypes.CDLL(None, use_errno=3DT=
rue); ret =3D libc.renameat2(-100, b"snap/f", -100, b"snap/inner", 2); err =
=3D ctypes.get_errno(); print(f"ret=3D{ret}, errno=3D{err} ({os.strerror(er=
r)})")'

Btw, there's no need for Python to perform a rename exchange.

Just pass the --exchange and -T options to mv.

>
> renameat2() fails with ENOENT (ret=3D-1, errno=3D2), and the filesystem i=
s read-only from then on. Kernel log from running these steps on a fresh 1G=
 loop image (mkfs.btrfs from btrfs-progs v6.6.3, default mkfs and mount opt=
ions; 6.17.0-1022-azure, Ubuntu; the W taint is from an earlier hit of the =
same bug):
>
>   BTRFS critical (device loop8): failed to delete reference to inner, roo=
t 258 inode 2 parent 256
>   ------------[ cut here ]------------
>   BTRFS: Transaction aborted (error -2)
>   WARNING: CPU: 32 PID: 3839527 at fs/btrfs/inode.c:4291 __btrfs_unlink_i=
node+0x3bf/0x3e0 [btrfs]
>   CPU: 32 UID: 1000 PID: 3839527 Comm: python3 Tainted: G        W       =
    6.17.0-1022-azure #22-Ubuntu VOLUNTARY
>   Tainted: [W]=3DWARN
>   Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, B=
IOS Hyper-V UEFI Release v4.1 04/22/2026
>   RIP: 0010:__btrfs_unlink_inode+0x3bf/0x3e0 [btrfs]
>   Call Trace:
>    <TASK>
>    btrfs_rename_exchange+0x744/0xe20 [btrfs]
>    btrfs_rename2+0x59/0x70 [btrfs]
>    vfs_rename+0x787/0xc20
>    do_renameat2+0x425/0x620
>    __x64_sys_renameat2+0x4c/0x60
>    x64_sys_call+0x420/0x20d0
>    do_syscall_64+0x7b/0xb40
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>   BTRFS: error (device loop8 state A) in __btrfs_unlink_inode:4291: errno=
=3D-2 No such entry
>   BTRFS info (device loop8 state EA): forced readonly
>   BTRFS: error (device loop8 state EA) in btrfs_rename_exchange:8285: err=
no=3D-2 No such entry
>
>
> Root Cause, (using the names from the reproducer: f is the file and inner=
 is the placeholder):
> btrfs_rename_exchange() handles subvolume roots (inode 256) specially, bu=
t does not handle empty subvolume placeholders (inode 2). As a result, the =
placeholder follows the ordinary-inode code paths.
> It first inserts an inode ref named "inner" for f's inode, then an inode =
ref named "f" for inode 2.
> __btrfs_unlink_inode(old_dir, f's inode, "f") removes the original "f" en=
try.
> Next, __btrfs_unlink_inode(new_dir, inode 2, "inner") tries to remove an =
inode ref named "inner" for inode 2. However, the only inode ref for inode =
2 is the "f" ref inserted above. Consequently, btrfs_del_inode_ref() return=
s -ENOENT, aborting the transaction. This matches the kernel log: failed to=
 delete reference to inner ... inode 2.
> If the placeholder is the source instead, the corresponding __btrfs_unlin=
k_inode() call for the source should fail for the same reason, although I h=
ave not tested this case.
> In contrast, btrfs_rename() explicitly handles empty subvolume placeholde=
rs: it returns -EPERM when one is used as the new parent, -ENOTEMPTY when o=
ne is the source, and calls btrfs_unlink_subvol() when one is the target be=
ing replaced.
>
> btrfs_rename_exchange() has the same relevant implementation in mainline =
(9437ee8b6cf6) and btrfs for-next (14bf1d1d3641), so both appear to be affe=
cted. I have not built or tested mainline, nor have I bisected the issue.
>
>
> Suggested fix. I used -ENOTEMPTY to match the error returned by btrfs_ren=
ame() when the placeholder is the source.
>
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8256,6 +8256,15 @@ static int btrfs_rename_exchange(struct
> new_ino !=3D BTRFS_FIRST_FREE_OBJECTID))
> return -EXDEV;
> + /*
> + * An empty subvolume placeholder (what a snapshot holds in place of a
> + * nested subvolume) has no inode item or inode ref to swap, so
> + * __btrfs_unlink_inode() would fail and abort the transaction.
> + /
> + if (old_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
> + new_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
> + return -ENOTEMPTY;

-EPERM is a better choice here, since subvolume stubs are actually
dummy dentries that are always empty.

Sent a patch for this here:

https://lore.kernel.org/linux-btrfs/db82ae780edd7572f150da6b25f2fb73af1e31a=
9.1795798503.git.fdmanana@suse.com/

And a test case for fstests:

https://lore.kernel.org/linux-btrfs/35ae48a4921b42b89843f00b24608eba25f4647=
b.1795799439.git.fdmanana@suse.com/

Thanks for the report.

> +
> ret =3D fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fnam=
e);
> if (ret)
> return ret;
>
> Best,
> Tianyu
