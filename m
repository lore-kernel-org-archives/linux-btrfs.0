Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895C2E7F2C
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 02:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782785262; cv=none; b=TfPEiZSMl6fIarFEbzURxRWKPkz6/U3WEJshfSuUGOOeCV1fSHbn+3M7VA/EuefZVmKqyrdrZ788ijc1RUCKxI94qy8FYBUcLwQ1307CIdh4UukiCdAePeAT3HTYU0ifIhpw9XsltCXUqwnN3jXKC0i1gjQJEN9ILVMVJzsD3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782785262; c=relaxed/simple;
	bh=DZeJiyBX0UzOSITxQ/bIgQRuvhvIk/bhXIJT2wSKsh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDtaB+V9WmStXWq6FBYZDjITj43e1Ot341cj83Elp0VD67SulESzrpGyR7/nWEm2j887rvZdBDQHJfdDrk78P92xSIBlLzhCBTHuXafGGHiaamWse3SfoUN/frf47GDQMGEwn1OyXTFAJNmIqLIhrtPZ4r+PdnVlnCBMTknt1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J1RVGYS0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s+MnQLwm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J1RVGYS0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s+MnQLwm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J1RVGYS0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s+MnQLwm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J1RVGYS0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s+MnQLwm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C236471653;
	Tue, 30 Jun 2026 02:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782785258;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZIQ3v56EQhRGPpD2Lfh306Qz8KOo+ML3S3M8//nhKY=;
	b=J1RVGYS0rpPjsHZk0ip8RdNRpZ8TZkjiKhfg/Onts1h/Rhyi+Ch4XedOJLU4lsleNF0Swa
	KmNGULDrsm8puJAA6ih0AVuVDvl9IDuegW9z953LJAgHBsNs2d4aCN6/O4u/7EQixLT2yG
	6Yw0ijzuY12aW/JGTNvRu7Zvdv6pouk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782785258;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZIQ3v56EQhRGPpD2Lfh306Qz8KOo+ML3S3M8//nhKY=;
	b=s+MnQLwmnhdIM6W0hT6jC6azNpFhZEWphTjOV8UprKupfq6bo6azCZBpRP40iw+8UgSMPQ
	Cv6/OHGN6qMnPNDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782785258;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZIQ3v56EQhRGPpD2Lfh306Qz8KOo+ML3S3M8//nhKY=;
	b=J1RVGYS0rpPjsHZk0ip8RdNRpZ8TZkjiKhfg/Onts1h/Rhyi+Ch4XedOJLU4lsleNF0Swa
	KmNGULDrsm8puJAA6ih0AVuVDvl9IDuegW9z953LJAgHBsNs2d4aCN6/O4u/7EQixLT2yG
	6Yw0ijzuY12aW/JGTNvRu7Zvdv6pouk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782785258;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZIQ3v56EQhRGPpD2Lfh306Qz8KOo+ML3S3M8//nhKY=;
	b=s+MnQLwmnhdIM6W0hT6jC6azNpFhZEWphTjOV8UprKupfq6bo6azCZBpRP40iw+8UgSMPQ
	Cv6/OHGN6qMnPNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E584779A8;
	Tue, 30 Jun 2026 02:07:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ImxuJuokQ2o/KgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 02:07:38 +0000
Date: Tue, 30 Jun 2026 04:07:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>, Sun YangKai <sunk67188@gmail.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] btrfs: replace writeback inhibition xarray with a fixed
 inline buffer
