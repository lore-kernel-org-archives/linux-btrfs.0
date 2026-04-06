Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F3388E60
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775491985; cv=none; b=OQoecunhqTrCXb8SIRz4GYyzcW0qgSncZ9KGoP52pGji0/uAb6VwqqBQo+d/WLAvWcLpKmdQ77jHQLTPTd/J4CXGMu8DwgHPweEFxLfMUqw1kHoBMfiDURHotT+4KlstBzOwfgX40UzpeVpr475kJi33cj8HV5gt8jv5tjJXyB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775491985; c=relaxed/simple;
	bh=gqQEyfyudCMnuUpfKwxTELD0VBecQ4FFAzZ+DxkICQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUFbIthNgBUXlk781PjtRNpl4yA6uvhG7AyvfARKB+sr77RVYZxdlpwqNQfVcRpzITTfVjf1qh1l3DMF5sQgdnO+qfuHdzrnZQZG6DgclNPDkuc3Y6WuagY/Sj/Yc3spFgP65K64yw5Rt6GTVpMVoRRrzll3DHU4dGFZwQSqqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Uw9hXkOF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LVPsazWb; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Uw9hXkOF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LVPsazWb"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0EED21400082;
	Mon,  6 Apr 2026 12:13:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Apr 2026 12:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775491983; x=1775578383; bh=RcuW5ybrkg
	JM6Si2RG91Akq+Zr9pS34HrF0xQ3FMLg8=; b=Uw9hXkOF4zLnHlkOfdm83Y2vVz
	VrhBV27gN+HxordhZnmAzXOgYhWzQVzCZ23mt9OrJKMhTno1GoSgQCXVpeERHhNh
	pujDED4MNz/0bC3Qgh+rMhh5F4OO8PO0niLvf9J59Yi4Hf2bJ3JdmM2+ne+MBPPu
	u15PaRIB5UzNeqxXsVqMM/aoiiRCBmoLBVCNuzoGuqcVmt+bKTa7K1FGe4zTXsgE
	EajqLWV9TBoGlqXwK8/2z+rZI6FDMJmBMFuvrKvOj9AMsmbENoK4Dcxs1GLGY2FV
	aZebLhWC79mIlSdM97M5UZum+1mzCfNINgj7fh4aQBudVlEgHSFW+hQWR6pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775491983; x=1775578383; bh=RcuW5ybrkgJM6Si2RG91Akq+Zr9pS34HrF0
	xQ3FMLg8=; b=LVPsazWbx9uaG4Olw6HIKy8hvpGArUdslJX2brT2Agx+vTL36e7
	Gpv88LW5Vtb1ma1S6fWQvNmjJVdN5OaCvsK+8q/C050gik/B2kz4Nlo3Z3msrwuV
	k4XBNW3OhkmKSDKD2c43kOOH6t44WM5cr40EyktPmIFFQW4a/OJO7iruRIU9lxHO
	KEezPM9Dg1hiXsevw9BNpp6xGs1xPoJbbwyn7kRqDDB2rCeFEVEvdQAiN6OuD/+A
	nfGz8+wRPoksylAwhrfVX6aeNWLUDvuQt1eh1lz5GixsChmJMUW8pB3RMlvdXpBR
	kHdkIhvrqewUV0clRlFF7KEOuhf+8GFv33g==
X-ME-Sender: <xms:jtvTaZRV2DJa-c72_HSXGeU27GRlNXcCODugzP3OX1CERGT79nxgBA>
    <xme:jtvTaaNfQfHE2KXXXNgFFmwcfdo2NWEIdEsNME94pEXdrMczgANWRtk5Ah6vtg9ce
    3SQOc9fVrByoSaT-uoA8BUZ1wzzscIGfQCxXKEZXlFi-yJL7r9Dado>
X-ME-Received: <xmr:jtvTacMyhC2LQfK-rS9-P5uQ-uTrYYkU_KUyqTibAGRivqkdUUFKNSc7BdWC4cQ1aRmuPxchuomBj7iLGLVkgHQGyIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddukedukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeehtdfhvefghfdtvefghfelhffgueeugedtveduieehie
    ehteelgeehvdefgeefgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrnhgrjhgrihhnrdhsghesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqd
    gsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghl
    qdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:jtvTaatSc_VPq8o5Xr6MDv9F4cjauCflGqysrsJP8wbJY9blVFibFg>
    <xmx:jtvTaWVQZQinC1cxvr3Jz0KJLHZ7o-pQe2JVINoOKKPdriXs1bomRQ>
    <xmx:jtvTaSt6C1ce6kaVMVFZscU7LPz1QiFEeLii2jxSD_O_dCXLm8d-5A>
    <xmx:jtvTaSWwHLcTmeSOWIYtFRQgg7tfzrC-wLFA3VCkBdS-a1_2js58uw>
    <xmx:j9vTaas47WLW6emnwPom0L4uvE3V7Wguwicx2UkUgGtwObi1xfXTj8oC>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Apr 2026 12:13:02 -0400 (EDT)
