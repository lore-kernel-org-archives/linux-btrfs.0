Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC094BEE26
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 21:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789163496; cv=none; b=crTYCiVFUgIiJbv9TZTqlbAhdGjFw5/L0rKdwANDwlQXLhS4drXCY9uAU1T3e+bZhQgW6jy8UR6n3SJkGGwIniNqxZuj1HhszIkndxohRRgNehBSRLv98ft67g7gJHxLBxCTztxqp2Ua3po+PxX/0BiZKxoLSuM2PJkVHaZR5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789163496; c=relaxed/simple;
	bh=3zvm05W88IJ+vbu85OW+C71C2kh1HvmoVHflQ+cfSF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBn5XNLMhZPufSc3w2HADKL1fMN9az+ctDJAh3gAitB0Eqyk3J5DWu9ioQIdqsEaQbDFR4RIq1W3Ipu3v3DFf+1oqSn6Cjz6ObAvgnDaPaP3qaep4qNTzxFeQT/FUbibaSqZi2Wokl+rFHeEA1E651iHh1ECjsnVGQTBftgZuuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=L+lHjL0u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wy89Tj/U; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="L+lHjL0u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wy89Tj/U"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id DF3721D00085;
	Fri, 11 Sep 2026 17:51:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 11 Sep 2026 17:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789163493;
	 x=1789249893; bh=YQ8ZKGGG1yPGDtBYMLqqinpj48h0lYjXTB5I5Dxz7i4=; b=
	L+lHjL0uqgYJwjenAq5Wa8Ufe65kY0YqwgfON95F8XoPcAskvsbfBB+zxm6ybWeB
	L2R5p5SR5sqQQpUeVnkvb1uW+zL5TDI4/PkXh3qMngp0rvqWLlKxVI9xLHRsrp3/
	rhV22HMYvkfP3k0N70HBYxahtzU7Q2/j4JSRQmAPyNU5atVRMtr6GjVc2pZOxGfd
	P2SzsowGsJgfTS+bM24lse8nTos1VTtLPc8zPYQ7Q3CofYtQwU7OkksCUqOs36Mu
	IXxIs8PTo5pGzz8E2zz6wj9ToyJyoXK1wdy2z9rn7D0ixVa1bqA4oyQDx0+e/pjR
	2sguVY1sFd769M76kz2Eng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789163493; x=
	1789249893; bh=YQ8ZKGGG1yPGDtBYMLqqinpj48h0lYjXTB5I5Dxz7i4=; b=w
	y89Tj/UUpWBJli1F4CyVz8HV+riAs92UMnyIKas5si28qGMULXXDMrxTSa4vJs+2
	EOnvI89xupBWTUxqqD8G7Fb99h9fqlQIt+Xz+y3tMBqDnDelgVvTaRzD7Ij+BTky
	NlbrLL1VxRwjYc647qBHT/XSifgsBO2ldRreQvaOtqMDGdVH/gYS6P32pTt7gp9f
	jhkhgnUNWFP12MXS6l5uwiIS3DzDvd07I1v1dctct82VaDY0QOeaPh6qQKqm7eWc
	dXG/OnI/z/uH862cIob5UhZSbblSYag5pHL+V5PXXhYKJytMbycZ8hq5edMfxh7x
	5TROjo6EuXEs962l7Cqsg==
X-ME-Sender: <xms:5XekarSQOPEugRqenb9XOphHcefBrfN_qh99YqncloJ8Fr8RnKl8ZA>
    <xme:5XekakNM2bb5zt2J3kTB-whxUrAdUKDkh5oDRjb8MJa6MEc1ajdpVGlsVSAcxXL-V
    9s1k0ddAmg0E86l8cBdIGYWlvVSxjpGxM46XKskOgYdQkPKZ0JqoA>
