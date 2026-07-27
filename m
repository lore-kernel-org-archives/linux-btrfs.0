Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6A43F327A
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 23:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785194288; cv=none; b=qWAOn37Wb4xiblld9xPhSXdbr5DpiOcBhPQLXGrvqtACHzRYHwrb/DBc6AlOohfywtxQgDta1SRR7Mb56ORALgY0W3dMDL7DLkG5n+neQ179Nst+7WaryYnvRXPzNcYkvtAJcnh226wx7vI9NzMKUs6JrEUZZkJHZL9d+WM3BnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785194288; c=relaxed/simple;
	bh=g15teUtT5YKnGDnr67+BnXxYUTzdxksD3BtVP7mt0gg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=POGi2nIic4L/uUgswMhG2G26WyJ0bOt5+GNqlglDQfGZ6EM4fu8pCctdVmaPHTUK8hv9/TIdk8eJoiz7EZAFl3HjTejq2yrn2sPhyJ76+V+H5fcKIPjA+xqLlHvSt+6sWaHikdz6v37JNA0SrxRutpLU+dfxM665uqm3RDkskdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=G5Blsf0K; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="G5Blsf0K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785194253; x=1785799053; i=quwenruo.btrfs@gmx.com;
	bh=ka4o9rLK15MCmxueBoFo0lTpYZHMJDnX9nH6uGFyY0Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=G5Blsf0Knncvk9izF/qytWNu1C2sBryYGvGhaR1tI+5RxXvSQ/tBEvx5T+V+9Fe8
	 qR/adlmQNe1TsM4HBWyo+nkb0Xi4NCY+szcvLRk/J17cOVoTiiwO+rWqYrkQouAdQ
	 wj1hyet4kOdrIK+FCUhYpq1VB371KoWwNVlxbhb0gqJLzk+II4uaF7703o325Hooc
	 UydRUtcxgfenTeUX5wcNGm0GT1snBbLwl2r7wvr+lpjp1dcrq0gVEzJaCy1y3H60l
	 SUWmrvPf0xMkGzg3ZcTZJK1ckd5EYFaUDf2p5AFZJmLGD9fGGKXUiqedr0dnOAN9n
	 Fo2/untwqaPqyd+/Mw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MYNNy-1wRr8D1Dww-00SAlr; Tue, 28
 Jul 2026 01:17:32 +0200
Message-ID: <d741057a-43c0-4ff8-8333-ce67c46a5f03@gmx.com>
Date: Tue, 28 Jul 2026 08:47:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org, ljs@kernel.org, jack@suse.cz
References: <69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io>
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
In-Reply-To: <69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FyJNCHwJhHyis2yqyzkN73cOHCOFw5qpoMkhnhTOWt0DnOWjGzv
 4NGsHyfCp4qFqDaZicfBcZr0T7BpjKHSOWo7o+19acRbULjtPSq+bhw5l/p+2DDOIKjI216
 YG+DQr3+VBKJQoSjnUlslc67ahw0v0MGqd4Cn+E4dQDRUltMkG+VSuWGaGrDQxp85LoS3Na
 qxp+kI/L9pSWOO6Ws4MDQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2CEhMDRHQX0=;zIf3CFYEExpjjoEY8waT3Fgdel2
 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
 FlKfFre6V9QLVmlgev19C5WdldGYH8hleA==



