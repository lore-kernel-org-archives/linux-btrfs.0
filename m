Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758A43B8405;
	Thu,  9 Jul 2026 10:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593073; cv=none; b=rVMsMI7EvbgFjqprCNvc/mEjLuzhpHGVkB8kkH1kW345QFyMt6U2S1cDZH4CPsX2Ro8IH32gFvQcPDsND//kphp79IovK6wE/uza1HraWsUEZfWHkU8IVZoHP7ZWt1WRW8W03sqFIUVRnnPvTUkQslByotlQcS9ZANSrtELvKRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593073; c=relaxed/simple;
	bh=hVOdM/wwTvMFTEqKIYybUMIu8qalVtUlhUVHuynR9eM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4LBEj0cpxPiBy1u63Oe/YgM8msOfkDbQa76nbRUl4w+LnpdA7XgOR1SZRo6qVUyKVGfsYRzs/z7Ixx9mR0g4rf+P7/mii8616D3iy3CQZOlBxggYYE7sPR0/njoki8bT9V1OkR4umZvAKZQ2IhIo2/jl3WL1dzicIDpmnUAOFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WSE5SWFY; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WSE5SWFY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783593069; x=1784197869; i=quwenruo.btrfs@gmx.com;
	bh=NySWNMFuI5sUzF4T4yOFLMgRWOH2pH/Yl/vD8UbRu0Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WSE5SWFYRyV/pJqegfjgtnjpUrAFnk6gzFJMZwtEI1ocrPPq1NXH9/Qq2AGnDvOn
	 KP8ok/IC2HjVVcMXY40B3eY4jZS5ghIDcj1l1MV6Za6UM5fBjEA5wVSpfZ6hQOK0Q
	 LrJJDLscJXIUG5vCZGUwQFc25Nub2CSJGu3NqNqh7Afyn52bCJtfiqVXkz0cqNIlz
	 yXag4kqLnLSo9CQP/VZkjcLkeOD/e4bRjtR1Z3G2l8+ehTwIjxE2D5Bcfx/QNjD9C
	 YHwNzA5c8BET6JxCcVvX6tCdjWg3UrMCUHPkFFP9uoRbZY+YtZ/ys8KZxMSDhzZ4n
	 /tkTdvxARBcxk0aN5g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N17YY-1x5Ryh0FVi-015max; Thu, 09
 Jul 2026 12:31:09 +0200
Message-ID: <38704f1d-5880-4162-9051-4e6d0086f8aa@gmx.com>
Date: Thu, 9 Jul 2026 20:01:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't submit orphaned extent buffers
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, stable@vger.kernel.org
References: <20260703055431.117181-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260703055431.117181-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:szludWcFR9+Fz08p5bkTqTXpPztjo4zG0YFzu+pZymhpz0OpIJ5
 vfXIle6lcTCyN1CyK1/RAHXU5SOUEIotYkx6vjkBy/T7/gNhUkPba6SyXM/LbYPrvo/zcEX
 zWCglQvpHdofCqUi86IxxUJDX0PbBLclIHNklNGQYxrfhv1a8P/JmY9xx43KME+cQbJN88S
 KpdeD/mSe6IOZIniI4vFw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XSSd7aQXKfk=;wPXzER/EOLNiwYMMV8boQ2s41JA
 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
 IBR1+/oHF72OUDmZ0KjYw5JQIOitEcri/zmFfLO



=E5=9C=A8 2026/7/3 15:24, Johannes Thumshirn =E5=86=99=E9=81=93:
> On a zoned filesystem btree_writepages() can encounter a dirty metadata
> extent buffer whose block group no longer exists. Submitting a write for
> such a buffer maps it to a stale/removed block-group and leaves the foli=
o
> under writeback forever, hanging later in filemap_fdatawait_range(), for
> example the iput(btree_inode) in close_ctree(), which then hangs unmount=
.
>=20
> This is caused by btrfs_clear_buffer_dirty() not clearing the dirty bit =
of
> a freed tree block but it sets EXTENT_BUFFER_ZONED_ZEROOUT and keeps the
> buffer dirty so that it is still written out to keep the zone's
> meta_write_pointer advancing sequentially. So a freed metadata block
> legitimately stays dirty until that zero-write completes.
>=20
> Dropping these buffers is safe: the block group is empty, so they are
> stale, unreferenced, already-freed blocks. Once the zone is reset their
> zero-write is unneeded. Instead of submitting a such a write, finish the
> writeback immediately.
>=20
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Fixes: 7db94301a980 ("btrfs: zoned: introduce block group context to btr=
fs_eb_write_context")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/extent_io.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0edd532174fa..4a029ae719e9 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2280,7 +2280,8 @@ static void prepare_eb_write(struct extent_buffer =
*eb)
>   }
>  =20
>   static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
> -					    struct writeback_control *wbc)
> +					    struct writeback_control *wbc,
> +					    bool submit)
>   {
>   	struct btrfs_fs_info *fs_info =3D eb->fs_info;
>   	struct btrfs_bio *bbio;
> @@ -2310,6 +2311,12 @@ static noinline_for_stack void write_one_eb(struc=
t extent_buffer *eb,
>   		wbc_account_cgroup_owner(wbc, folio, range_len);
>   		folio_unlock(folio);
>   	}
> +
> +	if (!submit) {
> +		btrfs_bio_end_io(bbio, BLK_STS_OK);
> +		return;
> +	}
> +
>   	/*
>   	 * If the fs is already in error status, do not submit any writeback
>   	 * but immediately finish it.
> @@ -2397,6 +2404,8 @@ int btree_writepages(struct address_space *mapping=
, struct writeback_control *wb
>   		struct extent_buffer *eb;
>  =20
>   		while ((eb =3D eb_batch_next(&batch)) !=3D NULL) {
> +			bool submit =3D true;
> +
>   			ctx.eb =3D eb;
>  =20
>   			ret =3D btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
> @@ -2411,6 +2420,9 @@ int btree_writepages(struct address_space *mapping=
, struct writeback_control *wb
>   				continue;
>   			}
>  =20
> +			if (btrfs_is_zoned(fs_info) && !ctx.zoned_bg)
> +				submit =3D false;
> +
>   			if (!lock_extent_buffer_for_io(eb, wbc))
>   				continue;
>  =20
> @@ -2420,7 +2432,7 @@ int btree_writepages(struct address_space *mapping=
, struct writeback_control *wb
>   				btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
>   				ctx.zoned_bg->meta_write_pointer +=3D eb->len;
>   			}
> -			write_one_eb(eb, wbc);
> +			write_one_eb(eb, wbc, submit);

I understand this is the minimal fix, but I can't help but wondering,=20
would it be more instinctual to release all ebs inside a zoned metadata=20
bg when freeing the bg?

Thanks,
Qu

>   		}
>   		nr_to_write_done =3D (wbc->nr_to_write <=3D 0);
>   		eb_batch_release(&batch);

