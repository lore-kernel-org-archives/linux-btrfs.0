Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB2640B38C
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753702; cv=none; b=StPHNM9KyeE0MphpXra2dPUb1uuNO0GYr0OsVku7dtMNBjY1Ol+ra94N4t2HuoKyjx6wlTEHWXCpZCJw2ZLJll/vCBNTFdZKR21Q8VcFYzfZFaY3Y9d5R1Egvgx8H8Me0lCG6GE4DUi7OMlXWP0vKxbWgBdQCUIr1OhvTjS8rlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753702; c=relaxed/simple;
	bh=JYu8mvKXsKLEaEZ29euZ8oUqlufYNtchWXvGkeKYn04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qw+1qhDMKgWcZYLdYfJODyS/UknuOYa5d1GRm8teUdRd38AiKtiSL0lK+FxYHjbKNududNBhG/rHTbHBU2ps1PxtQMbOgW90V4iI3gNjva8sF0D3TNUU1lbjS4m3g7NO6OFTs8YFXPUXG8G00pPFsFmRI8WQzBqGY54/zLBpDWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=e1NsCaeU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sMn9CSAM; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="e1NsCaeU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sMn9CSAM"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 700D91D000EB;
	Fri, 18 Sep 2026 13:48:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 13:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789753695;
	 x=1789840095; bh=vFJiqLvPGX+8wnhcExg4Tl4rIRliWUSAJiMnqfsmdkE=; b=
	e1NsCaeUjNDPfWKO1QiiR94wdYvoAt3KsVjostHtIsq8XTNj7X7Uey8WfwT2QPK9
	cBiav5RHdPu7SLj6Y402wzQMz763t5jI2EfQ+Wp4kBMi/8F0ZHbwNoZwARBm8dG1
	HymEzAyQ0Q6h1vesVY7CNAhlUVGZFKNxu90Oyl6ZKMkoEat1lIYeEblTI0fAoKeO
	uIFkpgxVQR6JvM0bsZeglIysEc9vNMegx8P2N+LMTL3Y9byhMe+lKT/cLc0OxRt/
	T0mngQ/WpuqWloYmOIHRvs03vX2ISLRrfyddL1TOiJFb/F2p7X5CUv8AZk+nJG2H
	8v1zYWfwaIntlHSIPChgdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789753695; x=
	1789840095; bh=vFJiqLvPGX+8wnhcExg4Tl4rIRliWUSAJiMnqfsmdkE=; b=s
	Mn9CSAMeyRs1e3L2QVihL1Omh+AKW7E4y63aXcv0g0VWjNnZCDMcTidkzw6x2k7b
	G7cCD8nyVjKDZcsYOQFho5nHbXKMGQLz19pArLYq9bZCJ3WW0nxAI8hhKVs7Pljf
	iAFSiqWMrT8W2J+GWhryeNVQOYM0Wjph+mof/fRU2HRV/vInCGTom+0g1uOBLfHI
	mKBw/87w+C2bK7P3DQunquLZOhg8nFGBXIdbxcAZpRHPnteOhN6T5PHLRnG5dJmg
	ooqDRTxVxCIeEPRhfhRFP4KUC0+bZ3insoH83LLbozT5lm2gfo/sNFiVCOLWb7Uh
	kwgF4D8Rk2fL5AyXaFwyg==
X-ME-Sender: <xms:X3mtaq8_7KVAjATkvHU1cx6cjto9-Sa9Xf89AR1j9A1Yf5DqoPZyAQ>
    <xme:X3mtagv3tTbMJPhdZZS9iMyxIhN_11ZtjyMnEMJT6Fm3oaUiM5nc_GKstWcLADeUk
    T8ltMndJn3LBnlbCfiZ28Sp4CaYg_H8hU65Jgt3H9VU94vRFYwrP4I>
