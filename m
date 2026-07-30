Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB31624C0
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373721; cv=none; b=K9BL5OIt3WWCsqM1jqhTwR44hzhK5RcOQbSyFoXwrCOjfRzCrvN2JX1VHfiDximzu3e5jPzIJKeUKk2AY9TnUzFOrYkN2/Mhzq8upqRU+Wk/jurGwUt5jGdJnpLIww8ETdkIhoUvLVj0aeRsgEBpli1zBw9npMxNNCquL0pM0y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373721; c=relaxed/simple;
	bh=QbGY5znD80w6P0wVn9L+LNsZC5xA+AXsrhTLSw7RjEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u9shuJ9nn/yYHpEkKqSRhisv5R3qvULjRFwasziaVwUbY1e6WPa8cHGLowRROgcNBk0RMbQVPYcgvi8RjQuOkQiuWEkvM5jl2hMbqsO3LPiV1wyFozjcX3hkYuD3YUSPRaIj9gmJay8nTFk0IzXAJFTeoZt6qo7UZkc5wF0lLBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=iM7lhcWB; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="iM7lhcWB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785373710; x=1785978510; i=quwenruo.btrfs@gmx.com;
	bh=7gF42/TwKAenxbkKGtE+yfJx+MAhFXRFQfwTc+hfRZ0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=iM7lhcWBNvhfE6H9ADSdDxCi4HYxM7XO5a0O2DDtf81hIKx1ka99xqNDNbZGifuZ
	 O9CWQHqkjOh3n0sP60jvHEzzcNEZcgtB4sa7A9ZkEPSte+GJEtIqgl45LfL9VKtlt
	 2l9eES1FzXh1ItrDOeHVm6QPmvC9A5P6TRu76k4Ubp+Cp6CgVNl1j5gDaSWRMlbDx
	 HUeHPYABsKpoV2ZUpQFSN6TbfGL7g7iG4Bgpq3HRkBSusew8f7V6LDPt1vSSwx2IQ
	 TEvlgiH88g0w1juGOEpYHm8Q9dpcqbcmnb657BF/vCgONStRtIGzIsjse0jJ7fCyL
	 H3wYvHeN3NvOsOcFDg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N6sn7-1x0zYo45T5-00yXvs; Thu, 30
 Jul 2026 03:08:30 +0200
Message-ID: <60324a9c-6506-4583-9961-e8d9ecd43754@gmx.com>
Date: Thu, 30 Jul 2026 10:38:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] btrfs: flush the fixup workers during close_ctree
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <8b2ac16ef9cce964c2546a71249514899268cfa5.1785373134.git.boris@bur.io>
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
In-Reply-To: <8b2ac16ef9cce964c2546a71249514899268cfa5.1785373134.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VS773GH8EjhtIrcejfArKcp/EblXXnxMk4YrFuuRyA6gqlhdHq7
 By31mTckMP10nt3w3SBrapgyKh1qWMRRQ8Mb6LA2H3jSFrQ/0zTYmHpYAZtfUN2Oxsd1wui
 BxQK95WY+iDK4wQ2Q6lVWNkPNWSBGNr+c/UFrZ9zMJFvJV4KzS+GFIHg4pcSM9mASI7RD7f
 e79NWjftwgDPyqlYY/xoQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3K+RpFOIaW4=;hLSUaZWiwqH8S8u5LGmQEupvbur
 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
 qmsw8VoaDQRHFtfVJOb90DJrxTHm6iByUw==



