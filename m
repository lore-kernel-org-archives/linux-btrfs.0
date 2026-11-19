Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124123;
	b=jhrawj+glJFseyKigwvLjOePJ9K3O6+Hx205j3dYdeu4dKsKtadFuuWsHBkZL9gBMRCE
	 2FtxDOn7/OF+GuM+600YRBB3TqlK26wvOObHf1szOV+p3PLNCqaji1PqFgaxLeLJl2Ly8
	 hD5uKN/gS2QG9sZ68PGYHVXysaEY3Rl//Zcx0FSCwSkWL4uH3O+2hIRZLfVXgnfB0/94o
	 E9P6dwxlLCFgYumQuxBXOGqCk9/UAjmIB0i0gowcVuBV/NK2tyhCbnWzyIs1WzfognYiB
	 DANW0LktN3SBMpQ+D1HCTiG7/KhaTGehOktN4/52lqghdFclfTVXN2aM8GX0iCrIHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124123;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Oklg0jRwIDPcvM/KAFFzlTO4uZslxRFYb6ALkSbufLs=;
	b=FTAeanaxLWmhHG6Rhv8yhARKOV1OFZ7E8ReIEYhDz9XYXUF53OZK5qgepNJVHG8h4nAG
	 bPLYXBy4vMA617VjuQmgZwZ5bxotBpAKs/ldiWmoX1VJJY30j5C3lz/JT8i8LpjwLDx6b
	 Ppnahra9WuTPbafzKpTtARgSu6JAmYo20/bqyWzbXJAUMIn+7/zWsLymNcukJuuBPptYB
	 KJzqod1qH4m1V3+IsLKGWrMFUCDqWUPEDV5mAqaVND5ZlL39UPJs6VjVRhDJaGQBKLgaG
	 LrZ77Ttv6qarAdLALI7bVBUtZVUI3Xh/d1ZF//QPo8SSS1gSWaKwV/0QkO9YkRl5tAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=d3MIBXhm;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B48606A324
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5B48606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=d3MIBXhm
DKIM2-Signature:  i=1; m=1; t=1795124119;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:XPRvkQnGfJL1ctoZ5E7OhOa+R54U
   uxkZMRwcIqL/cvUvL5AH1WSepc2Jx8yY6MLum/rSpSAGVdkJnMm2tzSfI2XUV68QeQOu0p/OhWE
   RfvjcHu0Hmc0oiEkl/PMb9FUTq+GAcpedu1UKFlU95iKFPoGwh34Qak+VmbLcRW5XSFj/oEfb7X
   n4cwHRkWCZ3Mv4VZzu2k3aHYdN0dZTZ4Tywhwz2Yak+PXrhARTKct8kFO8WmOLByLjzKRtkIEQr
   2osTVx2DvB14LMqjuEyoxfj2gEt/i5S24VmLKApDjH8A8OqvJGoxPqlpKQEWRu++eqB8w7bPXOq
   ZQg8aAsSL64kJg==;
Message-Instance:  m=1;
 h=sha256:
   j0iHMdOVH9DlnHk13SmGJb1cMUMadTj1Jqardc3Xdbw=:
   XqUz3TE7AL59krobLqQTF94XlzH/etFlwzL+3GsOM6Y=,
  sha512:
   SuTNIPtKVyV2loPWBFQvCL7Q3dMyPmJNpCdhw13jrrPQEhaX/ThuahcXVirv/9wHWoWonS1cVhtp83R03+efvg==:
   RfVX0M6fjww+c9LfuZQTJsaaCAxXua3pmj1I1ZzgWpmMez4CP3NHqNcdmU5ILygQBSU4BOM1ADylkSvZpQnIiw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795124119; x=1795728919; i=quwenruo.btrfs@gmx.com;
	bh=Oklg0jRwIDPcvM/KAFFzlTO4uZslxRFYb6ALkSbufLs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=d3MIBXhmvWdvtaq17Bp5dmQcZIGSb+1aBLaf/m3Dj8I2ZcGPMIrgnz3N2XQpE/uu
	 ERWw7br+bzbJG3rJQu9zStEozSMi4bvtUe8vJN08ne8P+7kJVwiJxJre8HcOoMj/g
	 +ol3t1jM6i7drHbVMjzyqDUjXQzmRhG1c9cTFTRNz1a9SLGRCzqUwAoRRoj4dUxdH
	 107vX5LL90iYD2N2w+hkGDec/crphNNDjLQf3xoSWJSP8QdH43wVFQr37HCdyhIAj
	 7mW0UQsTCbyaTJST30KyXOUJlP0JN4gOENfJV0+MnN0bkiJZZxhIxP+sYtc1qx4XX
	 aAFi+SN7+6/CnkWWDw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNbox-1x54Q93uVH-00S4Ca; Thu, 19
 Nov 2026 22:35:19 +0100
