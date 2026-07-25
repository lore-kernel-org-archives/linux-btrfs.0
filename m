Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985D2380FE7
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 10:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784973898; cv=none; b=IJ8kHLHCtMLtoKWypnGaZi3fRowuRC5qlUM9vmPyL5sFJJPWbjlLHfF1FfTCEdRyFIM3H/4lV62JUMorgvyI0CiGKi5cKXdHPnPCciCEAX0Z6kmxRC56SzDuwhFuV5wy0NiKyzbW2AN0oUJ50Ppd/mLN71RFNo2rKgpVEzz2i54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784973898; c=relaxed/simple;
	bh=UUpA4XrT7lBkGyJ86G5GhiHpNatCuWHMc21zEnBqnic=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MOjvprYuwhnaqmsa6hzyHZ4JfkEwND1GWKJlwzYEiPNI/qmvHPU5L+pTd46qlfUXnrswC0I/hcQ8ezhCrsMBJiSUPm5rDISuf0H/6PWX22+t3vpm9j9L/c8yDYtAljOAqEgcjyFqwGXUBkmsqE/WBmLh4BStZItk8m56romlzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=oWbULyCM; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="oWbULyCM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784973890; x=1785578690; i=quwenruo.btrfs@gmx.com;
	bh=Am0n+fIpcKTI60ZyN3/Ox5tiIhufBirvUKXojh5Q4hM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oWbULyCMbDktZiAlgpFYmGp+0FlJiU4Bq/uoYsTCdUiWsf/311kkDDLV0GKoZuFA
	 9RCrEtdErB/HzeZN/IsUWpotAPbDr98ZRjcfY22aJLhVf7pW8V4fD0UzTHqCub9TY
	 l7vM95h/aO/ZIq7wCKi3ZPyWlPHJfGjhaEb7tBNYXHMaDd8e7/3jgLBTj43cDInLS
	 AOhSv23P/8/rwsjiayk2Xb7VJgQOyrw3KcZpaJc8INBiBR148Gy+L8n509GUzuGl+
	 mzSUAJszfQzuWR4SH22m0E//4nc7qXtIWXaVfKKLBiup332QJfX20QWQgNPBdJYMp
	 gq8whfTPIL5t6N+jHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Ml6qC-1xExWX44eC-00om23; Sat, 25
 Jul 2026 12:04:50 +0200
Message-ID: <dbb0e4ec-cdce-4852-9c1c-21634cc6fa4e@gmx.com>
Date: Sat, 25 Jul 2026 19:34:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
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
In-Reply-To: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dMO0CX8WhnA0efkQrE3Bh0IkwZD55/+hlAhGWLRbRmyan8SnAS2
 OaYJTEOKnsHSM91zcqVTe22OQvrxUGjsW6z/xuhMbDW505uMpCilCnsDmR3WWShstxtyUFr
 eijJFa1VRRZTwk4Wxt+EINkH3Z0H+FkNDhdwJMO/mgOfDdixcZ80bC1vuzjwfMkhq3aqmiH
 B/nKc70J4VVr7I0fkcNcg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JcT/McDgaNQ=;//4jHGbQfBvlJ9g9AHhWyxyl1k1
 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



=E5=9C=A8 2026/7/25 15:54, Boris Burkov =E5=86=99=E9=81=93:
[...]>
> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntr=
aeger@linux.ibm.com/
> Signed-off-by: Boris Burkov <boris@bur.io>
> Assisted-by: LLM

Without LLM it's very hard to come up with such huge change in such a=20
short time, especially considering this fix is a little urgent due to=20
both large folio and removal of cow fixup are in the same release.

So I'm totally fine with the involvement of LLM, just we will spend=20
quite some time reworking/removing a lot of comments/commit message.

Not because they are not not grammarly sound (unlike my replies), but a=20
lot of time they are too lengthy but brings not too much value compared=20
to the number of lines.

But still, very impressed to see a working RFC this soon.

