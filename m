Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BB73264DD
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776410176; cv=none; b=PIRiTE33KGUizliIHj9kKomEs2DWpWH6TgW1uWwTl+Ht/kRuITjf4GIVmJxgSf+pvsLyqhbdHTsyK2lHm+3Ob4OBNxoe2viZe8eTXgom6PHewok61oAfpzjVeO0r3mO3WeUEnRSDxBmmVT0TC+Z9leOg0xYm89Rfnf3Xglk/XRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776410176; c=relaxed/simple;
	bh=xcPOvki1Z0km0OmGfHBuUwa+2wETJ0zKnabrEVS6dbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EL8KMMiY1uFKdH6XSzKFpFD7eT8nKAg6lQefm1Jk589fvww1+RzsZ4xx1QqJg3IOB2SqtQ+FH9MEqNT8V7/ZJr06sJRG++mmbKacrmTVvKcxJCp0fNY4HO+h59Iv4Bsxsz8mUCrMroK/XKpoy2kBR6fpw1nPgBaLDqx+73G/AD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=sf0RoCSm; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="sf0RoCSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776410153; x=1777014953; i=quwenruo.btrfs@gmx.com;
	bh=YQfGQbXmqNDczgTnJOCWWMbmJ2hZjF89XNO/yn+4ujI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sf0RoCSmWmSEtLz4aDhihmkALgREyf1Ra84Dl5ZAA+k714m0SZweaMoxB7xfgwyc
	 XxrCRq9uRtBG7xeKFAyQUJwZP+S8q2a5CRj5J61JpL4Jcwi5IOV6pMABmKwI0J1LV
	 wCNFeKWdMowNjzc3hObHQeWiXxK/N0HmcK+Inl7xpt0bWLRThoNjFWz0NQ93eHn8q
	 ijL8VE22GjHC4aGCoosSOPklnsVHQa2eBw2zM8sOWbTXhsKVCXkaEvWbBWT8BiPG/
	 HkffESSkfkihXBmLRqkWR72RIJXqRrZvAHx+imeWha4k9Q07uHuj2Orx7fNgS+so/
	 5Cjng9ijEx/NHEL7Zg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mf0BG-1vlQDt3vWE-00iLo0; Fri, 17
 Apr 2026 09:15:53 +0200
Message-ID: <97f74be3-1630-44b7-a1df-accfad5c4090@gmx.com>
Date: Fri, 17 Apr 2026 16:45:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: preallocate extent changeset before acquiring
 extent_io_tree lock
To: tchou <tchou@synology.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260417064119.1316463-1-tchou@synology.com>
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
In-Reply-To: <20260417064119.1316463-1-tchou@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tzHUTinxQsu++PoIyhzqTamzQEDDcwNVzOS6AkdCFF9mdS20XQ0
 3aavBBelikjqDx6REnyjmUipeliTot7LPIhVxY545SdvUSq/oJiA92lnYnxJDjILBsiQCNe
 swXog6uoWTh0e4y+MvitCLxvCohQk+QulqvO7ZLTkIrJnOmULJIUx8WnaNEFWK67OnIoOoQ
 P6WgooxgDHYaH2cm0q2nw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xzLF2ZlWVu0=;VjKkWzR8MzzhZ4p5gtSP+bbWD0C
 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
 Y6gHAUKgc0EZyRwDnJ6JpyIBmCufZrvIHE80=



=E5=9C=A8 2026/4/17 16:11, tchou =E5=86=99=E9=81=93:
> In btrfs_clear_extent_bit_changeset(), the extent changeset ulist may ne=
ed
> to allocate new nodes. Currently, this can happen while holding the
> extent_io_tree->lock spinlock. Although ulist_prealloc() uses GFP_NOFS t=
o
> avoid deadlock with filesystem reclaim, it's better to preallocate befor=
e
> acquiring the spinlock to:
>=20
> 1. Avoid potential allocation failures while holding the lock
> 2. Be consistent with set_extent_bit() which already preallocates both
>     extent state and changeset before the spinlock
> 3. Reduce lock contention by not doing allocations under the lock
>=20
> Preallocate the changeset ulist node before acquiring the spinlock,
> mirroring the pattern used for extent state preallocation.

Missing the SoB line.

Otherwise looks good to me.

Thanks,
Qu
> ---
>   fs/btrfs/extent-io-tree.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
> index 626702244809..b5ba650cdb55 100644
> --- a/fs/btrfs/extent-io-tree.c
> +++ b/fs/btrfs/extent-io-tree.c
> @@ -663,6 +663,9 @@ int btrfs_clear_extent_bit_changeset(struct extent_i=
o_tree *tree, u64 start, u64
>   		 */
>   		prealloc =3D alloc_extent_state(mask);
>   	}
> +	/* Preallocate the extent changeset ulist node before acquiring spinlo=
ck. */
> +	if (changeset)
> +		extent_changeset_prealloc(changeset, mask);
>  =20
>   	spin_lock(&tree->lock);
>   	if (cached_state) {

