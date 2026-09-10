Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFE49B5AF
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 22:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078075; cv=none; b=CUGfepAeoiYoPKWEoDzKxWbHavCiUtXeE6nsZC2P0T8V2UtTkWgysTBvnd1veOUU7I6ElQZpo+ZUjhJjJUqX1wsHGnK/cjkzqezZ6EOndH4UWoGyos+7ejunopBUBSujMEDyLEjw4T+sQCfTkluw57+Ob8lAfXbQprkGAO0yYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078075; c=relaxed/simple;
	bh=9t6GN6H3zsBXcfDNBdC20m539d/wzjL0qiKT2lw710U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IbmXViMdzMPnQtYC3w2Ku19++RVzsvJo4tzV+Gs5n3gUbEVAlgYYcDqeAT2a/yj+VAPyWx+OgSh4jCY+aqh8u2E3X5WinaaxSVpqoavVem+EoBggfxdykNwG8kqcl7LkjFJUdMYM2Djjzz7IUrWBR6468Xv7hT0vT6G4NKP6HG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=QOJErPzb; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="QOJErPzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789078067; x=1789682867; i=quwenruo.btrfs@gmx.com;
	bh=+5HONmz6FyZO0p3l4D+UJP8Js0FJN4BgNRvKvhqMjaQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QOJErPzbx1H6MtPdZBWsyhiDB85t9fJsAehQDzkHERybqG6b+dnWLsFdyOWkzfe8
	 kKH3jxOQ1OqPKiM18ghHD9C+hsO8dCU1RDFBopAPYFMpXSgpQUa27gCUTeNFRlSlo
	 l0rmi6FEAbXXMGQ0XSy7n2i5UzqHOyhhfiHbfxcR1I1G6TuNluhSIw7aMhSbq/J1c
	 81SHzhGY/+//u4fiaxX6oXg6JlZ8tWkOXBl+HZGYsP0RbBO1f1z110uUcWCYmSbdO
	 6UCRIaBQdAdvz4sExye1qLdLEtLq5IsvIAq5ju77NuHOosB4AnTs9lTgXfb71nPS5
	 Q+tgl+xaR1e+GB+WaA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MAwXh-1wxs6c0Czp-000Cxu; Fri, 11
 Sep 2026 00:07:47 +0200
Message-ID: <b35bf3ba-3dd8-41d9-9ab4-eb1964b299e7@gmx.com>
Date: Fri, 11 Sep 2026 07:37:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tree-checker: fix error message regarding free
 space extent items
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <bfefcaf172db8da00666b85907b965603c22d821.1789059038.git.fdmanana@suse.com>
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
In-Reply-To: <bfefcaf172db8da00666b85907b965603c22d821.1789059038.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hctY/AdSKzkWabjOnAIKPAi6jWqmcYB/xrK5ngt1xygwd9rqC8v
 8KlsZFbMqTfQ9JwdM1a9cr9EQvWzsSWnqwMRiP/9MpNPprCXF11mFQn8J4XYD49rhn2kLXh
 8RAPH4PCJcbGIiUfXiphSvzWVQkr+4/hEMB+v/7XHT3qIOCu68JG3nhPWT+tjD5stmIviYg
 BuWAgey6FAwJe1t6/j6mA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8GbYkeu4z3M=;Ozl2KZjeMF9TaTgk7GPibqc2YiM
 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
 VhYofvCRj6jvt



=E5=9C=A8 2026/9/11 02:20, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The error message mentions a free space info item, but we are processing=
 a
> free space extent item, so fix the message.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-checker.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 63eea0852ceb..857ded43c3b9 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2348,7 +2348,7 @@ static int check_free_space_extent(struct extent_b=
uffer *leaf, struct btrfs_key
>  =20
>   	if (unlikely(btrfs_item_size(leaf, slot) !=3D 0)) {
>   		generic_err(leaf, slot,
> -			    "invalid item size for free space info, has %u expect 0",
> +			    "invalid item size for free space extent, has %u expect 0",
>   			    btrfs_item_size(leaf, slot));
>   		return -EUCLEAN;
>   	}

