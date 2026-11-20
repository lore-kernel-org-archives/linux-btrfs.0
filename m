Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205915;
	b=YQFWfnvW/zsnC4mPbsrO76UfCelcNDp+EsSxkz8r+h+/OIue6AFKzQgZdmYPdx6EOdyK
	 KAZyMDd0DooIE8b0NrWemiXaYqnhlaw30xInenpQutNBTPio1nZ51huXzRXwayxPCqosa
	 qSCs2g5VAvDwl4JK0VLJPnoyiJtd6Dz3jVRLgLBSCHg3lDb6poPhH90rOwe7hAV8Ui3UY
	 CQd7xwxUgRGqaGF4/QYLm8fG+KkqZMeB8LIbbLwnPvw93JKJyDxcAWFAfq/+cDilN8vty
	 GY7rF7EUZmSAopUOsYLgodDaDLiuojH3xe+tw3VWchkfX/3w7lYpS4xzr2BTr0gjNkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205915;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=93CWF9aoISl1WjMy8eWurmjerA3od0clrZgmMj4rjNU=;
	b=1jouPiLqw0tJ4w/B2kURgKGIlSLEhmU8Rwi+iITxasD2pqV07v818zqp4lC1GmXgvEtx
	 Om7aaI1g8LckDHcpopRYom9HdJj5lAL9c467WyOMRjCDqPkZsoZlZ/RpH4goyOL1we+yR
	 GzmhY1Mnda96wYJAyCtvFcT26zDe/8p2FZNhDTBF28wirSgTeEJZkCIX0J5G0amSU1nNv
	 kaNOrLyuVGS2D+x5SZ3MjnEjgsY2R/4URP7yr0hQ74A4/IFE/55ed3QsajBQptnaE5VaX
	 V59dps50+xDKXJlF98eYx67xZNqDCZ22Wr0OUvp5DMOrvuvYKNK9LUx665urwew/YnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=snixm2vg;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA3606A6DB
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AEA3606A6DB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=snixm2vg
DKIM2-Signature:  i=1; m=1; t=1795205902;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:DbK+ATpf45LjFGX7osEXa8HYxMOH
   4r9WpOvrvFXQhLRl4meIvLLAckkkgyOxr9jMU7iRctqv71AwEBF5eGE4iBNaefwDeOBmJRp3Fsk
   9CrDMKissdngSoGzcIZd8FUh9NYGkwLaLZKlO95HsKUzZnrDsSrsXADLiwBKJ7yXwVuqW7aM2s9
   O3Qcbi5G4yFKQKYFEU4SB/bG2+z9zX2QQDchrAdo5v06BnhiZLkSckCAJ1YHs0OZl++xPSSJ3Cy
   2reUi4by8E+ADlj11C+fl9pRa1yqpdX08wLdXYaD7aquCtO+Y7Q/oi0xeF9SiftQUAP/IFyiZ7E
   sbKPJGJG/6dSMw==;
Message-Instance:  m=1;
 h=sha256:
   /TEm8L+Kyq1kcTIt1bq/OeTqBYFgoyna5Cs78p0nrXE=:
   QhFEgs7EdKL9zOoKpSY9FqRlYbGjsVN0n32dnoAFCeI=,
  sha512:
   MgMokvIx5kwAiholrMOfj/pZtLJw0p7WH2Wyx4fMKcLT1WogerbqaEowx1/ci6sJN7Xcpyol5LBDKF9w3PFKpQ==:
   fUY5H9TIFXZRcMLBxjSNl4UNN8QsMXNa8k7d2rt8SPK2cTyuDxeO9QLA3RykitW/2xy3T1aYyH+Oa7/ZVENl6g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795205902; x=1795810702; i=quwenruo.btrfs@gmx.com;
	bh=93CWF9aoISl1WjMy8eWurmjerA3od0clrZgmMj4rjNU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=snixm2vgiCB2LZQJX3O3DOy9qoW93zvbgTbKBhfn+BcmQvnXGWUqGywPFSrY8T3S
	 3zH+SQGqg/gqCBki76WCyiUtQ3S+1JNSGUJsU3D+bGSA0trU3M/BFC+FWG32xCVUg
	 J2DR7XBZr0jkheKDGhdmSnUpVAY3FgPZHU0aKawPL07udRxLJFORYLBMemhG8TCx4
	 T3foX+20OYrMtNsXPzf48eNtvFQT3a4rfnQncXEpe7Lpfq34a9yioamZr3HkhV6iO
	 1DS0wuKKtINR2wqRECfgNDdKwVuOOA1nS6/xMU50rST4zwA0AcsDmk5FIcEa5OYoO
	 AlERbG62AVhk0DQ1cQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMofc-1xnGvp3kZg-00I6gI; Fri, 20
 Nov 2026 21:18:22 +0100
Message-ID: <b31f4347-c620-41d0-b228-303c738682b7@gmx.com>
Date: Sat, 21 Nov 2026 06:48:19 +1030
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
Subject: Re: [PATCH v2] btrfs: avoid copying too much memory in the logical to
 ino ioctl
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <d20ac8e45fe2df6dbfde223e4a786f2b542756b8.1794928978.git.fdmanana@suse.com>
 <6340b0cbc797d7d9b3920aaac1e93dd85602b6e1.1794929971.git.fdmanana@suse.com>
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
In-Reply-To: <6340b0cbc797d7d9b3920aaac1e93dd85602b6e1.1794929971.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9fm1yqJHTyadGY91i4km9Pu5meVTqpsU51Oe0cTb+ernLpBwmWi
 qVCANXs3f3NpsXgBrf3TJF7uzjWhMEAwJ4JNeoNUJASnSQlVDfFsTlNX/LhXmXfbti4i++v
 PIDDiJFZGCq9P+YIccRHZfclsKdiitY/gC8/U+w5Xk9j0z0fztZDYRbwNX6rylX6mgfEpTI
 RAqvwSBy+AsVooJsycU1g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+Ui9tpBDsYU=;q+3YrxE/t+PSkM2x5KSG/fBay7s
 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
 t4VvtaNpBd0UZCAgE98XHUMSEuMFyeCV7rEn4YE=



=E5=9C=A8 2026/11/18 02:10, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We always copy the entire data container into user space, no matter how
> many inodes we found. If for example the buffer is 16M (the maximum
> allowed in the v2 version of the ioctl) and we found only one inode, we
> copy 16M back to user space instead of just the amount matching one inod=
e.
>=20
> Improve on this by copying only what we need.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Fix the byte count, it's actualy just elem_cnt * sizeof(u64), no nee=
d
>      to multiply by 3, and with with case where buffer size is less than
>      sizeof(*inodes).
>=20
>   fs/btrfs/ioctl.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a4de331c46a5..4271f7a6d48a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3343,6 +3343,15 @@ static long btrfs_ioctl_logical_to_ino(struct btr=
fs_fs_info *fs_info,
>   	if (ret < 0)
>   		return ret;
>  =20
> +	/*
> +	 * Copy only what we found instead of the whole data container. If for
> +	 * example 'size' is 16M and we found only 1 inode, it's wasteful to
> +	 * copy 16M instead of sizeof(*inodes) + 1 * sizeof(u64)).
> +	 * For each inode we find we add 3 elements to the inodes->val array:
> +	 * inode number, offset and root ID.
> +	 */
> +	if (size > sizeof(*inodes))
> +		size =3D sizeof(*inodes) + inodes->elem_cnt * sizeof(u64);
>   	ret =3D copy_to_user((void __user *)(unsigned long)loi->inodes, inode=
s,
>   			   size);
>   	if (ret)

