Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A93B0588
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 22:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785449246; cv=none; b=qidWJDG5V4DqG56UJFN+JD+HAblHwK86Fk17PlnTarfcqEIXW5POc2fayJmriQtZOligjE5+HQTlMQUPB3I7QFgKIKn/hlxFQU96K4gYWAMSL13hqhabTQ9bPiQx3flTuwE/WZhc3jij10yA2b1Vfd68TbPJ5t6fZVUxfwhzB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785449246; c=relaxed/simple;
	bh=mQDSbOBfb/TjFlLJDYzVfsTiq+rDGbqSzsGRhLEuNG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QE1Q8pzQ+BSIUt9Pp5cB0qd+vIY3+/m1+DFVzp3FSHaS1t5SQludLIcw16nkKaJfDRynkd3NWnjQb32/r3CIyvav/aCwj78y9ABzE5OpBKYuBNatGy4CCufXMMMGEl2igMuiAmRL7LbetGJUax6p4r5/YITqT9Rf0mDxl0GGDM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lL4HSkkM; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lL4HSkkM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785449239; x=1786054039; i=quwenruo.btrfs@gmx.com;
	bh=v1jUUsedo9haGXXVq+61Fl56BgzcOm+TGDYE/dL/i3Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lL4HSkkMIhp1uJjD5rJ39sSq05GHQAf+vor8mP3aSncD5g4zNRwF1p3g/bJxE0uO
	 T4+E5lZC11meQ3khQVNM4ervUvwtxpDu1lHaNvffQagFt4ZFoF/G4bUR1TxbYYhJR
	 3ZsZZOhADoHgdBLzPwlMIB9SLsFiDKW/mkd91QU7r8FIyJJrXwfIHs1BbKO5897MM
	 0bzoehlVzS4iMpel1mRMUhvbbDk3i3wp4vnrlCcnDnvUMIMR95MVqDhwQx5EF2VjS
	 WPih/ZsYEkSGmVZKv3dAg4pwy2i/MROIKHy3N9TmLzOjp4ymeC792Oyb3E8S0qAI+
	 BHQv5xI2AezSLg8Ocg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQv8x-1wcaUT255T-00Pg7j; Fri, 31
 Jul 2026 00:07:19 +0200
Message-ID: <d7b8dc75-db46-4631-ba1e-4513b850a474@gmx.com>
Date: Fri, 31 Jul 2026 07:37:13 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: flush the fixup workers during close_ctree
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <97d1b25314a0006e8fa3be0c66cb850f6d08523f.1785428166.git.boris@bur.io>
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
In-Reply-To: <97d1b25314a0006e8fa3be0c66cb850f6d08523f.1785428166.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:b7dNlZTAoyEKZLSr9o67gaVQq+DiuvQ6WOxgyvDkyagX1/nnTcf
 1pa7tVdM8e86B/KqvLg34TUgXqZmx5Ui4dUcjm0tKdM4yPY592v6nW/rzgzA14X4/PeZkVw
 +/URImtwxeTPbej+1NI/z7tTrkRi6JiP7h9lLxRnvQcRh8fzV8aonphCLX18a3UcTSLKTBe
 B7gp8lDZddvPOYu93P8Jw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xVPp+ekad0k=;LQEp+q64UtGQrRHTt90p6oVpWPu
 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
 l5vHEJEAOckM



=E5=9C=A8 2026/7/31 02:08, Boris Burkov =E5=86=99=E9=81=93:
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

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changelog:
> v2:
> - clear fixup on skip, following the model of errors in the worker
>=20
>   fs/btrfs/disk-io.c | 21 +++++++++++++++++++++
>   fs/btrfs/inode.c   | 17 +++++++++++++++++
>   2 files changed, 38 insertions(+)
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
> index 78143e241ca4..04efe183d57b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2964,6 +2964,23 @@ void btrfs_queue_writepage_fixup(struct btrfs_ino=
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
> +		btrfs_warn_rl(fs_info,
> +	"dropping unqueued fixup blocks at unmount. root %lld ino %llu folio %=
llu",
> +			      btrfs_root_id(inode->root), btrfs_ino(inode),
> +			      folio_pos(folio));
> +		btrfs_folio_clear_fixup_dirty(fs_info, folio,
> +					      folio_pos(folio), folio_size(folio));
> +		return;
> +	}
> +
>   	fixup =3D kzalloc_obj(*fixup, GFP_NOFS);
>   	if (!fixup)
>   		return;

