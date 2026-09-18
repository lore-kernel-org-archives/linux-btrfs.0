Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41F5208B6
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789757906; cv=none; b=V+YJZB3J7zaMEndcXaXtbZCm7oByh+jDjRvhjS5KIXOABQxN8rizx6v9dfStjUgCpNMlmpqb9Egd8+Obdbnq3QjVvGGgA6rgfi1qRFAQ8hXdYlSyF5FbC39rOVUKA1qK4XR9zV1UpJ3EeVnncd2v1jt0rsTsckxEhvbskM0m1qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789757906; c=relaxed/simple;
	bh=mlq2TQLpSGdC2gY1qUtbxCw546/9XglpIS03uke9tok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbXtO0vBphntJP1FRqv/Aq0OQQH78hFm45wpDtuwU/IFQyxmzZ5AH5D3hsBxGqFy0mJo8M0JqNmg0A+PX2A3HROLQby6sufP4FVtlkNg34GoSEBxan8T7YKiy/t1H9D8aKZnF7BeeNtu1HMCjhMso5X1XrFMcbYrMqRPGOfc8HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=gqz8Rd1D; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XIZmraEz; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="gqz8Rd1D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XIZmraEz"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 533A81D0007E;
	Fri, 18 Sep 2026 14:58:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 18 Sep 2026 14:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789757896;
	 x=1789844296; bh=HtP9ci91AlqecswUC0WZH//cc0RilGdMh4yE6nYGDQ8=; b=
	gqz8Rd1Dkqpqi99RLEuCz1EVJ3TKgzIjZwGATW6AtZz3v9luxWbyj+k1Y/UK0dX+
	aKU2NunTpzl+Mwz3hSeY0vzzhWA1RCv9Tx9/38gL7KLN65WALICLkDVKyZb8gkEW
	L+hyJi1EniZ1Fkj3SpwTIGJcBEGv6C7/pW/xurYCcz5DSA0fHkl2hxtAnLxnEPhZ
	W2UjsTph+W67JEB5QUXiP4ex3mED4iu0XgIambfXdVHeZFw2YIsEA/zmHEi7TIZb
	tDb1h4+De8q/MwiDTSQ6AqzhCcesgy/Nx+hgF01R7RZ/AUxPx85wx8DBZbIcgYdX
	ZjkLOQIDUO+hUCtYzZapbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789757896; x=
	1789844296; bh=HtP9ci91AlqecswUC0WZH//cc0RilGdMh4yE6nYGDQ8=; b=X
	IZmraEzcIig8zfNzYhiuwUuMH3xcNTzKeA5ILRtwRUYveaJTF4UAAcjqQb2LUR00
	fkD4YO4KQG0hvCiC1JxR+b7cI1/dI6UVvUCp1wyqjS31nHTGNqUQtAkuxacpVy+v
	6g41cmP3OSBv4PyNGxyMtnXl9uBRMJBugbLJiUkG6tniH4Ve+NOndHO+Z4bWwQW4
	5uJyyT2bAOy8SrWj6dTHb928/B67R+To8V/AqN5YKgB7pdvdKsnIUood05MJR8/B
	TA8InxMrCtfDUCzhcapg3dO1G3/1P7uhha04cBsc98SFgjyZ3qF0nDQzD0sFTJus
	TiPWRMCQzqhMKC2JYGJrw==
X-ME-Sender: <xms:x4mtasspVGo8pITHVkoxOcMLD2aCfIWHl4KfqmSOUevVWecBBkCf_A>
    <xme:x4mtavfMGU1JEYF7hos3XPizGee9IWfX7tUv5f7xIx1Zea2S5qJcompzneT1sN7vI
    kDqhFAtW2K_s1gHm3Fl7M8t86IQ1P4UflWrakr9CGtVhAr_6mhqPSNO>
X-ME-Received: <xmr:x4mtalYlH1ziRGcbUpNwZ8zx2rwQDkiuTkImjlefOz-uMTPPSg0Emqs>
X-ME-Proxy-Cause: dmFkZTGl+i7zZQrGWWBnfV1i8xpgJCIqSx9mCG8f49udN8QqER2XazEjEKIOjXTYyLkktm
    lO6/76nCklLSvXdbwVOQKzndXjKfxmo6qgMi5q7+VJmFWeWFZH/PurEVf+kur5+E1kDKel
    Oj6vLLyPHiHFs/TFLTFLv2dJJHOq6GrDWbniZSfKcaaphpmfHqDNe1yzqlfIZmxPz1Iwm8
    O8WOGmrgVeqRQ6j9pO1cBS9irpwn1Ge440pDninxGqSMXnYQzQ5lU7ez53feWKSzw4J6oW
    YrIS6EgrFk7y36OGRi+2W46LRhRMGxT+dI2Lbkv/yjWmBN37pNk+QJYvtGK20RrDT8+Iiw
    u8RczLCERkvNZm3XKkb0KBt8xFCiZ83zTAFAdYpHjwsUsFtSBdM0FNiZURLLsHXiSIFwu6
    0qXLXJiqbJkhux0/vOzYxAmry+QMYUVnnro8leQHGXQ/fWsjlMU9Qm+HCS5fYckvQVCzoW
    /Ogsjlo4TUpxQq3KYHsXtrK2HhQWzIRrv2hnUmRXk+6L1P6kj2j/qeRjgJOe8mzCxPSHNK
    kNpm4Oj8PzhIxa+vBeCRLTrJ/n+9ZoXixMnHm4hdM9FxQObHg2o13nxNY2wBEbS6y5N60G
    uaxIOnqS3o0V4SpYhS6Suzp7/L3bcid1bwwmO915Die1sqNE+V9bp3USItYQ
