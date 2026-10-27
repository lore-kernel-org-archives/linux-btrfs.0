Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112532;
	b=qTW9ULZMOqAPlEQB8tIzTBfkihjCzuWlWxc23nMlu54P3Xox4E/eq5pFMVafa+Vmnjm+
	 bn6TUz+2Zwq70w/hPVofAPMZnlrc54nh5uOFmXqdXBuogzvt7/laqhOBQHgszpOC36QcX
	 v7Yrum6pKsQKJoRTvwa3Ng1Wh1W5bYSuaqoFACZuuzwBqtmBNkscNBT72hNa0tZ0Anbgg
	 FeMBR/dD725e1Xk+tAumOZ20Svva5ilmuIunSwi8O0ZW43CNMK47EV2/nfvHf+fgNDIrh
	 is41Lbr4JWFMAu0YrmDZOZ2l7ip+x11icI6nvVh95SbZ/RGRg2xJ2nN9wYUEaXU+T+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112532;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=bMTKtUBzmCPTnkeWiQ5sE4dUtN2GcFHXBw8QPd9CNCE=;
	b=Vlb2vXljUruNWkqHrHM73uWBIZNIRWurQ67lSPeybw2D2Z8SmuKqsGBndH0tWWKF7AtM
	 CFBKTiidRKaYcwegAsBe41v1TFtt9Yh1jQs7HLyHTp9ehDcEAsYJWcsSnU7z83QhkVqtm
	 BA3gpEGdCfo/ErKFeg70hdsYTnkl+ROUNt5+fy4BqfiTi1GHjOwgCv/BDoZ4rSlqAZGUT
	 zJIAP+zoOD288jr3dvb92GgHoZw0xHz3XNYIXSe+w62Sk98V3eE90RxDkXLXkj5H7Txv+
	 9EEOgzUBamz/eq78JgNg4lKCxS6ojo9IgR1F8QXAMCxCdWsMbTRijK7DFF0IQTyRkRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rvi3BkCY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768D606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3768D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rvi3BkCY
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-353804b591eso7444995eec.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:48:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793112531; cv=none;
        d=google.com; s=arc-20260327;
        b=g+FU08JSwu8bCBdhHWdwar6E0I7a2YzlmnNOpkyRhvlY0kNEMF8+Khd9EPlVWmViAj
         P6q21aB2MhmmgC8qB2Ghxk3Z4AuEcEg3hVG0O8FbOMcZ+U0ag5vPo02RRlDfViuYrmMV
         UM8hxY38cCE6h1LfGRK0FjK29uGlb+J4zyu+9RQLXRgciDGaKofJCVwe0tLhZ3s0uCc1
         +CNq0ZcTRgsokCHFG3eexTz0E14k6i3pO5Ka9lOMq69pODU0QE8PlPTbAMnlDd+gsVvK
         Ut6i+5YerPFykg64Qk404REtOVEqVwj1NKRIt7h6P3784LWDgpGxaB5p6m588ChWlW6m
         SKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bMTKtUBzmCPTnkeWiQ5sE4dUtN2GcFHXBw8QPd9CNCE=;
        fh=D7tJ5qHN0+SESQT0D/gyxhEPfiL27Q0ATfsEm/dhTNQ=;
        b=JI5LlRkCv74GB0nizt2Ih4sEPyiukaUQu0Cn/roAxTM/1cAWIMRKCQaY2GH+Pf22L6
         nXsUHOWJ31gUHA5l8coQExYF0keTS/LduuK9Ly66ylVkmV8jIGLQOAxzm84r/owl8vNT
         7SxsNpbcTP3ltM0Rax+qrGfZ5rZvAEcKWAGMh0wZy9xe6y4ST6HoZEVVEpOWT/UAmdR6
         Zxmz9sw7eqXiSWV82BnZ4g6MvqfM8iNwOpZktmQIvNFpWrWat52Q+RWzGNv7cjAp/tkj
         1ocQdmdpYS+eZJw+IM825TJzb2zuiiM0PsEAmmAO3PEYTWrDUNl0gCQUgRNbcfhMq5SL
         NRig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793112531; x=1793717331; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bMTKtUBzmCPTnkeWiQ5sE4dUtN2GcFHXBw8QPd9CNCE=;
        b=Rvi3BkCYSYfzOgJgOkQyB2tTkqGyBGHC+KDcKSsI5yuHwejlXqhvY2CuJ8XWmTV15I
         at8EvX3AQh6r2jSg66cM/KMCQWcOyyOrlmMYbwQKTJNpY69F7M8TqmRYVKnkmU+INlUB
         +sLVhwCOZ0nI8L4PF/IoVG5h9YuDr6KNYQZSkGeK36Ftvp8GuHkCCMJ3uyAbmCZyKsCf
         GxP6bc+StxK1JJDInInPRUwBF70zj+sWRmREwMT4dqNWvctDlDVAOJi0b0gsisEyBuKx
         TPz9Y+gnS9GV8qRJqFqDoOH7WjHs5l2e7FzvYNGzbmwVNbs6VJDx7gRx0OyGdGiL4Ad2
         OGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793112531; x=1793717331;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bMTKtUBzmCPTnkeWiQ5sE4dUtN2GcFHXBw8QPd9CNCE=;
        b=GUto2qgw8BHO43GJkrFPT7sYF2hJQ8sgZ+mJox4eyxzNcplyhptMXZBm54GLJ9E9py
         NHJyj21hvgt+1jyChhfdTIoK6FjGbzUv9yI+x3flGiSUAn36nP+9+NhacMWuN9PT+PNl
         sBcJ/1ADB230y82bz/nhw2UtDWMrMWBGG4Cba6vj9w6TI0do0YnJH8TJkC3Qy8w7ErBY
         VJFOBfuEd+sKu+WopjVPaa1FKsg0jEIdy/B26oNn/QHwpWmrX7suuG0pFsf9p30Od2Jv
         nb6HiCKsb66ABT5ik8UMgaxXAvZ/Bb1cpAKh2VoXR932LLNS33z6a9qetMJQvkSU0Enk
         Q8Gg==
