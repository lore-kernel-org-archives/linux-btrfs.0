Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4933C6A5D
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 22:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774392608; cv=none; b=NXiLZgk8BZY6UsakPSpIgE86k3bLVQ6I6+9iv4ZxHuP0MnoK5wJYXR+AF3fkVkAYNa2PN5piht8pKS3HGVBqZOSCgA1OiW1hRG/2FGpT/7AwiGRhTB6W3k37EyiDtIQTTDP4fX7+eylNK71BXiDL9kJe5Y2DCgu0EtCVTxyv+Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774392608; c=relaxed/simple;
	bh=1jdrrl7ErfDkyRKJ4ArrDLRWAA77MjrsUQ28JZi3L/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sFbbnxrB3zmizdLXX3VY9Vuza0GlNFixYo49Iu7/fe9vIEuxEDXMRlrxwOOxc3fPa+vyWrSsWBPliW7DYO347awt5oU5AQQVke0lTptfT/1Lfw18f2KJcus9zK/+YgHM8MuWRw1R4Adm4bq5TdvqHXzKmuI6fFjQrbyGMz2fKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MRNNFkiM; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MRNNFkiM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774392601; x=1774997401; i=quwenruo.btrfs@gmx.com;
	bh=fI2hgnGw6Ny63Es+Dx0KXrqCgiMMvXchYgWDYs2PEYc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MRNNFkiMRfPd9yqeebmeM2pqj6Jp1OxUaaL3iZaQBe3+vAGkKdazJGTIleX0GfLS
	 prwJwJVTv5OGP7QQTFuF1+C+zUxNvlG2lXifLz9L+ia0QX9O44WsHheqm0xX4dGDz
	 Uuj93L7dLU8j1CntFpaQ9RboemGXkZRChmxdH6acL0uGRYQY7cGncR4UiSJMGHRXq
	 fMNGE85pmlM3LpA2Ohq2B8FHhopXQz2G4qVfrHNkrjHX3ZrlAZix0YiLpLfvWYK1w
	 584ZvZoJCm0qdB3FoAKzUybAAA960W1bbGPm39u5UievLKLP8dL5OKNFErLuWmBVb
	 JcJ1+RJOVexuuZABZA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MOzT4-1vvKHl05gS-00YK1Y; Tue, 24
 Mar 2026 23:50:01 +0100
Message-ID: <60ecd7cd-2fc2-439b-86a8-bc3a2ae8364d@gmx.com>
Date: Wed, 25 Mar 2026 09:19:58 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: check: recognize verity item keys in
 original mode
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <77723ae3c51bb05723123a15b869cdee921727e2.1774378180.git.loemra.dev@gmail.com>
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
In-Reply-To: <77723ae3c51bb05723123a15b869cdee921727e2.1774378180.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VhU/EQWG7l0nR9MRJ0N0V7xFRUjTv70nE1/wRCO1yE1r36/gmoC
 8kgZSRiEALswC1VLn/Ka/OtQ5FcY/L8oJH7q03BErRnWlnadfJl1rfMuUzzvqdFNZmxMp1O
 j5gp2pXG99jJzy1Vsou1UEJVODvZehpuYeFXS21yK3GRhXMqdGLj+2n8oyz5SGoWs+Zte5t
 BH6XLbXAdphN6CKBduYXQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vdUzie8Wz3c=;yVZoeYZdx4JYsk/jf6i6r/pu1iX
 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



=E5=9C=A8 2026/3/25 05:22, Leo Martins =E5=86=99=E9=81=93:
> Commit 4e88bb6e ("btrfs-progs: enhance detection on unknown inode keys")
> added stricter validation for inode keys in the original mode checker,
> flagging unknown key types as errors. However, it did not add cases for
> BTRFS_VERITY_DESC_ITEM_KEY (36) and BTRFS_VERITY_MERKLE_ITEM_KEY (37),
> causing any filesystem with fs-verity enabled files to fail the check
> with:
>=20
>    ERROR: unknown key (257 36 0) found in leaf 30621696
>=20
> Add the missing switch cases so that verity metadata items are
> recognized and silently skipped during the check, matching the behavior
> of lowmem mode which already handles them.

Unfortunately I noticed that, lowmem mode doesn't have such handling eithe=
r.

As I created a test case with verity items, and CI failed due to false=20
alerts from CI.

I'll send out a small fix for the lowmem mode, along with the test case.

Thanks,
Qu

>=20
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>   check/main.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/check/main.c b/check/main.c
> index c96969fd..4fdd8867 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1895,6 +1895,9 @@ static int process_one_leaf(struct btrfs_root *roo=
t, struct extent_buffer *eb,
>   		case BTRFS_XATTR_ITEM_KEY:
>   			ret =3D process_xattr_item(eb, i, &key, active_node);
>   			break;
> +		case BTRFS_VERITY_DESC_ITEM_KEY:
> +		case BTRFS_VERITY_MERKLE_ITEM_KEY:
> +			break;
>   		default:
>   			error("unknown key (%llu %u %llu) found in leaf %llu",
>   			      key.objectid, key.type, key.offset, eb->start);

