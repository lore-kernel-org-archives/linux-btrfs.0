Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C152E285C;
	Mon, 30 Mar 2026 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905805; cv=none; b=j+SYH5SE7f8u4X65RCatVesgCcU7rcWQK+AWkDG3PqtHpPBcZgcIsCssp7AsDHLaTx3aoKoLlSozJR5lKxfbg+zIYeSHlGq2jb3vWnpc4jaPSCO8Gv3+KtpKl+Vh50QFr7R+YO4opn5/RR6d4KNHOo3LVMAjo6jRQq9aFA6YKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905805; c=relaxed/simple;
	bh=ElVAGBKjevYQZfMX58azoB2rqyZKDzdU7fBCpSaC4Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPqD2JRIqhdwIWUtNOiTuPCwoJvx5IgXXY5x7COMfWrDHXOGrKVIUjcW5v3Ns3kN2pXKPDCmtG3sbeYC7zwjSKgWXdJhFWTL1wTqQOcpOjOz0X5jP3Yj5abtluJB7FxogdALdtVg5n7jJgXkr8aECDliRXFAN38ie5XO73+MOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uR/hU+L7; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uR/hU+L7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774905799; x=1775510599; i=quwenruo.btrfs@gmx.com;
	bh=8vLnJVPPxHx5o2+reOWF0nHtHETnXBUzpeQcSWGmw8o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uR/hU+L746mN0/24Iu3yAbVULGGyxcodQSPmOn2fQj8yNHu45uoNtm2ma7HkfYh8
	 5xqjLsEPrtL3Cw7UxVV7vFtgMiZqRIDdHaZ1pmdaOwR/J4IdmaoN0imIIADWGoqIG
	 0cr6v6JmQ1+pytSIJWe+CAiKAS1GitVbepVcuAD1MwDWFjkeDhiTo8AbNqlmf0iKA
	 PauoED8LBpYqXPBzbbhQByygfCCo+2f9xH2XdFdygSevPtZU4UJb/obK4VajsTik+
	 0/GGYoZyjyjLuORazH8ezwD89CePTQuB/xfms1+b7UmjgntCQzUzqaBzZ/+eLn84R
	 ttNJ9w3SfVeZ2LdFHA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MmUHj-1vh1gT1cbR-00ov3H; Mon, 30
 Mar 2026 23:23:19 +0200
Message-ID: <b4077e08-18e1-480f-8c1c-0d08b9fd5bc8@gmx.com>
Date: Tue, 31 Mar 2026 07:53:11 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix silent IO error loss in encoded writes and
 zoned split
To: Michal Grzedzicki <mge@meta.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
References: <20260330160644.3678224-1-mge@meta.com>
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
In-Reply-To: <20260330160644.3678224-1-mge@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:isGTpbZ9zeh3MYM2zloz+hh0suCgzVFotoaE3kuujRwAOQrq/4n
 F52+glec6t/Del55YlVnzqYHs22zXyDRv14jPF6ekzWJDRj5zp0fiDAOIIqejFZ4bHhK1PA
 Ae26De90+WNBr9bucjZ6NbkuijgeHeZwC57jPFWPF0AkJG8tS6946i362cE4D4OJxHjdj7P
 POUoUYfvgOOtVdc6Mu+lQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZWZG0R5QlqM=;DaVvki64wRr38Egg2nqIzEFyUea
 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



=E5=9C=A8 2026/3/31 02:36, Michal Grzedzicki =E5=86=99=E9=81=93:
> can_finish_ordered_extent() and btrfs_finish_ordered_zoned() set
> BTRFS_ORDERED_IOERR via bare set_bit(). Later,
> btrfs_mark_ordered_extent_error() in btrfs_finish_one_ordered() uses
> test_and_set_bit(), finds it already set, and skips
> mapping_set_error(). The error is never recorded on the inode's
> address_space, making it invisible to fsync. For encoded writes this
> causes btrfs receive to silently produce files with zero-filled holes.
>=20
> Fix: replace bare set_bit(BTRFS_ORDERED_IOERR) with
> btrfs_mark_ordered_extent_error() which pairs test_and_set_bit() with
> mapping_set_error(), guaranteeing the error is recorded exactly once.
>=20
> Signed-off-by: Michal Grzedzicki <mge@meta.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/ordered-data.c | 2 +-
>   fs/btrfs/zoned.c        | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 5df02c707aee..b65c1f1e2956 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -385,7 +385,7 @@ static bool can_finish_ordered_extent(struct btrfs_o=
rdered_extent *ordered,
>   	}
>  =20
>   	if (!uptodate)
> -		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
> +		btrfs_mark_ordered_extent_error(ordered);
>  =20
>   	if (ordered->bytes_left)
>   		return false;
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0cd7fd3fcfa3..d728c3bafc09 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2136,7 +2136,7 @@ void btrfs_finish_ordered_zoned(struct btrfs_order=
ed_extent *ordered)
>   			continue;
>   		}
>   		if (!btrfs_zoned_split_ordered(ordered, logical, len)) {
> -			set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
> +			btrfs_mark_ordered_extent_error(ordered);
>   			btrfs_err(fs_info, "failed to split ordered extent");
>   			goto out;
>   		}