> ---
>   fs/btrfs/btrfs_inode.h       |   1 +
>   fs/btrfs/defrag.c            |   1 +
>   fs/btrfs/disk-io.c           |   6 +-
>   fs/btrfs/extent_io.c         | 127 +++++++++++++++++
>   fs/btrfs/file.c              |   2 +
>   fs/btrfs/fs.h                |  20 +++
>   fs/btrfs/inode.c             | 262 ++++++++++++++++++++++++++++++++++-
>   fs/btrfs/reflink.c           |   1 +
>   fs/btrfs/relocation.c        |   1 +
>   fs/btrfs/subpage.c           |  93 +++++++++++++
>   fs/btrfs/subpage.h           |  43 +++++-
>   include/trace/events/btrfs.h |  35 +++++
>   12 files changed, 585 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 7fdc6c3fd066..037445586b31 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -600,6 +600,7 @@ int btrfs_prealloc_file_range_trans(struct inode *in=
ode,
>   				    loff_t actual_len, u64 *alloc_hint);
>   int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *=
locked_folio,
>   			     u64 start, u64 end, struct writeback_control *wbc);
> +int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio=
 *folio);
>   int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_=
info,
>   					     int compress_type);
>   int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 6ec5dd760d42..7de5febee9d1 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1158,6 +1158,7 @@ static void defrag_one_locked_target(struct btrfs_=
inode *inode,
>   		    start + len <=3D folio_pos(folio))
>   			continue;
>   		btrfs_folio_clamp_set_dirty(fs_info, folio, start, len);
> +		btrfs_folio_cancel_fixup(fs_info, folio, start, len);

This call is very frequent, and to be honest, it's redundant.

We can merge the cancel into btrfs_folio*_set_dirty(), as the=20
btrfs_folio_*set_dirty() is the "proper dirty" entrance, so we know if=20
we're going through that interface, we are ensured to cancel the fixup.

> +
> +	if (!folio_test_fixup_pending(folio))

if (likely())

> +		return 0;
> +
> +	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
> +		const u64 start =3D page_start + (bit << fs_info->sectorsize_bits);
> +
> +		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
> +						start + sectorsize - 1,
> +						EXTENT_DELALLOC))

Can we simplify the check to just check if the fixup bit is not set?

To me, without fixup bit it means it went through the regular write=20
preparation, thus should have EXTENT_DELALLOC.
And checking a bit is way faster than check an extent range.

> +			continue;
> +		if (btrfs_is_subpage(fs_info, folio) &&
> +		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize)) {

Again, we prefer not to use btrfs_is_subpage() and btrfs_subpage_*() out=
=20
of subpage.c when possible.

So just some helper, like btrfs_folio_test_fixup() would make it more=20
readable.

> +			struct btrfs_ordered_extent *ordered;
> +
> +			/*
> +			 * Not a suspect: the only legal explanation for a
> +			 * dirty, unfunded block is that it is pending its own
> +			 * submission into a covering ordered extent - punting
> +			 * it would starve that ordered extent forever, and
> +			 * the worker could not see it anyway (its work list
> +			 * is the fixup bits). Verify the ordered extent
> +			 * exists; if not, the invariant is broken - leave the
> +			 * block in the bitmap so submission fails loudly
> +			 * (EUCLEAN) instead of silently repairing.
> +			 */

The block can be dirtied properly before, then ->dirty_folio() callback=20
is triggered.

In that case, we may have not run delalloc for the folio, thus there may=
=20
be no OE created yet.

It looks like the assumption is not correct to me, and may cause false=20
alerts.

But on the other hand, it's already very hard to hit a case where we=20
have some proper dirty blocks, and ->dirty_folio() is called.
E.g. for the direct IO case, ->dirty_folio() is only called when the=20
folio is clean.

Thus this false alerts case is not easy to test.

> +			ordered =3D btrfs_lookup_ordered_range(inode, start,
> +							     sectorsize);

Doing this is a little overkilled.

As the recent patch "btrfs: use ordered extent to grab the logical=20
address for submission" will do it at submission time, with better=20
cached OE usage.

I'd prefer skip the OE lookup completely, and let the final submission=20
path to grab the OE (which can reuse bbio->ordered when possible).
> +			if (unlikely(!ordered))
> +				DEBUG_WARN();
> +			else
> +				btrfs_put_ordered_extent(ordered);
> +			continue;
> +		}
> +		/*
> +		 * Block re-dirtied via dirty_folio(), requires async fixup.
> +		 * All other blocks in the folio should proceed as normal so
> +		 * that their OEs can make progress and complete.
> +		 */
> +		bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
> +		punt =3D true;

