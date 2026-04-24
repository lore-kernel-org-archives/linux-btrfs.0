Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A93829ACCD
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777012716; cv=none; b=P9iL5JibhF+b/mMmUZPbgWtc5VoLz31AwPnHLbK8ycMAOG+g8yZ2mOHVYWYxrcczaoc0JDA3uc+k2oU8F4+KwIH4SOZqYoL6FC+5iCjdFNYOtCkGItxblIMHEmcagk4udCPX5LoJuP5YendKFYsJNLtqHHs/JhZhXTs75D8+4lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777012716; c=relaxed/simple;
	bh=dMwUTE1e2HWwlKdXLhwBswTlBNZunzoqtSeF8AJfU54=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jxwQerGiMiyY3H2SGe/2tT1H5ljCITD/+d9ksKV8/BY3VuPm/htJpNZmesyH+ktfA4ktiGGDLQZ/eix26AzfcWUOkadntK9oMbipxlg28iH+DR6egP5xfmqkdLUVRs71T3wpah+xBFf/0WW5LcGUz+whmr4Okwv0d4l5pXhJ7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Ivfr0WUh; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Ivfr0WUh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777012705; x=1777617505; i=quwenruo.btrfs@gmx.com;
	bh=KbycquSKC6o+Z4iBolUw53UWwZ7AGxk23LI5THT1w94=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Ivfr0WUhWfMy3wrqBqOIQM8NQQuAEEPGhUUIYyGwYGfhORSM0jLYEBaepvstuI0k
	 6vrnozZtXenuMnBqb72AYJoELGdoH9qo4G2OvSLGZukRk7mUNM5BLeknGBaHmg4Z6
	 NdGUgoXqhjuan9lz/HPOWJufzPUelF3BZ/rzigyeB9flZspTkCfNOjLl3UJ5lJH4O
	 R07KgmXbY2DVU+CQuobXWRfTQKPs4qv9sgGRcLsjD9ZKK8Wbsl6YOaTjfEecLPyCG
	 WfNPUFDCXBlLCUmlQoojaAxMGCj7WkDt0wfY0DaxaXXphhhG8H4ydejehViuAmXmH
	 xL+/hZ5ZQW8ScvXfCQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N7QxB-1vJppU0zfR-00sUke; Fri, 24
 Apr 2026 08:38:25 +0200
Message-ID: <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
Date: Fri, 24 Apr 2026 16:08:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
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
In-Reply-To: <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MJ07vfyXGy0R2mR/aA/z0j5AyO6yy1XdN4T9Pb8RijR7Et8NQgv
 fiWdopNaBuOIukdtJzBrwoukstHyqV/XbvgeoiGaE7QOAezn/KkYp9F/cH0X2KNSbrTu/tz
 WnBsDv6UuRkFSy66oAIQyPV9CI4aXVUUm60jLUaLOj+u+c2w/0DguG1QsTh7e5Cglj8TALA
 VhMrCKnA0S1xFyrHfJmVw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:IWb5aqVLUxA=;NuXLF5x7tUzGcgbXrHBIhqJ02T0
 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



=E5=9C=A8 2026/4/10 03:18, Boris Burkov =E5=86=99=E9=81=93:
[...]
>=20
> This means iterating over to_reclaim by 128MiB at a time until it is
> drained or we satisfy a ticket, rather than trying 3 times to do the
> whole thing.
>=20
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Boris Burkov <boris@bur.io>

Hi Boris,

I'm testing the latest for-next base as the baseline for the incoming=20
huge folio support.

On arm64 64K page size, 4K fs block size, I'm seeing a very weird=20
behavior on generic/027.
On 7.0-rc7, the test case takes less than 5 seconds and passes as expected=
.

But on for-next it never finished, furthermore there is always a kworker=
=20
taking a full core, deadlooping inside=20
btrfs_async_reclaim_metadata_space(), and you can not unmount the fs.

Here is the "echo l > /proc/sysrq-trigger" stack dump for the involved=20
btrfs kworker:

[ 6616.093728] CPU: 0 UID: 0 PID: 501715 Comm: kworker/u33:0 Not tainted=
=20
7.0.0-rc7-custom-64k+ #9 PREEMPT(full)
[ 6616.093732] Hardware name: QEMU KVM Virtual Machine, BIOS unknown=20
2/2/2022
[ 6616.093734] Workqueue: events_unbound=20
btrfs_async_reclaim_metadata_space [btrfs]
[ 6616.093849] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS=20
BTYPE=3D--)
[ 6616.093852] pc : btrfs_start_delalloc_roots+0xf0/0x268 [btrfs]
[ 6616.093923] lr : btrfs_start_delalloc_roots+0x88/0x268 [btrfs]
[ 6616.093987] sp : ffff80008af0fbd0
[...]
[ 6616.094008] Call trace:
[ 6616.094009]  btrfs_start_delalloc_roots+0xf0/0x268 [btrfs] (P)
[ 6616.094073]  flush_space+0x3d4/0x6b0 [btrfs]
[ 6616.094138]  do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
[ 6616.094201]  btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs]
[ 6616.094263]  process_one_work+0x174/0x540
[ 6616.094277]  worker_thread+0x1a0/0x318
[ 6616.094279]  kthread+0x140/0x158
[ 6616.094285]  ret_from_fork+0x10/0x20

