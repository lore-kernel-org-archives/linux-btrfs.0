Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEDF30F81A;
	Wed,  3 Jun 2026 04:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780461288; cv=none; b=pZVKEtwr2/AiEqFgHsTEFyEPjf7AQiTZpUiYbpWbmors3dT64dkQSRLOcNZgPAM0H0drjlp3mR6hfxnQ80yGmnu5rEUZ4AsVnUJtXqmmXlYqZe8t7tZ0JpkFycx1/i6CJHtDjldQzZ2h4G8Is/IQaPMCktJRGOP4QG5h7U0mem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780461288; c=relaxed/simple;
	bh=JhQ4YvlGOtgE7YWu2N+AEzauIaeUBwJwL7LxJOv6yS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0GfiTJC8KSWThghCuFMqrI69dFzIi5xOwPawIjq0SPRdgWYeayvj+5qzoe6jH49cQryJt8XXZS2ZV8jU53TUWFgHunM6FZqVfWIdFG8kcPkCoG7qfDnOBMYRwaV7IG/lfTXCSJGUgBvLhDWccDe++PNIKVpsOvFCx4Nn7zdJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=b3RT8pNi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TjWuz8IA; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="b3RT8pNi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TjWuz8IA"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 9C4F21D000D3;
	Wed,  3 Jun 2026 00:34:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 03 Jun 2026 00:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1780461285; x=1780547685; bh=Hi2/RtH61Q
	HhSNVu4ZT5CPHNlkakWTVW/16Zfzm1sOk=; b=b3RT8pNi2UJLDBJCaBSgaQ7kl3
	wB1NQubqgg0T5KtwAxnnmjZSsBd2tmTq8+xx/SA28TQlY4euUwPJZqJUJ3sgrgF5
	qtjOZw4NB9Odbms5I41p2FP118nSgiFdNjQ5ymFicz+03A0lhLjnboUD/R2+tlSt
	4ctpDh5aL0EhUC/ySpBXZr6fRqeCqIBYj/chwmiycqqkHxberxw+oeHevAm3exdu
	hprKnj8sh5vWbMtysSrQZpZPHhZ5jdeWVwiT0yXqT0diah6Adm0hcsa5HsfNgSeX
	XZBTbnlx/EjHkoV8oFTBTMDOrmWceyDjpz/uCpnmNzItYaIZj0Mp/wo8GI3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780461285; x=1780547685; bh=Hi2/RtH61QHhSNVu4ZT5CPHNlkakWTVW/16
	Zfzm1sOk=; b=TjWuz8IANcTtpSDgHRh9mBQi4SW/khqmX35hnwfWOKGllx6eA+x
	4n8HBKN3G4eSAqx50+hT8+24AE/LtnJYbXL0FFVzOkMLHYL5MAwPGbo1ls89ag12
	WGIx1LVsDXR1TdsmPD9HWFmPrcdi10tYGJ6oUSFoADMu22JZAYc3oF4VhGuSZyEM
	wND4pSQ50AMkTYv+ackht6Tf5AdlpMs1mQrocWccuhJvMTT1K3Qmz3QCg6wxeYyO
	nlddkw3uGJ9OEqPuXmU3oOH8oVuS/jDRGtkbWuLwiOiqx4aCFsFw2AkAuTcsd0/p
	J8rju2JiKf5n2WOCqIFxy293PVg5N/kV9Xw==
X-ME-Sender: <xms:5a4fasO7pNyaccOJyIc5j_w5OlthXCeUYMUcXOp1Jx1327Br5q7VkQ>
    <xme:5a4faqunYw2bmO6dW7XgzWuvQV0-hBDyrUCl2XuSovhHJINytDqeoQIs9EhIttBuR
    pFSjslnDMdDPeGafkixTMKPe3pNKG50pZLoNzwixMV4bn-6lJJY5XM>
