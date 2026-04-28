Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1F733D6F0
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777416346; cv=none; b=eCJr4smzPLZgtI3zGwKExTf9Ca60RiFBrUJoXV/xUhqn2orLgryICBJ2wyzhxg9if4unNv7ubkR680qqQV3UvdUD1OVVbU+LDOJtskvYpL03b3imPXa8I2I4/lZW+F4IGWBPQBVGUuppr+3YzsIirkCF8oDgI+W3IWeU/q4kkoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777416346; c=relaxed/simple;
	bh=VPpnVTptQVvjhsvuCLDJZzCW3hIGpUNi6iVP768C5zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J9+jpz57lM7JeD3+D33O6Qi9Q4nt3A0lnQcyFJcB4dB0h2jOJBOCfgm2Iw1kxQHkyT3fVFdzWfX2uzZzEF4EBlsFWXgeg4uPDYKoj6i7gYCxAAqMOsYJOswW5y7zsFXuHUcF2D78/VvZf/E8aNxT7dQCrVNTwiTHlc4ABgDDqoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WM/KS4lP; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WM/KS4lP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777416342; x=1778021142; i=quwenruo.btrfs@gmx.com;
	bh=D3rkdrOIzta9aI0ecgQRIhkeOq6kBQxD+kIJbrJJ11Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WM/KS4lP3C7Nq9n61p2hlHVPAHXpp8IB1yJKC2vJ+jgpRCPZCB2LE54lV4/EfWGP
	 j8yRl9gdT0soiNd2v+ARM+pbmTH7weCBmNVYjKhoV2Jdkg9vbe/nUF2DvSE8rBkyq
	 tQtrUs3ujlDN/q15zFDG0bQk/0FUnRP23TfRhrucCtHaUJ0kgc+nRJjpMAWrvQYUN
	 op761d/GwibnflFMydwLi7CnUN4TGjl4H27Op8OXZy+ifn7u/dc2ymK4Xgo8LBTia
	 FYBW9yzyRbMWktJtcA9lKh9sc2GQ/o4oWUUbBd7wehIWWM5qgcnMDsnpeCN/CBg/N
	 zQbUdlXyi2OKDmV2fw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MowKc-1vZOQa0i8U-00agnq; Wed, 29
 Apr 2026 00:45:42 +0200
Message-ID: <f910a267-a99d-4007-a5ee-a186471697a8@gmx.com>
Date: Wed, 29 Apr 2026 08:15:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move transaction abort message to
 __btrfs_abort_transaction()
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260428155148.2399-1-dsterba@suse.com>
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
In-Reply-To: <20260428155148.2399-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eCq42uMEV/6SmJpEwQAM8Z7GpoNffXAHL6KYw7wYxkNLBqhL4rW
 LApwLpeyZfEssrRo0TMHCRAWszwLKovg0A1+G1EOAs2DiHi4AkfepkOjeDiXDhrN3v+rULL
 fvmII/KVGDd+JTNeOcJ+olAr+qgwGVT4ylZQf405ceUFTMFmPOR8kPFYpta6EdmrsZUzLUt
 sCcYBckICMIUaSe7Amrww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+oguqyP0Y4c=;H+LijzSkJfje2P9Y57V924Vcj0Q
 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
 eTsRtFNZ22814Qks2DXbSPXA==



=E5=9C=A8 2026/4/29 01:21, David Sterba =E5=86=99=E9=81=93:
> The btrfs_abort_transaction() is called at the location where we want to
> report the abort. It must be a macro so we get the correct line and
> stack trace. This inlines the necessary code and the rest is pushed to
> __btrfs_abort_transaction().
>=20
> There's a possibility to reduce the inlined code if we move the message
> to the helper function as well, without loss of information. The
> difference is only that the WARN will not print it inside the stack
> report but after:
>=20
>    --[ cut here ]--
>    WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa2=
1/0xd30 [btrfs], CPU#11: bonnie++/3377975
>    ...
>    --[ end trace ] --
>    BTRFS error (device dm-0 state A): Transaction aborted (error -28)
>=20
> While previously there would be one more line like:
>=20
>    --[ cut here ]--
>    BTRFS: Transaction aborted (error -28)
>    WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa2=
1/0xd30 [btrfs], CPU#11: bonnie++/3377975
>    ...
>    --[ end trace ] --
>=20
> This removes about 22KiB of btrfs.ko on a release config.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/transaction.c |  3 +++
>   fs/btrfs/transaction.h | 11 +----------
>   2 files changed, 4 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 194f581b36f3..5125cb20ef85 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2729,6 +2729,9 @@ void __cold __btrfs_abort_transaction(struct btrfs=
_trans_handle *trans,
>   {
>   	struct btrfs_fs_info *fs_info =3D trans->fs_info;
>  =20
> +	btrfs_err(trans->fs_info, "Transaction %llu aborted (error %d)",
> +		  trans->transid, error);
> +

This message will be outputted for every btrfs_abort_transaction() call.

Shouldn't we move it behind first_hit check?

Thanks,
Qu

