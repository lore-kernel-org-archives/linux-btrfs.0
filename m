Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B0E19049B
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010806; cv=none; b=tRrNAmSW2YY+VjypzJpx20MBABV0xrU8hr2ToA2N8Vq+i0DYqjiAMaTXKn72MJW8KEvJN2L5TQ3gOv8kBKF4+/xOsbv6ukbU+bbR9YLOQHHQ7QKVUo9GnCOmCFVCK1I7s3uytCyAKze1iZSo7+9VADoLUhmyXd/9DKeNBLAhPWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010806; c=relaxed/simple;
	bh=GxbvudAOZu0SU8z9M7YaSqX2h9+hWQVWNBQcenDdUFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sSxFE+rcDryupUSiSys0GoVSNqFf4Q+DMgtXYHjXhuQaKg08Dq0m4yqoWQeBbWtPJvM3S4OPMHNqPbr5mZ2Iq4/jLoPKmz1CiQVLLP8k0snrjeopg//svssgN+AoRJ8G37Bu9JnTys6BcY3ViChzNLNKZhO1mDZtuZ2HctcwwcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dR1Sup1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dR1Sup1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B531F00ADE
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010804;
	bh=Iqve2V3BOrmFkxo/hwg3XwGjNj8NrfAaMmD4ohc9EQw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dR1Sup1qT8rfgg9miOKogw9H6nsybpQihlnLQslUuGUwznogzIkuggcbYgbCKO3Bo
	 mXFk3hjq8qNfwB1HqSzPfr/Lhc3HUiqKdUy85Vd6AUeNSvPg093cUlnX8JPNKsVTX8
	 PAaB6kweoXQhzSDa+DW0FFDOvV45EJoUVzh7yX2C60lk1dBeviVHKK1lk0epG7neRO
	 +zZMai/hGnnMrpVOrvyQ5d6b/cX5XxnDGj4LumPGJrEo0YjjDQE4VIhykdgsMUZXTS
	 f/AX0T3LXMQ5b9uZIpua8NBKmYi+kUMXe6hi0C/vdQB2YD2SqOCZUEuXNCFkCx4DSw
	 jZlU238ad3gQg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c127813835aso267857066b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 09:46:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoaMlCPpBdKd/NkUSQQ0BibfiKEYZUX60ThDvO5UWgN9tdbZc7alVpiNPVFQ5SkXix2pzqZgdCq1ijKaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDi+cXrbOSEXs8XXY8Hxn+qDaMv8NMXUl59vazSIwQrnlaGrK0
	zC+3ZsdqorpSL+hVjIrlJpy2NPQzx1n9V2xcfP2xdyjcIKIqlgLA0bYKwijhzPiip3g6hyyUUJh
	KLOuFa9f0xjlse9B0sPZYZxFAFgucpak=
X-Received: by 2002:a17:907:3d02:b0:c12:764e:326 with SMTP id
 a640c23a62f3a-c12a9da169amr304282066b.27.1783010803245; Thu, 02 Jul 2026
 09:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <12d3c3f07b8610ca13b0f3f792d420541afb7b33.1782949130.git.loemra.dev@gmail.com>
In-Reply-To: <12d3c3f07b8610ca13b0f3f792d420541afb7b33.1782949130.git.loemra.dev@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 2 Jul 2026 17:46:06 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6H8a0nPK8Ysvr-6P7CuBMOv=BjoFob8B5WvpMUxZCqRg@mail.gmail.com>
X-Gm-Features: AVVi8CfQyDNrj54bflgwKcNBeJXC3F1w-GbJmklNEcudn990o17lwE59vpHAyDk
Message-ID: <CAL3q7H6H8a0nPK8Ysvr-6P7CuBMOv=BjoFob8B5WvpMUxZCqRg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: replace writeback inhibition xarray with a
 fixed inline buffer