The variable naming choice is definitely very LLM.

Non-native speaker like me may need to google the word first...

> +	}
> +	if (punt) {
> +		btrfs_queue_writepage_fixup(inode, folio);
> +		/*
> +		 * Keep the folio dirty for the punted blocks.  If nothing
> +		 * is left to submit this pass, the folio is done and we own
> +		 * the unlock, matching the async-submission contract.
> +		 */
> +		folio_redirty_for_writepage(bio_ctrl->wbc, folio);

We haven't yet cleared any bit nor folio dirty in the first place.
So not sure if this is really needed, nor the comment.

> +		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> +			folio_unlock(folio);
> +			return 1;
> +		}
> +		return 0;
> +	}
> +	/* Every dirty block is now covered; the folio is ordinary again. */
> +	if (btrfs_is_subpage(fs_info, folio))
> +		btrfs_subpage_clear_fixup(fs_info, folio, page_start,
> +					  folio_size(folio));

Again, a btrfs_folio_clear_fixup() is more helpful.

[...]
> +/*
> + * The folio has (or, for single-block folios, is) dirty blocks that we=
re
> + * dirtied without notifying the filesystem (e.g. set_page_dirty_lock()=
 on a
> + * GUP pin) and carry no reservation.  Set by btrfs_data_dirty_folio(),=
 which
> + * records the affected blocks in the subpage fixup bitmap; cleared whe=
n the
> + * writepage fixup has covered every dirty block, or by a reserving wri=
te
> + * that covers the whole folio.  Reuses the PG_owner_2 bit that the fol=
io
> + * ordered flag occupied before it was removed.

Again, very LLM comments. That's why always delete all comments from LLM=
=20
by default.

The older, removed comment is very simple for folio_ordered:

  * We use folio flag owner_2 to indicate there is an ordered extent with
  * unfinished IO.


[...]
> +static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
> +{
> +	struct btrfs_writepage_fixup *fixup =3D
> +		container_of(work, struct btrfs_writepage_fixup, work);
> +	struct extent_state *cached_state =3D NULL;
> +	struct extent_changeset *data_reserved =3D NULL;
> +	unsigned long funded[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] =3D { =
0 };
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
> +	 * Reserve for the whole folio before taking the folio lock, like
> +	 * page_mkwrite: the reservation may flush, and flushing writeback
> +	 * takes folio locks.  Which blocks actually need funding is only
> +	 * knowable under the lock, so reserve the worst case and release
> +	 * the unused ranges once the funded set is known.
> +	 */
> +	ret =3D btrfs_delalloc_reserve_space(inode, &data_reserved, page_start=
,
> +					   folio_size(folio));

You fall into the same pitfall I'm worried about, but unfortunately or=20
fortunately, it's very hard to hit.

The problem here is, we can over-reserve, e.g. some range is already=20
properly dirtied, thus they have already space reserved.

And you can not release the reserved space for them, because release=20
will also clear the qgroup reserved extent flag.

This is the biggest problem that I have no way to fix.
As there is no way to ensure the space we reserved is really needed=20
before holding the folio lock.


But since it's really hard to get a dirty folio to be called with=20
->dirty_folio(), thus it may not be exposed through tests.

