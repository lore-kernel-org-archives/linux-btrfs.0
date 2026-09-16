Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE04B1CF8
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 23:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599878; cv=none; b=P7Md/7+B2t+4tC8RWEoXpAX8OBJlUSbOD5WlL1t4DK1J2VASnVLqChXYJF7Ynmp7VpGMFkqKwdnV9zBKzmLAjGdZFr0pbPUpmMNSI0mE8BxVh6UMOaCg7utU6XYub8jS4uT8znwdhHlrlNTuI6tuHHfUe9OfwAPZFNngczMfx98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599878; c=relaxed/simple;
	bh=X6fgyF8xoFOS+kbr9JHbDWB0/dFakCC33KLrxMM1EEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSn1bqQNUlsr/E//EdrPgeXYczukfXCoTiyE7oyW+UBlk0BT8jQLxmHu/Vxa4r7avlHasUE5+HZoOLMbJ42mywjRa4EPSKvdxdFnRqx3/TvFsgIWfAXr9/5geQz8trU0KTI/kwBApLxZNbb0Ox+5qmgQa82NUz1kVdOH4cw36vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=tZrr8kW+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RjJNJMeo; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="tZrr8kW+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RjJNJMeo"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C905414000F2;
	Wed, 16 Sep 2026 19:04:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 16 Sep 2026 19:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789599872;
	 x=1789686272; bh=MaWqERoMoVCpY3Gj1FmmInBFbCaDr3tYl2W8fKjORmY=; b=
	tZrr8kW+qEotrnHGdI7C9VC5aJ4imYYm1K7pJoOAGiV7Lp/w63xlGWNgar5LkZBK
	VZ5vvpomO42IV8MFP+dtSj5Dw5jKCVjGhob8m/m0N/42MDUsiKnrqmK6KIj7GXrV
	w01b9tg5pRHgIH19pyc/8LKtYhq9Qv4QJRQGAFogeaxlv0zb1wrs8uIO+U244LF7
	7NUuYf1LBhsvOE0cBA41qqF7YbvjX2yLonNQC3euer0XGKBQ0Rts1OILjE6zzU/Q
	gLFa0aezpEXn2B6whzjBIj/0Bc99lIg4UEUwDeyV/jRht5VkYNRMdb8mJog1PpR3
	QY0+6EtRKtr/3IGEPUis6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789599872; x=
	1789686272; bh=MaWqERoMoVCpY3Gj1FmmInBFbCaDr3tYl2W8fKjORmY=; b=R
	jJNJMeouH4HVMY3xlmV1ols0rgkbstQsgpWOSXjyFa4IwvFb9S9cVorxn8bwNuCt
	H8jDfTa7s/x/M7kRdGrA/AmfcGxihPxgEC/H+NP1eB1sD3IrP2RdxCh35oziHVbH
	3WuqYcRDjlT3ZG/bxGpHSAJsV32SRrMlQpQbDvMGdoNL9ZA6SDiPfYm8EJU5HBmQ
	DY8n5wAdxOxCJWfOesdhvHjoFYrvHDJisihrC0BuItIg091DmOjnPd/VCJr1Q1pX
	/2YB6/vph5FMpCDua9EfGVkcJ4DlepLlZrPyoROj3REGhhhFiFgSTchSCZmA5CfW
	RaUnaf+RugaDA1vRhC9hw==
X-ME-Sender: <xms:gCCrajLn4Lh_qBayPQqzxeY4HLYzk3rlKFKKElJtup4L5DFkl_EJVw>
    <xme:gCCraulTY_fqYSiV_yFGFSeEG9PMc6KYSk9Baqc3NNW3jUwLf8QDcX_1kaqCi929T
    AyMZorsEZLdKjwj2VzD0FS7EIWtM8RUbC4Ei9kqx8BwNqia6WiF9x8>
X-ME-Received: <xmr:gCCrapEY-C_rkF8c1wYkDusrYDKa7NnFquMAcbG2yGu3QVJIkT_r_vM>
X-ME-Proxy-Cause: dmFkZTFsCk0ySCnvynYGuxUaJKWt4fZaklAyintvFoXw2iZ5P3ZJ/bPSDARfTQX3YQJ4XW
    Ct/mRDWxDj9hdwyRDZVBPJSeQPnTrNyFTRsUmijmUH7Poj36WwmHgs5Mk3PJzde1l+IIOv
    iF7GiBaBcvCTh9zSZdmyhAm036JzxIiTCWyS6f4AimuiwRD5PqYiWHUrnr0IgdipILaSjn
    vRPn1t7UUW/Ma3wTD6VLxcBzCzPbiq5Hel9mg/GOgeH07FH2LCHWzw/o+473Pps5oyGJwh
    eLs9HEcJ3DfTGsZ4TLfG2NfLngTV2YNGJxLIuFVC4pY12pTgUhKCatO468BLa8eX+MPwVv
    JkW20B0pzX0ftLcspkNPUkmZJ4Cqxf5S8Kb+DL+c6V+wsh0hTuU9ZDtYP20FqC/h92/40B
    yCIlILjg+s+6oZXPm9WbHKu2R+ZRqnroYM2M45ZPLkIJ2dYr7Ozdv23pKEh73Ec4LbCVNn
    1KFGMP+hPeIo2F7r9EZ9SZ2/9IsKPplfz0+XaakyZUTRiroHHcdMiOUwZ2AlX8LD/S33nt
    lT73JJe5e8BU/3scphe18uYtTII9SVt2daMU2JB3I3ANNYMFgI6VueVKuR0csOygznqCCU
    cv5EpC8YzogTxwzJP81Xxp/QpU4Lu/YNWbq/RHQ9d+zqJbKfnPKF/ri/vA4A