X-ME-Received: <xmr:X3mtatoH20OoovEtIa0hypyuuwUmo1zA-dlVO4Ef1NjrnTXqJDld8ok>
X-ME-Proxy-Cause: dmFkZTFIarZ0u9l1ItteWR63+46I4jsKIpZrz6ofTRIk9Zo75OOzx2gxZaH8DX4bb7HEed
    Dixxrmzt/kKutN2jyDWNpDTDTyFSUv1hAmJvOWiTePcf8OD+P7tH+l2Uve6p3CHfqv7s38
    oJaH2uLqUNzz16K9rXEycW/rdP32MjGuPwCPPStmXSrd8avMgnGnw8oMocifJnb6ydNmNF
    jq9QIzUHEsxil61dfyWnupvK9cKdVNs1FXGZRYlYsmIMgaYuFfPXtO9frXwuCRp7wlxkU3
    aQOmSGOHfGspGAWgxb2509DhvKokipagxlECdYSLvWukW1OoPhsR1gXnGOqmJx1uUTWakR
    ETcGoLZZRjYZuXn/Xts/G8dpcM4vBpmC78Z73aTwPKZIMR8moUbX4tIYmbgI6kEJRe1ZmR
    Il0C8zjiNfRNqoEjKE+HY/gt3TR42/wIS37sNF87gV1fy/s2fPfiDmQ5oWHQbMpRM0GTFU
    xHhao1MuUv5Ig1sOF18qzco8kVYUTsVnXvcgDGKXdWBtbHrnsUXi1TuoVvhgaSVjBpfVAv
    3ww3VGig7l8i1NDwAH8Ao0jQeYownFV0iFcTwaGONT3wDyE6Asbs4GDqPcszUBdS4F5Zb7
    v1sqbZOYbCEiKFLNEamcz84vE2yadzJByTvOVgkfgf3KyiIWFMZsrF7UlACw
X-ME-Proxy: <xmx:X3mtatl8Ih74XSaOvzrGqu029H3Ivlq2dI3q_Ajx6ARm_cLKqlzeXA>
    <xmx:X3mtahycrAAHGJ_uuvnxQZu89keRDAApF_86Ul6ClYg12sd-gKPCbQ>
    <xmx:X3mtalmLJy1yIi6RgKTg4SNCniUqIbEuWRzrGR7gzkwKnTEI3ooL-g>
    <xmx:X3mtaqf9qEC4X2FCThdTaNAWO5dGcKSsOQQ6lX4n5l2FkCFjGEyHYw>
    <xmx:X3mtakRKkYQhfhVlv5R6TxQdLkwAhYD2QzK98CKstpNkYvsURJBdS4i->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:48:14 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:48:26 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit
 from record_root_in_trans()
Message-ID: <20260918174826.GA2925568@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
 <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
 <20260918171906.GB2900089@zen.localdomain>
 <CAL3q7H4dSDPm5Z3F1qwkFA-omHaCXLtyH5u7BOpkhOqAQ3knKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4dSDPm5Z3F1qwkFA-omHaCXLtyH5u7BOpkhOqAQ3knKg@mail.gmail.com>

On Fri, Sep 18, 2026 at 06:32:05PM +0100, Filipe Manana wrote:
> On Fri, Sep 18, 2026 at 6:18 PM Boris Burkov <boris@bur.io> wrote:
> >
> > On Fri, Sep 18, 2026 at 01:28:09PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > If we exit early because the transaction that last used the root already
> > > matches the current transaction, we leave the BTRFS_ROOT_IN_TRANS_SETUP
> > > bit set in the root (which we just set right before the exit). While this
> > > does not cause any functional issue, it makes callers of
> > > btrfs_record_root_in_trans() always lock fs_info->reloc_mutex and call
> >
> > I found "always" kind of confusing here. It's until one succeeds and
> > clears the bit right? It kind of makes it sound like it leaks it
> > forever.
> 
> Yes, I can reword the sentence to:
> 
> "While this does not cause any functional issue, it makes callers of
>   btrfs_record_root_in_trans() lock fs_info->reloc_mutex and call
>   record_root_in_trans() for nothing, causing unnecessary lock contention,
>   until one of them clears the bit in record_root_in_trans()."
> 
> Thanks.
> 

That version sounds great!

> >
> > > record_root_in_trans() for nothing, causing unnecessary lock contention.
> > > One caller of btrfs_record_root_in_trans() is start_transaction(), used to
> > > start new transaction or joining an existing one, which is a hot path.
> > >
> > > So clear BTRFS_ROOT_IN_TRANS_SETUP on early exit.
> > >
> > > Assisted-by: LLM
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  fs/btrfs/transaction.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > index ca114235bbe1..c1555621ae4e 100644
> > > --- a/fs/btrfs/transaction.c
> > > +++ b/fs/btrfs/transaction.c
> > > @@ -432,6 +432,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
> > >               spin_lock(&fs_info->fs_roots_radix_lock);
> > >               if (btrfs_get_root_last_trans(root) == trans->transid && !force) {
> > >                       spin_unlock(&fs_info->fs_roots_radix_lock);
> > > +                     clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
> > >                       return 0;
> > >               }
> > >               radix_tree_tag_set(&fs_info->fs_roots_radix,
> > > --
> > > 2.47.2
> > >