Message-ID: <20260630020733.GG2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,fb.com,suse.com,bur.io,gmail.com,intel.com];
	FREEMAIL_TO(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,intel.com:email,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.50

On Wed, Jun 24, 2026 at 10:57:03AM -0700, Leo Martins wrote:
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
> btrfs.

22% drop is quite significant, it's now in 7.1. It could be possible to
push that to 7.2 as it's fixing only the tracking mechanism. We'll need
to get it tested for some time, so estimated rc would be like rc3 or rc4
at most.

> The cost is the per-COW xarray store done on every COW'd block.
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
> referenced, so revisited buffers survive eviction while write-once buffers
> are reclaimed first. A small fixed buffer is therefore enough where a
> non-evicting array would either overflow or have to grow without bound.
> BTRFS_INHIBITED_EBS_SLOTS is 8 and the reference bits pack into a u32.
> 
> The CLOCK eviction is what justifies the extra complexity over a plain
> non-evicting array. On a workload built to stress amplification, removing
> 16 heavily fragmented 64 MiB files in one transaction while background
> writeback keeps writing out in-use metadata, counting re-COW events (a
> buffer already COWed in the running transaction, written back, then COWed
> again) against first-COW events and summing across the eviction (n=5),
> re-COWs outnumber first COWs about 6.1 to 1 with no inhibition, 3.8 to 1
> with a non-evicting array of 32 slots, 1.6 to 1 with this 8 slot CLOCK
> array, and 1.4 to 1 with the reverted unbounded xarray. The non-evicting
> array fills with write-once buffers and stops covering the buffers the
> handle keeps revisiting, so even at four times the slots it leaves most of
> the amplification. CLOCK evicts the cold buffers and keeps the revisited
> ones, which recovers almost all of the unbounded benefit. The eviction
> policy, not the buffer size, is what closes the gap.

Can you please transform the paragraph to a table or split it by case?
The numbers are burried in text, hard to see what's the actual benefit.

> eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
> lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
> are unaffected. A reference is taken on each tracked buffer so it cannot
> be freed while the array points at it; eviction drops that reference and
> the inhibitor count.
> 
> Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com

Would be good to comment under the report that you're aware of the
issue, not necessarily say how you're fixing it or when.

> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>  fs/btrfs/extent_io.c   | 78 +++++++++++++++++++++++++-----------------
>  fs/btrfs/transaction.c |  2 --
>  fs/btrfs/transaction.h | 15 ++++++--
>  3 files changed, 59 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9d7ca80477fd..1845a617fb10 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> +	/* Already tracked: set its reference bit (second chance) and return. */
> +	for (u32 i = 0; i < trans->nr_inhibited_ebs; i++) {

For simple indexes we use 'int', it does not make any differences for
the bit shifts when it's the number.

> +		if (trans->inhibited_ebs[i] == eb) {
> +			trans->inhibited_ebs_referenced |= 1U << i;
> +			return;
> +		}
>  	}
>  
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -12,7 +12,6 @@
>  #include <linux/time64.h>
>  #include <linux/mutex.h>
>  #include <linux/wait.h>
> -#include <linux/xarray.h>
>  #include "btrfs_inode.h"
>  #include "delayed-ref.h"
>  
> @@ -23,6 +22,7 @@ struct btrfs_fs_info;
>  struct btrfs_root_item;
>  struct btrfs_root;
>  struct btrfs_path;
> +struct extent_buffer;
>  
>  /*
>   * Signal that a direct IO write is in progress, to avoid deadlock for sync
> @@ -136,6 +136,12 @@ enum {
>  
>  #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
>  
> +/*
> + * Must stay <= 32: the CLOCK reference bits pack into the u32
> + * inhibited_ebs_referenced.
> + */
> +#define BTRFS_INHIBITED_EBS_SLOTS	8

Please use static_assert for the constraints, for power of two there's
the "n != 0 && (n & (n - 1)) == 0" trick that also works for the
assertion.

> +
>  struct btrfs_trans_handle {
>  	u64 transid;
>  	u64 bytes_reserved;
> @@ -163,8 +169,11 @@ struct btrfs_trans_handle {
>  	struct btrfs_fs_info *fs_info;
>  	struct list_head new_bgs;
>  	struct btrfs_block_rsv delayed_rsv;
> -	/* Extent buffers with writeback inhibited by this handle. */
> -	struct xarray writeback_inhibited_ebs;
> +	/* Extent buffers this handle has inhibited writeback on. */
> +	struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];
> +	u32 inhibited_ebs_referenced;	/* CLOCK reference bit per slot */
> +	u32 nr_inhibited_ebs;
> +	u8 inhibited_ebs_hand;		/* CLOCK hand */

Due to alignment constraints you can use u32 too, thre will be a hole
after it anyway.

As mentioned in my other reply, the structure size is under 256 so we
don't have to save space with narrow types, majority of the tracking is
still in the inhibited_ebs array.