X-ME-Received: <xmr:5XekauOyS7HMTs_mYhcjIFbTLBv5_bMmpqCwMG4n8BL9vBGaLWsrtwg>
X-ME-Proxy-Cause: dmFkZTFsDjOgD3isLubTEDYQ7ep8PxASTaIqV9wfJHeHlh/I+SG4mfWFNZMKPa6FSKNKLf
    kzlx/iNXFvU8TSWvqMR3a4ovufJ11gA9Q8Wkd8BIdVZDKMV0BaCnqW6iF4aJx8M00tti4f
    +Z5U9YDrfIgJJ0887OX/zl7LS9atRU03KPpxa0+UV7O0C4czkgNjxL6oJw18QxUXnmPjxJ
    AO+OjerXXoZauJqKON09jA/8XzLvnLYwwKyE9ak7knhVpiOmHyvNGBojTT8ny7Shx0USpL
    C49AA4HJx37DjlyEe73XrogqLEitfDTKVNAlIy17YPwUJV7bAr28ntCJSxOw5lNs9zaHkG
    j1Onh+033ecYayC1TpS4+XDWOYOTA+JjMJsxzzZWN0Oa0B6oQ3x7pn5PS/wIXb0NOejAks
    dYk0OtPiIiebakcd38Vumfa5/0kWZm3EOftLfbZKEFdb7sNcV5NYsXoXamyRBNb5dtQX5M
    7uqXGWVdvx50/pwVtv2uDHZk+qfjEiXifU4zyEryxPi2eRDvOk0vSxx8MrWrq1cTJ/jlyO
    JyLfku89iRQigWx1GOXKo6v9fxO4RSuTqGxKwbvWstw+R+N+pBHQdUBK/TgS9oScQKkmnh
    gXi3b6x+6uyCzFB3QW3GAZTmFV9OeaL5xpTrKdjvBUdnWto7Vamzsh2037ig
X-ME-Proxy: <xmx:5XekakugASwpQvHaZeTUQxhltRdd5J2XOMcv-7ztODY_c3zAw9-Dkg>
    <xmx:5XekaoUdOmwt88LsoNWHoygfQNAjSu2f3ChdTMdhGvqrNetpoXBoXA>
    <xmx:5XekasuQceLAqNTMdD8mvYL6aqIPqb8CKSbd_Pfrn61ox7IQ5MrXIw>
    <xmx:5XekakUSaGWxjinnDIQpo0cZnwVuHcGyHSUe5t0fb5px2KEbsRwlpg>
    <xmx:5XekatteQ3S147ZXBHoYfnKfidMDL4uCKQO95oiJTeEoKgB9MLaDCtxS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Sep 2026 17:51:33 -0400 (EDT)
Date: Fri, 11 Sep 2026 14:51:53 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 1/3] btrfs: pre-flush reflink source before taking
 inode locks
Message-ID: <20260911215153.GA2375744@zen.localdomain>
References: <cover.1789085863.git.boris@bur.io>
 <4ef5a4ea85bf903e058b0a8c88549e15745729c0.1789085863.git.boris@bur.io>
 <CAL3q7H7_JXnHXZrBGpdK55CQtxiTA6H7KN0yemUirNU6RdNwPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7_JXnHXZrBGpdK55CQtxiTA6H7KN0yemUirNU6RdNwPA@mail.gmail.com>

