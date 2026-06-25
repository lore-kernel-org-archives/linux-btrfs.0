Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3B2F7EF8
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782422120; cv=none; b=cvAN0GK/ZfRHSSp78JA851FmhPMc7YQuh+K8tjS8HhOxnk0SziiQLgZKOPGMv4TekGrPnRMSMhpAMeqxmJfgaQ76ZOJcwZ2/H3AmrEdtQJqezP4/45TBCexIu3iiy35/27ttSzbENoYZ4GU1dFvlEDbiyhtl2UzkJOjzaOOM8tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782422120; c=relaxed/simple;
	bh=WzPB74eY1A6riBAyHoGUeZIElWJ7orxLLX+LqpbLSo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASDIsnS2kuWOZilVioFgDN4/064ZUzgVzsDUAms4TgYo7FixfHFDBzc5LCgoMNTYbE1B1s3uPKLBzF/FvaUxoyXQu3AhUHxvhcnMYmBv2D6IZ0yt384zimYVREjM3+5VY8qt5CTOZI2e/J1WlLTQj8QqGoFgS7KeXQGd1DI7xpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=DADK69+9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=alduoAla; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="DADK69+9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="alduoAla"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 56B651400090;
	Thu, 25 Jun 2026 17:15:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 25 Jun 2026 17:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1782422118; x=1782508518; bh=cSkBpmpcy6
	H+/1neA/UMCbhbXeDyf4PfUQbsCy+czZk=; b=DADK69+98JLxzTF+/a4MwcyIKl
	HnHEJtrEjoaSmvl96tglxSsA3FKWaXwr33eNYeTY49vobSZBW3O0RAWKv9+8m25g
	ia3OQKMrzePzj2JCmek2epu8VA/jwIDDy7QKvLudt7SxujyXaz7J9f4Sz/ez2TM3
	XP6KHIcfDwWgs1h+Ojxco/iLQYqVWt2bA6uvu0n/Y0o8q26SD764mFkFoGe1gT0B
	F0FYBk+FplJadn1Z1Q6PL77ubS9gPOFW2PBogE+GcUSpt8CQqIyRSQPG6vSZ1gUW
	OFGIPZYDNf/LGvC33j4426Jbj9D9pwF9io3US9YxSWBgb6ySpWxc1TC9otsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782422118; x=1782508518; bh=cSkBpmpcy6H+/1neA/UMCbhbXeDyf4PfUQb
	sCy+czZk=; b=alduoAla9AxduirQAJhoNFpb8+j/hVZWSWumrdYA9gYtCxeXzIH
	aJRqc3+79xVhG4L+b9da7iJAlr8PrNnxNi/RrWl6JOlur120HAzlW/Z6RUNBD/BS
	91/Uy02pN96JsWdTbtiFFCkO1oRTq5TTrObiTrM8M7BHldywUola8xvxs6jYDW1u
	m9fC9n+bNrxXv1m7Tz2LuVq8hWLuOVbDUC0ECItQ6T8jYHxQozAI6VC7GgL8wzjl
	O00rxmnTv/aoKNvfTh9ICqV2d3TUV+atTK7LKoLx21trMlENlEB/E3s+pOdyfcTj
	yq+cgpSICCXW8Ur4hDRGuqE+VqZJnepLp1g==
X-ME-Sender: <xms:ZZo9aj8KSZlc4zG6yAJNgEvXab6Hip-mnMldyJX7Q0B9pnssR2Qofw>
    <xme:ZZo9anLuM6noSZTTJxPDFKCa_PgRuNLOP7s4WLktPeE5QlFSktwj63lFP_1ixVS8T
    6ps4O1qg9895nMDgqu9sx8IboHbEZtJ2stDzY2ZrFg-dbVbSyH2juo>
X-ME-Received: <xmr:ZZo9aub67JRlCUgnd3sroLXnV0bQSDMoZ-t6n1jvHQP3KYHOX-mnPr8T98K2Eeiu4O7z9bwcwdl7_C2CXLxlPTCrF9g>
X-ME-Proxy-Cause: dmFkZTFlaOhRq3IPeP8qT3V3u5uOg7Pf/6xUfwV3KBI6ase02t4S9EXBvXInvXmXN/iPCG
    UJtOadP6Ty/N2PwMtpjxLtseUpJmxg6yqFnL1UI32u7MMQuO3V8yuCN66iDOJuCUEdQ0VK
    X5Mg3vwo+7cWS521gQJ8niIdQQ6jzxfYa6cczWVo6FczUcL57c2+0oUG2T6udPWCLm++sn
    fqfjI7N5x+lhsurmOCKVwP0Xeqs1AwsdKDwvDGPF+8IHwo/GP6tuiEE3MEpqnX8oho16Xp
    Sf8VAUWdljkyMLxAJoDTr9A+si6luURlma1+Za/K0HhzgV/CpL3e1rYE8Ae2lPpWOVhHgm
    L9SL8/s6DRt4lW9ZyrQfhBYZcOSfdhjvl3bwy5IdyMrxcmCG/IF2bWnnE49Tjiqh3SqLbc
    VdCwWrafA3+Ium87GZbh6vTphdeY0OEqfP4gPitS3A4oHRxHP0xnVDI74iHsvRln2jqJ4L
    SMbnfenomMWPQkZ5mn+MdegdTQZPYvk9vc3CMaw8MiXd5Uo9+r9MEmQhwM7myQv15ThuOx
    dClzirR8LhH7Xiyb01y4qrOLHX8PTnOz6Jw4H22daM9if/5tLF3DDZi/4xGs4MBscHde2K
    YCShjrKn1xeEAIWWW2Bt88UmjiwKQlZLyrNfJqef8IEgZxjfq1vBzzM4TQ5w