=E5=9C=A8 2026/7/28 07:53, Boris Burkov =E5=86=99=E9=81=93:
> The problem scenario:
> If we have a folio mmapped shared and then somebody does a dio read with
> that folio as the read destination, then it is possible that the dio
> will see a dirty destination page when it starts (and thus skip
> dirtying and just gup pin it) but then while it is doing the read, btrfs
> finishes writing it back and by the endio, the folio is clean. In that
> case, the dio read must re-dirty the folio with aops->dirty_folio():
>=20
> btrfs_check_read_bio()
> |- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
>     |- bio_check_pages_dirty()
>        |- bio_dirty_fn()
>           |- bio_release_pages(bio, true)
>              |- __bio_release_pages(bio, mark_dirty =3D=3D true)
>                 |- folio_lock()
>                 |- folio_mark_dirty()
>                    |- aops->dirty_folio()
>                 |- folio_unlock()
>=20
> A data block normally moves through writeback as follows:
> TASK
>    folio_lock
>    write              clean -> dirty bit + delalloc
>    folio_unlock
> WRITEBACK
>    for-each-dirty-folio:
>      folio_lock
>      run_delalloc     delalloc consumed  -> dirty bit + OE
>      submission       dirty bit consumed -> writeback bit + OE
>      folio_unlock
> ENDIO
>    endio              OE bytes accounted
>    OE finish          writeback -> clean; destroy OE
>=20
> Three critical invariants that this path maintains are:
> I1. Any dirty block is covered by delalloc xor an ordered extent
> I2. Any dirty block covered by an OE will be submitted into that OE
> I3. Any dirty block already submitted into an OE will not be submitted
>      again into the same OE.
>=20
> These ensure that the block will be written exactly once. It is clear
> that not reserving delalloc for the re-dirty case violates I1.
>=20
> This situation, even without bs < folio_size, has long required btrfs to
> fixup such dirty pages during writeback with an asynchronous worker that
> is allowed to do this expensive work and writeback does not proceed for
> a folio while it is doing this work.
>=20
> Commit 247e743cbe6e ("Btrfs: Use async helpers to deal with pages that h=
ave been improperly dirtied")
> introduced the COW fixup to catch exactly this class at writeback, way
> back in 2008.
>=20
> Since then, there have been many advances to prevent most of the causes
> of such re-dirtying and we thought we could get away with removing the
> annoying cow-fixup in the hope of simplifying writeback for large folio
> support.
>=20
> Commit b2a9f217ad3f ("btrfs: remove the COW fixup mechanism")
> Commit 4927b141877c ("btrfs: remove folio ordered flag and subpage bitma=
p")
>=20
> Since it turns out this assumption was incorrect, as evidenced by the
> report and attendant reproducers, we must reintroduce the fixup concept.
>=20
> This is of course critically further complicated by bs < folio_size. In
> that case, rather than just a folio dirty bit, we have a bitmap for the
> dirty blocks in the folio. And the (also broken) invariant is:
> I4. folio dirty IFF at least one block bitmap dirty.
>=20
> The original report of a stall on a misinterpreted empty bitmap is
> exactly evidence of a violation of I4.
>=20
> It is exactly because of bs < folio_size we don't want to simply revert =
the
> removal patches. The original fixup was not properly bs < folio_size
> aware, which motivated removal in the first place. So we wish to build a
> bs < folio_size aware fixup.
>=20
> One other important detail from the old design, any normal write that
> happens after a re-dirty but before a fixup is racing with the cow fixup
> to do the delalloc reservation, therefore it must cancel the fixup state=
.
> If it arrives after the reservation exists, it will be a normal dirty
> overwrite. This critically informs the design in a pretty clear way.
> fixup requiring re-dirty has folio granularity, while cancellation has
> delalloc (block) granularity so while we only ever produce fixup in
> chunks of folios, we must be able to clear it in blocks. Therefore we
> must track the blocks needing fixup at block granularity.
>=20
> The obvious way to do this is with a new bitmap in btrfs_folio_state,
> but it is desirable to avoid that if possible. Unfortunately, I don't
> think it is possible and the reason is subtle and leans on a sort of
> extreme reproducer, but I think can be explained relatively succinctly.
>=20
> Consider a folio whose two halves will land in different ordered extents
> (can be accomplished with tricks using nodatasum) and a dio read is
> running with it as the shared mmap destination.
>=20
> 1. The front half:
>     a. folio comes clean on a normal write
>     b. dio read completes into the folio marking it fixup.
>     c. a write comes for the previous folio for a range extending into
>        this folio, this is a cancellation of the fixup which reserves
>        space.
>     d. writeback runs on the range *not* overlapping the folio. This hal=
f
>        remains dirty but is now covered by an OE and is awaiting
>        writeback running on its range to be submitted and finish the OE.
> 2. The back half:
>     a. the folio is part of an OE that gets far enough along to clear
>        writeback.
>     b. dio read completes into the folio marking it fixup.
>=20
> After this, the folio's front half is dirty in the "normal" sense, it
> needs to be submitted to the OE waiting for it. It's a cancelled fixup.
> Meanwhile, the second half is a true fresh fixup. So at this point if we
> run writeback on this folio, we genuinely can't know what to do without
> block level information. If we submit it, we submit unreserved dirty
> from the back half. If we don't, we will never finish the OE waiting for
> it. So it's either a corruption or a deadlock.
>=20
> Thus, the full high level design picture:
>=20
> - btrfs_data_dirty_folio(): For out of band non-reserving dirties,
>    mark still-clean blocks inside EOF dirty and set their fixup bits
>    (the event carries no range, so every clean block is suspect).
>    Already-dirty blocks are covered or pending and are left alone.
>=20
> - Writeback: skip fixup blocks and enqueue work for them
>=20
> - writepage_fixup(): for each fixup block do the fixup reservation in a
>    worker, after which the blocks can be written back normally.
>=20
> - Typical reserving write paths cancel fixup state for the ranges they
>    cover with btrfs_folio_cancel_fixup()
>=20
> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntr=
aeger@linux.ibm.com/
> Signed-off-by: Boris Burkov <boris@bur.io>
> Assisted-by: LLM

Reviewed-by: Qu Wenruo <wqu@suse.com>

Please ignore my previous reviewed-by tag on the older version.
I was doing a diff checking the changes, and replied to the wrong patch.

Thanks,
Qu

> ---
> Changelog:
> v3:
> - justified use of ihold() more clearly
> - more explicitly swallowed ENOMEM in fixup queueing
> - documented why zap_pte_range() should be safe (also ran experiments co=
nvincing
>    myself that synchronization on wb folio_mkclean() was real)
> - sashiko's partial uptodate bug is spurious for basically the same reas=
on. If
>    you are a writeable mapping, you got fully uptodate
> - improved fixup worker error gotos to hopefully be cleaner
> - switched to a plain workqueue
> - fixed style issues
> v2:
> - removed redundant llm defensive logic overhead in wb
> - removed redundant llm defensive logic overhead in worker
> - tried to streamline the dirtying/cleanup code better into helpers and
>    shared callers
> - removed sentinel for "reserving dirties"
> - trimmed down verbose comments and removed redundant comments
> - humanized logic and prose in comments
> - removed undefined jargon variable names (punt, fund, pending)
> - various other small cleanups
>=20
>   fs/btrfs/btrfs_inode.h       |   1 +
>   fs/btrfs/disk-io.c           |   7 +-
>   fs/btrfs/extent_io.c         | 113 ++++++++++++++++++
>   fs/btrfs/fs.h                |  12 ++
>   fs/btrfs/inode.c             | 200 +++++++++++++++++++++++++++++++-
>   fs/btrfs/subpage.c           | 216 ++++++++++++++++++++++++++++++++++-
>   fs/btrfs/subpage.h           |  41 ++++++-
>   include/trace/events/btrfs.h |  35 ++++++
>   8 files changed, 613 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 7fdc6c3fd066..1082fa92c145 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -600,6 +600,7 @@ int btrfs_prealloc_file_range_trans(struct inode *in=
ode,
>   				    loff_t actual_len, u64 *alloc_hint);
>   int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *=
locked_folio,
>   			     u64 start, u64 end, struct writeback_control *wbc);
> +void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct foli=
o *folio);
>   int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_=
info,
>   					     int compress_type);
>   int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7fee6e6e732b..7a2f7006085d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1758,6 +1758,8 @@ static int read_backup_root(struct btrfs_fs_info *=
fs_info, u8 priority)
>   /* helper to cleanup workers */
>   static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>   {
> +	if (fs_info->fixup_workers)
> +		destroy_workqueue(fs_info->fixup_workers);
>   	btrfs_destroy_workqueue(fs_info->delalloc_workers);
>   	btrfs_destroy_workqueue(fs_info->workers);
>   	if (fs_info->endio_workers)
> @@ -1965,6 +1967,9 @@ static int btrfs_init_workqueues(struct btrfs_fs_i=
nfo *fs_info)
>   	fs_info->caching_workers =3D
>   		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
>  =20
> +	fs_info->fixup_workers =3D
> +		alloc_ordered_workqueue("btrfs-fixup", ordered_flags);
> +
>   	fs_info->endio_workers =3D
>   		alloc_workqueue("btrfs-endio", flags, max_active);
>   	fs_info->endio_meta_workers =3D
> @@ -1990,7 +1995,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_i=
nfo *fs_info)
>   	      fs_info->endio_workers && fs_info->endio_meta_workers &&
>   	      fs_info->endio_write_workers &&
>   	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
> -	      fs_info->caching_workers &&
> +	      fs_info->caching_workers && fs_info->fixup_workers &&
>   	      fs_info->delayed_workers && fs_info->qgroup_rescan_workers &&
>   	      fs_info->discard_ctl.discard_workers)) {
>   		return -ENOMEM;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index e88381a40600..c7c3f138fb69 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1462,6 +1462,115 @@ static bool find_next_delalloc_bitmap(struct fol=
io *folio,
>   	return true;
>   }
>  =20
> +/*
> + * Debug checks for fixup selection logic to help ensure the invariants
> + * we expect for fixup marking hold in practice.
> + *
> + * - A dirty block without a fixup bit is covered by delalloc or a runn=
ing
> + *   ordered extent (it was dirtied by a reserving write path).
> + * - A block with a fixup bit is never covered by delalloc: every delal=
loc
> + *   setter holds the folio lock and cancels the fixup state of the blo=
cks
> + *   it covers (btrfs_folio_set_dirty()) before releasing it.
> + */
> +static void debug_check_writepage_fixup(struct btrfs_inode *inode, u64 =
start,
> +				       u32 len, bool needs_fixup)
> +{
> +	struct btrfs_ordered_extent *ordered;
> +	bool delalloc;
> +
> +	if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
> +		return;
> +
> +	delalloc =3D btrfs_test_range_bit_exists(&inode->io_tree, start,
> +					       start + len - 1, EXTENT_DELALLOC);
> +	if (needs_fixup) {
> +		if (unlikely(delalloc))
> +			DEBUG_WARN("writeback: delalloc and fixup conflict. ino %llu start %=
llu",
> +				   btrfs_ino(inode), start);
> +	} else {
> +		if (delalloc)
> +			return;
> +
> +		ordered =3D btrfs_lookup_ordered_range(inode, start, len);
> +		if (unlikely(!ordered))
> +			DEBUG_WARN("dirty block, no delalloc, fixup, ordered. ino %llu start=
 %llu",
> +				   btrfs_ino(inode), start);
> +		else
> +			btrfs_put_ordered_extent(ordered);
> +	}
> +}
> +
> +/*
> + * Handle folios dirtied without a delalloc reservation, e.g.
> + * O_DIRECT read into a MAP_SHARED mapping dirtying via set_page_dirty_=
lock().
> + *
> + * btrfs_data_dirty_folio() records the affected blocks in the fixup bi=
tmap
> + * and the folio fixup flag and we check them here in writeback.
> + *
> + * Don't submit such blocks and queue work for the fixup worker to rese=
rve
> + * space for them so that they can be submitted properly by writeback.
> + *
> + * Return 1 if the folio needed fixup, 0 if not, and a negative error c=
ode
> + * on error.
> + */
> +static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode=
,
> +					      struct folio *folio,
> +					      struct btrfs_bio_ctrl *bio_ctrl)
> +{
> +	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(&inode->vfs_inode);
> +	const unsigned int blocks_per_folio =3D btrfs_blocks_per_folio(fs_info=
, folio);
> +	const u32 sectorsize =3D fs_info->sectorsize;
> +	const u64 page_start =3D folio_pos(folio);
> +	bool found_fixup =3D false;
> +	unsigned int bit;
> +
> +	/*
> +	 * A folio was dirtied without calling aops->dirty_folio() which we
> +	 * explicitly assert is not allowed.
> +	 */
> +	if (unlikely(bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)))=
 {
> +		DEBUG_WARN();
> +		btrfs_err_rl(fs_info,
> +			     "root %lld ino %llu folio %llu is dirty with an empty dirty bit=
map",
> +			     btrfs_root_id(inode->root), btrfs_ino(inode),
> +			     folio_pos(folio));
> +		return -EUCLEAN;
> +	}
> +
> +	/* Cheap check on the folio flag. Set iff the fixup bitmap is non-empt=
y. */
> +	if (likely(!folio_test_fixup_pending(folio)))
> +		return 0;
> +
> +	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
> +		const u64 start =3D page_start + (bit << fs_info->sectorsize_bits);
> +		const bool needs_fixup =3D btrfs_folio_test_fixup(fs_info, folio,
> +								start, sectorsize);
> +
> +		debug_check_writepage_fixup(inode, start, sectorsize, needs_fixup);
> +		if (needs_fixup) {
> +			bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
> +			found_fixup =3D true;
> +		}
> +	}
> +	if (likely(found_fixup)) {
> +		btrfs_queue_writepage_fixup(inode, folio);
> +		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
> +		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> +			folio_unlock(folio);
> +			return 1;
> +		}
> +		return 0;
> +	}
> +	/* We should always find fixup if the folio fixup flag was set. */
> +	DEBUG_WARN();
> +	btrfs_err_rl(fs_info,
> +		     "root %lld ino %llu folio %llu is fixup with an empty fixup bitm=
ap",
> +		     btrfs_root_id(inode->root), btrfs_ino(inode),
> +		     folio_pos(folio));
> +
> +	return -EUCLEAN;
> +}
> +
>   /*
>    * Do all of the delayed allocation setup.
>    *
> @@ -1514,6 +1623,10 @@ static noinline_for_stack int writepage_delalloc(=
struct btrfs_inode *inode,
>   	/* Save the dirty bitmap as our submission bitmap will be a subset of=
 it. */