X-ME-Proxy: <xmx:gCCramE_K587fZ2123dtVm0-8mR4GDwlEpcWplkY6OA8eojKJeBr8w>
    <xmx:gCCrauOdKJYXJWQ4YcJxQ4h2WvzFfEcJGft9rm4P--NOMNeFxQrvoQ>
    <xmx:gCCratGs-t5I4QNgNbT4YwRwL8cTahpbBh1brLvXcapF0A6zBlY8Xw>
    <xmx:gCCratNkfiRCet_r8t0OW6TdTIJqTiHGI3pskoWMI3XvXT9Q5PA0IA>
    <xmx:gCCranmTsU2gJLDW6MK3Xe2TKyKvDFra6jAwWeKtP8eVZsNd4KmGSCt4>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 19:04:32 -0400 (EDT)
Date: Wed, 16 Sep 2026 16:04:47 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: keep unused block groups queued when a pass fails
Message-ID: <20260916230447.GA1706558@zen.localdomain>
References: <455009bf67d45ccb8df8c2a0aec270a16db80510.1789597031.git.boris@bur.io>
 <04e6331d-6b7a-4a2f-9eca-8aa7f0e4042a@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04e6331d-6b7a-4a2f-9eca-8aa7f0e4042a@suse.com>

On Thu, Sep 17, 2026 at 08:21:37AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/9/17 07:47, Boris Burkov 写道:
> > Once any block_group sets ret!=0 in the main loop of
> > btrfs_delete_unused_bgs(), the check
> >    if (ret || btrfs_mixed_space_info(space_info)) {
> >            btrfs_put_block_group(block_group);
> >            continue;
> >    }
> > skips the rest of the unused bgs while unlinking them from
> > fs_info->unused_bgs. There is no "level triggered" re-queueing of empty
> > block groups onto fs_info->unused_bgs so it is possible to leak quite a
> > bit of space this way and unless we happen to get a balance or
> > re-use/re-empty one of these bgs, they are leaked for good, which can
> > lead to a spurious enospc later.
> > 
> > While I have observed such leaked blocked groups that are empty but not
> > on the unused_bgs list on production systems, I have not observed that
> > it is definitely due to this issue. I also reproduced this behavior by
> > injecting an ENOSPC error from btrfs_start_trans_remove_block_group
> > which can also fail with ENOMEM, so this feels like a legitimate
> > injection point.
> 
> Do have happen to know which error caused this non-zero @ret?

I do not have a trace or any other error log in dmesg to conclude where
it came from. I just have boxes with a lot of empty bgs not linked on
the unused list and inferred this mechanism.

> 
> I did a quick glance into the loop, it looks like it's not that easy to get
> a non-zero @ret:
> 
> - inc_block_group_ro() failure
>   @ret is reset to 0, so not this path.
> 
> - btrfs_zone_finish()
>   I guess meta is not deploying zoned btrfs in production.
> 
> - btrfs_star_trans_remove_block_group()
>   This can return -ENOSPC, especially considering we have just marked
>   one bg read-only, thus even stealing from global rsv, we may still
>   fail with ENOSPC here.

I suspect ENOSPC or ENOMEM from this one, personally. Agreed with the
rest of your points on the other possible error sites.

> 
>   Although I'd say, that means the inc_block_group_ro() checks are not
>   doing the correct reserved space checking, and that may be the real
>   problem.
> 
> - btrfs_remove_chunk()
>   If it failed, the trans is already aborted.
> 
> > 
> > To fix it, instead of checking ret in the loop, just break out of the
> > loop when ret != 0. Also, link the bg to the retry list at the
> > individual failure sites so that the failing bg is not leaked.
> > 
> > Assisted-by: LLM (reproducer/error injection)
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> Otherwise the handling looks correct to me, doing the proper handling on
> error, other than delaying it to the next iteration.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Thanks,
> Qu
> > ---
> >   fs/btrfs/block-group.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> > index ee182369254c..2eb09c9901c9 100644
> > --- a/fs/btrfs/block-group.c
> > +++ b/fs/btrfs/block-group.c
> > @@ -1612,7 +1612,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >   		space_info = block_group->space_info;
> > -		if (ret || btrfs_mixed_space_info(space_info)) {
> > +		if (btrfs_mixed_space_info(space_info)) {
> >   			btrfs_put_block_group(block_group);
> >   			continue;
> >   		}
> > @@ -1727,6 +1727,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >   		ret = inc_block_group_ro(block_group, false);
> >   		up_write(&space_info->groups_sem);
> >   		if (ret < 0) {
> > +			btrfs_link_bg_list(block_group, &retry_list);
> >   			ret = 0;
> >   			goto next;
> >   		}
> > @@ -1749,6 +1750,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >   						     block_group->start);
> >   		if (IS_ERR(trans)) {
> >   			btrfs_dec_block_group_ro(block_group);
> > +			btrfs_link_bg_list(block_group, &retry_list);
> >   			ret = PTR_ERR(trans);
> >   			goto next;
> >   		}
> > @@ -1759,6 +1761,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >   		 */
> >   		if (!clean_pinned_extents(trans, block_group)) {
> >   			btrfs_dec_block_group_ro(block_group);
> > +			btrfs_link_bg_list(block_group, &retry_list);
> >   			goto end_trans;
> >   		}
> > @@ -1845,6 +1848,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >   next:
> >   		btrfs_put_block_group(block_group);
> >   		spin_lock(&fs_info->unused_bgs_lock);
> > +		if (ret)
> > +			break;
> >   	}
> >   	list_splice_tail(&retry_list, &fs_info->unused_bgs);
> >   	spin_unlock(&fs_info->unused_bgs_lock);
> 
