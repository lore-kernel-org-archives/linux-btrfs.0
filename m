Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978E22BEC2B;
	Sun,  6 Sep 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788736218; cv=none; b=b6jlzgKlAnOYf74tGDGIAB5ksAolpJ4D6G2MtqzqwAUsOnqSlXcY2WYIoHRm4P1DDxd2F485sbKyWk9b5t7tAcYPAGcJD2Vt4OLsfD8ZlMcC0ucvadNdAE2OPdpZfwiZ3LFTdBL9P7XXL1W2OVvCBQUD5xx/Rt4s30npfow2sYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788736218; c=relaxed/simple;
	bh=8CSDPfM2ZRhMsIBRLVMAIsZXejFN6XeS3Gp3AF09GDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NoiTcd/9sd0tIIg9crlfZC4IONrXvDyOOejpVuRp/MRquZLeL+ajJBVuIP9axe8qKZ4yqtqf5XsBV/L1Nbgpn+jnI2wFsROGYdIY/k9Gdpjv8W/9IWDpXwFdno9Gm5OGM8naGWEFNsNlSudwVVs+geiGV1YP1jvEFci4Ik9NwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=GHgCjftC; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="GHgCjftC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788736207; x=1789341007; i=quwenruo.btrfs@gmx.com;
	bh=eALVDwFAEmKsCXEjlsBX1X+LKTHtR7CRPXomGkElQjQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GHgCjftCWvKoL3G/6gyNko4wHewwbKpIIfZ5vh7h3D7HQP7d7AAv2b9k6xSelhFz
	 pmWQ/V5NdCFcYIV0Ek6tUjjG+37HlhfkXhqsm8eSuKmBMvmLlcMOpKDo//epU6X88
	 OJ1+6QjJpiMBNsiAyNROv+/wbedq+sh8WrHgL+On9yeBeGW+VvB512S/eNAvK5UV+
	 gN6jv2QPWMEytvt5uM3sa4shAAxfYcEVQ9wlbI7Skl9RxNVuu4iiJ4ixii+M3H8sC
	 +JFG+aS1YxNxjXCye3UiprUlh5iAdVtrAtgfnuuDoSDlzpQ7zpadlTyutEFSGCSVZ
	 ugq7YcFD8eeIDoGRGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MS3ir-1xRjPg07Q3-00RHEa; Mon, 07
 Sep 2026 01:10:07 +0200
Message-ID: <e626273b-b3a4-4ba2-a95d-8c56cc16529b@gmx.com>
Date: Mon, 7 Sep 2026 08:40:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] btrfs: keep the free space cache inode mapping at
 order 0
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-8-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-8-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hGU30jl/yzY++5GOhpeFoEodlhWFvT4CaqcOYYg5f/xEIGsuBlU
 3xH840Jnmb0d5E9KZ9c/xfuptg36kI0s+cu4LNmc8RyEA3qfQQYCR2FcH/nqEc4zbN2TUNt
 VxpWzOBvyncozEfx7/yaEKKugVibIk5HBKqufBcJZQv1WDHbWRB7Fto8ovjReuLydY7rNWl
 /QRE4Kv5mAX/cXbvfjPqA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bBAOfJPICPU=;mmAQcFmcEXclBTpjWBgPbHUK+89
 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
 uYneBb07ahHsETxRPfnL6q



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> The free space cache inode is a data inode, so the read path enables
> large folios on its mapping. The v1 cache code assumes one page per
> folio. With a large folio, consecutive __filemap_get_folio() calls in
> io_ctl_prepare_pages() would return the same folio and deadlock on the
> second FGP_LOCK.
>=20
> The v1 on-disk format is PAGE_SIZE granular, so keep the mapping at
> order 0 rather than teaching the io_ctl code about large folios.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

V1 space cache is already disabled by commit 545e560a5b0f ("btrfs:=20
disable v1 space cache").

I do not think you should add such check for things that we're already=20
planning to fully remove.

> ---
>   fs/btrfs/btrfs_inode.h | 7 +++++++
>   1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 89e5e9c0c904..5d85aa69db13 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -502,6 +502,13 @@ static inline void btrfs_set_inode_mapping_order(st=
ruct btrfs_inode *inode)
>   	/* Metadata inode should not reach here. */
>   	ASSERT(is_data_inode(inode));
>  =20
> +	/*
> +	 * The v1 free space cache operates on PAGE_SIZE chunks and assumes
> +	 * one page per folio. Leave it at order 0.
> +	 */
> +	if (btrfs_is_free_space_inode(inode))
> +		return;
> +
>   	mapping_set_folio_order_range(inode->vfs_inode.i_mapping,
>   				      inode->root->fs_info->block_min_order,
>   				      inode->root->fs_info->block_max_order);
>=20

