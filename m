Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95854332604
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722278; cv=none; b=ERhPNVuCTGYlkTDoFiXHvImN+Yh4CrwV7mOIfMMyG3VHnwJIyUC9jp6QDfp8UhigKxZr9oKMj3gFRMA9vIt/39+0oLIboIWuS7/W9DlJpKhpAhSqi8zhYJEUDhcyVdcVnImHi0o6cGBV7Y8Q2P1Go1yiCnHm6+BDXaJILwDAwkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722278; c=relaxed/simple;
	bh=S3EVKRHgRSH9ciT8GbII4wLQKAl+A7c3Y/xphuAt6Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qTflFKNHcLSaqiuQAv+GHl3YkE2oaUcqNNU6qvG644dBnD7o+JAjfXQJr2NCl00Y7k0Jrp22/tOekhQktgEOuPyt3BIY7K/cUfTFmfzCNfrw53RDwriayu364NAk7zCXni08G5ZHLM643WTtC57JDR5unTO8uL3hhgLNgnC4dD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=dpbX+UJI; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="dpbX+UJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776722270; x=1777327070; i=quwenruo.btrfs@gmx.com;
	bh=jtn7LLeg6HQsTaUerJYmacghIkXQjGFLF9v08ydaoLo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=dpbX+UJICVOmwWVu+FcxrkN2cz54V6nKKJ4/5mJyy4oeqMTpOllfInZ328oI71Uh
	 h+zznOJp8Cq6s+bgIw9Aa7fr6b+1e77afLxVRmEAASNXQb7d+FuTAuexxqEhY1A7m
	 LO29ypuXwoDa2A8rco4xvcH8VFhszDaGp77F+9xNm3F8c0wnJoT0kzsgY3HluabIO
	 V1wpKUAykgwxrkkRlaovXU0gs0ZYodd4oPh0Xs4OZo9TRv0WuQqmFG9TOidrCYmFu
	 7b+9RFY5J9sKLw90SBwpZeaSuses4EVYiKsl1VODLRdLxugm88PcEbSnXWuAwCFhp
	 ewf+L029JUFaVwzedw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M26r3-1wHQWt0QJ7-00Dz26; Mon, 20
 Apr 2026 23:57:50 +0200
Message-ID: <e5814387-b235-4277-a5fc-cdc2f52cdf3f@gmx.com>
Date: Tue, 21 Apr 2026 07:27:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use the enums instead of int type in struct
 btrfs_block_group fields
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
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
In-Reply-To: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0aAkeSaFSXCUJkpidcoqi5RNBiO8ccWrLfxD1QREvy2ku6Pn550
 PpQ6nPe1VFLo2xfSgmOXI54OtDdOV7GM1ySmtehJqF1KRJFq7Kc+lbw0mzNld3wRWC8FDU7
 TtPgZjolxVv02LZZGyZXqfisXD2hCFw5bArbqJvyVI34oOdApPE4UqCVNbwpHRRR16IlYJz
 oVaou2OyQCgtrr96TzjTw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XO/txBocRfI=;m32M+bX4CwefaX2xkngKattG205
 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



=E5=9C=A8 2026/4/20 23:24, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The 'disk_cache_state' and 'cached' fields are defined with an int type
> but all the values we assigned to them come from the enums
> btrfs_disk_cache_state and btrfs_caching_type. So change the type in the
> btrfs_block_group structure from int to these enums - in practice an enu=
m
> is an int, so this is more for readability and clarity.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/block-group.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 60a3b1c0a8ab..790c2d467af5 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -171,10 +171,10 @@ struct btrfs_block_group {
>   	unsigned long full_stripe_len;
>   	unsigned long runtime_flags;
>  =20
> -	int disk_cache_state;
> +	enum btrfs_disk_cache_state disk_cache_state;
>  =20
>   	/* Cache tracking stuff */
> -	int cached;
> +	enum btrfs_caching_type cached;
>   	struct btrfs_caching_control *caching_ctl;
>  =20
>   	struct btrfs_space_info *space_info;

