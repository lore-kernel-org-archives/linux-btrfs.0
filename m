Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0038AC8A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 21:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374948; cv=none; b=CVmBiJPZUuEgdHgTpW8ZS8yZGu3cWhZ4GQa24vSlZYvT7aG30Gsjeu6JFBNTATX+lstQgtYP5mEC4CII4SP32AWLnOT4VvfE+JiuoRm9ejQl0hunOO3BUFzg4qSmwqA/8ZXFTOI6NOgrp/RHVi1M1WzhXmpCFRIsS3Xf74zkRJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374948; c=relaxed/simple;
	bh=kh+l9VYE44BKXw5Ym0lnxpU3MRtmhVMLMpWN5JrT8sY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=K2fNxAXCp1hS5Usohf9rACluKKy+4bD/kvwRW6BGYgv8nI6n166d6qz0Z6cLrmZ2O581+VAByWzWzVflHWrL/YvAZAoqkPETDoiyTeIlo4uxAqBgbRDBiJj27BUgPY4DXZdXbeWUSp4y3yV4/TMUrJpoJk15W2P3OyHfcQSUKn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tt5z/Ru1; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tt5z/Ru1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776374943; x=1776979743; i=quwenruo.btrfs@gmx.com;
	bh=85QAsr+gUy4KA7H/rljL0WRQYXBo0O6QIYUGBB/ZbUM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tt5z/Ru1Mju+R0Mm6FfV0N6CM10c+s+RC9Ut/W8MbMnQ9JCxelDaZHENeI3OhFyT
	 7MsKb9+Sy8Cju1yBLHa1K+VwoyDPSLyL05uGkTAXo8D70l40X0TAzjym4PFjenHXn
	 8VPfYcnDCssUKUeYUQZheLQS6xS5kRA4BkUy0Xo41YL0w7SH+nKcuRB4xyv4k4kea
	 vQsW7Dgh2hIxsgk31Ga7kcLxhYITKV6GAXAoUT2a5p9F7KK6NRO2JeD9NFQ/3Uaor
	 MlyGcu4/n8AePhTBkMQD1Q7U6PFiTbKe/G1Fr1Vlw9/wJ/R3TgLjfTY0VBXkr6yqf
	 XsVqueBFm8qxJkq/Jg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQv8x-1w1Zmb1u23-00Tq70; Thu, 16
 Apr 2026 23:29:02 +0200
Message-ID: <b9b1f7e7-91f3-4b26-905b-6da1359ebe9d@gmx.com>
Date: Fri, 17 Apr 2026 06:58:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix double-decrement of bytes_may_use in
 submit_one_async_extent()
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <20260416174359.262120-1-mark@harmstone.com>
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
In-Reply-To: <20260416174359.262120-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+Dp6PDRkrp+37xXGTXXyx/pb57NxEG8WTqtiCJoeUo8jp0MmHa7
 nvPCoil2enfT9cWPFFSE+p5mNiehp1ExjcpCpytczahfGcGhfXT44YxjV7SKnbm9mY5QOiA
 37tf5aoZdgxtZDEsQeKzEMjEK3quSM/DGMiSAA4H/578GIglZcfZOtwzyySEZR11HQ88X4l
 BerUFN5ivYD5zkrCr2CDQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QvU7U1Bshis=;We5KZJlSEhLji/svEsvbVVOWca0
 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
 TO4fyemxDgrZ5hiG5PJlq2zjTeuxXqdHygG0=



=E5=9C=A8 2026/4/17 03:13, Mark Harmstone =E5=86=99=E9=81=93:
> submit_one_async_extent() calls btrfs_reserve_extent(), which decrements
> bytes_may_use. If the call btrfs_create_io_em() fails, we jump to
> out_free_reserve, which calls extent_clear_unlock_delalloc().
>=20
> Because we're specifying EXTENT_DO_ACCOUNTING, i.e.
> EXTENT_CLEAR_META_RESV | EXTENT_CLEAR_DATA_RESV, this decreases
> bytes_may_use again. This can lead to problems later on, as an initial
> write can fail only for the writeback to silently ENOSPC.
>=20
> Fix this by replacing EXTENT_DO_ACCOUNTING with EXTENT_CLEAR_META_RESV.
> This parallels a4fe134fc1d8, which is the same fix in cow_one_range().
>=20
> Fixes: 151a41bc46df ("Btrfs: fix what bits we clear when erroring out fr=
om delalloc")
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 36bbf2297a9987..abedaeb45189a2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1204,7 +1204,7 @@ static void submit_one_async_extent(struct async_c=
hunk *async_chunk,
>   				     NULL, &cached,
>   				     EXTENT_LOCKED | EXTENT_DELALLOC |
>   				     EXTENT_DELALLOC_NEW |
> -				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
> +				     EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV,
>   				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
>   				     PAGE_END_WRITEBACK);
>   	if (async_extent->cb)

