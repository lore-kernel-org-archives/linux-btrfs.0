Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7194B4137AB;
	Wed,  2 Sep 2026 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386543; cv=none; b=ASVbl/suqE/S8AwFiFJiHCrgOhjaYRSCNaSaW9cOzD9HrlOLqRFyn3uhj1XuBeKorn9SDwgmcxR2qYfs1yJrSg3uImK4bQppnxptGIV8QXRJpY7B4SgC2afpyAGEqEXg9Gb9WTbulLgikPUpgKnqBYOxhlxIf0iC9nrI3K40hZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386543; c=relaxed/simple;
	bh=7jrpiqVVpwUKj57+20+fIwb8VHGj8d+snHqmEAQBHlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufT8rpBQ2KS4t7FlJInA+QhANAcPN5xDcGFnitnvMoK0ttBqhw6fWetPwiW3mHbKzVnxYeyL4qeUXs3NP9P5+3Ea/dZvJDTPWXlbFxtelnmuTGFJU6CbliH3recrA4jA+O8jbP431BVQVbZX8LVnx/gz3qmZKRSFig3SWpFcYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WppR/x+O; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WppR/x+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788386531; x=1788991331; i=quwenruo.btrfs@gmx.com;
	bh=pWMJMno3OMAi+0kK12ONdJ4j5VCEw1ca3tPf+NmmLdc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WppR/x+OkZuD/jJNUq369yJGJy035C1W0rIwXNJBNoBpoOAPysjL5K1PorhcpG0y
	 4e8s2MLP/A/NPMib5GxHWj7w3x60bu7nJdpB5brVgIrFR7mocgxA5+JdQiHcgUsKJ
	 l34dcyOB6QWEysqwBfVKEh0JT4Llut9L/I+tpbsODs4XTcp8fNGLTv/ZMw7Ne7tww
	 Cq95SVOsD6zxF8p0D9yvRYsGug8jY0DpkdFkiuJYLpHmwbtQmiG1MqqMW+htyRkgG
	 9xnyWsIeuIoiUk9pEz4sTVJ1OJ6HoLJbv8p3rbdstZMFV2+lkYa9n7IYLILWm8Db1
	 YzCsUVnVu5vf+OFcsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N6KYl-1wmhcx3vTd-017Yml; Thu, 03
 Sep 2026 00:02:11 +0200
Message-ID: <b54b679d-18c7-492e-a4fa-ce797c0748fa@gmx.com>
Date: Thu, 3 Sep 2026 07:32:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: use bio::remaining for async checksumming
 synchronization
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>
References: <20260902165137.3781696-1-neelx@suse.com>
 <20260902165137.3781696-3-neelx@suse.com>
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
In-Reply-To: <20260902165137.3781696-3-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Uspexf1SN75sbWgpPh5Y3u7FO/mMT1cWb0kvFWWs9sOgC3dSpN5
 T83TYuDvUUHz48s+FPn9aKR+l93EHXrok7y2zJNGqM2cxbntZZgvw+8kSo4PL9LxYKZt/Xs
 kOwyNf8rNl/8Ba2OSQh4pUbX/I26TcOIgiOiCcRI1zVfN8yKead8jxN3r7d597P3c4Qmr0R
 UiIV8KxiuoLUIxkvb2s3g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3Ynyi3U3iWg=;z4nzIMMqhYsUgd25FPKRmFz9ZPy
 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
 =



=E5=9C=A8 2026/9/3 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> We can use bio::remaining counter to sync the offloaded checksuming.
> As a result we can slim down the btrfs_bio structure by 24 bytes
> and simplify the code a bit.
>=20
> $ pahole | diff
> -	/* size: 328, cachelines: 6, members: 15 */
> +	/* size: 304, cachelines: 5, members: 14 */
>=20
> Moreover this will allow us enabling async checksumming with encryption
> where we need to checksum the bounce bio instead of our regular one
> embedded in btrfs_bio. And so we need to extend it's lifetime. This is
> the preffered way to do so.
>=20
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   fs/btrfs/bio.c       | 4 ----
>   fs/btrfs/bio.h       | 4 ----
>   fs/btrfs/file-item.c | 6 ++----
>   3 files changed, 2 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 19b4855969f5..771b7d598aee 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -103,7 +103,6 @@ static struct btrfs_bio *btrfs_split_bio(struct btrf=
s_fs_info *fs_info,
>   	bbio->can_use_append =3D orig_bbio->can_use_append;
>   	bbio->is_scrub =3D orig_bbio->is_scrub;
>   	bbio->is_remap =3D orig_bbio->is_remap;
> -	bbio->async_csum =3D orig_bbio->async_csum;
>  =20
>   	atomic_inc(&orig_bbio->pending_ios);
>   	return bbio;
> @@ -114,9 +113,6 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_st=
atus_t status)
>   	/* Make sure we're already in task context. */
>   	ASSERT(in_task());
>  =20
> -	if (bbio->async_csum)
> -		wait_for_completion(&bbio->csum_done);
> -

But what if there is still a running csum calculation at this stage?

Without waiting for the completion, we are going to get incorrect csums.

>   	bbio->bio.bi_status =3D status;
>   	if (bbio->bio.bi_pool =3D=3D &btrfs_clone_bioset) {
>   		struct btrfs_bio *orig_bbio =3D bbio->private;
> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> index b7bd377a0162..bbf362b8668b 100644
> --- a/fs/btrfs/bio.h
> +++ b/fs/btrfs/bio.h
> @@ -58,7 +58,6 @@ struct btrfs_bio {
>   			struct btrfs_ordered_extent *ordered;
>   			struct btrfs_ordered_sum *sums;
>   			struct work_struct csum_work;
> -			struct completion csum_done;
>   			struct bvec_iter csum_saved_iter;
>   			u64 orig_physical;
>   			u64 orig_logical;
> @@ -93,9 +92,6 @@ struct btrfs_bio {
>   	/* Whether the bio is coming from copy_remapped_data_io(). */
>   	bool is_remap:1;
>  =20
> -	/* Whether the csum generation for data write is async. */
> -	bool async_csum:1;
> -
>   	/* Whether the bio is written using zone append. */
>   	bool can_use_append:1;
>  =20
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 5a5cffb18922..50dcd448d936 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -817,9 +817,8 @@ static void csum_one_bio_work(struct work_struct *wo=
rk)
>   	struct btrfs_bio *bbio =3D container_of(work, struct btrfs_bio, csum_=
work);
>  =20
>   	ASSERT(btrfs_op(&bbio->bio) =3D=3D BTRFS_MAP_WRITE);
> -	ASSERT(bbio->async_csum =3D=3D true);
>   	csum_one_bio(bbio, &bbio->csum_saved_iter);
> -	complete(&bbio->csum_done);
> +	bio_endio(&bbio->bio);
>   }
>  =20
>   /*
> @@ -854,8 +853,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool =
async)
>   		csum_one_bio(bbio, &iter);
>   		return 0;
>   	}
> -	init_completion(&bbio->csum_done);
> -	bbio->async_csum =3D true;
> +	bio_inc_remaining(bio);
>   	bbio->csum_saved_iter =3D bio->bi_iter;
>   	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>   	schedule_work(&bbio->csum_work);