To: Leo Martins <loemra.dev@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>, Sun YangKai <sunk67188@gmail.com>, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 12:48=E2=80=AFAM Leo Martins <loemra.dev@gmail.com> =
wrote:
>
> Commit f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent
> COW amplification") tracks the extent buffers a transaction handle has
> inhibited in a per-handle xarray. Keying the tracking to the transaction
> handle is correct, but using an xarray for it causes two problems in
> production.
>
> First, a write_iops regression. Every COW calls
> btrfs_inhibit_eb_writeback() from btrfs_force_cow_block() and
> should_cow_block(), which does an xa_store() keyed by eb->start. The
> kernel test robot reported a 22.6% fio.write_iops regression on a
> single-task 4k randwrite workload (ftruncate ioengine, buffered IO) on
> btrfs. The cost is the per-COW xarray store done on every COW'd block.
> Replacing it with a non-allocating fixed buffer recovers the lost
> throughput, and that buffer does more per-COW bookkeeping yet still
> recovers, so the cost is the xarray operation itself rather than the
> extra tracking work.
>
> Second, an unbounded cleanup walk. btrfs_uninhibit_all_eb_writeback()
> iterates every eb the handle inhibited with xa_for_each(). A single
> handle that COWs a very large number of blocks (inode eviction, or
> truncate of a file with many extents, where btrfs_truncate_inode_items()
> loops over many search_again descents under one handle) makes that walk
> arbitrarily long. It runs in __btrfs_end_transaction() before
> num_writers is dropped, so it blocks the committing thread; this shows up
> as multi-second stalls and RCU stall reports.
>
> Replace the xarray with a fixed inline array on btrfs_trans_handle,
> managed with a CLOCK (second-chance) eviction policy. Inhibiting a buffer
> becomes an array append with no allocation and no tree walk, and the
> end-of-handle cleanup is bounded by the array size.
>
> The set that actually needs protection is the working set the handle
> revisits across search_again descents, the search path frontier, which is
> on the order of the tree height. It is not every block the handle ever
> COWs. should_cow_block() re-inhibiting an already tracked buffer marks it
> referenced, so revisited buffers survive eviction while write-once buffer=
s
> are reclaimed first. A small fixed buffer is therefore enough where a
> non-evicting array would either overflow or have to grow without bound.
> BTRFS_INHIBITED_EBS_SLOTS is 8 and the reference bits pack into a u32.
>
> The CLOCK eviction is what justifies the extra complexity over a plain
> non-evicting array. The test workload stresses amplification: it removes
> 16 heavily fragmented 64 MiB files in one transaction while background
> writeback keeps writing out in-use metadata. A re-COW event is a buffer
> already COWed in the running transaction that was written back and then
> COWed again; the figure below is the ratio of re-COW events to first-COW
> events summed across the eviction (n=3D5, lower is better):
>
>   tracking                           re-COW per first-COW
>   no inhibition                      6.1
>   non-evicting array, 32 slots       3.8
>   CLOCK array, 8 slots (this patch)  1.6
>   unbounded xarray (reverted)        1.4
>
> The non-evicting array fills with write-once buffers and stops covering
> the buffers the handle keeps revisiting, so even at four times the slots
> it leaves most of the amplification. CLOCK evicts the cold buffers and
> keeps the revisited ones, recovering almost all of the unbounded benefit.
> The eviction policy, not the buffer size, is what closes the gap.
>
> eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
> lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
> are unaffected. A reference is taken on each tracked buffer so it cannot
> be freed while the array points at it; eviction drops that reference and
> the inhibitor count.
>
> Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent C=
OW amplification")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.co=
m
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> Reviewed-by: Sun YangKai <sunk67188@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Some minor things to fixup below.

First, the Reviewed-by tag is in the wrong location, see:

https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html#ordering

> ---
> v2:
> - Present the amplification numbers as a table instead of prose (David St=
erba).
> - Use int for the loop indices and the slot local instead of u32 (David S=
terba).
> - Replace the BTRFS_INHIBITED_EBS_SLOTS comment with static_assert checks=
 for
