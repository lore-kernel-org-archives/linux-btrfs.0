Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B1503BD1
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376234; cv=none; b=K/azZnKwirb4MNBkNnZDwoTJXgobLVCumYqcpqiKlYqeAWnO9TtrbXMEpUNszuoeRmmIDr/uBVjFkxwpsMgK+DS5RvcJR0NEhcucUidQfLZ4Pc7s5yKtyuUqrd0ke6dyjNF6+FXS7+yvbuPS7FCh42ooTJv3bVUu0mp29D5KUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376234; c=relaxed/simple;
	bh=Sk1OKf5xjtGA62m83wWbCRS322zYBV9MW4NCl93Mj3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fxdsLEAQDKGthnUTQpExy599FhKjnwO9pPDrUBd41GXAcB7DWorV4Dl59bFnVc9CIufdjzK08MlBnGr8U78j3NJpiAFKYc8L0jXwhDs7yQdqEYZwRvwOSLMHD0VBLwi4lJSo2SZFYtRkt+HqAYwxBQaJfjusZOeE/sp8pIdF9Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tOI42KBZ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tOI42KBZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790376229; x=1790981029; i=quwenruo.btrfs@gmx.com;
	bh=YdGa0TVLtDbATb7huuLDXGZ+Z41x4s5Os9D9eY4qCEM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tOI42KBZL1FSRqCpGuNEXemmimmptsQ8P17eab9rkKU07h+rOX57kbnFl0wP7+wB
	 UsLZ7i/b23nTJKQhuQP2m5mfofPgnfYlms7CfgvkfPr5kqiY1GY8QDECj/GakPufi
	 +gRuBi8KOV7yVKKgnERpIpvLt98+DZLKT4SCby3piyoegok93O029uPDWECBm6dUh
	 ZnFf/HAcsENFbNxQon/ksHJzlxyEPhSRI8SMD4f64AayOZJAO9FZCTH9P4lsyUsfV
	 CR4BAsrpLWzHx+Q1fbV31YlQQP0jWTJZIn2wIVPITABfVBzUtDWFTEitPN1wZ3ql8
	 KIsOml4G0KSIo8nkNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mr9Bu-1wM0Ru43z4-00kTHH; Sat, 26
 Sep 2026 00:43:49 +0200
Message-ID: <d09b9361-af58-42fa-ba3c-45a9f83f8be3@gmx.com>
Date: Sat, 26 Sep 2026 08:13:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: simplify dir item location setup in
 btrfs_insert_xattr_item()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <8f24a85bf4a14292293a0e43c2522418f80f6a52.1790355077.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <8f24a85bf4a14292293a0e43c2522418f80f6a52.1790355077.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DQq9HG6Jz5AIVMrndoYv6yXV6BgpTiGb9ZjdpEQkyvYP1gWFrPT
 2Z2yQVp1fbcQaDMaSlZ3PSAIwIple8U/rVs66449oaAtm2x1/fRANUuCo0rhgUfRXUBoYmX
 iCvZ7BC8BWv+D5WGMHx8aQWtFjMhz1AXcf1dNcNp0Xwv+IdyyBdvpinhCRfHNFNAhsfegy+
 nmPE5ZUlOMhMfQDN013iA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t1zkKxJpLHY=;2DurkuFJJ41wacGFS/4LSi/QKNr
 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
 2g29



=E5=9C=A8 2026/9/26 02:22, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The location (a btrfs_disk_key) of a btrfs_dir_item used for a xattr is
> always zeroed and we have a complex setup in btrfs_insert_xattr_item()
> where we declare an on stack btrfs_key, zero it out, convert it into a
> btrfs_disk_key, also declared on stack, and then pass that btrfs_disk_ke=
y
> to a btrfs_set_dir_item_key() call.
>=20
> We can simplify this, and save stack space (one btrfs_disk_key and one
> btrfs_key), by simply using memzero_extent_buffer().
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/dir-item.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 3a90736915af..d39f85035b43 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -62,8 +62,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle =
*trans,
>   	int ret =3D 0;
>   	struct btrfs_dir_item *dir_item;
>   	unsigned long name_ptr, data_ptr;
> -	struct btrfs_key key, location;
> -	struct btrfs_disk_key disk_key;
> +	struct btrfs_key key;
>   	struct extent_buffer *leaf;
>   	u32 data_size;
>  =20
> @@ -79,11 +78,11 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handl=
e *trans,
>   					name, name_len);
>   	if (IS_ERR(dir_item))
>   		return PTR_ERR(dir_item);
> -	memset(&location, 0, sizeof(location));
>  =20
>   	leaf =3D path->nodes[0];
> -	btrfs_cpu_key_to_disk(&disk_key, &location);
> -	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
> +	memzero_extent_buffer(leaf, (unsigned long)dir_item +
> +			      offsetof(struct btrfs_dir_item, location),
> +			      sizeof(struct btrfs_disk_key));
>   	btrfs_set_dir_flags(leaf, dir_item, BTRFS_FT_XATTR);
>   	btrfs_set_dir_name_len(leaf, dir_item, name_len);
>   	btrfs_set_dir_transid(leaf, dir_item, trans->transid);

