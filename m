Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15937416A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 22:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774045134; cv=none; b=Q10ayF7rxm1UNNHY9esyYqCJTTFVF78e1aoyiVlKTNcvwRvef6ysbQf2CG9CnI4ihiy6/4OkOX0GJ59ASUkLEY0GYD2acjNGrkFGNFon2/skUzgFhfsskbuTmDm76vJMHFT4Auih9fbALxCWRFl4krTEXFhnB89DSe2Kf6GaRtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774045134; c=relaxed/simple;
	bh=VeV+rfOakT7ky8AVaxXUKak1LIdWIetQFobV9bMmb0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vg5bemqNMbFBlaQkJNBF3X0Fa3McvTomzYgQDT7VS+b75zconLHYA/LOjaJvj12l4kcNZTQDSUWiaWg4kHghn980Y8FshPVnYC/KQbFN6hyymEBWWijWYx2QTHQkSMN0P4OFgUjUDzqVyiOsAKsheWaBFOB/fNQBhrm6tUsmu+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=BW32hf7y; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="BW32hf7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774045128; x=1774649928; i=quwenruo.btrfs@gmx.com;
	bh=ic+wkgIFsgufo7tX1LmDUhenAKlb19n20VCZjtbn/vA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BW32hf7yE8Ja8wIbYE+9R7ttHvpg7NRe7L54dHXBZieulytEr/KK3OQ4JR0cmp4o
	 ewjHasb6XFw5DEu4BDEICG/Z0xPeXciiv4l/Yy11j5L2UIqWI5shZkRpLkd0zMocu
	 gN6o0VOEOh0h2a3508UqvVZPgGIh8PAtsvzVV4DQLRDadgZ3vclU6fJK5SOb0V0Af
	 qklvdw1sxclMZOJp6WeTrIFG1ZHq1v60rlG8FzLTcf2dRfyaAGtd68zGVaGZnmXfR
	 VmY69xRCrPZ+KdzrrcTgmkvjk33skHcnRiTxbiNkGCjPS1u1SBwWzplmVQrfc2lnF
	 xeO+l80rcrSt0pYKBA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVeMG-1wBN8u14ce-00NFIt; Fri, 20
 Mar 2026 23:18:48 +0100
Message-ID: <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
Date: Sat, 21 Mar 2026 08:48:45 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
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
In-Reply-To: <20260320125058.90053-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cU10+N1I18+JDN88J+ZgTmxSMRD+c5O7lTOAZS/Ajoq8FaWpSZf
 p9FjPsufmqfAcMp30lR+UMV2i3qOFF9ZnOwUrcRGjFJUlAPvCO+SL3YanJrB51iNaZk7Zm6
 +ajDZ8RNKE6h6xurf9DsUtABE5zxS/WmUHKNZgQ3zFUqWvTxKZHSAtuTRkcslcFN5rxaAMg
 cmM01O3GHu9dmTtAvXt+w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lWGYDaUop9c=;2TPvZUiGAdSfpfgzTr1x+wewlKP
 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
 85n+UStqhmnTXQwlpluQhf5+QYDEN



=E5=9C=A8 2026/3/20 23:20, Mark Harmstone =E5=86=99=E9=81=93:
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.
>=20
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.
>=20
> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_SPARSE - this is so userspace knows it can use
> the precomputed hash of the zero sector. Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NO_CSUMS.

I'm not sure if it's a good idea to put hole and preallocated range into=
=20
the same BTRFS_GET_CSUMS_SPARSE.

Although both means there is no csum, hole case means there is really no=
=20
data extent, thus we should not create any extent instead of writing zero.

For preallocated, indicating it has no CSUM can allow mkfs to=20
distinguish hole and preallocated, thus change to zero writes to=20
prealloc, which is faster and make the resulted fs more aligned to the=20
source dir.


And for EOF checks, I think we don't need to bother that much, aka, just=
=20
let it return the regular results.

My assumption is, the mkfs shouldn't pass a range completely beyond the=20
round_up(i_size), as non-reflink rootdir population would always read=20
out the content of the inode from the host fs.
Thus we won't really read beyond the inode size.

>=20
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace.

I agree with the skip of compressed extents, but I'd prefer to have a=20
special flag to indicate that, other than NO_CSUMS.

Or mkfs is unable to distinguish hole and compressed extents.

[...]
> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	0
> +#define BTRFS_GET_CSUMS_SPARSE		1
> +#define BTRFS_GET_CSUMS_NO_CSUMS	2
> +
> +struct btrfs_ioctl_get_csums_entry {
> +	__u64 offset;		/* file offset of this range */
> +	__u64 length;		/* length in bytes */
> +	__u32 type;		/* BTRFS_GET_CSUMS_* type */
> +	__u32 reserved;		/* padding, must be 0 */
> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +	__u64 offset;		/* in/out: file offset */
> +	__u64 length;		/* in/out: range length */
> +	__u64 buf_size;		/* in/out: buffer capacity / bytes written */
> +	__u8 buf[];		/* out: entries + csum data */
> +};

 From the progs usage, it is always a single btrfs_ioctl_get_csums_entry=
=20
at the beginning of buf[], then real buffer for csum, can we just=20
combine both structures into one?

Furthermore, since we only query one extent at one time, the=20
offset/length are more or less duplicated between args and entry structure=
.

We can just save the length into the args without the need for entry=20
members (except the type).

Thanks,
Qu

> +
>   /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>   #define BTRFS_SHUTDOWN_FLAGS_DEFAULT			0x0
>   #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH			0x1
> @@ -1226,6 +1245,8 @@ enum btrfs_err_code {
>   				     struct btrfs_ioctl_encoded_io_args)
>   #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>   					struct btrfs_ioctl_subvol_wait)
> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
> +				  struct btrfs_ioctl_get_csums_args)
>  =20
>   /* Shutdown ioctl should follow XFS's interfaces, thus not using btrfs=
 magic. */
>   #define BTRFS_IOC_SHUTDOWN	_IOR('X', 125, __u32)

