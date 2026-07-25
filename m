Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F92BD0B;
	Sat, 25 Jul 2026 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784960791; cv=none; b=oFgLG8iLfP7T4rZ1o+Qx1YWNM8O10hMAsFdt1r80zzEmmQB1VoFH7hhMXKEqmrp1bq2/P/GTd8RwL1C6Ch3hCX4PqadEebYy9C2+aQOcEs7aZA8kF354HHpjCKeSwHojJc47Br4oFgk9AhZ56wc+uCOSERbkqfdAvSJEQwS6Q/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784960791; c=relaxed/simple;
	bh=ThzLVPkyAqRzoZ/BYPEukuwlSKEt3wbFqQF9K7lEP+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJytN8LPtqDzMVD1hSk3WrWmN8c6zg6NcDagrJcdAJOqu69kVNNdpcoTM784eD/68kPdovnJSs1yZps+j5pBEaPVE3De8Ua66pHLYJHuospIn1KmJGNiDlmZZ3khQeq1au7GD7p04wpErFf9eea9kfuTpHq/XK22e7LVq7Ie/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=G+mFIm8e; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bpbAKQmc; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="G+mFIm8e";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bpbAKQmc"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3CCC97A011F;
	Sat, 25 Jul 2026 02:26:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 25 Jul 2026 02:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1784960789;
	 x=1785047189; bh=+fEzNHdT81nG+FD6y5g3w6OiXhQitOnL0cq79oUPrH0=; b=
	G+mFIm8eeRJJJQH+OPn4mkczWnbar7bJUS7AKAUl4PL/V5FDCwo+XNmTpCBPgc/z
	3KHtLrbr6MAKumC+Em+deHhD2r4b6Y+AOYhjv6zQeB7vhalD/U/8oV2tn5G9vYUS
	eviQtsACIAYkPFIx1OmuaDrax9fGCiV7xu2BTTw4PIkW+6E5QAaj8k9inAp/r16f
	H+cCOjcSfZuWULYekuMIgT3g3NEaXBSRrTMCTgoDsgMqGu7M3TIceTj3E4xk265S
	CtoEkKQ3pcEViab+JLiBZ/Z10snIw4rSCthzV2v8D58y/GqqDVjdSbrxBV4P4TrW
	bHwA2L6PZfwTMu6xhtbrFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784960789; x=
	1785047189; bh=+fEzNHdT81nG+FD6y5g3w6OiXhQitOnL0cq79oUPrH0=; b=b
	pbAKQmcgggbwX8VKy5zNLlJ5RgexCNSbBNixh0ZN11eMNoR6qJiHZgbjV5UDf4TC
	+TUoZotcO5GjMIPjmFfvG2h2yx5JBlAmA0X4n6kd2U5sQxzl/GVKFgN8SQFnTkNa
	BXdHLwsrVRQphKOLaJQcD7KHuTuWO1j6m05h4Mb7ETBX2N5j9KHQyCNPv5zJhPD/
	rRseCZcPngIirNKrPk5dIQ82GT8v5TwZvz6CDEdYGerz9wXLLUfVx0coxMCio4tP
	kulYDcUeKCWokqmVDW4N/7RFP2wnoA8HRKx+Hn2gm2kTGp2NFNK0gv2b/ptsKk70
	vfB6Un9BZDHEFAp7lXspg==
X-ME-Sender: <xms:FFdkaoBsceelMrkoB7jAR7IbAFCYdYS2onj2E7HSLkU_Rgfd7pBXYA>
    <xme:FFdkaqFx5BbuOzedQcx_SKJw5VkaZyf0vcso3YPRb0eXq6o40lIt1YYONtcJEUW7_
    PAnD36dh2cbaa7fAsnqBWqpPZZRctUvshKVVrdT2if6bpVqA6qfQyQ>
