Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04650488214
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594542; cv=none; b=M8xmAym5uc26+OFkdhgDtLVtZnkQhidJnlftrCmHaNN4s6vy+f754yf25ixJNm4lRZzJx2nGcsjCiYmCv5vY06Q1VDXQec9GNMcJnn6NW+zQYiMqVQkDk4RCfOCX4lQV0DRTB1QOyDuI7YT/hLUFtI17uhDf5Gt/QXqC3YMaAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594542; c=relaxed/simple;
	bh=nj85QlXiCFevtpleqeGcGg6OREQhI8u79BstLRLI0dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mjn3zdF9fmIundZ8MJ2sInPAuQqcf6C52PA7DssCkVZAA7FI9i0D7nXq625uTctsh35fyPECjmizdRwFzG3Gb2Lm04HkTsU4XzfH/7PSf6349floFPXWdiL3vdMjluRBxoWQ6liaSRU/3Pd1eP88gMh4m0rxSTFaq0DRKv83z2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=eWDb8k59; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="eWDb8k59"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789594530; x=1790199330; i=quwenruo.btrfs@gmx.com;
	bh=Re3G1ykXpr9nEWAsEKS7mic7ZWrGtsE08raO1/E0Oss=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eWDb8k59REFs4L8SmHBTmmHEpJqZ5b7X7CxP6o6OPVOYZ1ihfVCcYeqJTNgm6tnv
	 E7DMG0qDFcZZdlMRukM0TuYlL8SWDPIcb8RVQCuSr/JBDLBd2TafE4sKj9A8bGP04
	 +4DD8n2zRd0vVjEGhAm7pTks8r+c3HgCFzn67X8WKuOT37GoPsnLP4lqFpNPIHorc
	 BDCLLjTGgBcdatB0wyZ/ZiOy1zQlUSsfujhE4dn5bog8lHdzS9QpRQY8CrWmhbBAk
	 WnOgB+gbryAj7McL5/e5oSB7lMB0Rof2B9ZhcRwQladTLQHDMhvZJQHJFs0T4A4mQ
	 JfPT6JFNQheXuJpf3w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N5VDE-1wiSBX1apO-018NNb; Wed, 16
 Sep 2026 23:35:30 +0200
Message-ID: <c610733d-cc94-434f-8cf9-666df880d509@gmx.com>
Date: Thu, 17 Sep 2026 07:05:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: remove reduntant eb generation check in
 btrfs_buffer_uptodate()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <9d46a922c893b72ffcd82c82ee552b661b163be0.1789575886.git.fdmanana@suse.com>
 <7fb642c266224d8ccdb3fcafcf4de1cab9f9c419.1789576145.git.fdmanana@suse.com>
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
In-Reply-To: <7fb642c266224d8ccdb3fcafcf4de1cab9f9c419.1789576145.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wI43LKMPOtz9gn53N5ezQl9oZNEVYYmOlAdTCi62WojSjFLqad6
 K65AhNbU7Q4/dOK7lssy/SBoDUv0A0/ulujN32LfM9xMU1PrdTA3CunKK/Z+OzisTUftTbq
 TBWR0ELgzqaLlkSUCoH/qpC/LHimUu3MoFTYq43v8td4blmuhqdjdjwn8/8aeQYd4MZOX8I
 Wi4R+CunPkjPYoMNyoDOQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:D/1gb88yvTM=;ms/zhCtJYadqaq9gq+KmMJSldbE
 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



=E5=9C=A8 2026/9/17 02:00, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> It's pointless to check if the extent buffer's generation does not match
> the value of 'parent_transid' because if it does, then we have already
> entered the previous if statement and returned from the function.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Fix the logic, wrong return value and missing error message and call=
 to
>      clear_extent_buffer_uptodate().
>=20
>   fs/btrfs/disk-io.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 21b72c90bd90..5947d24152fb 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -125,15 +125,12 @@ int btrfs_buffer_uptodate(struct extent_buffer *eb=
, u64 parent_transid,
>   		return 1;
>   	}
>  =20
> -	if (btrfs_header_generation(eb) !=3D parent_transid) {
> -		btrfs_err_rl(eb->fs_info,
> +	btrfs_err_rl(eb->fs_info,
>   "parent transid verify failed on logical %llu mirror %u wanted %llu fo=
und %llu",
>   			eb->start, eb->read_mirror,
>   			parent_transid, btrfs_header_generation(eb));
> -		clear_extent_buffer_uptodate(eb);
> -		return 0;
> -	}
> -	return 1;
> +	clear_extent_buffer_uptodate(eb);
> +	return 0;
>   }
>  =20
>   static bool btrfs_supported_super_csum(u16 csum_type)

