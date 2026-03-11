Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FC1F4176;
	Wed, 11 Mar 2026 21:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773263325; cv=none; b=tEU2moftRcZM/nX5GoITtsCOUcp2gfAHNuSfKbq6+eY9HcgzQMus8iKnjw+eVJdo1NJoGFA+fF79PxMzwINcPESs9PPNV3vnisge2VeeK+sDXlGY0No5Z4A8vRgCht1qyEKSD0Iatd0ICUAIu+QgUpCjvLzJcLt6GehIUWKArrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773263325; c=relaxed/simple;
	bh=Th02jhwVsTCCiLYgnsXOsURox2rBx7CCaUvQZSW1D7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HuVoQmsNQ9TojWpX+4i+y2LT4M4e2EV5n8mdGY3fk8Y2cKwpH1L8nISTLo+/YRN4Wuhq4HoKvZazJRXbGRo2vFtPXQ70ytkQi2hbR6E8r+RfUjdH1xIA87Zbpvpi1dWeCgCbDsNfBnh/E37CBelqCWtTgwIZOtCGYDcRc9ra4WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=sdTLyWNJ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="sdTLyWNJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773263318; x=1773868118; i=quwenruo.btrfs@gmx.com;
	bh=BtX6ZI7hjAl0NFjAjFE4PA5pJP8m7/9CFTkmoWYSIec=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sdTLyWNJDBQv1eEBns8aRGfOuy8gfcQ0PkqOmBzsc7zaDnOLxmPaXLcFX+WgDmoe
	 jAnNfXmKUoHAnHBcDMMYXmm6AvjGFrDLYvG7KLhpZNDBijjQ9UxcuwSDqrTV0/WHE
	 9mwDo3N+V8FGOS9Avb6AcMsaYZnjw0o5uF33LS+XKkDNxe2+Bu/oJXWmOTzrx67tq
	 dbRwT5SjOEVYTNiX8CloPRfpM4WiOooCZPWlDpH+LvngSD4N4tJA8E51zNTTu4IDx
	 00A8/qUxSBozPCuOpcljQpdiRYdS+MB4u4pG8hmbEB4jZ7DW4lu4rygVpAESfbVUl
	 Nejvn573r7yBmi/1OQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mk0NU-1vKWPU0mam-00p9li; Wed, 11
 Mar 2026 22:08:38 +0100
Message-ID: <849ac4be-b10d-4eb7-892f-4b9ee2ef5cb2@gmx.com>
Date: Thu, 12 Mar 2026 07:38:29 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject root items with drop_progress and zero
 drop_level
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 wqu@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 stable@vger.kernel.org
References: <20260311111632.2836293-1-gality369@gmail.com>
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
In-Reply-To: <20260311111632.2836293-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rI3TWJtxIUnC/jKxAomA6lwPEDj2p/HJ6hSVxy+GTncl8jqTX0q
 UzFlkjpxU6NRgy1bO15clALa+JQQjiQTUSchViBQecvp+dElENzjbyLJFqN3gyLMYdjDM2i
 2z5GjPqEOYRCCpYGrlk6MDgh7SeoLSLP7vts6cgfwqqFTNndXN0dCxVu/BpIe5nt9MIUkm2
 XmuaMBL5RTOoS+4cxkn6w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:usgjAyyweHI=;h89CGTvlmSDlthJ/MlUOQ43Z14E
 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
 Ck4Ksdc3C78Tk76IcaR4NevJ/Wa5ge93w==