X-ME-Proxy: <xmx:x4mtaqVy8FswgY9ZmJvd_rpgtlRj0pi8jvL3OAOAH6-jqpKDpKBCFg>
    <xmx:x4mtaviLQ9yP5PFUZckUftj2X4__KWuz6b1mOEnQmiRQs-cIigSe1g>
    <xmx:x4mtagVUuy7CM2uKC2vyfcdPfhudYm_mOyf-hrc1v9AjdbPcIa1bMg>
    <xmx:x4mtauP2b9n3OOpa0Fzaq54vHSPjTaAwmLw6fT1meyBxx078K3CESw>
    <xmx:yImtaoCR2SCoTaHKaK2DhvPUJ_GS_VSQHocZpPHgbOdurtBw6QMijRBu>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 14:58:15 -0400 (EDT)
Date: Fri, 18 Sep 2026 11:58:27 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: fix barrier usage in
 btrfs_record_root_in_trans()
Message-ID: <20260918185827.GA2934910@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
 <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
 <20260918173655.GC2900089@zen.localdomain>
 <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>
 <20260918174718.GA2923381@zen.localdomain>
 <CAL3q7H667csOQydtbgyqnSmrFDkNLbdBwz+9N2mt8tWd5MfbvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H667csOQydtbgyqnSmrFDkNLbdBwz+9N2mt8tWd5MfbvQ@mail.gmail.com>

On Fri, Sep 18, 2026 at 07:05:24PM +0100, Filipe Manana wrote:
> On Fri, Sep 18, 2026 at 6:47 PM Boris Burkov <boris@bur.io> wrote:
> >
> > On Fri, Sep 18, 2026 at 06:43:54PM +0100, Filipe Manana wrote:
> > > On Fri, Sep 18, 2026 at 6:36 PM Boris Burkov <boris@bur.io> wrote:
> > > >
> > > > On Fri, Sep 18, 2026 at 01:28:10PM +0100, fdmanana@kernel.org wrote:
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > The barrier usage in btrfs_record_root_in_trans() is wrong, as the writer
> > > > > side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, does a
> > > > > write barrier and then sets the root's last transaction. This means the
> > > > > reader side must check the root's last transaction, issue a read barrier
> > > > > and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we issue
> > > > > a read barrier and then check the root's last transaction and the bit
> > > > > BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU is
> > > > > free to reorder the checks and the following can happen:
> > > > >
> > > > > 1) Before reading the root's last_trans, it checks that
> > > > >    BTRFS_ROOT_IN_TRANS_SETUP is not set.
> > > > >
> > > > > 2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and updates
> > > > >    the root's last_trans.
> > > > >
> > > > > 3) The reader then sees the root's last_trans matches the current
> > > > >    transaction and falsely concludes the root setup is completes and
> > > > >    returns without waiting for the writer task to complete the setup
> > > > >    (calling btrfs_init_reloc_root()).
> > > > >
> > > > > So fix the reading ordered as previously described: check the root's
> > > > > last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_SETUP
> > > > > (the reverse of what the writer side does).
> > > >
> > > > I think a comment on why we can't use release/acquire (u64) but that the
> > > > non-atomicity is ok (we only check equality?) might be nice. Otherwise
> > > > we are supposed to have some code like i_size_read(), right?
> > > >
> > > > Not blocking at all, just an observation, since those helpers are
> > > > supposed to prevent this kind of bug.
> > >
> > > I'm not sure what you mean. If you are mentioning the helpers for
> > > last_trans use READ/WRITE_ONCE and that that prevents the bug being
> > > fixed here, then that is not correct, because READ/WRITE_ONCE does not
> > > prevent a CPU from reordering intructions (just compiler level
> > > reordering, load/store tearing and a few other things).
> > >
> > >
> >
> > Sorry for being unclear. No, what I mean is I think we should
> > justify/document why we are not using smp_store_release/smp_load_acquire
> > since those are exactly this pattern, and if we had used them, it would
> > have prevented the bug.
> 
> It should work, but I don't see an advantage of one method over the
> other (perhaps smp_store_release and and_load_acquire are a bit easier
> to read for some).
> 
> I have no idea why that code (really old now) was written using smp_wmb/rmb.
> Perhaps the macros for smp_store_release and and_load_acquire did not
> exist back then, and that explains why we don't use them anywhere in
> btrfs and always use smp_wmb/rmb.
> 
> 

OK, all good. Thanks for the discussion and the fix, and you don't need
to bother with any additional justification or explanation.

> >
> > > >
> > > > >
> > > > > Assisted-by: LLM
> > > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > > ---
> > > > >  fs/btrfs/transaction.c | 9 +++++----
> > > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > > > index c1555621ae4e..13203ea9e116 100644
> > > > > --- a/fs/btrfs/transaction.c
> > > > > +++ b/fs/btrfs/transaction.c
> > > > > @@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
> > > > >        * see record_root_in_trans for comments about IN_TRANS_SETUP usage
> > > > >        * and barriers
> > > > >        */
> > > > > -     smp_rmb();
> > > > > -     if (btrfs_get_root_last_trans(root) == trans->transid &&
> > > > > -         !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > > > > -             return 0;
> > > > > +     if (btrfs_get_root_last_trans(root) == trans->transid) {
> > > > > +             smp_rmb();
> > > > > +             if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > > > > +                     return 0;
> > > > > +     }
> > > > >
> > > > >       mutex_lock(&fs_info->reloc_mutex);
> > > > >       ret = record_root_in_trans(trans, root, false);
> > > > > --
> > > > > 2.47.2
> > > > >
