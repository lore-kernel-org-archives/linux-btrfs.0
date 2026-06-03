Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B3D5CDF1;
	Wed,  3 Jun 2026 04:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780461307; cv=none; b=UBPLkokVbwQX9qebopxJtrSbQKHdk75qe643gXMRtW/vbOCHXsdDLZ4RuieWofrSftrTpaqoQmmrPB9T/TB/U/ttiJ26osn0Hy9yf6ItkN413HLw/NbqKU2fMFG5KaR5GLHo/KHBA0VRnWTYl97aCq92n7UG+UdsyxqrGMvgSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780461307; c=relaxed/simple;
	bh=upeVWz+iFvknECMTzh9HSR6Sv3jI65GTALTC6jA3VnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGAaVsY52+oRjHgFqcrKMszwyF2voUI6Lngi8hTJ7uDWpXwjqshGpdWrMY458F0pRxNwFM/KmH+znCQdd+GXcglH+/ZPkcUDspKi0rSi4MPQs3DoyxJ+kdMMsWKNAIoFsQLFkPRIyVZvfuB1tGE3qPQXIEjyDXunttZF1SfuKKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=jrzWDWGx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Tz1dGTf3; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="jrzWDWGx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Tz1dGTf3"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id CA3151D000D3;
	Wed,  3 Jun 2026 00:35:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 03 Jun 2026 00:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1780461305; x=1780547705; bh=aKL3zuUW4C
	sYzvFG92Q8iHKYTA6xuLGPTGz5qU0XQ5Q=; b=jrzWDWGxvOfJ5rAiRJoVTZwqPy
	PH+RGuJU7Z0Zk6XXOiJONenyCEjaltksXZe5kNyO8JviMXA+hyTkguFnu9Lfi/33
	t5Dp0S/qi413kxUmF/9IKO0uvqav8UWt13ceigBIe8U7591VodaLpS0W5AExQZWT
	BE+f1K54DDYDres1LJyMaZ6q7rcKFGUasksffSDJe40m0Mzg94Y6WfxlV9wq45y5
	6iziGtlwFVSm2Av1cIa5gXv/9IwWJfRNcq+p1vupP68SkueRBQUc/uJQ3IObDZIQ
	0aCy1Q/fIgwPYmBkwI4seEdx97csvfeVkDJ+c2UFVujYGWILUWDkvoPMb2jA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780461305; x=1780547705; bh=aKL3zuUW4CsYzvFG92Q8iHKYTA6xuLGPTGz
	5qU0XQ5Q=; b=Tz1dGTf382TT/I9DcMWg4hHMYgVh6QWrBPUbszI41/fVid8lAiH
	uj4qshfRPArhxu9IZT0BF9LqQwKf2F5/ejRplwMYN3iG+giGdGjrZ7rz2ntXpeNX
	ie5gds29nWmm7FdqwYJihbJYl8vQDiIwGUq0up4LzjzChbTO9luT241tf/sOsa3e
	BkDHFDcQrcVoAqQ6fgvltH7oJXVbdAuR2giHVw9B9WTo+ecQALeYlgtdaG3yMBH7
	vd6JuJzYm65DIS5ICC3cWuKN+ME7JOSeSF0NVuVeU0SBn0oJDd9jQFbF+Si1S1DU
	Zccfk2+xAZ7YoAOMATqtMrP+mMx21zk+LKQ==
X-ME-Sender: <xms:-a4favRTzE6spQTUb6ZCU94gKxkn5yWoIL71OPXQRSR_MoIVbbYsQw>
    <xme:-a4faoh6Jwaq7T5FOV0xZ0xHvuIXYg1vv8qmiPn-dYhgoYpfjQuD-bAffT98Yjvoh
    QofGAUnbpbd3-IFA8WMK2k7pTQvLy8dcM-yf-N3rSHeVOYgqycUSsA>
