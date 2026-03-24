Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AB53A759B
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774392550; cv=none; b=c5LlE1UNbPCq/GxcH3bPxvhbzevtEx6GtsDGTXF2sEwsFrDhcrSrcZHQLQf0zGq2Tcwc5e5O7dzyEqHGCpvgtCdd5EULr0sRwKbXi6haOUHHjXmqzmEaBak2ZutCXB4MeiLcDLvU7KV5ogih/WTKU2O9jajm5nlX7JIwWZeb+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774392550; c=relaxed/simple;
	bh=1jdrrl7ErfDkyRKJ4ArrDLRWAA77MjrsUQ28JZi3L/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dZ3HYgb5hH6g/rl9rmdS0Ch1OhrCSdIHQ9JutFr9GN5cqA2NhpTSroA+KrbeiJp0XcUORdXCmA0JbLp3TIom3BtXVppnGsVB+MjQm6afci2PjAYJU1S2XyUsDjoZ5+cUB2f/1zqZAGCFnDKfYaRJiCaXC2LVjeU88VW9HBNWN/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=LaXxqQUL; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="LaXxqQUL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774392544; x=1774997344; i=quwenruo.btrfs@gmx.com;
	bh=fI2hgnGw6Ny63Es+Dx0KXrqCgiMMvXchYgWDYs2PEYc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=LaXxqQULpe/r5AopyqcwFZOlSejzHMmURKscfpEqbpmGVTnixWk5XWG5cj8cNs4w
	 I/Ztekjj7laM04ZcloMmJueG13Mi1acx50xk3rsM1mvVODN7rtAYBBDLKwOFC6df6
	 DgdkPwJ9DjCNbMDGrGBUZ7f/CvROgvrjBLNAUwtmN8C3ClDk08FlC7yTm0vzSu2Gl
	 f5LMY6xSqCKr4BsXlq5WYLSwwGzxg9NVTRO/A7rwO7A7UOjmHHsoIRO33xuUyBIy/
	 blVX5aoXDku5fVU9uPLJdQM19PYGus6nkdjJ4FzunmtDDA+gfWsbY9tK0HG9Ae6Gt
	 40d7pXbjti3zDOeeDA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MBm1e-1wHJ6x2A8a-003TKO; Tue, 24
 Mar 2026 23:49:04 +0100
Message-ID: <298ed1b9-72e3-45ac-9d3c-41cb3cf50029@gmx.com>
Date: Wed, 25 Mar 2026 09:19:00 +1030
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
X-Provags-ID: V03:K1:ffORdUMSBJ/kUC+x9uvIbkq9Cvt3JwLF/8qHqP/PnoFn6lBxhZl
 NiOjDT0qR+FUsj6C8h/DEp2q+Ao2GPR7hGF53HJ3AkBIVJymSZz28ehb9xe3RvT+NWzKYI6
 HG4/B9/MArzbgl/PPhQrdlIytoiTRmPzQWsTnVvvpnJuf1G4buyJtx7z0DPr9903GzMm7wn
 X3mR76nNiGRl2ri/3duwQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UpkPB4Z14HM=;CMxsdjRP9zjAUvpFUvj9+7n10Ce
 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
 Wi1fqhNPFea



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

