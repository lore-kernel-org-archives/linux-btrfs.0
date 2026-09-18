Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AE1396591
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753645; cv=none; b=N6IbnZVDlv9OQBvc+xW9IpqlHbeIScjzPtM+DGwwCydrVGDLpSrIPB1HSNg/X/Krv38aZ4H+aOadRTHaS9d4F3zl4y/plOO6XYDVMCK4pkXLSkiuFUDQ5Rfw1mU8M8de/5lec25oxSz3MSdBzxWq4qGoGkbmUk+nB1Sawj/04tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753645; c=relaxed/simple;
	bh=Z6islooe+re5HoIaM9QcLNKCI9OPNAH15Wj+MKcArAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4O19RzU43CMsyo2XIUhrVxMI7AzvPf+jsJm6zWS+Sa/Q/+ae1CwZCyiOFgrhY7QeLflcdXPT9SgI5VdLvJ26x6JmDOr1R52ZZrlTMdmfChfTTJnqkM1Sdg7Ns5n0edA6Z+noD4PNDWDsFQpH9qg6116RNSGhFqMRfVGQoOlAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LKiEqQnc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MOtSUm+9; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LKiEqQnc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MOtSUm+9"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 79E2B7A00DE;
	Fri, 18 Sep 2026 13:47:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 13:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789753633;
	 x=1789840033; bh=7d4y4VtCiY71dDyh02sspe30b2FHE2mRmH7k/C1tPps=; b=
	LKiEqQncR8KwGV6hBxb/Yww3Y4ECQ4opTs8W6hxZPSzEqA+j6mVKLhNkJ+rGRBHq
	QoW2heNioL7uZhLtamlN3wLxDt2RQNiQM5pZ4jlL6JYVo2Dhr68EWtXKulH8fFda
	mYBnVsKihbsRvIT9Ewbiw7kbXTY4suuX08qUkJAFVEk4xhusYtCPhgKMyZoN3d48
	jVVyHxCLjnJSWGJ6ok6U6+sU+JZ8zZ8NvvWvhJEUIgTA80zV5kpnICUnx+OgB/+3
	vtoXc4AvGlE+9JTkQ5bZw56KVltgzCVH6QMUj+HB9fHrbTOKPLPgiClJ/YMFL7gP
	8MssM6xhWYxeYRQ99jcFQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789753633; x=
	1789840033; bh=7d4y4VtCiY71dDyh02sspe30b2FHE2mRmH7k/C1tPps=; b=M
	OtSUm+9sRoOGRzU7zeEn6D6rh7H+Zc972cdPniWl42jNB2YZekaZeaMD7PiDpS1G
	TuA/04KHY0f5OIZFO/SDVwkoHgcwkcv6HHZGejqwqdJBf889e289aDADILhKUx9J
	H3c/zA+vQjsfc8KyLBVCJk7Ds102hBAwXy3s4yd18TCrFFVaplV3GrpbDIYo2mTQ
	1B03BWZC6JBeDywvXlWQvUaZuqwVzEyeDkLtBRAtYo0EUTmmJrGnclNqlRF9bvan
	NaUvt9dsvn6Gcju85UEG/AksbVQwJfDnwuMByKZITFYkWecXRiZWJmesQY9lBRCD
	NrFD2t9V5pNF2usKGl1xA==
X-ME-Sender: <xms:IXmtakgDMYm7UXXQ1Gk14sgz4bpxZHSigSf_KmWbBmFMb_6WJNU-Ig>
    <xme:IXmtajC1xMEXT2BuiSdr5lSVQrnwpDj4RLFJDRjRSjPnvdwdOozx1lTf9LImPu_fU
    sXogvqwyVXvXrHRYni9c0K6Cj_DbyZkhX4dsc7Wm5Ip8G0C3l0vW9Y>
X-ME-Received: <xmr:IXmtaps7Exi9sRG_P1uR3jhVeATtZHyWYgiovCrBgd3r-RPMG4-hmEs>
X-ME-Proxy-Cause: dmFkZTFIarZ0u9l1ItteWR63+46I4jsKIpZrz6ofTRIk9Zo75OOzx2gxZaH8DX4bb7HEed
    Dixxrmzt/kKutN2jyDWNpDTDTyFSUv1hAmJvOWiTePcf8OD+P7tH+l2Uve6p3CHfqv7s38
    oJaH2uLqUNzz16K9rXEycW/rdP32MjGuPwCPPStmXSrd8avMgnGnw8oMocifJnb6ydNmNF
    jq9QIzUHEsxil61dfyWnupvK9cKdVNs1FXGZRYlYsmIMgaYuFfPXtO9frXwuCRp7wlxkU3
    aQOmSGOHfGspGAWgxb2509DhvKokipagxlECdYSLvWukW1OoPhsR1gXnGOqmJx1uUTWaca
    lsHSG8/WTzN7xy6NN+jPo5dwI9BFF55JQulPEdRxIcMlVrQ3lQKwmaAnvpiPIj0Rlo7NGE
    hn/dR0tR3wxYuaFIRFZcEJxOvALhTHW+GWYjVqR0q9XjPeMQ0JHGem/rao3GHDE+ae5SIB
    vKn9823Na3MQ+tNebNxwwx2MKPXJRiiKGeuugUchTSUnqR1RKUoeBn6Q5e1sxvo+speLT1
    /9Z3jHmra0V2r178nnY+fMISL11M9g1B1vwxIhtUtmobnKaSvt3p5a8sWgwd6htO6gb/uw
    2GnVLofTJvtm3xD3oaNSYFvcLp8txPWvl0THWfVj1Lh+DQvVlAktvWiDZssg