On Fri, Sep 11, 2026 at 10:17:27AM +0100, Filipe Manana wrote:
> On Fri, Sep 11, 2026 at 1:39 AM Boris Burkov <boris@bur.io> wrote:
> >
> > Consider the following sketch of a shell script:
> >   dd if=/dev/urandom of=/mnt/src bs=1M count=4096
> >   cp --reflink=always /mnt/src /mnt/dst &
> >   sleep 0.1   # let the clone reach its flush
> >   time dd if=/mnt/src of=/dev/null bs=4K count=1 iflag=direct
> >
> > The current logic in reflink ensures the existence and stability of both
> > the src and destination inode by locking them both and then flushing all
> > dirty pages / ordered_extents under the inode lock. This blocks
> > concurrent usage by even readers of the inode locks, like direct reads
> > or seeks for the duration of writeback on the entirety of the two files.
> >
> > We observe this particular contention frequently in the Meta fleet.
> >
> > It is also a relatively common pattern to write the src file, then reflink
> > it while it is still dirty, so that typical path naturally hits this
> > contention. This workload motivates a relatively simple optimization:
> > trigger the unavoidable src flushing outside the locked region.
> >
> > It is tempting to try to move the writeback out of the locks entirely
> > but this is fraught with all kinds of consistency errors under various
> > patterns of concurrent writes. fsync is able to manage such a pattern,
> > but with significant infrastructure investment I don't think is
> > justified for reflink.
> >
> > Therefore, do an optimistic single backwards pass which completes latent
> > OEs while relying on the calls to btrfs_wait_ordered_range() under the
> > locks in btrfs_remap_file_range_prep() ensure correctness. In the worst
> > case with concurrent writes while unlocked, we can end up doing the
> > writeback twice, which I think is a reasonable price to pay to avoid
> > victimizing innocent readers in a common case.
> >
> > With and without this patch, the above reproducer runs the reflink in
> > the same ~0.5s on my system. Without the patch, the direct read blocks
> > for basically the full duration of the reflink while with the patch it
> > returns in a few milliseconds.
> >
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/reflink.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> >
> > diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> > index d2a4101912bd..7bab391f1be4 100644
> > --- a/fs/btrfs/reflink.c
> > +++ b/fs/btrfs/reflink.c
> > @@ -923,6 +923,46 @@ static bool file_sync_write(const struct file *file)
> >         return false;
> >  }
> >
> > +/*
> > + * Do a single backwards pass waiting for ordered extents on the inode.
> > + *
> > + * Backwards is helpful because it avoids picking up concurrent appended OEs
> > + * and the intent of the function is to wait on pre-existing OEs without going
> > + * to the extreme of locking the ordered_tree and snapshotting its contents.
> > + *
> > + * This is only useful as an optimization for waiting for ordered extents outside
> > + * locks. It DOES NOT ensure that the range is free of ordered extents.
> > + *
> > + * Returns -EIO if any waited on OE had the ORDERED_IOERR bit set and 0 otherwise.
> > + */
> > +static int wait_existing_ordered_extents(struct btrfs_inode *inode)
> > +{
> > +       u64 orig_end = i_size_read(&inode->vfs_inode);
> > +       u64 end = orig_end;
> 
> What's the point of orig_end if it's not used elsehwere?
> Just this:
> 
> u64 end = i_size_read(&inode->vfs_inode);
> 
> 
> > +       int ret = 0;
> > +
> > +       while (true) {
> > +               struct btrfs_ordered_extent *ordered;
> > +
> > +               ordered = btrfs_lookup_first_ordered_extent(inode, end);
> > +               if (!ordered)
> > +                       break;
> > +               if (ordered->file_offset > end) {
> > +                       btrfs_put_ordered_extent(ordered);
> > +                       break;
> > +               }
> > +               btrfs_start_ordered_extent(ordered);
> > +               end = ordered->file_offset;
> > +               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
> > +                       ret = -EIO;
> > +               btrfs_put_ordered_extent(ordered);
> > +               if (!end)
> > +                       break;
> > +               end--;
> > +       }
> > +       return ret;
> 
> Why do we need another function to wait for ordered extents just for reflinks?
> 
> We have btrfs_wait_ordered_range() that does exactly the same...
> 
> Besides that, this waits for all ordered extents. If a reflink
> operates on a small range, we end up waiting for any ordered extents,
> which slows down such ranged reflinks.
> btrfs_wait_ordered_range() allows to pass a range.
> 

TL;DR you are right

I started with btrfs_wait_ordered_range() then got turned around while
exploring the space and ended here which turns out to not be any better.
Thanks for pushing back.

Basically I was battling against cases related to the one helped by the
second patch (concurrent writers producing dirtying which causes write
amplification with the duplicate flush outside the locks) and tried to
create a "lightest weight good enough" flush for this application.

However, I don't think I succeeded and can't think of anything actually
better than btrfs_wait_ordered_range(). (and it's worse for using
SYNC_NONE and doing the whole file...)

> > +}
> > +
> >  loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
> >                 struct file *dst_file, loff_t destoff, loff_t len,
> >                 unsigned int remap_flags)
> > @@ -938,6 +978,14 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
> >         if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
> >                 return -EINVAL;
> >
> > +       ret = filemap_flush(src_inode->vfs_inode.i_mapping);
> 
> So again, this flushes the entire file, which adds overhead for
> reflinks operating on a small range and causes unnecessary IO.
> 
> Further, using filemap_flush() is not enough in case we have compression.
> The flush call only starts the compression work in an async worker, we
> need a second flush call to wait for the compression to finish and for
> writeback to start (creating ordered extents).
> That's why we have btrfs_fdatawrite_range(), which does the double
> flush in case we have compression, and also supports specifying a
> range.

Interestingly, this turns out to not really matter due to how the folio
locking works today (and that we don't care about 100% perfect
submission anyway). Basically the second folio gets blocked right away
in filemap_flush and waits until the first folio's async compression
finishes and unlocks it. This is the same pattern that Qu is contending
with in his parent-child OE redesign to try to make compressed writeback
look "normal".

There is 0 benefit I can demonstrate objectively from relying on this so
I am going to switch back to plain btrfs_wait_ordered_range() for v3.

> 
> Thanks.
> 
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = wait_existing_ordered_extents(src_inode);
> > +       if (ret < 0)
> > +               return ret;
> > +
> >         if (same_inode) {
> >                 btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
> >         } else {
> > --
> > 2.55.0
> >
> >