X-Forwarded-Encrypted: i=1; AKwUvBzufmsDSZ8HIUp5NrF3CeWixDMACpsqC21ILIwmvd4BylC1WIlvWyTdupFSn1tFDTOKTWI3zA6AbNrCQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJwMcnTLcRJed6GKMypnJdulrnNqQVyhngCAeIQG9gJq+yG89LS
	T42/ImIqrYhHYzh0iB6fDEz6cMMgqyciJWYWrGKb8tjT0nlsuEPfHUEWqJkhm4RQZOS/UhHT0Lz
	jJ+uGf7QcxzVZRFlDhknpcqR70kBqO+U=
X-Gm-Gg: AYBFou12jAuCjIpyV9QJbagZl5ACHkTfZOEBcufWiKLd6udXxaRXwf238Gm1gZnHq42
	XY0+xma8Ko6pJt6j3vKWBKsbQvWA0KBLbe/Y62ECHqN98Mnefiqc1QO5FeTdqcWirTN0Nw9SY++
	YT1X0Gm13DPgYp9XPbDXmFJBqDIoTqE3mNjFCiuz85sxRzwdTBgirctkzqGYNEZVSrAYLpV7J2r
	yIHA1jZznGKyK8JMARxGekGebCRumwX4AbvY8Eov+LXL9QS+5d6V/7gODGzcMcTv64J4no/CC3G
	UeUFLxBgEvo7vqembILozQnqtV62kwIuyXNavr8cgCNG+SczfrmiVQ+l1kYbGzRDAnmXcA8iZqG
	hhMi1ynhCtXmzj+6NOQ0Z3KwzI2aiYg3gLWf2tBGoWvtk/sLy46cXhE9FfP1nk7buQUExXhgSM8
	/HWv9LRjU0IFrgrHh16zOabvZep545nEQ8JIf9uFrXZ0Db7g==
X-Received: by 2002:a05:693c:6206:b0:36a:dbb:2607 with SMTP id
 5a478bee46e88-36a0dbb4fd4mr4524952eec.23.1793112530884; Tue, 27 Oct 2026
 07:48:50 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAEmTpZGu5x9PS7vFwgc_dFH80rL3cFD4-geuuL_w8i=vFDo8AA@mail.gmail.com>
 <52925d79-4dce-4621-b9e1-fd062b47e35d@wdc.com>
In-Reply-To: <52925d79-4dce-4621-b9e1-fd062b47e35d@wdc.com>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 27 Oct 2026 19:48:38 +0500
X-Gm-Features: AclHuK9cOSmFsR2g2E8QdJz-sb9spC7usp4ACkTou4qLNNRyiBLa1H1T0ER5iq4
Message-ID: <CAEmTpZGifFxr+yaKddZcG8UxhntYvZROygi6s-8goAoxuUzqHQ@mail.gmail.com>
Subject: Re: [RFC] btrfs: zoned: reset stale zones in unallocated device space
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000729e65065ed38b76"

--000000000000729e65065ed38b76
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

I rebased your patch onto current master and found a few problems in
review, so I reworked it. v2 is attached. Main issues:

1) Data loss during device replace: the replace target has no chunk
   stripes until the replace finishes, so all data already copied to
   it was reset, and the resumed replace never copies it again.
   Trigger: start a replace, umount or remount,ro, then mount rw.
   v2 skips the pass while a replace is ongoing.

2) Races: chunks can be allocated (data reloc bg, transaction kthread)
   and removed (relocating repair after a read error) while the pass
   runs, and the removal is not committed yet. v2 takes
   reclaim_bgs_lock, commits, and holds chunk_mutex.

3) Used zones: v1 marked only the zone where each stripe starts. Today
   stripes are exactly one zone long, but mount does not enforce that,
   so a longer stripe would get its other zones reset. v2 checks
   device->alloc_state instead, the allocator's own record of which
   ranges belong to chunks, over the full stripe length. This also
   drops the bitmap allocation that could fail the mount.

4) Zones that must not be reset: zones beyond total_bytes, read-only
   devices, offline and read-only zones. v2 skips them.

5) v2 resets adjacent zones in one call and logs each reset range.

The commit message also now says why the existing code does not help:
btrfs_find_allocatable_zones() skips non-empty zones, so leaked zones
are never reused. And the typo in your Signed-off-by is fixed.

I used an AI assistant (Claude) for the review and for v2. v2 is build
tested and checkpatch clean, not runtime tested yet.

Please check that it still covers the case you hit, and tell me if you
prefer to fold it into your patch or keep it as a fix on top.

Thanks,
Mark