X-ME-Received: <xmr:5a4famWBF4IszVczTIkWGim4wwZ3XgP_IEHnE7ozwsD7BNkxkP6c6FrjVAn5yzHXwTc3FGQtbF0NGkksM3P8NXmFr6o>
X-ME-Proxy-Cause: dmFkZTEwGi6hBRiKGdWsO1pM/+GouOqpHgOwPzahjKpwQoO78TA0HPt9PLhqj9oYmIEQl6
    hd57+P/M2v/QU4yGVudFIn4OfnMVmD27F3HZ6RaNhV8Htrytnxym5Fa0wYW55vz70LZ9l4
    93Z8mV9kJckH6/oYrv2wm+Oio5XF/ZByRsydyTYF3kTctp//jAlXo1chu1l24xiq1SLHxv
    CRQPI5ajCuE5L0ZFODcPnrh5P1OnYEbJWQfH/eQQV7r6MGCeidmbRne8d/k/Tan6oEgYJP
    ZK3ZPc0JSQfbt/QjTrVM+c9H3eglOXZ7KcX8A2FwRs3T82CN/cbp8pA2rp9FNtDb+wzAly
    jRvbVXhswDVaHmqLHqmcYyXpxiOW21X0bpp16JZgV7UCQtMafMQSUK4nZYZ2GQL+Sd1sBb
    mZo5xZcqPK3EBwrdo2SmSUe4wp1/fc9gxocbAa3pR/+h/hA95UAeBJZaE9iFuMUd4iVAGs
    Yi3/splsSpkTKQFr555yMAAjuJ4mtJoPK+pGPwZxTdp2oriJckdr5KLsQwy937AXiJ/PGr
    v9LuxF3n9ZCn2CWJnkHOjW+tKgRZ52DqreSyuRT5zj2BR4WCS13srLqS0phYNgCpJceaLp
    nosJgUWsWwOAvepS7KraAnF9ZD4LH+0xxcSY5LG1eyZHzd86L8viGZxqn7EQ
X-ME-Proxy: <xmx:5a4faitX8GtoR_Psu3qbhIKdtdtX3Af2WA5gT0j_pKdyhoR6ebomFQ>
    <xmx:5a4faiXJHPdRRLskZdmgs1CveQ-kJoRW4U0aOAITgaUIKRSEwj2sCQ>
    <xmx:5a4falmjQ_sFL_j5HmBkChq7aPFJ45Ett2mRLCbsgD0FVvjVRK2hSg>
    <xmx:5a4faraQhPImx-u3igCI3Iq5r4-xaaobsCPGSJ5OsNGoNFW9nPT-Ag>
    <xmx:5a4fave81QCkmfca6QRbIOdjRLUM7uj9cvmns_5SEE0SfEvt4S_-CtZM>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 00:34:44 -0400 (EDT)
Date: Tue, 2 Jun 2026 21:34:15 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: fix incorrect buffered IO fallback for
 append direct writes
Message-ID: <20260603043415.GA2114331@zen.localdomain>
References: <cover.1780112003.git.wqu@suse.com>
 <8f3a0006edc5014c1de15b669f4d8c6d2aea3d61.1780112003.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f3a0006edc5014c1de15b669f4d8c6d2aea3d61.1780112003.git.wqu@suse.com>

On Sat, May 30, 2026 at 01:04:18PM +0930, Qu Wenruo wrote:
> [BUG]
> With the previous bug of short direct writes fixed, test case
> generic/362 (*) still fails with the following error with nodatasum
> mount option:
> 
>  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>  - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +Wrong file size after first write, got 8192 expected 4096
>      Silence is golden
>     ...
> 
> *: If the test case has been executed before with default data checksum,
> the failure will not reproduce. Need the following fix to make it
> reliably reproducible:
> https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/
> 
> [CAUSE]
> Inside btrfs_dio_iomap_begin() for a direct write, we increase the isize
> if it's beyond the current isize.
> 
> But if the direct io finished short , we do not revert the isize to the
> previous value nor to the short write end.
> 
> Then if we need to fall back to buffered writes, and the write has
> IOCB_APPEND flag, then the buffered write will be positioned at the
> incorrect isize.
> 
> The call chain looks like this:
> 
>  btrfs_direct_write(pos=0, length=4K)
>  |- __iomap_dio_rw()
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_begin()
>  |  |     |- btrfs_get_blocks_direct_write()
>  |  |        |- i_size_write()
>  |  |           Which updates the isize to the write end (4K).
>  |  |
>  |  |- iomap_dio_iter()
>  |  |  Failed with -EFAULT on the first page.
>  |  |
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_end()
>  |  |     Detects a short write, return -ENOTBLK
>  |  |- if (ret == -ENOTBLK) { ret = 0;}
>  |     Which resets the return value.
>  |
>  |- ret = iomap_dio_complet()
>  |  Which returns 0.
>  |
>  |- btrfs_buffered_write(iocb, from);
>     |- generic_write_checks()
>        |- iocb->ki_pos = i_size_read()
>           Which is still the new size (4K), other than the original
> 	  isize 0.
> 

