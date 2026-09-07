Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE8371D01;
	Mon,  7 Sep 2026 06:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763499; cv=none; b=nxqZnwRRz5BZUcMU4PS5yyJq4aaDjAmocdercChczFOTl6iOxWFOHl2Vs/75H6YVg5j9WDnjJAi17WPoDyVA56vpV6tkXK9i+Jc4qArxwHhmVlfJIBZhOT0CeQP8afk95ckFPWsgIO3Q5Njszhv3/kqRLyRJMBOYJZtitV2a87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763499; c=relaxed/simple;
	bh=lB9ZXHwJS1gT8xw1AAGrtQFjW8rYEg21dySRIqI0Kjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OJbuKglh6G7MJoQ3l13WdY0U9VPTRHUKFDpUyzqslvamvkXYoVvyF3sskp7rAlIokS07yFuJ0YegoczxMkdkhlVMlGZ8NUfWy7pRf+dQ088C+LdyCk/Jflblmw1DZtomQvh24eYdNM7vl/xn1kbmce/9lYHoRPYmti3u8qrbXAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cGEEXJx0; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cGEEXJx0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788763479; x=1789368279; i=quwenruo.btrfs@gmx.com;
	bh=7tr6XnlAkS95O6/cgXubIGAc9Z0uHDPPtXowQu+fRzU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cGEEXJx04ZCILd+XXdZas7/9Cft584j2+IRQO5ln1k6OSfWhkIsf9R+PgDEqYOGd
	 8uNuyPOoHK5hMggCJfbgx6nICs5iRQNYPXRpcjozKJfgV19Iy4KoplcfXpYO2gd06
	 uLoJWPwJ46Fu8c3M3SgqQx33u9e1ACCs7YxTwT2+s9q3iUiGNyZ3ks3BRd7vN+SIK
	 bRhi+LZzieKsDrauDgGV2krPrWmHvbYw3VCOPiQyUz9PwBsvBoRX416XsFPLRWnjX
	 dCq3ZSdWbfCi8nxvpf4tuWD3NQoCFFo/Trji2Y1sXoV+NBUk+VS050g0sWfuWyGEi
	 yGPVAX9Psi+H8g2/BA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MPXhA-1xG27w3gyw-00Okh9; Mon, 07
 Sep 2026 08:44:39 +0200
Message-ID: <2901102a-2688-485f-8cc5-016b3e1ecbc6@gmx.com>
Date: Mon, 7 Sep 2026 16:14:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] btrfs: convert heuristic_collect_sample() to use
 folios
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-5-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-5-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ODps8Ti5smcvyWM1yjUhkUC70FdsDvim27L6IFc/cvOv+UaB47p
 uqVj+ATX0sGcMrS/h2GWI8jv5RD2yRG7BPDh0aprcJbMrUvEF+mTGcwPCSj3vu0/TGW776/
 rZeJ41oquiQfnqGftpK4+B9LY+bbBBdbYYMgdRMn3DZdrL3T2+o30cj/1rd6cG/F8nZTb37
 9WmQn6HztsrVY2XwuJtCg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3m5G3eSJ39I=;1avhtvo8zDAFRvAyLs/oOqna584
 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
 xj6ZrYpWk4SxTPIAY83dS3Wzj8ebrL1jSug==



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> Convert the sampling loop to folios. This removes the last caller of
> find_get_page() in btrfs and saves a call to compound_head() per sampled
> page. Document that the lookup is not supposed to fail with an ASSERT().
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Although the existing code doesn't looks particularly well, e.g. it's=20
still fully based on page index, and not handling large folios correctly=
=20
that well.

E.g. if we hit a large folio, we can handle the whole range inside the=20
folio in one go, without the need to grab example pages by pages.

But that's for future improvement, and shouldn't bother your page->folio=
=20
interface change.

Thanks,
Qu
> ---
>   fs/btrfs/compression.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 979b2ffbd8fc..fa8b92592321 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1488,7 +1488,7 @@ static bool sample_repeated_patterns(struct heuris=
tic_ws *ws)
>   static void heuristic_collect_sample(struct inode *inode, u64 start, u=
64 end,
>   				     struct heuristic_ws *ws)
>   {
> -	struct page *page;
> +	struct folio *folio;
>   	pgoff_t index, index_end;
>   	u32 i, curr_sample_pos;
>   	u8 *in_data;
> @@ -1514,8 +1514,10 @@ static void heuristic_collect_sample(struct inode=
 *inode, u64 start, u64 end,
>  =20
>   	curr_sample_pos =3D 0;
>   	while (index < index_end) {
> -		page =3D find_get_page(inode->i_mapping, index);
> -		in_data =3D kmap_local_page(page);
> +		folio =3D filemap_get_folio(inode->i_mapping, index);
> +		ASSERT(!IS_ERR(folio));
> +		in_data =3D kmap_local_folio(folio,
> +				offset_in_folio(folio, (u64)index << PAGE_SHIFT));
>   		/* Handle case where the start is not aligned to PAGE_SIZE */
>   		i =3D start % PAGE_SIZE;
>   		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {
> @@ -1529,7 +1531,7 @@ static void heuristic_collect_sample(struct inode =
*inode, u64 start, u64 end,
>   			curr_sample_pos +=3D SAMPLING_READ_SIZE;
>   		}
>   		kunmap_local(in_data);
> -		put_page(page);
> +		folio_put(folio);
>  =20
>   		index++;
>   	}
>=20

