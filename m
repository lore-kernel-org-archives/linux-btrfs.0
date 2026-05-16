Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6382773EC;
	Sat, 16 May 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778939740; cv=none; b=d+3Rg62D9NahrHACXo8SVQ0hsLN4dDM6mBz4Eo/BV+Enc9jBlXV70hA7DBvEJT4Tsdhua77oob9gDHt3k+jnimyfqgCWwX2JduTRhIN60hHuFTFdXaw6ljW/ig1GlGQKmjeuKjHWAx6+/xKaFi2m45wlKdAKOnJNZb9X/n2Wktc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778939740; c=relaxed/simple;
	bh=mY8YaNnAtq3STAA8KAYmnPxlSQLbzdGdNLToKmXs5i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqT/BTiSSJAN1HtlJuOp4WT4YO2sESDgIepKqPDyiXZGhP+SpyFZY6ZpegQp6diYVZOGuUqDuKqNdtft04UNXx/3Sr85XuDmQjdh+gNXnaIy5PxSpTQkGPyNPlcS5FkoUB7RxY96GkYpwkJvGsZUdmiNyGlgGkh6jwNmRVC2E3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEHZnRZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEHZnRZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E74C19425;
	Sat, 16 May 2026 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778939739;
	bh=mY8YaNnAtq3STAA8KAYmnPxlSQLbzdGdNLToKmXs5i0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEHZnRZn4k/1HUbzFUal/4FxWUEGNCu67heSJD9j7nIS9+7L79hEx95bgTBWaCsP0
	 y/pLm/bDY0GL8eyQqfeYiWc9BKTFQhlD6ChQqKfP1kDE/lROOxv9KB4gibQtKCNJGd
	 sRceF1/SOEWfwTzPH2cU0vB+tyqhaxg41Mt0gtQhi5hgnL/TQHybQnVEnKcHn3jAlm
	 xGBusVekXCQTYviJ7j96t7CFQCK9L+nSz9dsR79K/DF/V6xC5VuxLhsohcQxumwPSl
	 jxW6c6hbRoDGnHbPed6h3clIJ3qOd4Tmtas8X3mueADYkmf6CqhAdoiH7wHWrd35ou
	 WClmQbLTo89wg==
Date: Sat, 16 May 2026 21:55:33 +0800
From: Zorro Lang <zlang@kernel.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: inline enable_quota helper in test 301
Message-ID: <agh2fWSSrcyYchml@zlang-mailbox>
Mail-Followup-To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	kernel-team@fb.com, fstests@vger.kernel.org
References: <cover.1778632843.git.boris@bur.io>
 <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
 <agU-k5OnlkvcLiFB@zlang-mailbox>
 <20260515211549.GA3470939@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515211549.GA3470939@zen.localdomain>

On Fri, May 15, 2026 at 02:15:49PM -0700, Boris Burkov wrote:
> On Thu, May 14, 2026 at 11:34:00AM +0800, Zorro Lang wrote:
> > On Tue, May 12, 2026 at 05:43:33PM -0700, Boris Burkov wrote:
> > > The enable_quota helper in btrfs/301 takes a mode argument ('n', 's',
> > > or anything else) to switch between "no quota", "simple quota", and
> > > "full quota" enable.  Only the simple-quota path is ever exercised by
> > > this test, so the dispatch is dead weight and the indirection just
> > > obscures the actual btrfs command being run.
> > > 
> > > Inline the two call sites to call 'btrfs quota enable --simple'
> > > directly and drop the helper.
> > > 
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > 
> > Hahah, to be honest, the title '[PATCH 0/2] squota delete fstests' gave me
> > a minor heart attack. I thought it was a critical bug report about fstests
> > accidentally deleting itself while running :-D
> > 
> 
> Oops, sorry!
>
> > >  tests/btrfs/301 | 14 ++------------
> > >  1 file changed, 2 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/tests/btrfs/301 b/tests/btrfs/301
> > > index 1f72a97b..31243aab 100755
> > > --- a/tests/btrfs/301
> > > +++ b/tests/btrfs/301
> > > @@ -169,16 +169,6 @@ do_enospc_falloc()
> > >  	do_falloc $file $sz
> > >  }
> > >  
> > > -enable_quota()
> > > -{
> > > -	local mode=$1
> > > -
> > > -	[ $mode == "n" ] && return
> > > -	arg=$([ $mode == "s" ] && echo "--simple")
> > > -
> > > -	$BTRFS_UTIL_PROG quota enable $arg $SCRATCH_MNT
> > > -}
> > > -
> > >  get_subvid() > >  {
> > >  	_btrfs_get_subvolid $SCRATCH_MNT subv
> > > @@ -198,7 +188,7 @@ prepare()
> > >  {
> > >  	_scratch_mkfs >> $seqres.full
> > >  	_scratch_mount
> > > -	enable_quota "s"
> > > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> > >  	$BTRFS_UTIL_PROG subvolume create $subv >> $seqres.full
> > >  	local subvid=$(get_subvid)
> > >  	set_subvol_limit $subvid $limit
> > > @@ -421,7 +411,7 @@ enable_mature()
> > >  	# Sync before enabling squotas to reliably *not* count the writes
> > >  	# we did before enabling.
> > >  	sync
> > > -	enable_quota "s"
> > > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> > 
> > This change doesn't seem related to patch 2/2. I think we can review
> > these 2 patches separately.

Don't worry. What I mean is that as long as one of these two patches gets an
Ack first, even if the other is still being questioned, we can merge it first.
After all, they are independent of each other.

> > 
> > For this patch, I'm fine with or without it. If the btrfs list prefers
> > to have it, or move it to be a common helper, I'm good with that.

Sure.

> > 
> > Thanks,
> > Zorro
> > 
> 
> I pulled this into a separate patch based on Filipe's feedback on the
> old version I failed to get in. Agreed it doesn't need to be a series,
> just felt related enough to send in a batch, due to the context.
> 
> Thanks for taking a look,
> Boris
> 
> > >  	set_subvol_limit $subvid $limit
> > >  	_scratch_cycle_mount
> > >  	usage=$(get_subvol_usage $subvid)
> > > -- 
> > > 2.54.0
> > > 
> > > 
> 