X-ME-Proxy: <xmx:IXmtagbsewyaBfomMnRBEzvkUpAEE9ZuX-ds4mlIC8cwTfNpoPtGFw>
    <xmx:IXmtakVgH1qEJY-jkyZSuoDqrEHP_wqUmJVhU6H3ULpCO629Z789ng>
    <xmx:IXmtas7mDcNAXZ4OmQ4RFKAFygalxd6NLr9nHp3SINtAApQvsjQ7zA>
    <xmx:IXmtangMxc9fmQLLcq4058qi_9qD--mJtfLmcIID7gSg3cWnqr5Maw>
    <xmx:IXmtapUVWnQY9Mw4UxYatNN3Qhd0vu8g_1tW-ZPiJeCKpQiGLraP4RKB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:47:12 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:47:18 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: fix barrier usage in
 btrfs_record_root_in_trans()
Message-ID: <20260918174718.GA2923381@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
 <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
 <20260918173655.GC2900089@zen.localdomain>
 <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>

On Fri, Sep 18, 2026 at 06:43:54PM +0100, Filipe Manana wrote:
> On Fri, Sep 18, 2026 at 6:36 PM Boris Burkov <boris@bur.io> wrote:
> >
> > On Fri, Sep 18, 2026 at 01:28:10PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > The barrier usage in btrfs_record_root_in_trans() is wrong, as the writer
> > > side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, does a
> > > write barrier and then sets the root's last transaction. This means the
> > > reader side must check the root's last transaction, issue a read barrier
> > > and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we issue
> > > a read barrier and then check the root's last transaction and the bit
> > > BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU is
> > > free to reorder the checks and the following can happen:
> > >
> > > 1) Before reading the root's last_trans, it checks that
> > >    BTRFS_ROOT_IN_TRANS_SETUP is not set.
> > >
> > > 2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and updates
> > >    the root's last_trans.
> > >
> > > 3) The reader then sees the root's last_trans matches the current
> > >    transaction and falsely concludes the root setup is completes and
> > >    returns without waiting for the writer task to complete the setup
> > >    (calling btrfs_init_reloc_root()).
> > >
> > > So fix the reading ordered as previously described: check the root's
> > > last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_SETUP
> > > (the reverse of what the writer side does).
> >
> > I think a comment on why we can't use release/acquire (u64) but that the
> > non-atomicity is ok (we only check equality?) might be nice. Otherwise
> > we are supposed to have some code like i_size_read(), right?
> >
> > Not blocking at all, just an observation, since those helpers are
> > supposed to prevent this kind of bug.
> 
> I'm not sure what you mean. If you are mentioning the helpers for
> last_trans use READ/WRITE_ONCE and that that prevents the bug being
> fixed here, then that is not correct, because READ/WRITE_ONCE does not
> prevent a CPU from reordering intructions (just compiler level
> reordering, load/store tearing and a few other things).
> 
> 

Sorry for being unclear. No, what I mean is I think we should
justify/document why we are not using smp_store_release/smp_load_acquire
since those are exactly this pattern, and if we had used them, it would
have prevented the bug.

> >
> > >
> > > Assisted-by: LLM
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  fs/btrfs/transaction.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > index c1555621ae4e..13203ea9e116 100644
> > > --- a/fs/btrfs/transaction.c
> > > +++ b/fs/btrfs/transaction.c
> > > @@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
> > >        * see record_root_in_trans for comments about IN_TRANS_SETUP usage
> > >        * and barriers
> > >        */
> > > -     smp_rmb();
> > > -     if (btrfs_get_root_last_trans(root) == trans->transid &&
> > > -         !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > > -             return 0;
> > > +     if (btrfs_get_root_last_trans(root) == trans->transid) {
> > > +             smp_rmb();
> > > +             if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > > +                     return 0;
> > > +     }
> > >
> > >       mutex_lock(&fs_info->reloc_mutex);
> > >       ret = record_root_in_trans(trans, root, false);
> > > --
> > > 2.47.2
> > >