X-ME-Received: <xmr:-a4fan7XpmbVhieI9tuqeI6my3K2-1jWYIaRWM-SbSDrTGRtJDC0nMxHpiczOuzMVRx1pWVgnFNiVNzA6R2qmXwHDEQ>
X-ME-Proxy-Cause: dmFkZTEwGi6hBRiKGdWsO1pM/+GouOqpHgOwPzahjKpwQoO78TA0HPt9PLhqj9oYmIEQl6
    hd57+P/M2v/QU4yGVudFIn4OfnMVmD27F3HZ6RaNhV8Htrytnxym5Fa0wYW55vz70LZ9l4
    93Z8mV9kJckH6/oYrv2wm+Oio5XF/ZByRsydyTYF3kTctp//jAlXo1chu1l24xiq1SLHxv
    CRQPI5ajCuE5L0ZFODcPnrh5P1OnYEbJWQfH/eQQV7r6MGCeidmbRne8d/k/Tan6oEgYJP
    ZK3ZPc0JSQfbt/QjTrVM+c9H3eglOXZ7KcX8A2FwRs3T82CN/cbp8pA2rp9FNtDb+wzAUG
    exyT5oYZduVhA/zMmpBOaT+k0lIgDrCBnn9Y5dPBU80XHzoWD+6qeYrQ6jzcxKbo4/7eco
    mn+9K3P0bTW43tvwWYkyY22lT9OUN0QIeX4Sf6U2lAu04CUbu0ulrlQDsdvl3riH0oNrsT
    2Fh0alrERM9fi1MavJlcAW0316QaKW1gHM2I1of7gk8TEWH0F26wXP+MccmWArL3eCxmlN
    na20Foh69f16/OlMZPxwmA0t5x561yAM9jsd50HLuuAf8wFGvtx03ggAl8ryX7huzUUkY1
    yJUz99V5atjRtARutCqqPWF1T7Rym+f9GpUU0Ws29D98YLmENh7h+mjnQB7A
X-ME-Proxy: <xmx:-a4fatB1XpH3LU3MU16_X_RquNjKFqwac8hUbNgqLZDE9kepdfwbRw>
    <xmx:-a4famYTpCw51fv0iJw-3ZuEpkIBFvH17Z9HcVFDh0reFhh-POlrvQ>
    <xmx:-a4fagangCRxgHhR7-ZZf3lh6hAF4g7536R8cFKGz5EzvbT1hrKbqg>
    <xmx:-a4fal-PSLx9pcNPRJVRwt6EnM2jobrTSXwsGsECBZJpBG_qBGrlhA>
    <xmx:-a4fanxG5WSSDYiSi2ZRPmrB9dt3xNrvgEBMtlr251Cn3aZwDi4qel_f>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 00:35:05 -0400 (EDT)
Date: Tue, 2 Jun 2026 21:34:40 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: fix false IO failure after falling back to
 buffered write
Message-ID: <20260603043440.GB2114331@zen.localdomain>
References: <cover.1780112003.git.wqu@suse.com>
 <474cf1bf278e4ec1fd66b90aa6eeb5603ae08cd4.1780112003.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474cf1bf278e4ec1fd66b90aa6eeb5603ae08cd4.1780112003.git.wqu@suse.com>