Date: Mon, 6 Apr 2026 09:12:55 -0700
From: Boris Burkov <boris@bur.io>
To: Anand Jain <anajain.sg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260406161255.GA1743674@zen.localdomain>
References: <f91b3827c56947e58b4606f142bef022b54da70e.1775318158.git.boris@bur.io>
 <5790719b-70a6-4d75-813d-5842e77c7b89@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5790719b-70a6-4d75-813d-5842e77c7b89@gmail.com>

On Mon, Apr 06, 2026 at 09:56:07PM +0800, Anand Jain wrote:
> 
> 
> Disagree. We should only track block-device-specific errors;
> specifically, only the missing MEDIUM ERROR should be added [1].
> 
> Including all error types would capture transport and fabric-related
> errors, which do not justify a device replacement or permanent error state.
> 
> In my experience with storage and transport protocols, transport errors
> and timeouts are often transient and far more frequent than actual block
> device media failures. Including them would introduce unnecessary noise
> into the device statistics.

This is just my mistake. I messed up with git and resent my v1 instead
of the updated version after Christoph's review here
https://lore.kernel.org/linux-btrfs/20260327102253.GA18582@lst.de/

I intended to only log bdev error on IOERR, TARGET, MEDIUM, and
PROTECTION as he suggested.

Sorry for wasting your time with that, Anand.

Boris

> 
> 
> #define BLK_STS_NOTSUPP         ((__force blk_status_t)1)
> #define BLK_STS_TIMEOUT         ((__force blk_status_t)2)
> #define BLK_STS_NOSPC           ((__force blk_status_t)3)
> #define BLK_STS_TRANSPORT       ((__force blk_status_t)4)
> #define BLK_STS_TARGET          ((__force blk_status_t)5)
> #define BLK_STS_RESV_CONFLICT   ((__force blk_status_t)6)
> #define BLK_STS_MEDIUM          ((__force blk_status_t)7)
> #define BLK_STS_PROTECTION      ((__force blk_status_t)8)
> #define BLK_STS_RESOURCE        ((__force blk_status_t)9)
> #define BLK_STS_IOERR           ((__force blk_status_t)10)
> <snap>
> #define BLK_STS_OFFLINE         ((__force blk_status_t)16)
> #define BLK_STS_DURATION_LIMIT  ((__force blk_status_t)17)
> #define BLK_STS_INVAL           ((__force blk_status_t)19)
> 
> 
> 
> [1]
> 
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2a2a21aec817..d7af38e9ce29 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -352,7 +352,8 @@ static void btrfs_log_dev_io_error(const struct bio
> *bio, struct btrfs_device *d
>  {
>         if (!dev || !dev->bdev)
>                 return;
> -       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
> BLK_STS_TARGET)
> +       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
> BLK_STS_TARGET &&
> +           bio->bi_status != BLK_STS_MEDIUM)
>                 return;
> 
>         if (btrfs_op(bio) == BTRFS_MAP_WRITE)
> 
> 
> 
> Thanks, Anand
> 
> On 4/4/26 23:57, Boris Burkov wrote:
> > As far as I can tell, we never intentionally constrained ourselves to
> > these status codes, and it is misleading and surprising to lack the
> > bdev error logging when we get a different error code from the block
> > layer. This can lead to jumping to a wrong conclusion like "this
> > system didn't see any bio failures but aborted with EIO".
> > 
> > For example on nvme devices, I observe many failures coming back as
> > BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> > BLK_STS_* status values in nvme_error_status().
> > 
> > So handle the known expected errors and make some noise on the rest
> > which we expect won't really happen.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> > Changelog:
> > v2:
> > - proper bdev err logging for expected block errors
> > - btrfs_warn_rl for all other errors
> > ---
> >  fs/btrfs/bio.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 2a2a21aec817..08b1d62603d0 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -352,8 +352,7 @@ static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *d
> >  {
> >  	if (!dev || !dev->bdev)
> >  		return;
> > -	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
> > -		return;
> > +	ASSERT(bio->bi_status);
> >  
> >  	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
> >  		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
> 