>   the <=3D 32 bound and the power-of-two size (David Sterba).
> - Widen inhibited_ebs_hand from u8 to u32; the handle stays in the same s=
lab
>   bucket and the u8 only left an alignment hole (David Sterba).
> - Factor slot selection and eviction into btrfs_inhibit_claim_slot()
>   (Sun YangKai).
> - Add Reviewed-by from Sun YangKai.
>
> v1: https://lore.kernel.org/linux-btrfs/e0d3d3ac7c585b023c2e14cec7e2b995b=
247b68e.1781728340.git.loemra.dev@gmail.com/
>
>  fs/btrfs/extent_io.c   | 93 +++++++++++++++++++++++++++---------------
>  fs/btrfs/transaction.c |  2 -
>  fs/btrfs/transaction.h | 21 ++++++++--
>  3 files changed, 78 insertions(+), 38 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9d7ca80477fd..145b6cf37331 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2982,47 +2982,75 @@ static inline void btrfs_release_extent_buffer(st=
ruct extent_buffer *eb)
>         kmem_cache_free(extent_buffer_cache, eb);
>  }
>
> +/*
> + * Claim a slot to track an extent buffer in, evicting the coldest track=
ed buffer
> + * when the array is full.
> + *
> + * Slots fill in order until the array is full. After that a CLOCK (seco=
nd
> + * chance) scan advances the hand, clearing one reference bit per step, =
until it
> + * lands on an unreferenced slot whose buffer is evicted. Clearing a bit=
 per step
> + * bounds the scan to BTRFS_INHIBITED_EBS_SLOTS iterations.
> + */
> +static int btrfs_inhibit_claim_slot(struct btrfs_trans_handle *trans)
> +{
> +       int slot;
> +
> +       if (trans->nr_inhibited_ebs < BTRFS_INHIBITED_EBS_SLOTS)
> +               return trans->nr_inhibited_ebs++;
> +
> +       while (trans->inhibited_ebs_referenced &
> +              (1U << trans->inhibited_ebs_hand)) {
> +               trans->inhibited_ebs_referenced &=3D
> +                       ~(1U << trans->inhibited_ebs_hand);
> +               trans->inhibited_ebs_hand =3D
> +                       (trans->inhibited_ebs_hand + 1) %
> +                       BTRFS_INHIBITED_EBS_SLOTS;
> +       }
> +       slot =3D trans->inhibited_ebs_hand;
> +       trans->inhibited_ebs_hand =3D
> +               (trans->inhibited_ebs_hand + 1) % BTRFS_INHIBITED_EBS_SLO=
TS;
> +
> +       atomic_dec(&trans->inhibited_ebs[slot]->writeback_inhibitors);
> +       free_extent_buffer(trans->inhibited_ebs[slot]);
> +       return slot;
> +}
> +
>  /*
>   * Inhibit writeback on buffer during transaction.
>   *
>   * @trans:  transaction handle that will own the inhibitor
>   * @eb:      extent buffer to inhibit writeback on
>   *
> - * Attempt to track this extent buffer in the transaction's inhibited se=
t.  If
> - * memory allocation fails, the buffer is simply not tracked. It may be =
written
> - * back and need re-COW, which is the original behavior.  This is accept=
able
> - * since inhibiting writeback is an optimization.
> + * Attempt to track this extent buffer in the transaction's inhibited se=
t.  When
> + * the set is full the coldest tracked buffer is evicted instead.  An un=
tracked
> + * buffer may be written back and need re-COW, which is the original beh=
avior.
> + * This is acceptable since inhibiting writeback is an optimization.
>   */
> -void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct=
 extent_buffer *eb)
> +void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans,
> +                               struct extent_buffer *eb)

We avoid style/indentation only changes.