=E5=9C=A8 2026/3/11 21:46, ZhengYuan Huang =E5=86=99=E9=81=93:
> [BUG]
> When recovering relocation at mount time, merge_reloc_root() and
> btrfs_drop_snapshot() both use BUG_ON(level =3D=3D 0) to guard against
> an impossible state: a non-zero drop_progress combined with a zero
> drop_level in a root_item, which can be triggered:
>=20
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/relocation.c:1545!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary)
> Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
> RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
> Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
> Call Trace:
>   merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
>   btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
>   btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
>   open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
>   btrfs_fill_super fs/btrfs/super.c:987 [inline]
>   btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
>   btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
>   btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
>   vfs_get_tree+0x9a/0x370 fs/super.c:1758
>   fc_mount fs/namespace.c:1199 [inline]
>   do_new_mount_fc fs/namespace.c:3642 [inline]
>   do_new_mount fs/namespace.c:3718 [inline]
>   path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
>   do_mount fs/namespace.c:4041 [inline]
>   __do_sys_mount fs/namespace.c:4229 [inline]
>   __se_sys_mount fs/namespace.c:4206 [inline]
>   __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
>   ...
> RIP: 0033:0x7f969c9a8fde
> Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
> ---[ end trace 0000000000000000 ]---
>=20
> [CAUSE]
> A non-zero drop_progress.objectid means an interrupted
> btrfs_drop_snapshot() left a resume point on disk, and in that case
> drop_level must be greater than 0 because the checkpoint is only
> saved at internal node levels.
>=20
> Although this invariant is enforced when the kernel writes the root
> item, it is not validated when the root item is read back from disk.
> That allows on-disk corruption to provide an invalid state with
> drop_progress.objectid !=3D 0 and drop_level =3D=3D 0.
>=20
> When relocation recovery later processes such a root item,
> merge_reloc_root() reads drop_level and hits BUG_ON(level =3D=3D 0). The
> same invalid metadata can also trigger the corresponding BUG_ON() in
> btrfs_drop_snapshot().
>=20
> [FIX]
> Fix this by validating the root_item invariant in tree-checker when
> reading root items from disk: if drop_progress.objectid is non-zero,
> drop_level must also be non-zero. Reject such malformed metadata with
> -EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
> and triggers the BUG_ON.
>=20
> Also fix the related tree-checker error message to report
> "invalid root drop_level" instead of the misleading "invalid root level"=
.
>=20
> The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
> metadata fuzzing tool that corrupts btrfs metadata at runtime. After
> the fix, the same corruption is correctly rejected by tree-checker
> and the BUG_ON is no longer triggered.
>=20
> Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")

The only "fix" part I can see is the fix of the message from drop_level.

If you really want to do that, please send out a fix dedicated for that=20
single line.

Otherwise you're adding a new check. Please do not mix fix and new check=
=20
into one patch.

Thanks,
Qu

> Cc: stable@vger.kernel.org # 5.3+
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> Reproduction (v6.18, x86_64, KASAN)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The PoC is relatively large, so it is provided separately through google=
 drive:
> https://drive.google.com/drive/folders/1Rto3DUtjUTOg3bjFeH5G2Kl8Li6OuzsG
>=20
> To reproduce the issue:
>    1. Build the ublk helper program from the ublk codebase, which is
> 	 used to provide the runtime corruption capability:
> 	  g++ -std=3Dc++20 -fcoroutines -O2 -o standalone_replay \
>        standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
>        -I. -Iinclude -Itargets/include \
>        -L./lib/.libs -lublksrv -luring -lpthread
>    2. Attach the crafted image through ublk:
>        ./standalone_replay add -t loop -f /path/to/image
>    3. Mount the image:
> 	  mount -o loop /path/to/image /mnt
> This reliably reproduces the bug.
> ---
>   fs/btrfs/tree-checker.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index dd274f67ad7f..a8c568b10432 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1256,10 +1256,27 @@ static int check_root_item(struct extent_buffer =
*leaf, struct btrfs_key *key,
>   	}
>   	if (unlikely(btrfs_root_drop_level(&ri) >=3D BTRFS_MAX_LEVEL)) {
>   		generic_err(leaf, slot,
> -			    "invalid root level, have %u expect [0, %u]",
> +			    "invalid root drop_level, have %u expect [0, %u]",
>   			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
>   		return -EUCLEAN;
>   	}
> +	/*
> +	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
> +	 * interrupted and the resume point was recorded in drop_progress and
> +	 * drop_level.  In that case drop_level must be >=3D 1: level 0 is the
> +	 * leaf level and drop_snapshot never saves a checkpoint there (it
> +	 * only records checkpoints at internal node levels in DROP_REFERENCE
> +	 * stage).  A zero drop_level combined with a non-zero drop_progress
> +	 * objectid indicates on-disk corruption and would cause a BUG_ON in
> +	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
> +	 */
> +	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) !=3D 0 &&
> +		     btrfs_root_drop_level(&ri) =3D=3D 0)) {
> +		generic_err(leaf, slot,
> +			    "invalid root drop_level 0 with non-zero drop_progress objectid =
%llu",
> +			    btrfs_disk_key_objectid(&ri.drop_progress));
> +		return -EUCLEAN;
> +	}
>  =20
>   	/* Flags check */
>   	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {

