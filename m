Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB44351C14
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781608699; cv=none; b=VFWBip1+GsKrz+NcyPBUkAFD6lbPNVaR3vxvW5kUj82W3qJa2flkdnxfwUSX4N/tr6kLpPieDY06/tMDS4aTJBavmNuHmzmQ6CRnwhJu6UeHpvYi3zwwtX+hNpjKrX5VfhnA+oHVFky7iuNiE0f1wM5XosXVSNkmQ9IsAZHe85Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781608699; c=relaxed/simple;
	bh=fs7LhAX7JI/6fsn6aawX0+HnZzxUObtvr+UaGlijANc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rp216p0QjeYMvODrFFoqR/DpJyV3j7a5KRT/3mw700BxBCeBA5Xt5T35xwG6uC9DWpNWvNHVw1vWR4BWZXPH6sl2YG+VGzbyVEkWoNoYd1EasDpLWBP9KytD+92Gq/cyR1K1P8cW/wBuF5II1WoqHCYSW0VMeqtkG5q32FEj3Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=nRsqQtxZ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="nRsqQtxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781608695; x=1782213495; i=quwenruo.btrfs@gmx.com;
	bh=F9VwRHdDgE4ACjGUrVOcACMdQ0nC3VSbE+/KYVmPit4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nRsqQtxZBNfrAoKr1plFSQ8gbbtLg7Ch2UflMfdJgl+2Q1SYFDPb+1skIwxcPNlg
	 I3n1f9EujyBGwp7ZyoXph2ms7rMZPFx1tgNHVgT1LGKBUrLLeXhHNaX42QkKTNAG8
	 IGtLNDvEeOKXw4QS/RIHb7ditwrOdWkaXlQVNFGvTeR/vWuN69w4i0CyoLSpGZacJ
	 YNBT5BiJuJ5zERkM/aQqDH5su4KtR48zaMFoejAVhm58H5dvn04TnSd7D2a5lk8ex
	 qBkJFLQRgbzK0GipRSoREHHY2ilQVvBDLmKahF43MS2uBaPcqZTXeUAcqmoe3V8jk
	 HCvdIDAw4f348HMWlQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MXGr8-1whjFA3jSQ-00PRLf; Tue, 16
 Jun 2026 13:18:15 +0200
Message-ID: <100019a1-636d-48de-ba27-988e7a41e541@gmx.com>
Date: Tue, 16 Jun 2026 20:48:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
To: You-Kai Zheng <ykzheng@synology.com>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>
References: <20260616103907.2157960-1-ykzheng@synology.com>
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
In-Reply-To: <20260616103907.2157960-1-ykzheng@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OZ6pMQC3XkU0EJwykQVEww7GfaFnZ2qt4VMfLBWNRs/eIzqw8Jy
 +ukn0RaUCL7npmd38vWpbIZ3a2cvr2GxHsrlEbNbuv/ci5VRvXSe5908aawMqQMoZhLvix9
 WT9T5TRgVMVQ7dkIUzDTFRAB5sEbZCRtx+NPAuY8Si1rKIbBrKj8XmXasQoN1XLdawa9kq6
 /lErLEA01qf+6XKapjsKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:F6asp5buKPA=;r+L4aCWNtxeaHU+sRfefg709Q5F
 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
 O57R3w==



=E5=9C=A8 2026/6/16 20:09, You-Kai Zheng =E5=86=99=E9=81=93:
> The variable-sized buffer buf in struct btrfs_ioctl_search_args_v2 is
> declared as __u64[], but it holds a packed byte stream of search results=
,
> where all offsets into the buffer are in bytes.
>=20
> Declaring buf as __u64[] makes it easy for user space to write incorrect
> pointer arithmetic: adding a byte offset directly to a __u64 pointer
> scales the offset by 8, landing at byte position offset*8 instead of
> offset.
>=20
> This recently caused an infinite loop in btrfs-progs: the accessor read
> all-zero data from misaddressed items, which fed zeroed search keys back
> into the ioctl loop and spun forever. The issue was worked around at the
> time by disabling TREE_SEARCH_V2 entirely in btrfs-progs (d73e69824854:
> "btrfs-progs: temporarily disable usage of v2 of search tree ioctl").
>=20
> The kernel side already treats buf as a byte buffer, so change the
> declaration to __u8[] to match the actual semantics and prevent similar
> misuse in user space. The change is ABI compatible: both the structure s=
ize
> and alignment are unchanged.
>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: You-Kai Zheng <ykzheng@synology.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And thanks for pinning down the btrfs-progs bug.

Thanks,
Qu

> ---
>   include/uapi/linux/btrfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d..16ff7beab9ca 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -598,7 +598,7 @@ struct btrfs_ioctl_search_args_v2 {
>   	__u64 buf_size;		   /* in - size of buffer
>   					    * out - on EOVERFLOW: needed size
>   					    *       to store item */
> -	__u64 buf[];                       /* out - found items */
> +	__u8 buf[];                        /* out - found items */
>   };
>  =20
>   /* With a @src_length of zero, the range from @src_offset->EOF is clon=
ed! */