X-ME-Proxy: <xmx:ZZo9apL7I_vFw9Z5KFhd16jy0_UJGGed2CySjg1WYwTXbewnMeQ2uQ>
    <xmx:ZZo9asDEUDNBiP-GadWtXIjVQFopgRb9VHLA6XzSbZ_YjQ9vWoqaFA>
    <xmx:ZZo9aurGuVWlgVZ03o32UeCDqaLFsQaGauXBZxXUU2b-FTCHvZ8D5g>
    <xmx:ZZo9anj3WiKJk34DrGEipp1d7-Hf1dD-jItr5qMLxMIA228SuQhjRQ>
    <xmx:Zpo9aqYJter9wd_PTN_Sx-rqJjEYsHGCYC5BamwhnkHvAgyaMCn9eD7a>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Jun 2026 17:15:17 -0400 (EDT)
Date: Thu, 25 Jun 2026 14:14:12 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/5] btrfs: factor init_extent_buffer from
 __alloc_extent_buffer
Message-ID: <20260625211412.GA3339383@zen.localdomain>
References: <cover.1782249000.git.boris@bur.io>
 <420436ec8cb5db154adfd65cfd5fb350b380a4ec.1782249000.git.boris@bur.io>
 <44af21bb-507a-42af-a908-66fa67c2a273@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44af21bb-507a-42af-a908-66fa67c2a273@wdc.com>

On Thu, Jun 25, 2026 at 04:26:56PM +0200, Johannes Thumshirn wrote:
> On 6/24/26 12:35 AM, Boris Burkov wrote:
> > In preparation for preallocating extent_buffer data, factor eb
> > initialization away from specifically allocating it. This allows us to
> > allocate the eb, bfs, folios, etc. together in the main search_slot code
> > paths, but still share initialization code with the dummy/test/clone
> > allocation paths.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >   fs/btrfs/extent_io.c | 20 ++++++++++++--------
> >   1 file changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 0edd532174fa..fa4cc8bcd1af 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -3054,12 +3054,9 @@ void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
> >   	xa_destroy(&trans->writeback_inhibited_ebs);
> >   }
> > -static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> > -						   u64 start)
> > +static void init_extent_buffer(struct btrfs_fs_info *fs_info,
> > +			       struct extent_buffer *eb, u64 start)
> >   {
> > -	struct extent_buffer *eb = NULL;
> > -
> > -	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
> >   	eb->start = start;
> >   	eb->len = fs_info->nodesize;
> >   	eb->fs_info = fs_info;
> > @@ -3072,7 +3069,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info
> >   	refcount_set(&eb->refs, 1);
> >   	ASSERT(eb->len <= BTRFS_MAX_METADATA_BLOCKSIZE);
> > +}
> > +
> > +static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> > +						   u64 start)
> > +{
> > +	struct extent_buffer *eb;
> > +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
> > +	init_extent_buffer(fs_info, eb, start);
> >   	return eb;
> >   }
> > @@ -3476,9 +3481,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> >   	if (eb)
> >   		return eb;
> > -	eb = __alloc_extent_buffer(fs_info, start);
> > -	if (!eb)
> > -		return ERR_PTR(-ENOMEM);
> > +	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
> > +	init_extent_buffer(fs_info, eb, start);
> >   	/*
> >   	 * The reloc trees are just snapshots, so we need them to appear to be
> 
> This looks wrong to me. Not the split out code, but how it is used in
> alloc_extent_buffer(). Either you keep calling __alloc_extent_buffer() in
> alloc_extent_buffer() OR don't call init_extent_buffer() in
> __alloc_extent_buffer(). I see this is an intermediate step (and I haven't
> looked at the rest of the series yet) but it looks wrong.
> 

The idea is that you eventually (optionally) have the allocation happen
elsewhere, so alloc_extent_buffer should not call __alloc_extent_buffer
any more. That should be clearer in the second patch, I think.

I left __alloc_extent_buffer for btrfs_clone_extent_buffer() and
alloc_dummy_extent_buffer(). Would you prefer me to delete
__alloc_extent_buffer and open code it in those two callers?

Thanks,
Boris