X-ME-Received: <xmr:FFdkav6aQj4vf-tkOSP5wPgorfb5jpmnF8QMj3KIBOGTBfn6t6A4ZNdYx7-flMjPx4rdbt8k6C7UmLAuAMgfYtwjy6A>
X-ME-Proxy-Cause: dmFkZTE8yrcjtnQH/jhzrzda23ac5bU0bQYcxjJuKgWbVXlvRh3mIDt1sFwNj+VixV9UGv
    ZnG3WPL/BwuSab3UyYWdofQEa69n1FU9ktgikvh0yECfeyOxzbdNN9OeaaH7MtFdUOF2YO
    kDARzmfgJE+DlMlTiciRPcJPBIYvjrawciVgoqL1LDUNW2XLl8b/NZNNFFuX3eGJcNYN+Y
    Tb76ZP2aEz6vlX2wyfC+eHATQP5GJBZR6G+d+tp4GeOX2YkQRkKvfQbiswI+2ZoBt666KF
    YxGgUMUXNrIE6D2ryrjILlc6JZNgUpj3zwd6TYd+AmfDBye3FBO6RTBvYkAWsjDS02vBA7
    49/9NgTycaQORwnHMKkaV7HstnXpeZtCq1NxsdAxgynDilbyyOD0a2wyDKmukHcCvxXMcD
    dSaj8B5W5xCi+i0NBZ+K2YXaVHk9KqYhuwvXFeVdmBJAzPn70m85az9B2ClT7LZGmSYWeW
    nu/Q+Hs7Cv9yYpMw8+nvylBtiofiIhWZxvFaJ+N/nHL3KASxzKNbBjUKcpsw2Xu4fzYdeI
    ziwBDKIofA1RKg42tqIJWhuy9vfRcjMhDdBSWsIp3l1fgf/bMwRKp2FVna1ikQjvGJBJvK
    IrKMSUaRG7YIbpNiLQE7R7e7g86xzTgrps+ZYBKcNm74PReTGPwLGBvjmV1Q
X-ME-Proxy: <xmx:FFdkahSypMBe6riODKTib_JJgX2dM3R2HyPV6NPmlYcAc0ry1farrQ>
    <xmx:FFdkaq5bScPKG0IpAOWFYwSlmIQP5DVc9fuS-zvApYnMEdQshaakDw>
    <xmx:FFdkauRxN_7DBdlrfQppQmGf1l3UiLTl1fJma8V_IXx8dm69c-WEPw>
    <xmx:FFdkavn15HBFGl2I9YFzhbuvLsyOf35Cdo1PfHyzyMUy66-RbXHw1g>
    <xmx:FVdkahdoxsaXwRDBWTLp1u4v9O01as_SwHDOsG9hZ5jgiqpaninKazsj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 25 Jul 2026 02:26:27 -0400 (EDT)
Date: Fri, 24 Jul 2026 23:26:14 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <20260725062614.GA2792359@zen.localdomain>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
 <amICQYTK9Xu4KLtH@casper.infradead.org>
 <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>

On Fri, Jul 24, 2026 at 08:10:36AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/23 21:30, Matthew Wilcox 写道:
> > On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/7/22 22:27, Matthew Wilcox 写道:
> > > > On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
> > > > >    *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
> > > > >    *      Whenever a full clean cycle (clear_page_dirty_for_io(),
> > > > >    *      writeback, bits cleared) completes inside thread A's
> > > > >    *      submission->completion window, the completion-time
> > > > >    *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
> > > > >    *      sets only the folio flag and the xarray tag - no btrfs subpage
> > > > >    *      dirty bit, no delalloc reservation.  See the 20-year-old comment
> > > > >    *      above bio_set_pages_dirty() in block/bio.c describing exactly
> > > > >    *      this ("other code (eg, flusher threads) could clean the pages").
> > > > 
> > > > There's your problem.  filemap_dirty_folio() documents that btrfs is
> > > > doing it wrongly:
> > > > 
> > > >    * Filesystems which do not use buffer heads should call this function
> > > >    * from their dirty_folio address space operation.  It ignores the
> > > >    * contents of folio_get_private(), so if the filesystem marks individual
> > > >    * blocks as dirty, the filesystem should handle that itself.
> > > > 
> > > > fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
> > > > 
> > > > so btrfs should have its own btrfs_dirty_folio() which does whatever
> > > > metadata updates it needs to and then call filemap_dirty_folio() to
> > > > take care of the page cache business.  See iomap_dirty_folio() as
> > > > an example, but many other filesystems also do this.
> > > 
> > > Thanks a lot for the advice.
> > > 
> > > However it looks like the sub-folio dirty block tracking is a little
> > > different between iomap and btrfs.
> > 
> > My point is not that "you should do it the exact same way as iomap".
> > Rather "the dirty_folio op is the entry point to tell the filesystem
> > that a folio is being dirtied".
> And since dirty_folio() is not allowed to sleep, we should introduce some
> extra mechanism, e.g. page private 2/checked, to notify the fs that the
> folio is marked dirty without proper preparation.
> 
> Then during writeback, detect such folio and do needed preparation for it
> since at writeback we're allowed to sleep.
> 
> That sounds feasible, but I haven't seen anyone doing that (including the
> older btrfs cow fixup).
> 
> Will explore that path. Thanks a lot again for the dirty_folio() help.
> 
> Thanks,
> Qu

Here is my proposal for a candidate fix. It passes the reproducer in
this thread as well as several more intense reproducers (alluded to but
not yet included)

https://lore.kernel.org/linux-btrfs/6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io/T/#u

Thanks,
Boris