=E5=9C=A8 2026/7/30 10:29, Boris Burkov =E5=86=99=E9=81=93:
> Reintroducing the COW fixup worker brought back the unmount race fixed
> by commit 41fd1e94066a ("btrfs: wait for fixup workers before stopping
> cleaner kthread during umount") without bringing back the fix.
>=20
> A fixup work item queued by the final writeback pass can still be in fli=
ght
> when close_ctree() stops the cleaner kthread and frees the fs roots.
> While destroy_workqueue() drains the queue, that happens after the
> cleaner thread was freed, so btrfs_add_delayed_iput() called from the
> fixup worker is no longer safe (not to mention that we are already in
> BTRFS_FS_STATE_NO_DELAYED_IPUT when it runs).
>=20
> Therefore we need to bring back explicitly flushing the fixup workqueue
> as in Filipe's original fix. The first flush will catch all the fixup
> writeback queued during the final sync before umount, but some of that
> might hit memory allocation errors and stay fixup in the blocks/folio,
> leading any subsequent writeback triggered *inside* umount (e.g. reclaim
> workers shutting down) to hit it and queue again. To fix that, and the
> possibility of any really long-lived pinned folios getting marked, deny
> queueing new fixup during umount. That allows us to flush twice (once
> before doing a real writeback pass to get the actual data, second time
> to clean up any rather unlikely stragglers right before declaring
> BTRFS_FS_STATE_NO_DELAYED_IPUT) and be certain nothing got re-queued.
>=20
> Reproduced by injecting a one-shot 30s sleep at the head of
> btrfs_writepage_fixup_worker() on a KASAN kernel, running the normal
> reproducing read dio workload before unmount and then observing:
>=20
>    BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x35/0x50
>    Read of size 1 at addr ffff88810b4b08f8 by task kworker/u32:5/219
>    Workqueue: btrfs-fixup btrfs_writepage_fixup_worker [btrfs]
>    Call Trace:
>     _raw_spin_lock_irqsave+0x35/0x50
>     try_to_wake_up+0xc0/0x18c0
>     btrfs_writepage_fixup_worker+0x7f3/0xf20 [btrfs]
>    ...
>=20
> Fixes: 4be9c7da6860 ("btrfs: trigger cow fixup via dirty_folio()")
> Assisted-by: LLM (reproduction, analysis)
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/disk-io.c | 21 +++++++++++++++++++++
>   fs/btrfs/inode.c   | 15 +++++++++++++++
>   2 files changed, 36 insertions(+)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7a2f7006085d..cc4dcd10631a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4377,6 +4377,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_=
info)
>   	/* clear out the rbtree of defraggable inodes */
>   	btrfs_cleanup_defrag_inodes(fs_info);
>  =20
> +	/*
> +	 * Before the unmount, we sync down all the writeback which can
> +	 * generate fixup work. We are about to run delalloc for autodefrag so
> +	 * piggy back on that by also flushing the fixup work which can also
> +	 * generate delalloc we would like to get run.
> +	 *
> +	 * After this, it is still possible that some thread doing writeback i=
s
> +	 * in btrfs_queue_writepage_fixup() and might finish queueing some fin=
al
> +	 * work, racing the btrfs_fs_closing() check there.
> +	 */
> +	flush_workqueue(fs_info->fixup_workers);
> +
>   	/*
>   	 * After we entered close_ctree() autodefrag could be running and bef=
ore
>   	 * we parked the cleaner kthread, it dirtied folios of some inode.
> @@ -4469,6 +4481,15 @@ void __cold close_ctree(struct btrfs_fs_info *fs_=
info)
>   	cancel_work_sync(&fs_info->preempt_reclaim_work);
>   	cancel_work_sync(&fs_info->em_shrinker_work);
>  =20
> +	/*
> +	 * Reclaim workers can run writeback which can queue fixup.
> +	 * After the above cancel_work_sync() calls, any such queueing attempt=
s are
> +	 * guaranteed to see btrfs_fs_closing(), so at this point we can genui=
nely fully
> +	 * flush the fixup workqueue. This relies on the belief that *now* no =
thread can
> +	 * still be sitting in btrfs_queue_writepage_fixup().
> +	 */
> +	flush_workqueue(fs_info->fixup_workers);
> +
>   	/*
>   	 * Run delayed iputs again because an async reclaim worker may have
>   	 * added new ones if it was flushing delalloc:
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 78143e241ca4..51d460572317 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2964,6 +2964,21 @@ void btrfs_queue_writepage_fixup(struct btrfs_ino=
de *inode, struct folio *folio)
>   	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>   	struct btrfs_writepage_fixup *fixup;
>  =20
> +	/*
> +	 * Disallow queueing more fixup during unmount to break the cycle
> +	 * of writeback queuing fixup queuing writeback etc.
> +	 *
> +	 * If it actually hit, then something which was fixup wasn't written
> +	 * which we should warn about.
> +	 */
> +	if (btrfs_fs_closing(fs_info)) {

Shouldn't we also clear the fixup and dirty bitmaps for this case?

As the folio is still dirty, and will never really go through writeback=20
until fixup work is done.

Thus canceling the corresponding dirty/fixup bits looks more reasonable.

Thanks,
Qu

> +		btrfs_warn_rl(fs_info,
> +	"dropping unqueued fixup blocks at unmount. root %lld ino %llu folio %=
llu",
> +			      btrfs_root_id(inode->root), btrfs_ino(inode),
> +			      folio_pos(folio));
> +		return;
> +	}
> +
>   	fixup =3D kzalloc_obj(*fixup, GFP_NOFS);
>   	if (!fixup)
>   		return;