The explanation is very clear, so thank you for that. I agree with the
bug and the direction of the fix.

However, I fear that there could still be a smaller bug left.

You have reasoned out a race against buffered writes, and the invalid
i_size you are fixing up only exists inside the dio thread holding the
inode lock, so the buffered write does not see it before you get to
fixup i_size. However, after we set the invalid i_size we release the
extent lock, so I believe a buffered reader could now observe the
intermediate too-big i_size before you manage to fix it.

I believe that the consequence of this is that reader will block on the
OE, then the split half will be finished/truncated, but the reader could
still see the too-big i_size and get back zeroes. I am not completely sure
if this is for sure a bug, but it does feel like it could be wrong.

For what it's worth, there is a comment at the i_size_write() in
btrfs_get_blocks_direct_write() which also confirms that it is important
that the update is done under the extent lock, not just the inode lock.

If it is, in fact, safe, then clarifying that in the existing comment
and/or a new comment would be helpful, I think. The comment is from 2012:
c3473e830074 ("Btrfs: fix dio write vs buffered read race")
so I suspect some of the original reasoning may now be out of date..

Thanks,
Boris

> [FIX]
> Introduce btrfs_dio_data::updated_isize and btrfs_dio_data::old_isize,
> so that if btrfs_get_blocks_direct_write() enlarged the inode size for
> the first time, we still know the old isize.
> 
> Then if we got a short write, and btrfs_dio_data::updated_isize is set,
> revert to the correct isize based on the old isize and the short write
> end.
> 
> [REASON FOR NO FIXES TAG]
> The bug is again very old, before commit f85781fb505e ("btrfs: switch to
> iomap for direct IO") we are already increasing isize without a
> proper rollback for short writes.
> 
> Thus only a CC to stable.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/direct-io.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 88cb2e82a507..fd53fac7186e 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -15,10 +15,16 @@
>  
>  struct btrfs_dio_data {
>  	ssize_t submitted;
> +	/*
> +	 * If we got a short dio write and @updated_isize is set,
> +	 * revert to the old isize.
> +	 */
> +	loff_t old_isize;
>  	struct extent_changeset *data_reserved;
>  	struct btrfs_ordered_extent *ordered;
>  	bool data_space_reserved;
>  	bool nocow_done;
> +	bool updated_isize;
>  };
>  
>  struct btrfs_dio_private {
> @@ -228,6 +234,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>  	bool space_reserved = false;
>  	u64 len = *lenp;
>  	u64 prev_len;
> +	loff_t old_isize;
>  	int ret = 0;
>  
>  	/*
> @@ -341,8 +348,14 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>  	 * Need to update the i_size under the extent lock so buffered
>  	 * readers will get the updated i_size when we unlock.
>  	 */
> -	if (start + len > i_size_read(inode))
> +	old_isize = i_size_read(inode);
> +	if (start + len > old_isize) {
> +		if (!dio_data->updated_isize) {
> +			dio_data->old_isize = old_isize;
> +			dio_data->updated_isize = true;
> +		}
>  		i_size_write(inode, start + len);
> +	}
>  out:
>  	if (ret && space_reserved) {
>  		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
> @@ -637,6 +650,16 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>  			btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
>  			btrfs_finish_ordered_extent(dio_data->ordered,
>  						    pos, length, true);
> +			if (dio_data->updated_isize) {
> +				u64 new_isize;
> +
> +				if (submitted == 0)
> +					new_isize = dio_data->old_isize;
> +				else
> +					new_isize = max(pos, dio_data->old_isize);
> +				i_size_write(inode, new_isize);
> +				dio_data->updated_isize = false;
> +			}
>  		} else {
>  			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
>  						pos + length - 1, NULL);
> -- 
> 2.54.0
> 