>  {
> -       unsigned long index =3D eb->start >> trans->fs_info->nodesize_bit=
s;
> -       void *old;
> +       int slot;
>
>         lockdep_assert_held(&eb->lock);
> -       /* Check if already inhibited by this handle. */
> -       old =3D xa_load(&trans->writeback_inhibited_ebs, index);
> -       if (old =3D=3D eb)
> -               return;
>
> -       /* Take reference for the xarray entry. */
> -       refcount_inc(&eb->refs);
> -
> -       old =3D xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_=
NOFS);
> -       if (xa_is_err(old)) {
> -               /* Allocation failed, just skip inhibiting this buffer. *=
/
> -               free_extent_buffer(eb);
> -               return;
> +       /* Already tracked: set its reference bit (second chance) and ret=
urn. */
> +       for (int i =3D 0; i < trans->nr_inhibited_ebs; i++) {
> +               if (trans->inhibited_ebs[i] =3D=3D eb) {
> +                       trans->inhibited_ebs_referenced |=3D 1U << i;
> +                       return;
> +               }
>         }
>
> -       /* Handle replacement of different eb at same index. */
> -       if (old && old !=3D eb) {
> -               struct extent_buffer *old_eb =3D old;
> -
> -               atomic_dec(&old_eb->writeback_inhibitors);
> -               free_extent_buffer(old_eb);
> -       }
> +       slot =3D btrfs_inhibit_claim_slot(trans);
>
> +       /*
> +        * Pin the eb while the array holds a raw pointer to it; the coun=
ter is
> +        * what lock_extent_buffer_for_io() checks.
> +        */
> +       refcount_inc(&eb->refs);
>         atomic_inc(&eb->writeback_inhibitors);
> +       trans->inhibited_ebs[slot] =3D eb;
> +       trans->inhibited_ebs_referenced |=3D 1U << slot;
>  }
>
>  /*
> @@ -3030,14 +3058,13 @@ void btrfs_inhibit_eb_writeback(struct btrfs_tran=
s_handle *trans, struct extent_
>   */
>  void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
>  {
> -       struct extent_buffer *eb;
> -       unsigned long index;
> -
> -       xa_for_each(&trans->writeback_inhibited_ebs, index, eb) {
> -               atomic_dec(&eb->writeback_inhibitors);
> -               free_extent_buffer(eb);
> +       for (int i =3D 0; i < trans->nr_inhibited_ebs; i++) {
> +               atomic_dec(&trans->inhibited_ebs[i]->writeback_inhibitors=
);
> +               free_extent_buffer(trans->inhibited_ebs[i]);
>         }
> -       xa_destroy(&trans->writeback_inhibited_ebs);
> +       trans->nr_inhibited_ebs =3D 0;
> +       trans->inhibited_ebs_referenced =3D 0;
> +       trans->inhibited_ebs_hand =3D 0;
>  }
>
>  static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info =
*fs_info,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4358f4b63057..b4b8d587effb 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -697,8 +697,6 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>                 goto alloc_fail;
>         }
>
> -       xa_init(&h->writeback_inhibited_ebs);
> -
>         /*
>          * If we are JOIN_NOLOCK we're already committing a transaction a=
nd
>          * waiting on this guy, so we don't need to do the sb_start_intwr=
ite
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..e918dde76920 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -7,12 +7,12 @@
>  #define BTRFS_TRANSACTION_H
>
>  #include <linux/atomic.h>
> +#include <linux/build_bug.h>
>  #include <linux/refcount.h>
>  #include <linux/list.h>
>  #include <linux/time64.h>
>  #include <linux/mutex.h>
>  #include <linux/wait.h>
> -#include <linux/xarray.h>
>  #include "btrfs_inode.h"
>  #include "delayed-ref.h"
>
> @@ -23,6 +23,7 @@ struct btrfs_fs_info;
>  struct btrfs_root_item;
>  struct btrfs_root;
>  struct btrfs_path;
> +struct extent_buffer;
>
>  /*
>   * Signal that a direct IO write is in progress, to avoid deadlock for s=
ync
> @@ -136,6 +137,17 @@ enum {
>
>  #define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
>
> +/*
> + * Number of extent buffers a transaction handle tracks for writeback
> + * inhibition. The CLOCK reference bits pack into a u32 so this must not=
 exceed
> + * 32, and keeping it a power of two lets the compiler reduce the CLOCK =
hand
> + * modulo to a mask.
> + */
> +#define BTRFS_INHIBITED_EBS_SLOTS      8
> +static_assert(BTRFS_INHIBITED_EBS_SLOTS <=3D 32);
> +static_assert(BTRFS_INHIBITED_EBS_SLOTS !=3D 0 &&
> +             (BTRFS_INHIBITED_EBS_SLOTS & (BTRFS_INHIBITED_EBS_SLOTS - 1=
)) =3D=3D 0);
> +
>  struct btrfs_trans_handle {
>         u64 transid;
>         u64 bytes_reserved;
> @@ -163,8 +175,11 @@ struct btrfs_trans_handle {
>         struct btrfs_fs_info *fs_info;
>         struct list_head new_bgs;
>         struct btrfs_block_rsv delayed_rsv;
> -       /* Extent buffers with writeback inhibited by this handle. */
> -       struct xarray writeback_inhibited_ebs;
> +       /* Extent buffers this handle has inhibited writeback on. */
> +       struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];
> +       u32 inhibited_ebs_referenced;   /* CLOCK reference bit per slot *=
/
> +       u32 nr_inhibited_ebs;
> +       u32 inhibited_ebs_hand;         /* CLOCK hand */

Comments about structure members should be always be in a line above
the member, and the first word should be capitalized, ending the
sentence with punctuation.
You did that well for inhibited_eb, but not the the other 2 members.

See:

https://btrfs.readthedocs.io/en/latest/dev/Development-notes.html#comments

Thanks.

>  };
>
>  /*
>
> base-commit: 12cdfd13afd5e929f359f0f9c0443e0cbd7f43fa
> --
> 2.53.0-Meta
>
>
