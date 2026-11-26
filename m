Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795654461;
	b=fLt1yQSJYMBNALA5r5H9FTRCJXBilZqObSrdHqq5IDSEVindBOx3xUc6wM3ZgMqwYkuw
	 TVSY2rAveDAS1U0SWVPrA9QN4DgHjMtOXCKGrPQ7uBWMRiphfdj7GaGY90oGKmwNPMeYT
	 fBalaKzqOT6Lqu+78a0N7WG1lvFM0OOLLp0UhEiV+nxyEQ2Seq95jkpWlGkJ7ZlqhpBA6
	 kq7PIOp2s9qNcnLtZ2kXesTzxDSDFLPZdBnV4XxYwHCpwmWcrZydzmwZymV51G0/UVtgz
	 DBH5pPPPGauJ5HxpAkhZTKTG61AlcbcmZ009YCNHgcdRYXYPfnIgNkLCB34xNAkO58A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795654461;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=HKnaZ1W7eGPg82X+/Rih4wChv/AEQ68oncV18be81pw=;
	b=qQBz2XCfiiWiiZnCsB5sLpsslC4iGW5511knmpm8nJmG0f5zW7VKBTHtEJ9ggC1WDSpJ
	 0cs6n2sOx8NXk9tHt1c65i67z4dNvaf6f2wNcJzMzO8py+592ovkMMfNVkLNZ6QBEilDV
	 in/zuuNwzlGzeObExYRmTsWLV8w7s5ZmUo3dH1YyeUotC6XmPQWDDz22ox6mgKSiR+ZbM
	 SDLHFOZyDIpeXyiTt3J0o7mSQwA/Fgs/yYUd8e2GEquxXwgnrZWOt3HFWzDeSQ2trUojy
	 kWOAsldw4ChufwiN389fuyVGTNt348U8twJ/BY9ursRD/5DEX89MUfsSlrDUHBmYJWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=JPmxEomm;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Co9FmHHT;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFB8606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 00:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AFB8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=JPmxEomm;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Co9FmHHT
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 311F8EC0B1F
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 19:54:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 19:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1795654460;
	 x=1795740860; bh=HKnaZ1W7eGPg82X+/Rih4wChv/AEQ68oncV18be81pw=; b=
	JPmxEommFiZQpuNqMZeHVzUQTo4SrqNLZ9D/04qfXl2XVIAWzcCwQVugOIhu1YH3
	+aRpoI3C33J1iEjHzFEMmOZ0W5YO0osxD5lKSvaQcPE5ETmu3PtXAeXN1SUP1b66
	bsE1PJQtiUm943L+phrPlo6zKURO0NiaKUy0AmfVLjgQHHvq6L01snPecniZ9JBE
	5v/tyGLL2kmAFood1jJTc+rdfymJUA/mwUDNjRbEOxITT4jDeq4IMLEzyftdmrxO
	X9q0JDB+g7ZbYOrCJPhEk+MMovn+o0fCjmUScUXcc9lM0o6lZmPCl42HJGR5X83D
	VT8+IpshDr82vwY2LWDDJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795654460; x=
	1795740860; bh=HKnaZ1W7eGPg82X+/Rih4wChv/AEQ68oncV18be81pw=; b=C
	o9FmHHTQSgESDBYyOLzB30+nX00Q2zc0K3aiEbsilhh9lh7mYd9tJEBlfaxUndFn
	GaYYDwLYhQoVE4wnHNfv9Psp40di+/zs7OldwRHXBgENPvr3qLRPvJ8I5Eflt2mD
	8BJkzKb6v2ZJxJXD/5ldM+u07xAEdoVauaE5WFkagqjRRckZLaa1WsfNVHfC2/4X
	5W2s8tTxMdZeRfhAhP6iwtUpETENWBz612v2CvJJl4etL7ZHLqwPR/E5RVMwYckn
	zbU1CjRjLwNy51rlbaxVgVQP2667+MpUw2DXmpLfRW+1Lg+tDPM7eiBHb/uSMfGo
	qbND7ydv3UMN5/WHjFrrw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795654460; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:DCneHaY99/xdhnPwFS7hvJWwDr0i9zegjNVdMCC1e4cOVFb
	6wPtck9weFTezwQolvnBZPFPxxldoVW0XhuqSuDdmwtTFYkiBQC42iFgw+NwVFtl
	ZZug5gviPBMchYy4v7mG7ksToAsLEVPoLz+eyw7n3k+Rym/JZR0BQLAaKVtOUNb7
	OVymah1rd5nwwSZ0QqLwV9Qh+vlBHeOweJ6x+QViq/2M7tnMFMTMDHovQ+m65nDa
	lTzBtU3pobhD2PbrCDreRbuUK5uD1pDrVHfXjoJQj4ehg1B4Q+ePjTjelUvv7dld
	Si5E9IDrlJdUwy23FBSScOLtPqMDze+aiEnsRPg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-disposition,content-transfer-encoding,
	content-type,date,feedback-id,from,in-reply-to,message-id,
	mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:54WCL+euzYEZ6oZ+PR1qwzMPlb6lzvv4LCTkEcfkPZY=:vcmbieM6Ru4H0C8JawXLSHkqpIOS3WDkWL6IWsOJTV8=;