=D0=B2=D1=82, 27 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 15:27, Joh=
annes Thumshirn <johannes.thumshirn@wdc.com>:
>
> On 10/27/26 9:36 AM, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
> > Hi,
> >
> > I'd like to propose a feature for zoned btrfs. I'm not planning to
> > implement it myself, but I'd like to get feedback and, if the idea is
> > considered reasonable, have it tracked as a TODO / project idea.
> >
> > Background
> > ----------
> > I maintain a host-managed zoned block device implemented with ublk,
> > where each zone is backed by S3 objects. Storage cost is proportional
> > to the amount of data actually held in zones, so zones that contain
> > data but are not referenced by the filesystem are a real cost, not
> > just lost capacity.
> >
> > Problem
> > -------
> > With a long commit interval (e.g. commit=3D300) and heavy buffered
> > writes, btrfs may allocate new block groups and write a large amount
> > of data into their zones before the transaction commits. If the
> > filesystem then goes down uncleanly before the commit, this is fine
> > from a consistency point of view: nobody called fsync(), and after
> > the next mount the filesystem is consistent at the last committed
> > transaction.
> >
> > For a virtual device like mine, "goes down uncleanly" is more likely
> > the ublk server crashing or losing connectivity to S3 than an actual
> > power loss, but the effect on btrfs is the same: the running
> > transaction never commits.
> >
> > The device extents of those new block groups were never persisted, so
> > after the next mount the corresponding zones belong to unallocated
> > device space from btrfs' point of view, while on the device they are
> > still non-empty (write pointer > zone start) and hold data.
>
> I have a patch lying around doing this in an old stale branch. I've
> attached it, but not tried rebasing it onto latest for-next. If you're
> brave enough to test it I'd be happy.
>
>
> > As far as I can tell, btrfs currently handles this lazily: such zones
> > are reset only when the allocator picks that range for a new chunk
> > (btrfs_ensure_empty_zones()). Until then they hold stale data
> > indefinitely. On SMR HDDs this does not matter much, but on ZNS SSDs
> > (where a reset helps the device's internal GC) and especially on
> > virtual/cloud-backed zoned devices it does.
> >
> > (Stale data past the committed alloc_offset inside *existing* block
> > groups is accounted as zone_unusable and can only be reclaimed via
> > relocation; this proposal does not try to address that case.)
> >
> > Current workaround
> > ------------------
> > The only safe way I see today is offline: unmount, walk the dev tree
> > to collect allocated dev extents, and issue BLKRESETZONE for every
> > non-empty sequential zone not covered by a dev extent. Doing this on
> > a mounted filesystem from userspace is unsafe, because it races with
> > chunk allocation (a dev extent may be allocated in the running
> > transaction but not yet visible in the committed dev tree).
> >
> > Proposal
> > --------
> > Let the kernel do it, since it can serialize against chunk allocation
> > (chunk_mutex / device->alloc_state). The operation itself: reset
> > every sequential zone that is fully contained in unallocated device
> > space and whose write pointer is not at the zone start.
> >
> > Possible interfaces, in order of my preference:
> >
> >   1. Automatic background cleanup, e.g. once after mount (after the
> >      dev extents are loaded) and/or as part of the existing
> >      reclaim/discard workers, possibly behind a mount option or sysfs
> >      knob. This requires no administrator action and covers the
> >      problem completely.
> >
> >   2. FITRIM: on zoned filesystems, apply the reset to unallocated
> >      device space as part of fstrim. Many distributions already run
> >      fstrim periodically (fstrim.timer), so this would also work
> >      without extra configuration in most setups, and it fits the
> >      "release unused space to the device" semantics.
> >
> >   3. A dedicated trigger: a new ioctl (exposed as a btrfs-progs
> >      subcommand) or a sysfs knob under /sys/fs/btrfs/<UUID>/ that
> >      starts the cleanup on demand. Least convenient, but still much
> >      better than the current offline-only workaround.
> >
> > Risk
> > ----
> > With corrupted metadata (a dev extent missing from the dev tree),
> > this could reset a zone that actually holds live data. But the
> > allocator already makes exactly the same assumption today when it
> > resets non-empty zones before reusing them, so this does not add a
> > new class of risk; it only performs the reset earlier. If automatic
> > cleanup is considered too aggressive, options 2 and 3 are explicit
> > and opt-in.
> >
> > Questions
> > ---------
> >   - Does this sound like something you would accept upstream?
> >   - Which interface would you prefer?
> >   - Am I missing a reason why the reset is intentionally deferred to
> >     allocation time?
> >
> > If the idea is acceptable, I'd appreciate it being added to the btrfs
> > TODO list so that someone interested could pick it up.
> >
> > Thanks,
> > Korenberg Mark
>


--=20
Segmentation fault

--000000000000729e65065ed38b76
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="v2-0001-btrfs-zoned-reset-leaked-zones-on-read-write-moun.patch"
Content-Disposition: attachment; 
	filename="v2-0001-btrfs-zoned-reset-leaked-zones-on-read-write-moun.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvqsvrpc0>
X-Attachment-Id: f_mvqsvrpc0

RnJvbSBjYzA5Mjk5MmZlMDUwYjRlZGNkZTY5MTgyOTQzNWExZTA5YjRmYjQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPgpEYXRlOiBUdWUsIDggU2VwIDIwMjYgMTE6NDI6MDUgKzAyMDAKU3ViamVjdDog
W1BBVENIIHYyXSBidHJmczogem9uZWQ6IHJlc2V0IGxlYWtlZCB6b25lcyBvbiByZWFkLXdyaXRl
IG1vdW50CgpJZiBhIHRyYW5zYWN0aW9uIGNvbW1pdCBpcyBhYm9ydGVkIGFmdGVyIHRoZSB6b25l
cyBvZiBhIG5ldyBibG9jayBncm91cAp3ZXJlIHdyaXR0ZW4gYnV0IGJlZm9yZSB0aGUgc3VwZXJi
bG9jayB3YXMsIHRoZSBjaHVuayBpdGVtIGFuZCB0aGUgZGV2CmV4dGVudCBhcmUgbmV2ZXIgcGVy
c2lzdGVkIGFuZCB0aGUgem9uZXMgbGVhay4gVGhlIGNodW5rIGFsbG9jYXRvciBza2lwcwpub24t
ZW1wdHkgem9uZXMsIHNvIHRoZXkgYXJlIG5ldmVyIHJldXNlZCwgb3BlbiBvbmVzIGtlZXAgY291
bnRpbmcKYWdhaW5zdCB0aGUgYWN0aXZlIHpvbmUgbGltaXQsIGFuZCBidHJmcyBjaGVjayByZXBv
cnRzIHRoZW0gYXMKdW5yZWZlcmVuY2VkLgoKT24gYSByZWFkLXdyaXRlIG1vdW50LCByZXNldCBl
dmVyeSBub24tZW1wdHkgc2VxdWVudGlhbCB6b25lIHRoYXQgaXMKbmVpdGhlciBhIHN1cGVyYmxv
Y2sgbG9nIHpvbmUgbm9yIGFsbG9jYXRlZCB0byBhIGNodW5rLiBDb21taXQgdGhlCnJ1bm5pbmcg
dHJhbnNhY3Rpb24gdW5kZXIgcmVjbGFpbV9iZ3NfbG9jayBmaXJzdCwgc28gdGhhdCBhIGNodW5r
CnJlbW92YWwgaXMgbm90IG1pc3Rha2VuIGZvciBhIGxlYWssIGhvbGQgY2h1bmtfbXV0ZXggc28g
dGhhdCBubyBjaHVuayBpcwphbGxvY2F0ZWQgbWVhbndoaWxlLCBhbmQgc2tpcCBpdCBhbGwgd2hp
bGUgYSBkZXZpY2UgcmVwbGFjZSBpcyBvbmdvaW5nLAphcyBubyBjaHVuayByZWZlcmVuY2VzIHRo
ZSByZXBsYWNlIHRhcmdldCB5ZXQuCgpTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4g
PGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPgotLS0KCk5vdGVzOgogICAgQ2hhbmdlcyBpbiB2
MjoKICAgIC0gU2tpcCB3aGlsZSBhIGRldmljZSByZXBsYWNlIGlzIG9uZ29pbmc7IHYxIHJlc2V0
IHRoZSBkYXRhIGFscmVhZHkKICAgICAgY29waWVkIHRvIHRoZSByZXBsYWNlIHRhcmdldC4KICAg
IC0gSG9sZCBjaHVua19tdXRleDsgdjEgcmFjZWQgd2l0aCBjaHVuayBhbGxvY2F0aW9uIGluIG9w
ZW5fY3RyZWUoKS4KICAgIC0gSG9sZCByZWNsYWltX2Jnc19sb2NrIGFuZCBjb21taXQgZmlyc3Q7
IHYxIGNvdWxkIHJlc2V0IHRoZSB6b25lcyBvZiBhCiAgICAgIGNodW5rIHJlbW92ZWQgYnkgYSBy
ZWxvY2F0aW5nIHJlcGFpciBiZWZvcmUgdGhlIHJlbW92YWwgd2FzIGNvbW1pdHRlZC4KICAgIC0g
Q2hlY2sgY292ZXJhZ2UgaW4gZGV2aWNlLT5hbGxvY19zdGF0ZTogY292ZXJzIHdob2xlIHN0cmlw
ZXMsIG5vCiAgICAgIGJpdG1hcCBhbGxvY2F0aW9uLCBubyBOVUxMIHBoeXNpY2FsX21hcCBjYXNl
LgogICAgLSBXYWxrIGFsbG9jX2xpc3QgKHdyaXRlYWJsZSBkZXZpY2VzKSB1bmRlciBjaHVua19t
dXRleCBpbnN0ZWFkIG9mIHRoZQogICAgICBkZXZpY2UgbGlzdCB1bmRlciBkZXZpY2VfbGlzdF9t
dXRleCwgb25seSB1cCB0byB0b3RhbF9ieXRlcy4KICAgIC0gU2tpcCBvZmZsaW5lIGFuZCByZWFk
LW9ubHkgem9uZXMsIHRoZXkgY2Fubm90IGJlIHJlc2V0LgogICAgLSBSZXNldCBhZGphY2VudCB6
b25lcyBpbiBvbmUgY2FsbCBhbmQgbG9nIGVhY2ggcmVzZXQgcmFuZ2UuCiAgICAKICAgIFJldmll
d2VkIHdpdGggdGhlIGhlbHAgb2YgYW4gQUkgYXNzaXN0YW50IChDbGF1ZGUpLCB3aGljaCBhbHNv
IGRyYWZ0ZWQKICAgIHRoZSB2MiBjaGFuZ2VzLiBCdWlsZCB0ZXN0ZWQgb25seS4KCiBmcy9idHJm
cy9kaXNrLWlvLmMgfCAgIDIgKwogZnMvYnRyZnMvem9uZWQuYyAgIHwgMTU5ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogZnMvYnRyZnMvem9uZWQuaCAgIHwg
ICAzICsKIDMgZmlsZXMgY2hhbmdlZCwgMTY0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9m
cy9idHJmcy9kaXNrLWlvLmMgYi9mcy9idHJmcy9kaXNrLWlvLmMKaW5kZXggYzQ1Y2RhNDI5MGQ1
Li5mM2UxNWM1NzVlOGEgMTAwNjQ0Ci0tLSBhL2ZzL2J0cmZzL2Rpc2staW8uYworKysgYi9mcy9i
dHJmcy9kaXNrLWlvLmMKQEAgLTMwNTksNiArMzA1OSw4IEBAIGludCBidHJmc19zdGFydF9wcmVf
cndfbW91bnQoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8pCiAJaW50IHJldDsKIAlib29s
IHJlYnVpbGRfZnJlZV9zcGFjZV90cmVlID0gZmFsc2U7CiAKKwlidHJmc19yZXNldF91bnJlZmVy
ZW5jZWRfem9uZXMoZnNfaW5mbyk7CisKIAlpZiAoYnRyZnNfdGVzdF9vcHQoZnNfaW5mbywgQ0xF
QVJfQ0FDSEUpICYmCiAJICAgIGJ0cmZzX2ZzX2NvbXBhdF9ybyhmc19pbmZvLCBGUkVFX1NQQUNF
X1RSRUUpKSB7CiAJCWlmIChidHJmc19mc19pbmNvbXBhdChmc19pbmZvLCBFWFRFTlRfVFJFRV9W
MikpCmRpZmYgLS1naXQgYS9mcy9idHJmcy96b25lZC5jIGIvZnMvYnRyZnMvem9uZWQuYwppbmRl
eCAxY2RhODgzMzIyODQuLjhiMDMzMWJjOGZhYiAxMDA2NDQKLS0tIGEvZnMvYnRyZnMvem9uZWQu
YworKysgYi9mcy9idHJmcy96b25lZC5jCkBAIC0zMjI2LDYgKzMyMjYsMTY1IEBAIGludCBidHJm
c19yZXNldF91bnVzZWRfYmxvY2tfZ3JvdXBzKHN0cnVjdCBidHJmc19zcGFjZV9pbmZvICpzcGFj
ZV9pbmZvLCB1NjQgbnVtCiAJcmV0dXJuIDA7CiB9CiAKKy8qCisgKiBBIHpvbmUgaXMgbGVha2Vk
IGlmIGl0IGlzIGEgbm9uLWVtcHR5IHNlcXVlbnRpYWwgem9uZSB0aGF0IGlzIG5laXRoZXIgYQor
ICogc3VwZXJibG9jayBsb2cgem9uZSBub3IgcGFydCBvZiBhbnkgc3RyaXBlIG9mIGFueSBjaHVu
ay4gQ2h1bmsgc3RyaXBlcyBhcmUKKyAqIGxvb2tlZCB1cCBpbiB0aGUgZGV2aWNlJ3MgYWxsb2Nf
c3RhdGUsIHdoaWNoIGNvdmVycyBldmVyeSBjaHVuayBpbiB0aGUKKyAqIG1hcHBpbmcgdHJlZSBv
dmVyIHRoZSB3aG9sZSBzdHJpcGUgbGVuZ3RoLgorICovCitzdGF0aWMgYm9vbCBpc19sZWFrZWRf
em9uZShzdHJ1Y3QgYnRyZnNfZGV2aWNlICpkZXZpY2UsIHUzMiB6bm8pCit7CisJc3RydWN0IGJ0
cmZzX3pvbmVkX2RldmljZV9pbmZvICp6aW5mbyA9IGRldmljZS0+em9uZV9pbmZvOworCXU2NCBz
dGFydCA9ICh1NjQpem5vIDw8IHppbmZvLT56b25lX3NpemVfc2hpZnQ7CisJc3RydWN0IGJsa196
b25lIHpvbmU7CisJdW5zaWduZWQgaW50IG5vZnNfZmxhZ3M7CisJaW50IHJldDsKKworCWlmICgh
YnRyZnNfZGV2X2lzX3NlcXVlbnRpYWwoZGV2aWNlLCBzdGFydCkpCisJCXJldHVybiBmYWxzZTsK
KworCWlmIChidHJmc19kZXZfaXNfZW1wdHlfem9uZShkZXZpY2UsIHN0YXJ0KSkKKwkJcmV0dXJu
IGZhbHNlOworCisJaWYgKGJ0cmZzX3Rlc3RfcmFuZ2VfYml0X2V4aXN0cygmZGV2aWNlLT5hbGxv
Y19zdGF0ZSwgc3RhcnQsCisJCQkJCXN0YXJ0ICsgemluZm8tPnpvbmVfc2l6ZSAtIDEsCisJCQkJ
CUNIVU5LX0FMTE9DQVRFRCkpCisJCXJldHVybiBmYWxzZTsKKworCWZvciAoaW50IG1pcnJvciA9
IDA7IG1pcnJvciA8IEJUUkZTX1NVUEVSX01JUlJPUl9NQVg7IG1pcnJvcisrKSB7CisJCXUzMiBz
Yl96bm8gPSBzYl96b25lX251bWJlcih6aW5mby0+em9uZV9zaXplX3NoaWZ0LCBtaXJyb3IpOwor
CisJCWlmIChzYl96bm8gKyBCVFJGU19OUl9TQl9MT0dfWk9ORVMgPiB6aW5mby0+bnJfem9uZXMp
CisJCQljb250aW51ZTsKKwkJaWYgKHpubyA+PSBzYl96bm8gJiYgem5vIDwgc2Jfem5vICsgQlRS
RlNfTlJfU0JfTE9HX1pPTkVTKQorCQkJcmV0dXJuIGZhbHNlOworCX0KKworCS8qCisJICogT2Zm
bGluZSBhbmQgcmVhZC1vbmx5IHpvbmVzIGFyZSBuZXZlciBtYXJrZWQgZW1wdHkgZWl0aGVyLCBi
dXQgdGhleQorCSAqIGNhbm5vdCBiZSByZXNldC4gVGhlaXIgY29uZGl0aW9uIGlzIG5vdCBjYWNo
ZWQsIHNvIGFzayB0aGUgZGV2aWNlLgorCSAqIFdlIGhvbGQgY2h1bmtfbXV0ZXggaGVyZSwgc28g
ZG9uJ3QgcmVjdXJzZSBpbnRvIHRoZSBmaWxlc3lzdGVtLgorCSAqLworCW5vZnNfZmxhZ3MgPSBt
ZW1hbGxvY19ub2ZzX3NhdmUoKTsKKwlyZXQgPSBidHJmc19nZXRfZGV2X3pvbmUoZGV2aWNlLCBz
dGFydCwgJnpvbmUpOworCW1lbWFsbG9jX25vZnNfcmVzdG9yZShub2ZzX2ZsYWdzKTsKKwlpZiAo
cmV0KQorCQlyZXR1cm4gZmFsc2U7CisKKwlpZiAoem9uZS5jb25kID09IEJMS19aT05FX0NPTkRf
T0ZGTElORSkKKwkJcmV0dXJuIGZhbHNlOworCisJaWYgKHpvbmUuY29uZCA9PSBCTEtfWk9ORV9D
T05EX1JFQURPTkxZKQorCQlyZXR1cm4gZmFsc2U7CisKKwlyZXR1cm4gdHJ1ZTsKK30KKwordm9p
ZCBidHJmc19yZXNldF91bnJlZmVyZW5jZWRfem9uZXMoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZz
X2luZm8pCit7CisJc3RydWN0IGJ0cmZzX2ZzX2RldmljZXMgKmZzX2RldmljZXMgPSBmc19pbmZv
LT5mc19kZXZpY2VzOworCXN0cnVjdCBidHJmc19kZXZfcmVwbGFjZSAqZGV2X3JlcGxhY2UgPSAm
ZnNfaW5mby0+ZGV2X3JlcGxhY2U7CisJc3RydWN0IGJ0cmZzX2RldmljZSAqZGV2aWNlOworCWJv
b2wgcmVwbGFjZV9vbmdvaW5nOworCWludCByZXQ7CisKKwlpZiAoIWJ0cmZzX2lzX3pvbmVkKGZz
X2luZm8pKQorCQlyZXR1cm47CisKKwkvKgorCSAqIE5vIGNodW5rIHN0cmlwZSBwb2ludHMgdG8g
dGhlIHRhcmdldCBvZiBhbiBpbnRlcnJ1cHRlZCBkZXZpY2UgcmVwbGFjZQorCSAqIHVudGlsIHRo
ZSByZXBsYWNlIGZpbmlzaGVzLCBzbyB0aGUgZGF0YSBhbHJlYWR5IGNvcGllZCB0byBpdCB3b3Vs
ZAorCSAqIGxvb2sgbGVha2VkLiBUaGUgcmVwbGFjZSByZXN1bWVzIGZyb20gdGhlIGxhc3QgY29t
bWl0dGVkIGN1cnNvciBhbmQKKwkgKiB3b3VsZCBuZXZlciBjb3B5IHRoYXQgZGF0YSBhZ2Fpbi4K
KwkgKgorCSAqIFRoZSB0YXJnZXQgaXMgbm90IG9uIGFsbG9jX2xpc3QsIHdoaWNoIGlzIHdhbGtl
ZCBiZWxvdywgc28gc3RyaWN0bHkKKwkgKiBzcGVha2luZyBpdCB3b3VsZCBiZSBlbm91Z2ggdG8g
c2tpcCBvbmx5IHRoZSBkZXZpY2UgdGhhdCBoYXMKKwkgKiBCVFJGU19ERVZfU1RBVEVfUkVQTEFD
RV9UR1Qgc2V0LiBTdGlsbCwgZG8gbm90IHJlc2V0IGFueXRoaW5nIGF0IGFsbAorCSAqIHdoaWxl
IGEgcmVwbGFjZSBpcyBvbmdvaW5nLCB0aGUgbGVha2VkIHpvbmVzIGNhbiBiZSByZWNsYWltZWQg
b24gdGhlCisJICogbmV4dCBtb3VudCBhZnRlciB0aGUgcmVwbGFjZSBoYXMgZmluaXNoZWQgb3Ig
d2FzIGNhbmNlbGVkLgorCSAqCisJICogRG8gbm90IGhvbGQgdGhlIHJ3c2VtIGFjcm9zcyB0aGUg
cGFzcywgdGhlIHJlcGxhY2UgY29kZSB0YWtlcyBpdAorCSAqIGFmdGVyIGNodW5rX211dGV4LiBB
IHJlcGxhY2UgY2Fubm90IGJlIHN0YXJ0ZWQgd2hpbGUgd2UgYXJlIGluIHRoZQorCSAqIChyZSlt
b3VudCBwYXRoLgorCSAqLworCWRvd25fcmVhZCgmZGV2X3JlcGxhY2UtPnJ3c2VtKTsKKwlyZXBs
YWNlX29uZ29pbmcgPSBidHJmc19kZXZfcmVwbGFjZV9pc19vbmdvaW5nKGRldl9yZXBsYWNlKTsK
Kwl1cF9yZWFkKCZkZXZfcmVwbGFjZS0+cndzZW0pOworCWlmIChyZXBsYWNlX29uZ29pbmcpIHsK
KwkJYnRyZnNfaW5mbyhmc19pbmZvLAorCQkJICAgInpvbmVkOiBkZXZpY2UgcmVwbGFjZSBpcyBv
bmdvaW5nLCBub3QgcmVzZXR0aW5nIGxlYWtlZCB6b25lcyIpOworCQlyZXR1cm47CisJfQorCisJ
LyoKKwkgKiBDaHVua3MgYXJlIG9ubHkgcmVtb3ZlZCB1bmRlciByZWNsYWltX2Jnc19sb2NrLCBh
bmQgdGhlaXIgem9uZXMgbXVzdAorCSAqIG5vdCBiZSByZXNldCBiZWZvcmUgdGhlIHJlbW92YWwg
aXMgY29tbWl0dGVkLiBBIHJlbG9jYXRpbmcgcmVwYWlyLAorCSAqIHN0YXJ0ZWQgYnkgYSByZWFk
IGVycm9yIGR1cmluZyBtb3VudCwgbWF5IGFscmVhZHkgaGF2ZSByZW1vdmVkIG9uZSBpbgorCSAq
IHRoZSBydW5uaW5nIHRyYW5zYWN0aW9uLCBzbyBjb21taXQgaXQgYmVmb3JlIGxvb2tpbmcgZm9y
IGxlYWtlZCB6b25lcy4KKwkgKi8KKwltdXRleF9sb2NrKCZmc19pbmZvLT5yZWNsYWltX2Jnc19s
b2NrKTsKKwlyZXQgPSBidHJmc19jb21taXRfY3VycmVudF90cmFuc2FjdGlvbihmc19pbmZvLT50
cmVlX3Jvb3QpOworCWlmIChyZXQpIHsKKwkJYnRyZnNfd2Fybihmc19pbmZvLAorCQkJICAgInpv
bmVkOiBmYWlsZWQgdG8gY29tbWl0IHRyYW5zYWN0aW9uLCBub3QgcmVzZXR0aW5nIGxlYWtlZCB6
b25lczogJXBlIiwKKwkJCSAgIEVSUl9QVFIocmV0KSk7CisJCWdvdG8gb3V0OworCX0KKworCS8q
CisJICogSG9sZCBjaHVua19tdXRleCwgd2hpY2ggYWxzbyBwcm90ZWN0cyBhbGxvY19saXN0LCBz
byB0aGF0IG5vIGNodW5rIGNhbgorCSAqIGJlIGFsbG9jYXRlZCBiZXR3ZWVuIGNoZWNraW5nIGEg
em9uZSBhbmQgcmVzZXR0aW5nIGl0LgorCSAqLworCW11dGV4X2xvY2soJmZzX2luZm8tPmNodW5r
X211dGV4KTsKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGRldmljZSwgJmZzX2RldmljZXMtPmFsbG9j
X2xpc3QsIGRldl9hbGxvY19saXN0KSB7CisJCXN0cnVjdCBidHJmc196b25lZF9kZXZpY2VfaW5m
byAqemluZm8gPSBkZXZpY2UtPnpvbmVfaW5mbzsKKwkJdTMyIG5yX3pvbmVzOworCisJCWlmICgh
ZGV2aWNlLT5iZGV2IHx8ICF6aW5mbyB8fCAhYmRldl9pc196b25lZChkZXZpY2UtPmJkZXYpKQor
CQkJY29udGludWU7CisKKwkJLyogTm90aGluZyBpcyBldmVyIGFsbG9jYXRlZCBiZXlvbmQgdG90
YWxfYnl0ZXMsIGxlYXZlIGl0IGFsb25lLiAqLworCQlucl96b25lcyA9IG1pbl90KHU2NCwgemlu
Zm8tPm5yX3pvbmVzLAorCQkJCSBkZXZpY2UtPnRvdGFsX2J5dGVzID4+IHppbmZvLT56b25lX3Np
emVfc2hpZnQpOworCisJCWZvciAodTMyIHpubyA9IDA7IHpubyA8IG5yX3pvbmVzOyB6bm8rKykg
eworCQkJdTMyIGZpcnN0ID0gem5vOworCQkJdTY0IHJlc2V0X2J5dGVzOworCisJCQljb25kX3Jl
c2NoZWQoKTsKKworCQkJd2hpbGUgKHpubyA8IG5yX3pvbmVzICYmIGlzX2xlYWtlZF96b25lKGRl
dmljZSwgem5vKSkKKwkJCQl6bm8rKzsKKwkJCWlmICh6bm8gPT0gZmlyc3QpCisJCQkJY29udGlu
dWU7CisKKwkJCXJldCA9IGJ0cmZzX3Jlc2V0X2RldmljZV96b25lKGRldmljZSwKKwkJCQkJCSAg
ICAgICh1NjQpZmlyc3QgPDwgemluZm8tPnpvbmVfc2l6ZV9zaGlmdCwKKwkJCQkJCSAgICAgICh1
NjQpKHpubyAtIGZpcnN0KSA8PCB6aW5mby0+em9uZV9zaXplX3NoaWZ0LAorCQkJCQkJICAgICAg
JnJlc2V0X2J5dGVzKTsKKwkJCS8qCisJCQkgKiBPbiBmYWlsdXJlIHRoZSBydW4gY291bGQgYmUg
cmV0cmllZCB6b25lIGJ5IHpvbmUsIHNvIHRoYXQKKwkJCSAqIGEgc2luZ2xlIHpvbmUgZmFpbGlu
ZyB0byByZXNldCBkb2VzIG5vdCBrZWVwIHRoZSBvdGhlcgorCQkJICogem9uZXMgb2YgdGhlIHJ1
biBmcm9tIGJlaW5nIHJlY2xhaW1lZC4gQSBmYWlsZWQgcmVzZXQgaXMKKwkJCSAqIGxpa2VseSBz
bG93IGFscmVhZHksIHNvIGp1c3QgbG9nIGl0IGFuZCBtb3ZlIG9uLCB0aGUgcnVuCisJCQkgKiBp
cyByZXRyaWVkIG9uIHRoZSBuZXh0IG1vdW50LgorCQkJICovCisJCQlpZiAocmV0KQorCQkJCWJ0
cmZzX3dhcm4oZnNfaW5mbywKKwkJCQkJICAgInpvbmVkOiBmYWlsZWQgdG8gcmVzZXQgbGVha2Vk
IHpvbmVzICV1LSV1IG9uIGRldmljZSAlcyAoZGV2aWQgJWxsdSk6ICVwZSIsCisJCQkJCSAgIGZp
cnN0LCB6bm8gLSAxLCBidHJmc19kZXZfbmFtZShkZXZpY2UpLAorCQkJCQkgICBkZXZpY2UtPmRl
dmlkLCBFUlJfUFRSKHJldCkpOworCQkJZWxzZQorCQkJCWJ0cmZzX2luZm8oZnNfaW5mbywKKwkJ
CQkJICAgInpvbmVkOiByZXNldCBsZWFrZWQgem9uZXMgJXUtJXUgb24gZGV2aWNlICVzIChkZXZp
ZCAlbGx1KSIsCisJCQkJCSAgIGZpcnN0LCB6bm8gLSAxLCBidHJmc19kZXZfbmFtZShkZXZpY2Up
LCBkZXZpY2UtPmRldmlkKTsKKwkJfQorCX0KKwltdXRleF91bmxvY2soJmZzX2luZm8tPmNodW5r
X211dGV4KTsKK291dDoKKwltdXRleF91bmxvY2soJmZzX2luZm8tPnJlY2xhaW1fYmdzX2xvY2sp
OworfQorCiB2b2lkIGJ0cmZzX3Nob3dfem9uZWRfc3RhdHMoc3RydWN0IGJ0cmZzX2ZzX2luZm8g
KmZzX2luZm8sIHN0cnVjdCBzZXFfZmlsZSAqc2VxKQogewogCXN0cnVjdCBidHJmc19ibG9ja19n
cm91cCAqYmc7CmRpZmYgLS1naXQgYS9mcy9idHJmcy96b25lZC5oIGIvZnMvYnRyZnMvem9uZWQu
aAppbmRleCA4ZTIxYTgzNmY4NTguLjc2YjQwZTgxY2EzMiAxMDA2NDQKLS0tIGEvZnMvYnRyZnMv
em9uZWQuaAorKysgYi9mcy9idHJmcy96b25lZC5oCkBAIC05Nyw2ICs5Nyw3IEBAIGludCBidHJm
c196b25lX2ZpbmlzaF9vbmVfYmcoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8pOwogaW50
IGJ0cmZzX3pvbmVkX2FjdGl2YXRlX29uZV9iZyhzdHJ1Y3QgYnRyZnNfc3BhY2VfaW5mbyAqc3Bh
Y2VfaW5mbywgYm9vbCBkb19maW5pc2gpOwogdm9pZCBidHJmc19jaGVja19hY3RpdmVfem9uZV9y
ZXNlcnZhdGlvbihzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbyk7CiBpbnQgYnRyZnNfcmVz
ZXRfdW51c2VkX2Jsb2NrX2dyb3VwcyhzdHJ1Y3QgYnRyZnNfc3BhY2VfaW5mbyAqc3BhY2VfaW5m
bywgdTY0IG51bV9ieXRlcyk7Cit2b2lkIGJ0cmZzX3Jlc2V0X3VucmVmZXJlbmNlZF96b25lcyhz
dHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbyk7CiB2b2lkIGJ0cmZzX3Nob3dfem9uZWRfc3Rh
dHMoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8sIHN0cnVjdCBzZXFfZmlsZSAqc2VxKTsK
IAogI2lmZGVmIENPTkZJR19CVFJGU19GU19SVU5fU0FOSVRZX1RFU1RTCkBAIC0yODcsNiArMjg4
LDggQEAgc3RhdGljIGlubGluZSBpbnQgYnRyZnNfcmVzZXRfdW51c2VkX2Jsb2NrX2dyb3Vwcyhz
dHJ1Y3QgYnRyZnNfc3BhY2VfaW5mbyAqc3BhY2UKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGlu
bGluZSB2b2lkIGJ0cmZzX3Jlc2V0X3VucmVmZXJlbmNlZF96b25lcyhzdHJ1Y3QgYnRyZnNfZnNf
aW5mbyAqZnNfaW5mbykgeyB9CisKIHN0YXRpYyBpbmxpbmUgaW50IGJ0cmZzX3Nob3dfem9uZWRf
c3RhdHMoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8sIHN0cnVjdCBzZXFfZmlsZSAqc2Vx
KQogewogCXJldHVybiAwOwoKYmFzZS1jb21taXQ6IGQxMzVhYjQ1M2E3NDAwYTM0OTMwYmRkYTFl
ZjRiZGM4YWNmYWM4MGUKLS0gCjIuNTYuMAoK
--000000000000729e65065ed38b76--
