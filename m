Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682253B19B6;
	Mon,  7 Sep 2026 06:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762637; cv=none; b=OZYQoCK0RmBr+ezstbX9V3H/3G7Yeevu7WrDucR5roDsNG1ShfLD4Yc1UPqXCl3/B8OpkNlKpSz3l/dP/p1dZsqNZ8YbdLFcC75HhIJ30OAoHQP4aJxdcA7WRwRFGweaL21gAYHea40pMpAWFHySS21HuoJEE3F4LXkUYemFhgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762637; c=relaxed/simple;
	bh=FWTjpzUXzxFAil0FZFP2Ug04K526azlavwV5haeWFug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufgTV8kpl5tIxcU32e6vBRm7nyeP7Ltc9gwmc/L9JIMLIZzs6kn01z6XSA7ZUM6n30LVRTdjn7BCLt2bGgjWXQL7mW4TakhuOet6BRfjrlc0zM1EVNd5ONqWA9e0F8eOlZFLYK1HJqf64Icg8K/anYub7wTqU4Adqw5Yj9lisK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=TFwkLuUo; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="TFwkLuUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788762630; x=1789367430; i=quwenruo.btrfs@gmx.com;
	bh=+DfA4GaD3zsnCcYB1CG+rO5TRwIYbuU53+8O1ymJvgI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TFwkLuUoBx5w5MeHUCjv+xOiXMdlbxHiimnWgnbg8BwsBd9LHpCvU0J2StIrlbZh
	 mqV/9//C8ocmrLR3KOll+NPjnW7wBGrqJMKGXKfLAcZrcKApSZwlXwCibgcrIzlfa
	 33abdir2k9F+Qv3sKdPw9lPq1/t+6dqMSBIht0hAnbYPpi4Wq8kI9FZzLMzUmkcY2
	 OXK2huWHhvi7+9Knt38k/XRlu3Mzv7UzGzhtyIk7s6PHXk+4eCJ5Xo8HL1FHBMzXC
	 WmX7eEyjWUTOYUR6iocG0pQ+W+7s+Pv/d1Miysthy4AOxa3huvGJcyB4NkCCdWkAf
	 LkE6NQDlIkcsy6reEQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MAwbz-1xAMlo2O7d-00CAA2; Mon, 07
 Sep 2026 08:30:30 +0200
Message-ID: <1a1d2b1d-d533-4f79-abaf-0aea60f895e2@gmx.com>
Date: Mon, 7 Sep 2026 16:00:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] btrfs: tests: rename process_page_range() to
 process_folio_range()
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-1-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-1-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qNqKZQW4j170AzAbFOofdqGwj7Haauxwx+DWSszVPrA+b8L5zJ2
 E6O+QXzFEEmWXC+LMXVTwpD3rK6PMW9n6Vq3anNJyudZyOgCwTrnQ3XvSNzPJZxTYm+1D0n
 bnEPrPdTzIjNo2ioVEY+RgLWqV0IGqo9d8m3PF/B2GtvDBKZRjWD9C0Q7QI6klETsFBIvtq
 KRZRlN6mHIS9Mfke4dtJw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jmQCqKbwBtU=;jxyjq3IIZ0Py4GlHFO+AH75lmBf
 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
 DHXvNuW5pGZIQ



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> It already operates on folios. No functional change.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tests/extent-io-tests.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io=
-tests.c
> index 23459cd4e503..6eb55bfb2bd4 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -18,8 +18,8 @@
>   #define PROCESS_RELEASE		(1U << 1)
>   #define PROCESS_TEST_LOCKED	(1U << 2)
>  =20
> -static noinline int process_page_range(struct inode *inode, u64 start, =
u64 end,
> -				       unsigned long flags)
> +static noinline int process_folio_range(struct inode *inode, u64 start,=
 u64 end,
> +					unsigned long flags)
>   {
>   	int ret;
>   	struct folio_batch fbatch;
> @@ -221,8 +221,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   				test_start, max_bytes - 1, start, end);
>   		goto out_bits;
>   	}
> -	if (process_page_range(inode, start, end,
> -			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> +	if (process_folio_range(inode, start, end,
> +				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
>   		test_err("there were unlocked pages in the range");
>   		goto out_bits;
>   	}
> @@ -276,8 +276,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   			 test_start, total_dirty - 1, start, end);
>   		goto out_bits;
>   	}
> -	if (process_page_range(inode, start, end,
> -			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> +	if (process_folio_range(inode, start, end,
> +				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
>   		test_err("pages in range were not all locked");
>   		goto out_bits;
>   	}
> @@ -317,8 +317,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   			 test_start, test_start + PAGE_SIZE - 1, start, end);
>   		goto out_bits;
>   	}
> -	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
> -			       PROCESS_UNLOCK)) {
> +	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
> +				PROCESS_UNLOCK)) {
>   		test_err("pages in range were not all locked");
>   		goto out_bits;
>   	}
> @@ -330,8 +330,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   out:
>   	if (locked_page)
>   		put_page(locked_page);
> -	process_page_range(inode, 0, total_dirty - 1,
> -			   PROCESS_UNLOCK | PROCESS_RELEASE);
> +	process_folio_range(inode, 0, total_dirty - 1,
> +			    PROCESS_UNLOCK | PROCESS_RELEASE);
>   	iput(inode);
>   out_root_info:
>   	btrfs_free_dummy_root(root);
>=20