Message-ID: <08291c32-8b34-4a45-92c0-a7328c451c0b@gmx.com>
Date: Fri, 20 Nov 2026 08:05:16 +1030
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
Subject: Re: [PATCH v2] btrfs: wait for async dio before dirtying folio in
 btrfs_cont_expand()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <a6b31fe34ababf35e0d9577589890ad637b09e20.1795104168.git.fdmanana@suse.com>
 <4881e4e5790a35e6e14af30198f4c83ae063dd6a.1795106352.git.fdmanana@suse.com>
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
In-Reply-To: <4881e4e5790a35e6e14af30198f4c83ae063dd6a.1795106352.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Y/QdOqHpcj0aWpdZSH/nBBzc2M9kis63vbDY0d4PuOlH7R0Lqhb
 mKrdBK1w+DXFe+Mv9IKg0tnzjj5SbwcWUhQQAlv/Z9r++63OcfJlYFXoLx4DnzbyOK0Z1lS
 hLpIF7onU9WLLb6AguN7jgsn2J5QV/rKKl19MyIk21sllv789GE1G6N++U9Hl0Axn2r8w6A
 A2JPj9F5MRZ/q/O+nbpiw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:B2ujl6MHWog=;+Eqfy4W5ZlhJd8U7Uze078CulDe
 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
 aJ1mol/s2Mh9R2J



=E5=9C=A8 2026/11/20 03:15, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Sashiko reported that we race with async direct IO during fallocate and
> truncation (to a larger i_size). For example for the truncation case:
>=20
>           CPU0                            CPU1
>=20
>    btrfs_setsize()
>      btrfs_cont_expand()
>        btrfs_truncate_block()
>          __filemap_get_folio()
>          btrfs_folio_set_dirty()
>                                    iomap_dio_complete()
>                                      kiocb_invalidate_post_direct_write(=
)
>                                        invalidate_inode_pages2_range()
>                                        dio_warn_stale_pagecache()
>                                          --> calls errseq_set() on the
>                                              file's mapping
>                                          --> triggers a warning in syslo=
g
>=20
> The warning is annoying to have in syslog/dmesg and it's something not
> expected, but having errseq_set() called on the file's mapping results
> in the next fsync to fails with -EIO (returned by the call to
> file_check_and_advance_wb_err() made by fsync).
>=20
> Fix this by having btrfs_truncate_block() call inode_dio_wait() when we
> need to zero out the head or tail of a folio.
>=20
> Sashiko reported this for fallocate and truncate and not for reflinking
> (for example) because we have already called inode_dio_wait() before,
> through the call to generic_remap_file_range_prep() from the VFS layer.
>=20
> Link: https://sashiko.dev/#/bug/linux-05440703-4fc3-41f8-a693-9ffe4d9f44=
26
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> v2: Move the inode_dio_wait() call down the call stack to
>      btrfs_truncate_block(), to avoid similar races in other places
>      that call btrfs_truncate_block() without going to btrfs_cont_expand=
().
>=20
>   fs/btrfs/inode.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b29b82eb180..347e5e295fa7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5047,6 +5047,22 @@ int btrfs_truncate_block(struct btrfs_inode *inod=
e, u64 offset, u64 start, u64 e
>   	if (!need_truncate_head && !need_truncate_tail)
>   		goto out;
>  =20
> +	/*
> +	 * Before zeroing the tail or head of the block, wait for any async
> +	 * direct IO writes in progress to complete, otherwise if they complet=
e
> +	 * after we dirty the folio, they will trigger a warning when trying t=
o
> +	 * invalidate the page cache and call errseq_set() on the mapping (whi=
ch
> +	 * makes the next fsync fail with -EIO), because the folio is dirty:
> +	 *
> +	 * iomap_dio_complete()
> +	 *    kiocb_invalidate_post_direct_write()
> +	 *       invalidate_inode_pages2_range()
> +	 *       dio_warn_stale_pagecache()
> +	 *          --> calls errseq_set() making next fsync fail
> +	 *          --> triggers warning
> +	 */
> +	inode_dio_wait(&inode->vfs_inode);
> +
>   	block_start =3D round_down(offset, blocksize);
>   	block_end =3D block_start + blocksize - 1;
>  =20