>   	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitm=
ap);
>  =20
> +	ret =3D writepage_fixup(inode, folio, bio_ctrl);
> +	if (ret)
> +		return ret;
> +
>   	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
>   			      blocks_per_folio) {
>   		u64 start =3D page_start + (start_bit << fs_info->sectorsize_bits);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 06b5884a9bcd..10e15a319b93 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -714,6 +714,8 @@ struct btrfs_fs_info {
>   	struct btrfs_workqueue *endio_write_workers;
>   	struct btrfs_workqueue *endio_freespace_worker;
>   	struct btrfs_workqueue *caching_workers;
> +
> +	struct workqueue_struct *fixup_workers;
>   	struct btrfs_workqueue *delayed_workers;
>  =20
>   	struct task_struct *transaction_kthread;
> @@ -1198,6 +1200,16 @@ static inline void btrfs_wake_unfinished_drop(str=
uct btrfs_fs_info *fs_info)
>   	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
>   }
>  =20
> +/*
> + * We use the folio owner_2 flag to indicate the folio has blocks that =
were
> + * dirtied without a space reservation and need the writepage fixup bef=
ore
> + * writeback. For bs < folio_size the fixup bitmap tracks the affected
> + * blocks.
> + */
> +#define folio_test_fixup_pending(folio) folio_test_owner_2(folio)
> +#define folio_set_fixup_pending(folio) folio_set_owner_2(folio)
> +#define folio_clear_fixup_pending(folio) folio_clear_owner_2(folio)
> +
>   #define BTRFS_FS_ERROR(fs_info)	(READ_ONCE((fs_info)->fs_error))
>  =20
>   #define BTRFS_FS_LOG_CLEANUP_ERROR(fs_info)				\
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a7c78261d021..78143e241ca4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2824,6 +2824,163 @@ int btrfs_set_extent_delalloc(struct btrfs_inode=
 *inode, u64 start, u64 end,
>   				    EXTENT_DELALLOC | extra_bits, cached_state);
>   }
>  =20
> +struct btrfs_writepage_fixup {
> +	struct folio *folio;
> +	struct btrfs_inode *inode;
> +	struct work_struct work;
> +};
> +
> +/*
> + * Do the real fixup work of reserving space for the blocks a folio's f=
ixup
> + * state records. Queued by writepage_fixup() when writeback found the =
bits set.
> + *
> + * Since the fixup can be cancelled by a task dirtying with a reservati=
on, we must
> + * re-check the state of fixup under the folio lock.
> + */
> +static void btrfs_writepage_fixup_worker(struct work_struct *work)
> +{
> +	struct btrfs_writepage_fixup *fixup =3D
> +		container_of(work, struct btrfs_writepage_fixup, work);
> +	struct extent_state *cached_state =3D NULL;
> +	struct extent_changeset *data_reserved =3D NULL;
> +	unsigned long delalloc_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO=
)] =3D { 0 };
> +	struct folio *folio =3D fixup->folio;
> +	struct btrfs_inode *inode =3D fixup->inode;
> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +	const unsigned int blocks_per_folio =3D btrfs_blocks_per_folio(fs_info=
, folio);
> +	const u32 sectorsize =3D fs_info->sectorsize;
> +	const u64 page_start =3D folio_pos(folio);
> +	const u64 page_end =3D folio_next_pos(folio) - 1;
> +	unsigned int start_bit;
> +	unsigned int end_bit;
> +	unsigned int bit;
> +	bool reserved;
> +	int ret;
> +
> +	/*
> +	 * We would prefer to reserve under the folio lock when we know exactl=
y
> +	 * which blocks need a reservation. Unfortunately, since the reservati=
on
> +	 * can go into flushers which can go into writeback, which takes folio
> +	 * locks, that is not possible. Therefore, we have to reserve for the
> +	 * whole folio here, then release what we didn't end up needing once w=
e
> +	 * figure it out.
> +	 *
> +	 * Also note the slightly strange error checking. If fixup is actually
> +	 * not set, we don't need to mark an error on the mapping. So hang on =
to
> +	 * ret until after we lock and find out if we actually care.
> +	 */
> +	ret =3D btrfs_delalloc_reserve_space(inode, &data_reserved, page_start=
,
> +					   folio_size(folio));
> +	reserved =3D (ret =3D=3D 0);
> +again:
> +	folio_lock(folio);
> +
> +	if (!folio->mapping || !folio_test_fixup_pending(folio)) {
> +		ret =3D 0;
> +		goto out;
> +	}
> +	if (ret)
> +		goto out;
> +
> +	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state=
);
> +
> +	for (bit =3D 0; bit < blocks_per_folio; bit++) {
> +		struct btrfs_ordered_extent *ordered;
> +		const u64 start =3D page_start + (bit << fs_info->sectorsize_bits);
> +
> +		if (test_bit(bit, delalloc_bitmap))
> +			continue;
> +		if (!btrfs_folio_test_fixup(fs_info, folio, start, sectorsize))
> +			continue;
> +		/*
> +		 * Any task that sets EXTENT_DELALLOC clears the fixup bits
> +		 * under the folio lock, so it should be impossible to observe
> +		 * both under the lock. Setting delalloc twice would wrongly
> +		 * double account the space.
> +		 */
> +		if (IS_ENABLED(CONFIG_BTRFS_DEBUG) &&
> +		    unlikely(btrfs_test_range_bit_exists(&inode->io_tree, start,
> +							 start + sectorsize - 1,
> +							 EXTENT_DELALLOC))) {
> +			DEBUG_WARN("fixup worker: delalloc and fixup conflict. ino %llu star=
t %llu",
> +				   btrfs_ino(inode), start);
> +			btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +			continue;
> +		}
> +		ordered =3D btrfs_lookup_ordered_range(inode, start, sectorsize);
> +		if (ordered) {
> +			trace_btrfs_writepage_fixup_defer(inode, ordered);
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			folio_unlock(folio);
> +			btrfs_start_ordered_extent(ordered);
> +			btrfs_put_ordered_extent(ordered);
> +			goto again;
> +		}
> +		ret =3D btrfs_set_extent_delalloc(inode, start,
> +						start + sectorsize - 1, 0,
> +						&cached_state);
> +		if (ret)
> +			break;
> +		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
> +		btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +		set_bit(bit, delalloc_bitmap);
> +	}
> +
> +	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_sta=
te);
> +out:
> +	if (ret < 0) {
> +		/* Failure here is analogous to failure in writeback. */
> +		mapping_set_error(folio->mapping, ret);
> +		btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start,
> +					      folio_size(folio));
> +	}
> +	if (reserved) {
> +		btrfs_delalloc_release_extents(inode, folio_size(folio));
> +		for_each_clear_bitrange(start_bit, end_bit, delalloc_bitmap,
> +					blocks_per_folio)
> +			btrfs_delalloc_release_space(inode, data_reserved,
> +				page_start + (start_bit << fs_info->sectorsize_bits),
> +				(end_bit - start_bit) << fs_info->sectorsize_bits,
> +				true);
> +	}
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	kfree(fixup);
> +	extent_changeset_free(data_reserved);
> +	btrfs_add_delayed_iput(inode);
> +}
> +
> +/*
> + * Queue space reservation fixup work for blocks dirtied without a spac=
e reservation.
> + *
> + * Should be used by writeback while holding the folio locked.
> + *
> + * If we fail to queue fixup, then the folio state is unchanged and a f=
uture
> + * writeback pass will still see it.
> + */
> +void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct foli=
o *folio)
> +{
> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +	struct btrfs_writepage_fixup *fixup;
> +
> +	fixup =3D kzalloc_obj(*fixup, GFP_NOFS);
> +	if (!fixup)
> +		return;
> +
> +	/*
> +	 * This is called from within extent_write_cache_pages() which
> +	 * has successfully done an igrab(). But that will be released at the
> +	 * end of the writeback pass. We need to extend it for the worker as w=
ell.
> +	 */
> +	ihold(&inode->vfs_inode);
> +	folio_get(folio);
> +	INIT_WORK(&fixup->work, btrfs_writepage_fixup_worker);
> +	fixup->folio =3D folio;
> +	fixup->inode =3D inode;
> +	queue_work(fs_info->fixup_workers, &fixup->work);
> +}
> +
>   /*
>    * Clear the old accounting flags and set EXTENT_DELALLOC for the rang=
e.
>    *
> @@ -7519,6 +7676,12 @@ static void btrfs_invalidate_folio(struct folio *=
folio, size_t offset,
>   	folio_wait_writeback(folio);
>   	wait_subpage_spinlock(folio);
>  =20
> +	/*
> +	 * The invalidated blocks are going away; drop any fixup blocks among
> +	 * them, data included, as they have no space reservation.
> +	 */
> +	btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start + offset, len=
gth);
> +
>   	/*
>   	 * For subpage case, we have call sites like
>   	 * btrfs_punch_hole_lock_range() which passes range not aligned to
> @@ -10585,6 +10748,41 @@ static const struct file_operations btrfs_dir_f=
ile_operations =3D {
>   	.setlease	=3D generic_setlease,
>   };
>  =20
> +/*
> + * The folio is going dirty without a btrfs delalloc space reservation.
> + * This requires a fixup before writeback which we might sleep so canno=
t
> + * run in this context, so we merely set state on the folio indicating =
it
> + * needs fixup before writeback.
> + *
> + * Note that there is no range in the input, so the whole folio is mark=
ed
> + * dirty and fixup.
> + *
> + * We believe that all callers of dirty_folio either:
> + * - take the folio lock (e.g. pinned folio release notification).
> + * - take the pte lock but must be running on a dirty pte which means
> + *   page_mkwrite() ran on it and reserved the space. zap_pte_range() c=
annot
> + *   race with writeback cleaning the folio because writeback runs
> + *   folio_mkclean() which also uses the pte lock and revokes outstandi=
ng
> + *   writable mappings.
> + * Therefore, an additional folio private lock (a la bfs->lock for all =
cases,
> + * not just subpage) is not necessary.
> + */
> +static bool btrfs_data_dirty_folio(struct address_space *mapping,
> +				   struct folio *folio)
> +{
> +	struct btrfs_inode *inode =3D BTRFS_I(mapping->host);
> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +	const u64 page_start =3D folio_pos(folio);
> +	const u64 range_end =3D min_t(u64, folio_next_pos(folio),
> +				    round_up(i_size_read(&inode->vfs_inode),
> +					     fs_info->sectorsize));
> +
> +	if (range_end > page_start)
> +		btrfs_folio_set_fixup_dirty(fs_info, folio, page_start,
> +					    range_end - page_start);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +
>   /*
>    * btrfs doesn't support the bmap operation because swapfiles
>    * use bmap to make a mapping of extents in the file.  They assume
> @@ -10605,7 +10803,7 @@ static const struct address_space_operations btr=
fs_aops =3D {
>   	.launder_folio	=3D btrfs_launder_folio,
>   	.release_folio	=3D btrfs_release_folio,
>   	.migrate_folio	=3D btrfs_migrate_folio,
> -	.dirty_folio	=3D filemap_dirty_folio,
> +	.dirty_folio	=3D btrfs_data_dirty_folio,
>   	.error_remove_folio =3D generic_error_remove_folio,
>   	.swap_activate	=3D btrfs_swap_activate,
>   	.swap_deactivate =3D btrfs_swap_deactivate,
> diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
> index 2a9397be8116..27dd677ca687 100644
> --- a/fs/btrfs/subpage.c
> +++ b/fs/btrfs/subpage.c
> @@ -345,18 +345,57 @@ void btrfs_subpage_clear_uptodate(const struct btr=
fs_fs_info *fs_info,
>   	spin_unlock_irqrestore(&bfs->lock, flags);
>   }
>  =20
> +/*
> + * folio_mark_dirty() for a folio we are dirtying with a space reservat=
ion.
> + *
> + * Dirtiers without a reservation use btrfs_data_dirty_folio().
> + */
> +static void btrfs_folio_mark_dirty(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio_mapping(folio);
> +
> +	if (!mapping || !mapping->host || !is_data_inode(BTRFS_I(mapping->host=
))) {
> +		folio_mark_dirty(folio);
> +		return;
> +	}
> +	if (folio_test_reclaim(folio))
> +		folio_clear_reclaim(folio);
> +	filemap_dirty_folio(mapping, folio);
> +}
> +
> +/*
> + * The set helper of the dirty ops, so it only runs for folios without =
a
> + * fixup bitmap: for those the folio flag is the whole fixup state, and=
 this
> + * reserving write covers the block, so retire it.  Metadata never has =
the
> + * flag set and only pays the test.
> + */
> +static void btrfs_folio_mark_dirty_reserved(struct folio *folio)
> +{
> +	if (folio_test_fixup_pending(folio))
> +		folio_clear_fixup_pending(folio);
> +	btrfs_folio_mark_dirty(folio);
> +}
> +
>   void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
>   			     struct folio *folio, u64 start, u32 len)
>   {
>   	struct btrfs_folio_state *bfs =3D folio_get_private(folio);
> -	unsigned int start_bit =3D subpage_calc_start_bit(fs_info, folio,
> +	unsigned int dirty_bit =3D subpage_calc_start_bit(fs_info, folio,
>   							dirty, start, len);
> +	unsigned int fixup_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits =3D len >> fs_info->sectorsize_bits;
>   	unsigned long flags;
>  =20
>   	spin_lock_irqsave(&bfs->lock, flags);
> -	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> +	bitmap_set(bfs->bitmaps, dirty_bit, nbits);
> +	/* Proper dirtying obviates the need for fixup. */
> +	bitmap_clear(bfs->bitmaps, fixup_bit, nbits);
> +	if (folio_test_fixup_pending(folio) &&
> +	    subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
>   	spin_unlock_irqrestore(&bfs->lock, flags);
> -	folio_mark_dirty(folio);
> +	btrfs_folio_mark_dirty(folio);
>   }
>  =20
>   static void folio_clear_tags(struct folio *folio)
> @@ -457,6 +496,172 @@ void btrfs_subpage_clear_writeback(const struct bt=
rfs_fs_info *fs_info,
>   	spin_unlock_irqrestore(&bfs->lock, flags);
>   }
>  =20
> +void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			       struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs =3D folio_get_private(folio);
> +	unsigned int start_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits)=
;
> +	if (subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +}
> +
> +/*
> + * In one pass under bfs->lock, mark every block with a clear dirty bit=
 in the
> + * range both dirty and needing fixup.
> + *
> + * Only called from the dirty_folio callback, which owns the folio-leve=
l
> + * dirty flag; calling folio_mark_dirty() here would recurse.
> + *
> + * The folio fixup flag and bits are both set under bfs->lock so that a
> + * writeback pass observing the new bits also observes the flag.
> + */
> +static void btrfs_subpage_set_fixup_dirty(const struct btrfs_fs_info *f=
s_info,
> +					  struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs =3D folio_get_private(folio);
> +	unsigned int dirty_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							dirty, start, len);
> +	unsigned int fixup_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits =3D len >> fs_info->sectorsize_bits;
> +	unsigned long flags;
> +	bool marked =3D false;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	for (unsigned int i =3D 0; i < nbits; i++) {
> +		if (test_bit(dirty_bit + i, bfs->bitmaps))
> +			continue;
> +		set_bit(dirty_bit + i, bfs->bitmaps);
> +		set_bit(fixup_bit + i, bfs->bitmaps);
> +		marked =3D true;
> +	}
> +	if (marked)
> +		folio_set_fixup_pending(folio);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +}
> +
> +/*
> + * Mark the still-clean blocks of a folio dirty and needing fixup, for
> + * btrfs_data_dirty_folio().
> + *
> + * A subpage block size folio that is not uptodate is left alone: its c=
lean
> + * blocks may hold content that was never read in, which must not be ma=
rked
> + * dirty.
> + */
> +void btrfs_folio_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				 struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		if (!folio_test_dirty(folio))
> +			folio_set_fixup_pending(folio);
> +		return;
> +	}
> +	if (!folio_test_uptodate(folio))
> +		return;
> +	btrfs_subpage_set_fixup_dirty(fs_info, folio, start, len);
> +}
> +
> +/*
> + * Drop the fixup blocks inside the range: clear both their fixup and d=
irty
> + * bits.
> + *
> + * Fixup blocks carry no space reservation, so their fixup and dirty bi=
ts
> + * must be dropped together. Clearing only the fixup bit would leave a
> + * dirty block without a reservation which is not a valid state.
> + *
> + * Returns true if the folio has no dirty blocks left.
> + */
> +static bool btrfs_subpage_clear_fixup_dirty(const struct btrfs_fs_info =
*fs_info,
> +					    struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs =3D folio_get_private(folio);
> +	unsigned int dirty_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							dirty, start, len);
> +	unsigned int fixup_bit =3D subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits =3D len >> fs_info->sectorsize_bits;
> +	unsigned long flags;
> +	bool last;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	for (unsigned int i =3D 0; i < nbits; i++) {
> +		if (!test_bit(fixup_bit + i, bfs->bitmaps))
> +			continue;
> +		clear_bit(fixup_bit + i, bfs->bitmaps);
> +		clear_bit(dirty_bit + i, bfs->bitmaps);
> +	}
> +	if (subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
> +	last =3D subpage_test_bitmap_all_zero(fs_info, folio, dirty);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +	return last;
> +}
> +
> +/*
> + * Drop the fixup blocks inside the range, for callers discarding their=
 data:
> + * btrfs_invalidate_folio() and the writepage fixup worker's error path=
.
> + *
> + * Callers that have just reserved space for a block want
> + * btrfs_folio_clear_fixup() instead - there the block stays dirty and =
gets
> + * written.
> + *
> + * The range can be byte-granular (an unaligned truncate through
> + * btrfs_invalidate_folio()); only blocks fully inside it are dropped, =
as a
> + * partially covered block still holds live data outside the range.  Fo=
r
> + * single-block folios the folio flag is the fixup state, so it is drop=
ped
> + * only when the range covers the whole folio.
> + */
> +void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				   struct folio *folio, u64 start, u32 len)
> +{
> +	u64 aligned_start;
> +	u64 aligned_end;
> +
> +	/* The folio flag is set whenever any fixup bitmap bit is. */
> +	if (!folio_test_fixup_pending(folio))
> +		return;
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		if (start <=3D folio_pos(folio) &&
> +		    start + len >=3D folio_next_pos(folio)) {
> +			folio_clear_fixup_pending(folio);
> +			folio_clear_dirty_for_io(folio);
> +		}
> +		return;
> +	}
> +	btrfs_subpage_clamp_range(folio, &start, &len);
> +	aligned_start =3D round_up(start, fs_info->sectorsize);
> +	aligned_end =3D round_down(start + len, fs_info->sectorsize);
> +	if (aligned_end <=3D aligned_start)
> +		return;
> +	if (btrfs_subpage_clear_fixup_dirty(fs_info, folio, aligned_start,
> +					    aligned_end - aligned_start))
> +		folio_clear_dirty_for_io(folio);
> +}
> +
> +bool btrfs_folio_test_fixup(const struct btrfs_fs_info *fs_info,
> +			    struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio))
> +		return folio_test_fixup_pending(folio);
> +	return btrfs_subpage_test_fixup(fs_info, folio, start, len);
> +}
> +
> +void btrfs_folio_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			     struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		folio_clear_fixup_pending(folio);
> +		return;
> +	}
> +	btrfs_subpage_clear_fixup(fs_info, folio, start, len);
> +}
> +
>   /*
>    * Unlike set/clear which is dependent on each page status, for test a=
ll bits
>    * are tested in the same way.
> @@ -480,6 +685,7 @@ bool btrfs_subpage_test_##name(const struct btrfs_fs=
_info *fs_info,	\
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(uptodate);
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
> +IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(fixup);
>  =20
>   /*
>    * Note that, in selftests (extent-io-tests), we can have empty fs_inf=
o passed
> @@ -571,8 +777,8 @@ bool btrfs_meta_folio_test_##name(struct folio *foli=
o, const struct extent_buffe
>   }
>   IMPLEMENT_BTRFS_PAGE_OPS(uptodate, folio_mark_uptodate, folio_clear_up=
todate,
>   			 folio_test_uptodate);
> -IMPLEMENT_BTRFS_PAGE_OPS(dirty, folio_mark_dirty, folio_clear_dirty_for=
_io,
> -			 folio_test_dirty);
> +IMPLEMENT_BTRFS_PAGE_OPS(dirty, btrfs_folio_mark_dirty_reserved,
> +			 folio_clear_dirty_for_io, folio_test_dirty);
>   IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_w=
riteback,
>   			 folio_test_writeback);
>  =20
> diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
> index c6d7394e6418..9aceba93c818 100644
> --- a/fs/btrfs/subpage.h
> +++ b/fs/btrfs/subpage.h
> @@ -14,15 +14,15 @@ struct folio;
>   /*
>    * Extra info for subpage bitmap.
>    *
> - * For subpage we pack all uptodate/dirty/writeback bitmaps into
> + * For subpage we pack all uptodate/dirty/writeback/fixup bitmaps into
>    * one larger bitmap.
>    *
>    * This structure records how they are organized in the bitmap:
>    *
> - * /- uptodate          /- dirty        /- writeback
> - * |			|		|
> - * v			v		v
> - * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.......|w|w|
> + * /- uptodate          /- dirty        /- writeback       /- fixup
> + * |			|		|		   |
> + * v			v		v		   v
> + * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.....|w|w|f|f|.....|f|f|
>    * |< sectors_per_page >|
>    *
>    * Unlike regular macro-like enums, here we do not go upper-case names=
, as
> @@ -40,6 +40,14 @@ enum {
>   	 */
>   	btrfs_bitmap_nr_writeback,
>  =20
> +	/*
> +	 * Blocks dirtied by the dirty_folio callback instead of a reserving
> +	 * write path (e.g. set_page_dirty_lock() on a GUP pin).  They have
> +	 * no space reservation and need the writepage fixup before they can
> +	 * be submitted.
> +	 */
> +	btrfs_bitmap_nr_fixup,
> +
>   	btrfs_bitmap_nr_max
>   };
>  =20
> @@ -165,6 +173,29 @@ DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
>   DECLARE_BTRFS_SUBPAGE_OPS(dirty);
>   DECLARE_BTRFS_SUBPAGE_OPS(writeback);
>  =20
> +/*
> + * Fixup bit helpers.
> + *
> + * The fixup bit is data-only and has no plain set helper (setting happ=
ens
> + * together with dirtying in btrfs_subpage_set_fixup_dirty()), so it do=
es not
> + * go through DECLARE_BTRFS_SUBPAGE_OPS().  For single-block folios the
> + * folio_*_fixup_pending() flag takes the place of the bitmap.
> + */
> +void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			       struct folio *folio, u64 start, u32 len);
> +bool btrfs_subpage_test_fixup(const struct btrfs_fs_info *fs_info,
> +			      struct folio *folio, u64 start, u32 len);
> +bool btrfs_folio_test_fixup(const struct btrfs_fs_info *fs_info,
> +			    struct folio *folio, u64 start, u32 len);
> +void btrfs_folio_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				 struct folio *folio, u64 start, u32 len);
> +/* For a block that just got its space reserved; it stays dirty. */
> +void btrfs_folio_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			     struct folio *folio, u64 start, u32 len);
> +/* For callers discarding the data; clears the dirty bits too. */
> +void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				   struct folio *folio, u64 start, u32 len);
> +
>   /*
>    * Helper for error cleanup, where a folio will have its dirty flag cl=
eared,
>    * with writeback started and finished.
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index f9d22cd71768..6ecfab97c1a9 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -689,6 +689,41 @@ DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_e=
xtent_lookup_first,
>   	     TP_ARGS(inode, ordered)
>   );
>  =20
> +/*
> + * The writepage fixup worker deferred a block because this still-runni=
ng
> + * ordered extent covers it.
> + */
> +DEFINE_EVENT(btrfs__ordered_extent, btrfs_writepage_fixup_defer,
> +
> +	     TP_PROTO(const struct btrfs_inode *inode,
> +		      const struct btrfs_ordered_extent *ordered),
> +
> +	     TP_ARGS(inode, ordered)
> +);
> +
> +/* The writepage fixup worker reserved space for a block and set delall=
oc. */
> +TRACE_EVENT(btrfs_writepage_fixup_reserve,
> +
> +	TP_PROTO(const struct btrfs_inode *inode, u64 start, u32 len),
> +
> +	TP_ARGS(inode, start, len),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	ino		)
> +		__field(	u64,	start		)
> +		__field(	u32,	len		)
> +	),
> +
> +	TP_fast_assign_btrfs(inode->root->fs_info,
> +		__entry->ino	=3D btrfs_ino(inode);
> +		__entry->start	=3D start;
> +		__entry->len	=3D len;
> +	),
> +
> +	TP_printk_btrfs("ino=3D%llu start=3D%llu len=3D%u",
> +			__entry->ino, __entry->start, __entry->len)
> +);
> +
>   DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_split,
>  =20
>   	     TP_PROTO(const struct btrfs_inode *inode,