X-ME-Sender: <xms:O4MHawyBm0JLmU-z2QhkWVcuPtpcSlqS6_xHpXovtQBPKD_-dFpXsA>
    <xme:O4MHa7uxCCNMJgou1DPwZ_BnEwoecXK_XbyOD2BZl3uhoJDBWchAHX4ls86zJUYVI
    bBQCERnrXAfO-eG9N2ME4KEs0L65tbVV7698GR1Za1wjlnu-03W5vlg>
X-ME-Received: <xmr:O4MHa_u2Q_H34zy8A0szaMJgQaJMGO0gv_u_KGrB2wRnwGM-e0bGpLIU>
X-ME-Proxy-Cause: dmFkZTGe7/lKnMobeTHnI+EWywprO5CUYxstT6KjbFYnq0AtQqeoRc8XKyG3NbPazCghyM
    aXq4e/DswzmVdPwPZ5cCp7j6z6ZcD1G3D+o/kiSCYBERzKb8oedgZn9pf5AWxwDEXbUcgk
    iiow5yaTiAIQoxiUPXvmyxuYzz04gAW99krfi/5wDMVDBHFsS6twJ79SbEmJWpRSmvxhv4
    O9VVRGQVDUNGAaSrlnQ/ZwYEy/KBw55f4ZmdvjbiqpVvLpu5RktMaRMkIkw3zMmIWWnruQ
    5RL4dd4RanWxOa4SuJhO/clguv/du6TSEgmRZrj+/YGN8RLna44DQLC/DraLCpxH1JHDMr
    ejjfIiWHIaUSn8thqMk6XTogBEtb2tGkR0jOIkSo0ZCiPzd6uWR6lgQ4EHorCE1yMtnMMl
    lZtA4ddChdjb0tbYkkaPqrjcqczK9bCCvNldKEn+Wc/d7r+f4x/Q7sr5Kl3Y1C/Nybt5NV
    2q06rH6gOcAgcOSt+2iMk6SA2vxS+syBIIvNYfQ+IRQE+V4iwIk5o+OdnZVYhckKx0H2Oh
    XOAMTHaeOB0d8xMzhOqxfOLuMsMhUGA6fpvdsnE7WGJBEDXGEKR1dJ54aa+SxmWvbcyXc4
    BYcRFb4ftjrQn7mVOPAgoqXt/3n4mQ4V9PRuFYDqIULxeBMiljEVl6jARZmA
X-ME-Proxy: <xmx:O4MHa4PuaNJZDqTYAFVSnMC7ozGj93qw1tKjg1KnF3V4zSUMBxEbFQ>
    <xmx:O4MHa127HMJfpaWY7Oo1ggkbmTQe7oLxJvFEQjckXs4Urr81NIqUNA>
    <xmx:O4MHa8PV3uCnFdjkWSdfJFFcDfhaJ-sAMVEIc6nz48bCFBIggCs0Sg>
    <xmx:O4MHa90_hYrPe_pa9jYyXjk-EbsJ7xQcodL1-S6OQixE9hTRU_eA_w>
    <xmx:PIMHazswBa99AywYtsrtscMgst84uLezjuF7op18673C1NL3qE-ZL0pf>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:54:19 -0500 (EST)
Date: Wed, 25 Nov 2026 16:53:59 -0800
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/4] btrfs: scrub: handle bwlimit below 512KiB
Message-ID: <20261126005359.GA1984368@zen.localdomain>
References: <cover.1795642270.git.boris@bur.io>
 <dae911ee8e0d50741fd4d92b7df57e0ebc2707f4.1795642270.git.boris@bur.io>
 <ebf4531e-584f-4d5f-beac-e81133907863@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ebf4531e-584f-4d5f-beac-e81133907863@suse.com>

