Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539631;
	b=vXnb1kBt09ujLSLHxxKptXlsZKd/J5ZbLuxRLf5VKH5rSxvyoyKCd8BBJ2B4J2po2Ort
	 HhwskgKmgvZ+Y3bbCOvs3AMpZJTFBivksNR1Os7+juJGaoNYz8UtVFvkC7DEV2jBln3jo
	 6YCPsgHtrneMIXZYI3TxSS/z20wk4GJllbXwn7cB1NNLYsOmcaSglkg1xS0H09a101SsV
	 d8lXWfWT/xMpCx75IUvtFrkwTqz9+zEIjD5sRjgZ42hykRhQqmTAwekP28ra+eqWfgT+F
	 d8AhjRzCdDeL2+LE6G01VKYoPttZnVwKroa8RxAdCGmA7FYEWl6aAW5VYvLlobvg4rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539631;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=XHKU0Ne7pUS7jNU5Y/0TnEppXP8hVjYRsCtTo9RheA8=;
	b=ur40RgTydT3q4WvCD2la6Ivo5YwZwexWbNYPgpQk5GV71QS/H5BRTEGQp9fcEzGqIL6k
	 Z2QBwSNLvswfxTJrW3lbBmYBeupph2izAGYCMEkvDtb9zK18u1uDClGJCAqJZw4Lp13Wl
	 aUFXQ6vbqs++URScyWUAnbi5EidgcD6knPbW2UVa+lBZc6zhfDCnHavW5L/rilvjQk28J
	 ERiw+MKkGVE+fyRMW7BavBBKcc3pFCifQ75dQ/QSXL4R0r/cAVhKt1v9DFN6qgFRtSiKN
	 hDEPS5X0LSaC/igvPRzTiD5jo0wy5JIUHLWxMtRAnWv5j/xD683d3YWqUDgmDKTONEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="Wrj0YbK/";
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC4606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 03:13:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBFC4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Wrj0YbK/
DKIM2-Signature:  i=1; m=1; t=1794539628;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:eyhsvQMHFLNi8DrBJYGsp5GJ6Hig
   NaDhXIzi1VgGKK/ojY51jxwzHCyr4+TwMkMYZ0Ajw+SazpMd1U+4n3cQ1T+A6+7f6KADPNLq8LP
   /PDEWFKBKprkeQ3UePxIJpUy7uLGiwUjYdSnPcqqiibzxVKRJETriLeCQzVk8/yW6cx+cNFkyzw
   nzzd/QJN5y2awIhR1qBiAmLuPtGWBJOEWkBDjOR/uIfCKIu9i0n6Yz12nzyPQ47RMm6tW0p6DmU
   f8zc0Q+KD2EtJ8eqswEsAQJ4+JwRby9y0FgaDbbU5ECGPy1iCIq/rS6eSBJ2uwnz5PZpQ54GITV
   qfFV8xIm5G+rhg==;
Message-Instance:  m=1;
 h=sha256:
   KpNk3ytzDguPlThkr60YTd+3FphqQS3mwc1BNuooccg=:
   MlxKMuaJ3OhCG2HXa9HOZNxcfkVZ+Q7DnrT+dXZcLIs=,
  sha512:
   JUtjU+R50kZacXMpVf9kpdVn4l13F+JpVM9G8LKqph4IxRiUeES56MoS4+kS7cIZS6o/gHl3150L8YBZUnBTHg==:
   aXNWmu0GWwv1h4VK4fzW+sUrIrKsGdYSC1s26VibK/GdJePpa+nvzSqXt0NYQnfB6VK2lE1KuUKgfY6DJJheDw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794539628; x=1795144428; i=quwenruo.btrfs@gmx.com;
	bh=XHKU0Ne7pUS7jNU5Y/0TnEppXP8hVjYRsCtTo9RheA8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Wrj0YbK/xbvG4OKlNe0AsF9wHpPBM59SKsIpiKD1koRcscBD6P6qX9PCK2jdsjAV
	 p5K6YhD8mf0sAlHPoz7D2vXq9AR6vxWO1MW5KrvXmsqgXpxY1O7q4/k9IaK40RXlx
	 oXSo2S+GUJ1AnAPS3l1ykeGoH1WxhiilzEJdXlByMCdc+39fLkClcnS4ZxD+koSeB
	 3HhJXq+WeByTNgu8XWjiNakrZBt4CdMovtU8NILLzdw90uxDKMPXEIO58q7bZ8K+T
	 UkKtkamKKZik7voWfWFQHw+4+JW/3uXCr3xtfHtoB99qcGKbt+BVlhoV7jU/gEW1f
	 HLFp0k1ginJ66MYHvw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mj8qj-1wnASH0QwX-00kR4G; Fri, 13
 Nov 2026 04:13:48 +0100
Message-ID: <cc63fc94-e99a-42e9-965c-6b138b0760b2@gmx.com>
Date: Fri, 13 Nov 2026 13:43:45 +1030
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
Subject: Re: [PATCH] btrfs: fiemap: deal with inline extent in
 fiemap_find_last_extent_offset()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <dc3e7e3972a3d82ad871c53418a646498204400d.1794504751.git.fdmanana@suse.com>
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
In-Reply-To: <dc3e7e3972a3d82ad871c53418a646498204400d.1794504751.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:igek2vzbmtIzH0E0zyllAalrdTOclQmc8TBhymlB2k5GGSh7O9T
 HJE3NQWT9zmAebO4P6dO9UJhZM/R6sukHDM3niNGQgACl6jlfUjqO+9Bp6A2R/Ndm1L7SR/
 jx6btZV6pq438f94nq0bgrIAtVm4hzHs0GRoHdiDNiOnN9z8atyrQZlUYmMQs1Q0a5zKcnb
 OKySdatd9Y61HIJ9X3W9Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NnuhkuL+r3M=;JS5dfB4KIzfE74syYrFq5v5Udtg
 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



=E5=9C=A8 2026/11/13 04:03, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> In the while loop that finds the first file extent item, counting from t=
he
> end of the file, that is not a hole, we are accessing the disk_bytenr
> field of each file extent item, which is wrong in case we have an item
> that represents an inline extent. In that case the inline data starts at
> the disk_bytenr offset and therefore we are reading user data or in case
> the inline data is less than 8 bytes, we are accessing another region of
> the leaf or even beyond the leaf boundaries in case it's the last item.
>=20
> This should be a very rare case, as it implies having an inline extent
> followed by a hole file extent item (the no-holes feature is not used).
>=20
> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate rep=
orting extent sharedness")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/fiemap.c | 2 ++
>   1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index 817171028413..285398eb36dc 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -621,6 +621,8 @@ static int fiemap_find_last_extent_offset(struct btr=
fs_inode *inode,
>   		leaf =3D path->nodes[0];
>   		ei =3D btrfs_item_ptr(leaf, path->slots[0],
>   				    struct btrfs_file_extent_item);
> +		if (btrfs_file_extent_type(leaf, ei) =3D=3D BTRFS_FILE_EXTENT_INLINE)
> +			break;
>   		disk_bytenr =3D btrfs_file_extent_disk_bytenr(leaf, ei);
>   	}
>  =20