On Sat, May 30, 2026 at 01:04:17PM +0930, Qu Wenruo wrote:
> [BUG]
> The test case generic/362 will fail with "nodatasum" mount option (*):
> 
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:21:17.574771567 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +First write failed: Input/output error
>      Silence is golden
>     ...
> 
> *: If the test case has been executed before with default data checksum,
> the failure will not reproduce. Need the following fix to make it
> reliably reproducible:
> https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/
> 
> [CAUSE]
> Inside __iomap_dio_rw(), the -EFAULT/-ENOTBLK error is not directly returned.
> Thus we never got an error pointer from __iomap_dio_rw().
> 
> The call chain looks like this:
> 
>  btrfs_direct_write()
>  |- btrfs_dio_write()
>  |-  __iomap_dio_rw()
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_begin()
>  |  |     Now an ordered extent is allocated for the 4K write.
>  |  |
>  |  |- iomi.status = iomap_dio_iter()
>  |  |  Where iomap_dio_iter() returned -EFAULT.
>  |  |
>  |  |- ret = iomap_iter()
>  |  |  |- btrfs_dio_iomap_end()
>  |  |  |  |- btrfs_finish_ordered_extent(uptodate = false)
>  |  |  |  |  |- can_finish_ordered_extent()
>  |  |  |  |     |- btrfs_mark_ordered_extent_error()
>  |  |  |  |        |- mapping_set_error()
>  |  |  |  |           Now the address space is marked error.
>  |  |  |  | return -ENOTBLK
>  |  |  |- return -ENOTBLK
>  |  |- if (ret == -ENOTBLK) { ret = 0; }
>  |     Now the return value is reset to 0.
>  |     Thus no error pointer will be returned.
>  |
>  |- ret = iomap_dio_complete()
>  |  Since no byte is submitted, @ret is 0.
>  |
>  |- Fallback to buffered IO
>  |  And the buffered write finished without error
>  |
>  |- filemap_fdatawait_range()
>     |- filemap_check_errors()
>        The previous error is recorded, thus an error is returned
> 
> However the buffered write is properly submitted and finished, the error
> is from the btrfs_finish_ordered_extent() call with @uptodate = false.
> 
> [FIX]
> When a short dio write happened, any range that is submitted will have
> btrfs_extract_ordered_extent() to be called, thus the submitted range
> will always have an OE just covering the submitted range.
> 
> The remaining OE range is never submitted, thus they should be treated
> as truncated, not an error. So that we can properly reclaim and not
> insert an unnecessary file extent item, without marking the mapping as
> error.
> 
> Extract a helper, btrfs_mark_ordered_extent_truncated(), and utilize
> that helper to mark the direct IO ordered extent as truncated, so it
> won't cause failure for the later buffered fallback.
> 
> [REASON FOR NO FIXES TAG]
> The bug itself is pretty old, at commit f85781fb505e ("btrfs: switch to
> iomap for direct IO") we're already passing @uptodate=false finishing
> the OE.
> But at that time OE with IOERR won't call mapping_set_error(), so it's
> not exposed.
> Later commit d61bec08b904 ("btrfs: mark ordered extent and inode with
> error if we fail to finish") finally exposed the bug, but that commit
> is doing a correct job, not the root cause.
> 
> Anyway the bug is very old, dating back to 5.1x days, thus only CC to
> stable.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/direct-io.c    | 17 ++++++++++++++---
>  fs/btrfs/inode.c        |  6 +-----
>  fs/btrfs/ordered-data.c | 12 ++++++++++++
>  fs/btrfs/ordered-data.h |  2 ++
>  4 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56dc72..88cb2e82a507 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -624,12 +624,23 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>  	if (submitted < length) {
>  		pos += submitted;
>  		length -= submitted;
> -		if (write)
> +		if (write) {
> +			/*
> +			 * We have a short write, if there is any range
> +			 * that is submitted properly, that part will have
> +			 * its own OE split from the original one.
> +			 *
> +			 * So for the OE at dio_data->ordered, it's the part
> +			 * that is not submitted, and should be marked
> +			 * as fully truncated.
> +			 */
> +			btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
>  			btrfs_finish_ordered_extent(dio_data->ordered,
> -						    pos, length, false);
> -		else
> +						    pos, length, true);
> +		} else {
>  			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
>  						pos + length - 1, NULL);
> +		}
>  		ret = -ENOTBLK;
>  	}
>  	if (write) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 973a89301baa..2c0131452754 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7590,11 +7590,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
>  					       EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
>  					       EXTENT_DEFRAG, &cached_state);
>  
> -		spin_lock(&inode->ordered_tree_lock);
> -		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> -		ordered->truncated_len = min(ordered->truncated_len,
> -					     cur - ordered->file_offset);
> -		spin_unlock(&inode->ordered_tree_lock);
> +		btrfs_mark_ordered_extent_truncated(ordered, cur - ordered->file_offset);
>  
>  		/*
>  		 * If the ordered extent has finished, we're safe to delete all
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index f5f77c33cf59..b32d4eabe0ab 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -358,6 +358,18 @@ void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered)
>  		mapping_set_error(ordered->inode->vfs_inode.i_mapping, -EIO);
>  }
>  
> +void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
> +					 u64 truncate_len)
> +{
> +	struct btrfs_inode *inode = ordered->inode;
> +
> +	ASSERT(truncate_len <= ordered->num_bytes);
> +	spin_lock(&inode->ordered_tree_lock);
> +	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> +	ordered->truncated_len = min(ordered->truncated_len, truncate_len);
> +	spin_unlock(&inode->ordered_tree_lock);
> +}
> +
>  static void finish_ordered_fn(struct btrfs_work *work)
>  {
>  	struct btrfs_ordered_extent *ordered_extent;
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 03e12380a2fd..8d5d5ba1e02f 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -226,6 +226,8 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
>  struct btrfs_ordered_extent *btrfs_split_ordered_extent(
>  			struct btrfs_ordered_extent *ordered, u64 len);
>  void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
> +void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
> +					 u64 truncate_len);
>  int __init ordered_data_init(void);
>  void __cold ordered_data_exit(void);
>  
> -- 
> 2.54.0
> 