On Thu, Nov 26, 2026 at 10:15:45AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/26 08:04, Boris Burkov 写道:
> > scrub_throttle_dev_io() divides a time slice into up to 64 intervals
> > with the computation
> >    div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
> > So at bwlimit below 16MiB/s, the time slice is unitary and above 1GiB/s
> > the slice is split into 64 intervals.
> > 
> > Each interval represents an opportunity to schedule IO and we set a
> > throttle deadline to now + time_slice / div. time_slice is 1000ms or 1s.
> > 
> > At each interval we count bio_size against bwlimit / div, or the portion
> > of the per second bwlimit for that interval. If it is under, we send the
> > bio with no throttling. Otherwise, we throttle till the end of the
> > interval then send the bio.
> > 
> > This ensures that we have a hard cap of 64 sleeps in a second which
> > ensures good throughput for typical unbounded or high limit scrubs.
> > 
> > But because bio_size is always 512KiB and we send at each interval, the
> > practical minimum limit is 512KiB/s, as we will send at least 512KiB
> > every second (the longest possible interval when div = 1).
> > 
> > To support lower limits without ruining throughput at higher limits,
> > change to a model which can sleep for an arbitrary duration to properly
> > amortize the data sent and acheive an average IO demand below bwlimit
> > for bwlimit < 512KiB/s.
> 
> For the bandwidth limit, I doubt if it's really practical to set it so low.
> One 1GiB bg will take over 30min to scrub, which doesn't sound that sane.
> 

I agree in general.

We have a use-case with a remote disk and a bw budget for bg
checking where we would like to set a low limit. If you have a small
amount of metadata and scrub the metadata bg it can be feasible to do
quite slow scrubs and get some good utility.

Would it make more sense if I also sent a patch to extend the scrub
ioctl to have it respect narrower ranges of the disk than the whole
chunk?

> > 
> > However, at higher limits, because the unit of sending is still 512KiB,
> > sleeping between every IO for a naively calculated limit would be far
> > too many sleeps and adds unacceptable sleeping overhead, ruining our
> > ability to even submit at those limits. Therefore, we need to allow a
> > "burst duration" as a floor for the sleeping duration. 10ms is a
> > reasonable value: it is a similar number of sleeps at high limits (100
> > vs 64 per second) and is a responsive duration relatively commensurate
> > in scale with disk latencies and intuitively seems like it would not
> > be "too bursty" at any speed.
> 
> I agree the old sleep behavior is not that good for high limits, especially
> considering how fast modern storage can be.
> 

Sorry if I was unclear but the old behavior should be fast on high
limits, at least as I understand it. My motivation here was:

1. slow scrub needs to sleep for required (possibly long) duration
between IOs.
2. sleep for required duration between IOs done naively makes fast
scrub sleep thousands of times for nanoseconds, now we are harassing
the scheduler for all the sleeping/waking.
3. bring back the upper bound on how often we sleep by always allowing
the burst worth of IO.

So the point is to enable slow scrubs without regressing fast scrubs, I
don't think this patch should help fast scrubs at all. Besides making
the code a little simpler, at least IMO.