> +	reserved =3D (ret =3D=3D 0);
> +again:
> +	folio_lock(folio);
> +
> +	/*
> +	 * The queueing writeback pass took references on the folio and the
> +	 * inode, but nothing else is stable: an in-band write may have funded
> +	 * the blocks and cancelled the fixup state, or the folio may have
> +	 * been invalidated.  Then there is nothing left to do - and a failed
> +	 * reservation against a folio that no longer needs one is no error.
> +	 */
> +	if (!folio->mapping || !folio_test_dirty(folio) ||
> +	    !folio_test_fixup_pending(folio)) {
> +		ret =3D 0;
> +		goto out;
> +	}
> +
> +	/* The folio still needs funding we could not get. */
> +	if (ret)
> +		goto out_error;
> +
> +	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state=
);
> +
> +	for (bit =3D 0; bit < blocks_per_folio; bit++) {
> +		struct btrfs_ordered_extent *ordered;
> +		const u64 start =3D page_start + (bit << fs_info->sectorsize_bits);
> +
> +		if (test_bit(bit, funded))
> +			continue;
> +		if (btrfs_is_subpage(fs_info, folio) &&
> +		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize))
> +			continue;
> +		/* An in-band write may have funded the block while we waited. */
> +		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
> +						start + sectorsize - 1,
> +						EXTENT_DELALLOC))
> +			continue;
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
> +		if (ret) {
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			goto out_error;
> +		}
> +		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
> +		if (btrfs_is_subpage(fs_info, folio))
> +			btrfs_subpage_clear_fixup(fs_info, folio, start,
> +						  sectorsize);
> +		__set_bit(bit, funded);

Why __set_bit() not set_bit()?

