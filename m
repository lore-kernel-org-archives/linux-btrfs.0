Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF963F86ED;
	Fri, 15 May 2026 21:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879766; cv=none; b=CU/kZOdZktkKVeA7PhKQJeuUGXo1PNsNRiBjEYTSjgVrILAMAzFKWrdIW1H2dMRWt7MEY9S3NoGq8oE6igJm9jMQx/Hp3bFpNJLiCSaRwzJuwEoouSn6zllNdXupYm4GHm7+P7jky9m0JqshqdWo2v/rk7414tDSs+MxmeB5Yek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879766; c=relaxed/simple;
	bh=v1ZMVdVTScUFdRTnLCXoeqP2CFA/KimCyQ7FIvHqhgo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8YkqdIPKz47sGr4u7EZoZ6Ar4kEHP3YurF9oQFx98QiC4Lwe8LkWmOEPMznLuNLG7XunvpavtwpZgGGksDpWl9q6XNU3JRlERWqL220eRSrVVEwd/NR2hj9puNXuIbwUomQufjp1CtGyAQU+3ZCKkVMLeu0dk8rL8SlBSA9ZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=FYxF0lwl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hMkzsfPz; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="FYxF0lwl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hMkzsfPz"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 65B4114000AD;
	Fri, 15 May 2026 17:16:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 15 May 2026 17:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778879763; x=1778966163; bh=VXcfs4KVQr
	53AVvuwo4ENuxo1HHNMoygZgChmb7Aq/g=; b=FYxF0lwlK2VWfnM3yMrd0RWrvR
	Sqta8eCQ3bIOdi61/l5Wo3gv1ppRB/5mN72mumijXx/IzOAM84tPGbklnGC240SX
	WkrTFfjdKfwW8osfl5Yw6MulkSFZNKVjYHqq7cSHR8PEImc4C4RVH491JZL4kfyV
	ShC4FYC6FXhNErzGwzsRNobdBSF0HleSxvT6TvVFSmTIvFmGn4AludQb5sVb4wpe
	NVXCaTa5ahjt4oBxGr+MBMV1jkGbu4hSWL3B3mXUbZBlpPWwEgcz1D7OLaHTt6OG
	AmrRT7BononqizuTSvE6kyhKLO+8KMTjjTHPXO5WTsJRrqryZ09GeEq1HTZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778879763; x=1778966163; bh=VXcfs4KVQr53AVvuwo4ENuxo1HHNMoygZgC
	hmb7Aq/g=; b=hMkzsfPzj/BydrQZ5qJ65aKsdu+vpn/J+No1hYXrkQSZhZQWBn1
	PQiw/b12sCy87zq56bG9Zfn6r45Ad4ygXODtTYIE58LqgfoenmVLMrqI8TJDaF96
	kuyfsr6weBDRwenUtOUEcrcT/8m0PMDvcw1UTRhczr7iYJnkWq65T4vEv+vsItCQ
	Buy7HVl871YGKriodiGM2vUVerQU/cgqHu5p5qGG2xCPeKQWgXFRuVzelEm9GwfZ
	cD6Vrd+N8q3nsxcOITJfzPpklYDFm0fkGHVUeFJK2Ou+PHtwWsj7IV/TLJa/XRki
	YyKkeLHm2PCuH1O2OtxTdX+uXQUFajqNL+Q==
X-ME-Sender: <xms:E40HaiN23A2whEBpm7at0V6-LwV7YQK3n4lwCk4639gxvpxMtXwtEA>
    <xme:E40HaotCECRXw09134_1VBXXt20roL0j1FGCOXieV0D_t5S8qWgfckxw6s9wfaUK6
    uhYSxaPDk3z3N30oRMkUPbm85Vbm6AKGVkkkD2laKzQ3dYOtKp09W1_>
