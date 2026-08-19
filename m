Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F583B8944
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135794; cv=none; b=csSi2t39NFMzeIldCeTRf/tEPey3zQ8pBBTHjK1A1OpjSB7ceGfSBniBtq4OZPrdNhYR7jePOSoqBaD3bx5+c+zsuK9R3V8rHxcWzVnLvV/em9Jb9duz0KvNLIbyDPutv5D2sherbUbFcQf0wxyyS9zQFkdXuH5ncFix7jmNNMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135794; c=relaxed/simple;
	bh=GwVQgGdPi9H4wTb28mN/IaY58bwQMHFDGV9gJr4QOnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q082UNvruq66lJ2q/5btzJT78THDFw6+Bucqikq4dXJwaHhS1qQ7XkChI0Wxx3kmih/Jed8UX9tSa9rLsGXdklOYjxhevx8EoqdRpMvCwdSkv1TXZBrLnc09b9j5uREXObJTBtRkzkUH/+C+xL+7zlYZftBtBRhMiFTn8P27b1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=T85UaxVC; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="T85UaxVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787135786; x=1787740586; i=quwenruo.btrfs@gmx.com;
	bh=UO6fBREo3buFZaV+jPIW3ivnB2usiuw8Mmqcf+mCFL4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=T85UaxVCWuS0z1E14lkMUi95s+NewVBYMSaiwMsloFmerooY6TwlJqh2BXjreJ9o
	 8TaJddYWM90wVA1FpSHkHaBwCZm5sNB7n9gyx98RCoIjr46P6ajQK7CjIWFFrACo/
	 XUx1LVzv35956PxyBZx7LjY333NZXFr7vT6rDDNP+DqKKT8ZPuoino/hC8/Utfqsn
	 9ECGl/xW7oI48+jRgBvPsCEWP1ZG9/ZmOMr22fhlaVb55MubyXmxpKhxemjWEZETA
	 9XCIcAhnIMx2w2i8KSoE6/a50lJo7b5NwRuGVitZFw6tPVgR91WMSFYOz/Llo3tf/
	 SH1qnSqBBo+bsPalFg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MNt0M-1xKvq60QrQ-00W1Pq; Wed, 19
 Aug 2026 12:36:26 +0200
Message-ID: <cd693c05-8b33-4888-a0f2-318183625633@gmx.com>
Date: Wed, 19 Aug 2026 20:06:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: finish active block group cleanup if
 call_zone_finish() fails
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20260819102636.1423347-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260819102636.1423347-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QRaYIwCmfdIrJXPkaiz7jf1QTbTIojBMJs0+N3eybvY0K+frmaH
 3WIJObwOAp704bDNxPcgH7Xs5e+WRAr0RSNmntJQzpF85EbPGoNvPmutrvFp36ycghs62HV
 XjBO0k4K0KSRMqZA4H8ys8PqGFSYtJrpjO0y2oKJNeObsqil2h7wd8ORDHvTmpFCHtKTyKF
 telBUEU4h1wODvPqqa7yQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gXBFfE5AaOU=;dlvWYLC/2CjYyDrIpDQy+qNO5MX
 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



=E5=9C=A8 2026/8/19 19:56, Johannes Thumshirn =E5=86=99=E9=81=93:
> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
> the zones. If call_zone_finish() then fails it returned early, leaving t=
he
> now inactive block group on fs_info->zone_active_bgs, leaking its
> reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
> its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() kee=
ps
> selecting it, spinning btrfs_zoned_activate_one_bg().
>=20
> Fall through to the cleanup on failure too and return the error, but kee=
p
> the block group read-only as its zones are left inconsistent.
>=20
> Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
> Link: https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.t=
humshirn%40wdc.com
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/zoned.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 82c2394dd43c..9d448cdd60c4 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2628,14 +2628,12 @@ static int do_zone_finish(struct btrfs_block_gro=
up *block_group, bool fully_writ
>   	for (i =3D 0; i < map->num_stripes; i++) {
>  =20
>   		ret =3D call_zone_finish(block_group, &map->stripes[i]);
> -		if (ret) {
> -			up_read(&dev_replace->rwsem);
> -			return ret;
> -		}
> +		if (ret)
> +			break;

I'm wondering should we continue to finish the other stripes instead?

>   	}
>   	up_read(&dev_replace->rwsem);
>  =20
> -	if (!fully_written)
> +	if (!ret && !fully_written)

Not familiar with zoned code, but if we hit an error, the block group=20
will stay RO.

Is that the expected behavior?

The branch for bg with FLAG_ZONED_DATA_RELOC case, we return -EAGAIN but=
=20
decrease the bg RO before returning.

So it looks like we should always decrease the bg RO even for error case?

Thanks,
Qu

>   		btrfs_dec_block_group_ro(block_group);
>  =20
>   	spin_lock(&fs_info->zone_active_bgs_lock);
> @@ -2648,7 +2646,7 @@ static int do_zone_finish(struct btrfs_block_group=
 *block_group, bool fully_writ
>  =20
>   	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>  =20
> -	return 0;
> +	return ret;
>   }
>  =20
>   int btrfs_zone_finish(struct btrfs_block_group *block_group)