So it's a regression, and bisection points to this patch.

And I tried the following steps to further confirm it's caused by this=20
commit:

- The test passes just before the commit
   The previous commit is "btrfs: make inode->outstanding_extents a u64".

- The test failed at that commit
   The test case never finish and one kworker dead looping.

- The test case pass at for-next with this commit reverted
   The test case finishes in seconds as usual.

Do you have any clue on what's going wrong? I guess it's pretty hard to=20
hit on x86_64.

I have a local btrfs branch with huge folios support, with that it's=20
pretty easy to hit similar problems on x86_64, but without that branch,=20
no hit is observed so far on x86_64.

Thanks,
Qu

> ---
>   fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
>   1 file changed, 20 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f0436eea1544..e931deb3d013 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -725,9 +725,8 @@ static void shrink_delalloc(struct btrfs_space_info =
*space_info,
>   	struct btrfs_trans_handle *trans;
>   	u64 delalloc_bytes;
>   	u64 ordered_bytes;
> -	u64 items;
>   	long time_left;
> -	int loops;
> +	u64 orig_tickets_id;
>  =20
>   	delalloc_bytes =3D percpu_counter_sum_positive(&fs_info->delalloc_byt=
es);
>   	ordered_bytes =3D percpu_counter_sum_positive(&fs_info->ordered_bytes=
);
> @@ -735,9 +734,7 @@ static void shrink_delalloc(struct btrfs_space_info =
*space_info,
>   		return;
>  =20
>   	/* Calc the number of the pages we need flush for space reservation *=
/
> -	if (to_reclaim =3D=3D U64_MAX) {
> -		items =3D U64_MAX;
> -	} else {
> +	if (to_reclaim !=3D U64_MAX) {
>   		/*
>   		 * to_reclaim is set to however much metadata we need to
>   		 * reclaim, but reclaiming that much data doesn't really track
> @@ -751,7 +748,6 @@ static void shrink_delalloc(struct btrfs_space_info =
*space_info,
>   		 * aggressive.
>   		 */
>   		to_reclaim =3D max(to_reclaim, delalloc_bytes >> 3);
> -		items =3D calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
>   	}
>  =20
>   	trans =3D current->journal_info;
> @@ -764,10 +760,14 @@ static void shrink_delalloc(struct btrfs_space_inf=
o *space_info,
>   	if (ordered_bytes > delalloc_bytes && !for_preempt)
>   		wait_ordered =3D true;
>  =20
> -	loops =3D 0;
> -	while ((delalloc_bytes || ordered_bytes) && loops < 3) {
> -		u64 temp =3D min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
> -		long nr_pages =3D min_t(u64, temp, LONG_MAX);
> +	spin_lock(&space_info->lock);
> +	orig_tickets_id =3D space_info->tickets_id;
> +	spin_unlock(&space_info->lock);
> +
> +	while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
> +		u64 iter_reclaim =3D min_t(u64, to_reclaim, SZ_128M);
> +		long nr_pages =3D min_t(u64, delalloc_bytes, iter_reclaim) >> PAGE_SH=
IFT;
> +		u64 items =3D calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
>   		int async_pages;
>  =20
>   		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> @@ -811,7 +811,7 @@ static void shrink_delalloc(struct btrfs_space_info =
*space_info,
>   			   atomic_read(&fs_info->async_delalloc_pages) <=3D
>   			   async_pages);
>   skip_async:
> -		loops++;
> +		to_reclaim -=3D iter_reclaim;
>   		if (wait_ordered && !trans) {
>   			btrfs_wait_ordered_roots(fs_info, items, NULL);
>   		} else {
> @@ -834,6 +834,15 @@ static void shrink_delalloc(struct btrfs_space_info=
 *space_info,
>   			spin_unlock(&space_info->lock);
>   			break;
>   		}
> +		/*
> +		 * If a ticket was satisfied since we started, break out
> +		 * so the async reclaim state machine can process delayed
> +		 * refs before we flush more delalloc.
> +		 */
> +		if (space_info->tickets_id !=3D orig_tickets_id) {
> +			spin_unlock(&space_info->lock);
> +			break;
> +		}
>   		spin_unlock(&space_info->lock);
>  =20
>   		delalloc_bytes =3D percpu_counter_sum_positive(