X-ME-Received: <xmr:E40HasWyOkNw7UupnEkrW-ERLN4MTU80IR1eWH9TbASIa0y2-ojqOMnWxb2EcbozqMXMxGZ4_rmZN-B5bkjWObEz8Do>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufedugeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeehudevleekieetleevieeuhfduhedtiefgheekfeefge
    elvdeuveeggfduueevfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepfedpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
    dprhgtphhtthhopehfshhtvghsthhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:E40HagudyAqI6fB6_9YiUH6U4iaKn7hwmEUtaDfc1AR-Y3jpwA23bg>
    <xmx:E40HaoXJeZL2VSV48eb7aymLvs_9a7lctJHqjWMKTIXuz2l7izjDzg>
    <xmx:E40HajkMs0hyxcIH4Iok4nddSIhWnjbfWr15agfjxoL93ZFg3jd5xg>
    <xmx:E40HahZ4rfErFckZN-TGO29Blo70vQUOZO0pQ96Tw7CPCFB3x2iCaQ>
    <xmx:E40HaqZJhOtD93LDU15ECikGwNVH4uon8GNWOg6jTdlgFjj3rV22acbs>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 May 2026 17:16:02 -0400 (EDT)
Date: Fri, 15 May 2026 14:15:49 -0700
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: inline enable_quota helper in test 301
Message-ID: <20260515211549.GA3470939@zen.localdomain>
References: <cover.1778632843.git.boris@bur.io>
 <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
 <agU-k5OnlkvcLiFB@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agU-k5OnlkvcLiFB@zlang-mailbox>

On Thu, May 14, 2026 at 11:34:00AM +0800, Zorro Lang wrote:
> On Tue, May 12, 2026 at 05:43:33PM -0700, Boris Burkov wrote:
> > The enable_quota helper in btrfs/301 takes a mode argument ('n', 's',
> > or anything else) to switch between "no quota", "simple quota", and
> > "full quota" enable.  Only the simple-quota path is ever exercised by
> > this test, so the dispatch is dead weight and the indirection just
> > obscures the actual btrfs command being run.
> > 
> > Inline the two call sites to call 'btrfs quota enable --simple'
> > directly and drop the helper.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> 
> Hahah, to be honest, the title '[PATCH 0/2] squota delete fstests' gave me
> a minor heart attack. I thought it was a critical bug report about fstests
> accidentally deleting itself while running :-D
> 

Oops, sorry!

> >  tests/btrfs/301 | 14 ++------------
> >  1 file changed, 2 insertions(+), 12 deletions(-)
> > 
> > diff --git a/tests/btrfs/301 b/tests/btrfs/301
> > index 1f72a97b..31243aab 100755
> > --- a/tests/btrfs/301
> > +++ b/tests/btrfs/301
> > @@ -169,16 +169,6 @@ do_enospc_falloc()
> >  	do_falloc $file $sz
> >  }
> >  
> > -enable_quota()
> > -{
> > -	local mode=$1
> > -
> > -	[ $mode == "n" ] && return
> > -	arg=$([ $mode == "s" ] && echo "--simple")
> > -
> > -	$BTRFS_UTIL_PROG quota enable $arg $SCRATCH_MNT
> > -}
> > -
> >  get_subvid() > >  {
> >  	_btrfs_get_subvolid $SCRATCH_MNT subv
> > @@ -198,7 +188,7 @@ prepare()
> >  {
> >  	_scratch_mkfs >> $seqres.full
> >  	_scratch_mount
> > -	enable_quota "s"
> > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> >  	$BTRFS_UTIL_PROG subvolume create $subv >> $seqres.full
> >  	local subvid=$(get_subvid)
> >  	set_subvol_limit $subvid $limit
> > @@ -421,7 +411,7 @@ enable_mature()
> >  	# Sync before enabling squotas to reliably *not* count the writes
> >  	# we did before enabling.
> >  	sync
> > -	enable_quota "s"
> > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> 
> This change doesn't seem related to patch 2/2. I think we can review
> these 2 patches separately.
> 
> For this patch, I'm fine with or without it. If the btrfs list prefers
> to have it, or move it to be a common helper, I'm good with that.
> 
> Thanks,
> Zorro
> 

I pulled this into a separate patch based on Filipe's feedback on the
old version I failed to get in. Agreed it doesn't need to be a series,
just felt related enough to send in a batch, due to the context.

Thanks for taking a look,
Boris

> >  	set_subvol_limit $subvid $limit
> >  	_scratch_cycle_mount
> >  	usage=$(get_subvol_usage $subvid)
> > -- 
> > 2.54.0
> > 
> > 
