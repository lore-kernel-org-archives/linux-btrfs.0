Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7C375809
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 09:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417645; cv=none; b=LgXGTmzwLHTyIm3Giv04Xo6bkKRomGG/6DlG6AIx0Ezz5yFBAe+AoeuCCBrS+2I/YA2AvnVRKvBD4oo8wLYiWGrkoBMiVmUTiERVXJCCwDs3i+8QAKPB9nfmt9rVFoBAXxzh/mkT2F6cwgfD3CslSi5o5WPu1OHIraRJorKaGbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417645; c=relaxed/simple;
	bh=JdaRc4Fhy160JUqApMPp2s+sIt10A6a4SX+V44BNcWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zidf3kvRSiYxc+VvJnPdtKQnqAzmSbEkeuYVdT9GRV7w21CP+HZtrMwhpwp2Q0K+69qSVe2QxXg+CQRyolx4+Cphfs06Qt8iqIYJWICeE8nP1LDfr2s34LHKyleZHW/AbvoaJQ+HSUoZKyomFlxbxW1+4FvFbHhq1I2eTfRoj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ByQAlCkM; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ByQAlCkM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776417631; x=1777022431; i=quwenruo.btrfs@gmx.com;
	bh=pUZaI9h8HRzvVgma3g0IyImVFPJBFKcuU7Rg3DBnZa8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ByQAlCkMObJLhdCG8LYw+twQ3RR/kgo4hInRVl8fZi9CB07SL31fCtKX6nJOknFo
	 +hKo+sw72aDAl5gW7qGVY44HFJkRP4VYB3AMS/SZ8lZq5+14czRdmvmMY16hvKTIy
	 TwSpJLPmEncDll7DlI6fZ3y0H+59GpvB6TdhC3gs3eNsxLqcVXXj1p0Oj7LE9iytX
	 RbdBI4C93Kf/rGaAaF4YLs2+LzEnQbTepV5ZlS0CCP0YdcLqOJowQjlEBXe+Gk8xd
	 mGZYrHcEoNS4rscWzBgGX0fv/InIZ2MK7KX5n5XMwlZH8rw5Vq8QTUef3FZz9CthE
	 1NUi0rEN4k4SqzWTSA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUGiJ-1vnR7t1SfD-00M52Z; Fri, 17
 Apr 2026 11:20:31 +0200
Message-ID: <9180d175-397c-45ba-94ac-8b6299fb9ec4@gmx.com>
Date: Fri, 17 Apr 2026 18:50:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: preallocate extent changeset before acquiring
 extent_io_tree lock
To: tchou <tchou@synology.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260417064011.1316310-1-tchou@synology.com>
 <20260417073836.1320467-1-tchou@synology.com>
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
In-Reply-To: <20260417073836.1320467-1-tchou@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:x/Jow1sXhCWucm+0LKRDghVk7y5X7jlticcs/qb1UJj1C9KzAI3
 3+LGf+o0m8JOkEUYjOiRhnlPNaMX2mzaYo0W0XIuyrp2tx0W1UdeLLKy6ePVE3U94/jhvLG
 ZWslNG+hMMr+0r1CZmaXxLhXBMt/oGX4btoVMoqZbk7jm2WtLhBFWxHewNctWvxkRI1ghEp
 d8u5a3MXXSXx2F2w8VPBw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0WNcG63xbrM=;EmQph225iou6Jg3y3zySdsbuFam
 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
 veopmj5cvAH9oG6qLWaLMiIQsMmpp4J4PopY=



=E5=9C=A8 2026/4/17 17:08, tchou =E5=86=99=E9=81=93:
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
>=20
> Signed-off-by: Ting-Chang Hou <tchou@synology.com>
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Now pushed to for-next.

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