> +	}
> +
> +	/* Every fixup block is funded; the folio is ordinary again. */
> +	folio_clear_fixup_pending(folio);
> +	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_sta=
te);
> +	goto out;
> +
> +out_error:
> +	/*
> +	 * The remaining unnotified blocks cannot be funded.  There is no
> +	 * syscall to return this through, so surface it the way a failed
> +	 * writeback would - record the error on the mapping - and drop the
> +	 * blocks, or writeback would find and requeue them forever.
> +	 */
> +	mapping_set_error(folio->mapping, ret);
> +	if (btrfs_is_subpage(fs_info, folio)) {
> +		bool last =3D false;
> +
> +		for (bit =3D 0; bit < blocks_per_folio; bit++) {

Again, a proper btrfs_folio_clear_fixup() and pass the folio range into=20
it should handle the loop.

> +			const u64 start =3D page_start +
> +					  (bit << fs_info->sectorsize_bits);
> +
> +			if (!btrfs_subpage_test_fixup(fs_info, folio, start,
> +						      sectorsize))
> +				continue;
> +			last =3D btrfs_subpage_clear_and_test_dirty(fs_info,
> +							folio, start,
> +							sectorsize);
> +		}
> +		btrfs_folio_cancel_fixup(fs_info, folio, page_start,
> +					 folio_size(folio));
> +		if (last)
> +			folio_clear_dirty_for_io(folio);

Again, the regular btrfs_folio_clear_dirty() is going to handle all=20
these, and no need for a special subpage branch.

> +	} else {
> +		folio_clear_dirty_for_io(folio);
> +	}
> +	folio_clear_fixup_pending(folio);
> +out:
> +	if (reserved) {
> +		btrfs_delalloc_release_extents(inode, folio_size(folio));
> +		for_each_clear_bitrange(start_bit, end_bit, funded,
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
> +	/*
> +	 * As a precaution, do a delayed iput in case it would be the last
> +	 * iput that could need flushing space. Recursing back to the fixup
> +	 * worker would deadlock.
> +	 */
> +	btrfs_add_delayed_iput(inode);
> +}
[...]
> +static bool btrfs_data_dirty_folio(struct address_space *mapping,
> +				   struct folio *folio)
> +{
> +	struct btrfs_inode *inode =3D BTRFS_I(mapping->host);
> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +	bool marked =3D false;
> +
> +	if (btrfs_is_subpage(fs_info, folio)) {
> +		const struct btrfs_folio_state *bfs =3D folio_get_private(folio);
> +		const u64 page_start =3D folio_pos(folio);
> +		const u64 range_end =3D min_t(u64, page_start + folio_size(folio),
> +					    round_up(i_size_read(&inode->vfs_inode),
> +						     fs_info->sectorsize));
> +
> +		if (!READ_ONCE(bfs->reserving_dirty) &&
> +		    folio_test_uptodate(folio) && range_end > page_start)
> +			marked =3D btrfs_subpage_set_fixup_dirty(fs_info, folio,
> +							       page_start,
> +							       range_end - page_start);
> +	} else if (!folio_test_dirty(folio) &&
> +		   !btrfs_test_range_bit_exists(&inode->io_tree,
> +						folio_pos(folio),
> +						folio_next_pos(folio) - 1,
> +						EXTENT_DELALLOC)) {

Again, the same question why the folio_test_dirty() check is not enough.

The subpage part has no such check.

> +		marked =3D true;
> +	}
> +	if (marked)
> +		folio_set_fixup_pending(folio);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +
[..]
> --- a/fs/btrfs/subpage.c
> +++ b/fs/btrfs/subpage.c
> @@ -356,7 +356,17 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_=
info *fs_info,
>   	spin_lock_irqsave(&bfs->lock, flags);
>   	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
>   	spin_unlock_irqrestore(&bfs->lock, flags);
> +	/*
> +	 * Every caller of this helper is a reserving write path dirtying
> +	 * exactly the range it reserved; the dirty_folio callback must not
> +	 * treat it as potentially unnotified and drag the folio's clean
> +	 * sibling blocks into COW (that breaks reflink sharing of the
> +	 * untouched blocks, among other things).  Unnotified dirtiers call
> +	 * folio_mark_dirty() directly and never pass through here.
> +	 */
> +	WRITE_ONCE(bfs->reserving_dirty, true);
>   	folio_mark_dirty(folio);

My solution in my initial patchset is to not call folio_mark_dirty() as=20
it will call back to the ->dirty_folio() call back.

So I implemented an local version which call back to=20
filemap_mark_dirty(), other than ->dirty_folio() which sets the fixup bits=
.

> +	WRITE_ONCE(bfs->reserving_dirty, false);
>   }
>  =20
>   static void folio_clear_tags(struct folio *folio)
> @@ -457,6 +467,88 @@ void btrfs_subpage_clear_writeback(const struct btr=
fs_fs_info *fs_info,
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
> +	spin_unlock_irqrestore(&bfs->lock, flags);

Shouldn't we also check if we have cleared the last fixup bit and clear=20
the folio fixup flag?
[...]
> +void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
> +			      struct folio *folio, u64 start, u32 len)

Why not let IMPLEMNT_BTRFS_PAGE_OPS() to implement all the fixup helpers?

[...]
>  =20
> @@ -50,6 +65,14 @@ enum {
>   struct btrfs_folio_state {
>   	/* Common members for both data and metadata pages */
>   	spinlock_t lock;
> +	/*
> +	 * Set across the folio_mark_dirty() that a reserving write path
> +	 * issues from btrfs_subpage_set_dirty(), so that the dirty_folio
> +	 * callback does not treat the dirtying as potentially unnotified
> +	 * and mark the folio's still-clean sibling blocks.  Written under
> +	 * the folio lock, which every reserving path holds.
> +	 */
> +	bool reserving_dirty;

As I mentioned, this is only for dirty_folio() to skip setting fixup bit.

We can get rid of it, if the btrfs_folio_set_dirty() helper doesn't go=20
through folio_mark_dirty().

Thanks,
Qu