> > 
> > Now that we might sleep for a rather long time rather than at most 1s,
> > although the sleeps are cancellable, also add a wakeup/cancel path from
> > changing the limit again. If the user tunes the limit higher, they
> > should just start running rather than needing to cancel.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >   fs/btrfs/scrub.c | 71 +++++++++++++++++++-----------------------------
> >   fs/btrfs/sysfs.c |  2 ++
> >   2 files changed, 30 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index a976897cea8d..d68e8d2f766f 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -57,6 +57,9 @@ struct scrub_ctx;
> >   #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
> > +/* Length of a burst of throttled scrub IO, see scrub_throttle_dev_io(). */
> > +#define SCRUB_THROTTLE_BURST_MS		10
> > +
> >   /* Represent one sector and its needed info to verify the content. */
> >   struct scrub_sector_verification {
> >   	union {
> > @@ -195,9 +198,8 @@ struct scrub_ctx {
> >   	atomic_t		cancel_req;
> >   	int			readonly;
> > -	/* State of IO submission throttling affecting the associated device */
> > -	ktime_t			throttle_deadline;
> > -	u64			throttle_sent;
> > +	/* Earliest time the next read may be submitted under scrub_speed_max. */
> > +	ktime_t			throttle_next;
> >   	bool			is_dev_replace;
> >   	u64			write_pointer;
> > @@ -451,16 +453,19 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
> >   /*
> >    * Pause the scrub, and sleep for the throttle duration. Pausing allows the
> >    * commit to proceed unblocked.
> > - * Scrub cancel interrupts the sleep.
> > + * Scrub cancel or a change of the limit the sleep was computed under
> > + * interrupts the sleep.
> >    */
> > -static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
> > +static void scrub_throttle_sleep(struct scrub_ctx *sctx, struct btrfs_device *device,
> > +				 u64 bwlimit, ktime_t timeout)
> >   {
> >   	struct btrfs_fs_info *fs_info = sctx->fs_info;
> >   	scrub_pause_on(sctx);
> >   	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
> >   					   atomic_read(&fs_info->scrub_cancel_req) ||
> > -					   atomic_read(&sctx->cancel_req),
> > +					   atomic_read(&sctx->cancel_req) ||
> > +					   READ_ONCE(device->scrub_speed_max) != bwlimit,
> 
> One question, do we really need to bother the scrub_speed_max change?
> 
> I think this is a little overengineered, and Sashiko is already report low
> priority problem related to this part.

Yeah we can drop it, I think this was a nice-to-have UX addon. The user
can always cancel if necessary.

> 
> Thanks,
> Qu
> 

Thanks for the review!

> >   					   timeout);
> >   	scrub_pause_off(fs_info);
> >   }
> > @@ -514,7 +519,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
> >   	atomic_set(&sctx->cancel_req, 0);
> >   	spin_lock_init(&sctx->stat_lock);
> > -	sctx->throttle_deadline = 0;
> > +	sctx->throttle_next = 0;
> >   	mutex_init(&sctx->wr_lock);
> >   	if (is_dev_replace) {
> > @@ -1409,54 +1414,34 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
> >   }
> >   /*
> > - * Throttling of IO submission, bandwidth-limit based, the timeslice is 1
> > - * second.  Limit can be set via /sys/fs/UUID/devinfo/devid/scrub_speed_max.
> > + * Throttling of IO submission, bandwidth-limit based. Limit can be set via
> > + * /sys/fs/UUID/devinfo/devid/scrub_speed_max.
> >    */
> >   static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *device,
> >   				  unsigned int bio_size)
> >   {
> > -	const int time_slice = 1000;
> > -	s64 delta;
> > +	const u64 bwlimit = READ_ONCE(device->scrub_speed_max);
> >   	ktime_t now;
> > -	u32 div;
> > -	u64 bwlimit;
> > +	ktime_t ahead;
> > -	bwlimit = READ_ONCE(device->scrub_speed_max);
> >   	if (bwlimit == 0)
> >   		return;
> > -	/*
> > -	 * Slice is divided into intervals when the IO is submitted, adjust by
> > -	 * bwlimit and maximum of 64 intervals.
> > -	 */
> > -	div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
> > -
> > -	/* Start new epoch, set deadline */
> >   	now = ktime_get();
> > -	if (sctx->throttle_deadline == 0) {
> > -		sctx->throttle_deadline = ktime_add_ms(now, time_slice / div);
> > -		sctx->throttle_sent = 0;
> > -	}
> > -
> > -	/* Still in the time to send? */
> > -	if (ktime_before(now, sctx->throttle_deadline)) {
> > -		/* If current bio is within the limit, send it */
> > -		sctx->throttle_sent += bio_size;
> > -		if (sctx->throttle_sent <= div_u64(bwlimit, div))
> > +	ahead = ktime_sub(sctx->throttle_next, now);
> > +	if (ahead < 0) {
> > +		sctx->throttle_next = now;
> > +	} else if (ahead > SCRUB_THROTTLE_BURST_MS * NSEC_PER_MSEC) {
> > +		scrub_throttle_sleep(sctx, device, bwlimit, ahead);
> > +		/* Woken by a limit change: the debt was accrued at the old limit. */
> > +		if (READ_ONCE(device->scrub_speed_max) != bwlimit) {
> > +			sctx->throttle_next = ktime_get();
> >   			return;
> > -
> > -		/* We're over the limit, sleep until the rest of the slice */
> > -		delta = ktime_ms_delta(sctx->throttle_deadline, now);
> > -	} else {
> > -		/* New request after deadline, start new epoch */
> > -		delta = 0;
> > +		}
> >   	}
> > -
> > -	if (delta)
> > -		scrub_throttle_sleep(sctx, ms_to_ktime(delta));
> > -
> > -	/* Next call will start the deadline period */
> > -	sctx->throttle_deadline = 0;
> > +	/* (bytes * (nsec / sec)) / (bytes / sec) ==> nsec */
> > +	sctx->throttle_next = ktime_add_ns(sctx->throttle_next,
> > +				div64_u64((u64)bio_size * NSEC_PER_SEC, bwlimit));
> >   }
> >   /*
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 89b0a4ef4063..4c7f486c2924 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -1928,6 +1928,8 @@ static ssize_t btrfs_devinfo_scrub_speed_max_store(struct kobject *kobj,
> >   	if (*endptr != 0)
> >   		return -EINVAL;
> >   	WRITE_ONCE(device->scrub_speed_max, limit);
> > +	/* A throttled scrub sleeps on this under the old limit. */
> > +	wake_up(&device->fs_info->scrub_pause_wait);
> >   	return len;
> >   }
> >   BTRFS_ATTR_RW(devid, scrub_speed_max, btrfs_devinfo_scrub_speed_max_show,
> 
