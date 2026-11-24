Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554687;
	b=TXs2Ag4pRYlejgbS7nnmXey6nHIsb1hLR1RWApqrPGPRSa+ybBf53aTBD1E3E9pPERjG
	 /bPcPXO5vNTJFYs0RH3ov6ofXDkC0MC7HqGtZ14CXQGmnJw1ubi7971pfWI1u/rfauXfD
	 a7TkEgEdutvf6NYW4Vx2AJDHAmCahKxNkLHJCmrjLuzaUyTzvzB5QuTcaIyTEzC+qJz3g
	 xEMTf15gxWw+Zu3MxmbcxbZ2UHlsBEBa0Rn+RBFfPcpCXqeR4jCanp1JVI8vyW+aXacAi
	 GxHkoo2yfn+qb8KDRbINi7h2YBLxAHz6R4pO/aSQomQkzV9xlfTDNfDZAzg4Rr6Pg/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554687;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=R4pw9DcpdnMYeIxEUYnbnv91ThzTvTrm2VVYBrvrMnw=;
	b=1VhKZ44QP9flPknGp2H5Ag5cBqqEGuZPIrW6DsWaJhumM8P6x1Pue7pHVp2xZz0gw7SQ
	 mRBGjAVOA6u51QfzS0OtRItBfHDaRAernBnxl4uK+ChUcuxEQo+YATSoOoKiDwW0gdd79
	 s1tfWh7xbc7o7CFX6zlsTN0Ej4KiZXXQhAZm5BN8xJWF5jAqtD8Rc2JTDk+VG3SsMXMdG
	 70SleS4pYB/H5JwDpxxyQbzATh5JsgfMjkH2ZY8V1DId3q9MVt3RHBGO9FxIv+pkWvdHL
	 pPvFzH6N3IVV2ZXtLlnsfIWq2jLsYcXC0wZ0NONaYpb5LscKh2TjJcrds6sgLX6vzXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HKOoVTgW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44F0606A335
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 21:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A44F0606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HKOoVTgW
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so661335766b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 13:11:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795554685; cv=none;
        d=google.com; s=arc-20260327;
        b=neQCfzUrnOG4o5mlgfrmKnF6y4w6h7JccO1ush5kPGdQ7m55OFo8kgEbmMmh5njzDD
         WqBOpOh24TfjNzzCKcQ6UjrWWAx0QbBP5MWYiNN+84QwtyfWLUx3kasUl+F7/2F6mzu3
         iDUnXxwig+6Apn3eB7nicpi/01aLjv5Av6awaqQP/2uTpBy8TTLxiDTY35oLED0wz+fq
         FvfDlcpt0Qh9f4gVajLrYlbS9jso7MP+Na0oFDCEEG20bSK0zc1CRGZWnKVZeHUE1U/A
         TlP3HZ67fiSsfjVOyHcL1Gi/xOfuQOYvIl93HbDXVwF45uAs28JXjvql1YNB2vKT6AUT
         bymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R4pw9DcpdnMYeIxEUYnbnv91ThzTvTrm2VVYBrvrMnw=;
        fh=JcihQBAaJWtdizSy572jtkr7Cp/9kL6dmB5BfDV/CMM=;
        b=WM1UUwjX8PzW+O3fnQ5UfE5VUva/YLN4SYLDGqp5IcWpign7N0diMzVk5vhWv18IX3
         ae+CwKZa+moR9qw+44jqIvhd4O2Kn5xawYOc2W6w/ZTtnuyNQJAFQeeioVeqWjaD1Nvw
         PY2FQCcb94CPqQ7iucxSTiqeElzSAPw8l1EYui5gDZ3rEO7SC1nOY/cKqiGFFSyMPHKL
         anbrBP8ibIOyd1QydYK0NBh5TfHqG29O+nFEcBcRl6mahdcK5GqonTiRLNwZ9m5PHbfh
         0NF4f9eMDpyL2J8xpR8yvDAm5PvS1VLyz1HN9NCErgJvcBGAwR/7sNTR5fEXw4YHBcmX
         jjtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795554685; x=1796159485; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R4pw9DcpdnMYeIxEUYnbnv91ThzTvTrm2VVYBrvrMnw=;
        b=HKOoVTgWD/jri2ICKWYuabv2C9ujuA+HmAdR17PYnmvFnkT100ju59IEN9nDAg7lhQ
         3izGbBqkf1fX3HoYq56E8uvZBM8ZfAXmNAMUUomMtkB8DHkorVYcnwfKwOZBzRAsgJO2
         wbssVX4FXCgljByNAMwJEcMSidhJrLwVFKJ1EfKU+8JqRAFj8NpfeL3/N4xH71b2T0ZD
         PXQrVq2c0wZQYeDZp0n+YHWMjfbJA3/aBiAASKWtScWWXk2KhE5bNgUwG12UKI/EVE3c
         WsQsHA0ImsWl4+O15635i2+p+jMvtEzWWzvoBA93u4Nd2V3dnI4ABVn9slfjzPalO5cK
         HwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795554685; x=1796159485;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R4pw9DcpdnMYeIxEUYnbnv91ThzTvTrm2VVYBrvrMnw=;
        b=1z3XSvOMp54EvaJpQDKmTnUQKwPYVZXmoSRzTcMuiAMrROhzYRxsRu8G9PIOqwTGnG
         HwGFhOC4XLVRo6tLPkUan35uL53TneC5jnBqxP4hqDWIOy+2Xi04dhQDhbmCI1UDJF3u
         X8MEZHwNEd8TMydMqKD6+JNpDewPAIC1YrYIBv9fQTn4mdCZ0CtQjMhM3Ppo1EbRI2AR
         oe3x2LtwtI/+ScAhrF7uLLCDUoTA/7J3wdJ0yPMRaaWdBp5tmy8tAFtt34d+y1Rbd+Og
         H3Rlj6742XWQ8LWhf9fJ1C418nLx/iskgTY1hHKXFaYGEUPqroigZhKjkE+lGPUSbZ7y
         Uv4Q==
X-Forwarded-Encrypted: i=1; AL+hErFTFDDCeOLkTPAr5AE/gwFFu5UKQ4tnGOC81bXJu9JiaJQ7mkYiSZdGrUAljKqVMWxPAA8V8pDUZweJzA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9KPOgodgWfeQ7KsNBRuB1rkFPiPUUnznwddF7hK41FxdhsA1zr
	vdgjyxkH9tL49GYLMN6xtnBHzy6sCNqaukDkTbnsKo3sSwBjf8ox3G1tA+nu2hRQM9nwzNWs8/Q
	3XGcOSyHT1wcslqxfOZc289ljFLPFaS6eP07/l3yM
X-Gm-Gg: AZFdTZfA3RGX2vh+nuUEY2hos8woSmG533RMpFThtQwMKHeiAxFAjXRlI3Okla+03zf
	hbgMwX8pbYkq+nq87MPqmsCL94a48CdwHcEzBFUY8h8e49syGItbrLh9Oeb9yh0lBwKSbN2Q2KY
	UXr9w17i5v7QIK/sBHnMKPvo6z2IJwVYNcxw4Ocn1dfNkSn61rb0xc+e7ZS24PcQn6WdITIZmqT
	JLwFkLI/1T1X/+9uk/MYUY1j4yrxBrBv5d1v7F8hV1LnAG2m7biqFzgczyvDigX7iuMUcqd3gz3
	1+1R/yetqbJikcddY3VKAes+hLrHyfdU6bz18wZro08+pGMLgcMqM/jWxhoVO4NsOPpjYWCsrS+
	7s2b+AEtLcpvF1yvbnOtVr8tvllJc6iyMiLmuzMyPGh4vX2oST5WVsafpNzdi/1J1eRZ1waLC5J
	WdHFwRxFGeMDhkSZIdtgP1n0EiKfo1JvAt8WtxEqX+TEwq/x5cv1M=
X-Received: by 2002:a17:907:8e90:b0:c50:5186:a428 with SMTP id
 a640c23a62f3a-c513a87d9edmr1227142466b.27.1795554684471; Tue, 24 Nov 2026
 13:11:24 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
 <20261027231728.1466446-1-jthoughton@google.com> <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
In-Reply-To: <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 16:10:47 -0500
X-Gm-Features: Aa3M54qLiZYW-OI4p5Ie96tNauNpwSe6qBub2eVFZl5dz1FgCFOseL6mdcwJEy8
Message-ID: <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pavel Begunkov <asml.silence@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, kvm@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Mike Rapoport <rppt@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Sorry for the long delay; I am finally able to get back to this
series. Thanks for all your feedback so far!

On Wed, Oct 28, 2026 at 7:14=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:
> >>
> >>  - does there need to be any compile-time configuration to skip
> >>    the extra checks and/or the warnings?
> >
> > Since patch 10 moves the warning out of line, it costs nothing on the
> > fast path, so making the WARN configurable wouldn't save anything. The
> > question is really whether the mm check itself should be configurable,
> > and that check is also what makes the access safe.
>
> Right, makes sense.
>
> > The text size increase seems manageable[1], but it would be great to
> > hear other people's thoughts. For the runtime cost, I'll do some
> > performance testing. My guess is that a load of current->mm and a
> > well-predicted branch per user access will be negligible, but I'll get
> > numbers.
>
> Sounds good. I agree this should not have much of a performance
> impact, and for the size it is probably as good as it gets without
> a major rework of the lazy mm switch.
>
> >>  - are there any cheaper ways to make it safe than to add a
> >>    condition on each user access?
> >>    E.g. the original lazy mm switch was intended to avoid
> >>    expensive TLB flushes when switching to a kernel thread and
> >>    back to the original task on 32-bit x86. On modern CPUs,
> >>    the MMU can deal with multiple ASIDs cheaply, so turning
> >>    off user access in a kernel thread may be cheaper than
> >>    adding code to uaccess depending on the architecture.
> >
> > That's a fair point. If user memory were inaccessible in kernel threads
> > and after exit_mm(), every such access would fault, and the fault
> > handler could WARN about it (x86's do_user_addr_fault() already has a
> > !mm branch), so it could still be loud without a check on every access.
> >
> > I'll look into disabling lazy mm switching on x86 and doing some
> > performance testing with that (like comparing the per-uaccess check
> > with the added cost of non-lazy mm switching).
> >
> > Other than the performance difference, I see these issues with making
> > uaccess safe entirely with the mm switch mechanics:
> >
> >  - It only helps on architectures (and configs) that implement it,
> >    while the common check works everywhere today.
>
> Yes, this would probably be opt-in by architecture, unless we decide
> to give up on lazy mm switch altogether and pay the performance
> penalty for that on CPUs without ASID support. Either way it is not
> be something we can do right away but that we can still consider
> in the future.

Agreed. I haven't collected performance numbers yet; I'll try to do
that before sending v2.

> >  - The fault handler would need to tell legitimate faults apart from
> >    bugs, e.g. copy_from_user_nofault() from BPF or perf in a kernel
> >    thread is fine and must stay quiet.
>
> Would it be possible to move those checks into the individual
> callers that want to avoid the WARN_ON(), with a comment on
> each one explaining why they do that? It feels more consistent
> to always warn here, and I would expect that for most of the
> _nofault() users we do want the warning, and I'm still unsure
> what is special about these.

Yes, I think that is better, and I've done this for v2.

The _nofault() users really did need more scrutiny, thanks Arnd. They
are special for different reasons, and they differ in how we should
handle them.

1. They can run in any context. Many of the BPF functions like
probe_read_user*, probe_write_user, user dynptr and bprintf helpers,
etc. are like this; a user can just attach a BPF program to places
where there is no mm. So we should fail the uaccess but not WARN on
it.

2. They run in process context, but use nofault because they can't
take page faults. btrfs's tree search ioctl is an example. In these
cases, a missing mm is a bug, so we should WARN. So v2 will fix these.

3. There are three cases where it tries to read the PC while handling
an exception that was taken from user mode. In these cases, it should
always be the case that `current->mm` is non-NULL, because we just
came from user mode (i.e., when user_mode(regs) returns true,
`current->mm` should always be non-NULL and pointing to the correct
mm). So we should WARN if current->mm is NULL, which v2 will do.

4. powerpc's BHRB decoding is a special case; I'll just put this in v2
and we can discuss it there.

So now in v2, the _nofault() helpers themselves do not check current->mm.

I've uploaded a draft version of v2 here, in case you want to take a look:
  https://github.com/48ca/linux uaccess-v2-wip

> > The series handles that today by
> >    checking current->mm in the nofault helpers (patch 6).
> >
> > The two approaches are mostly complementary: if non-lazy switching
> > turns out to be cheap enough, an architecture that does this will have
> > better defense against uaccess bugs. But I'd still like the common
> > check so that these bugs are reported on every architecture.
>
> Agreed. My main remaining concern is about the number of functions
> that need the additional check, if we want to avoid missing
> any of them. If we can have the check in access_ok(), that would
> cover the majority of the functions you are changing right now,
> and it looks like we can deal with the corner cases individually.
>
> Since in principle every user access should go through both
> access_ok/mask_user_address and current->mm check at some point,
> so combining the two as much as possible should help long-term
> maintainability.

You're right, and v2 has been restructured like this.

- The check is in access_ok() itself: the generic version, plus the
arm64 and riscv versions. __access_ok() remains a plain range check.
- The callers of mask_user_address()/masked_user_*_access_begin()
check current->mm explicitly. There are about a dozen such callers.
- The unchecked accessors, __copy_{from,to}_user()
and__copy_{from,to}_user_inatomic() (and arm64's
copy_from_user_flushcache(), which also relies on an earlier
access_ok()), keep an explicit check for now. Once their users are
converted to the checked versions, those checks can be dropped.

Compared to v1, this also covers get_user()/put_user()/clear_user() on
arm64, powerpc, riscv and the asm-generic architectures, and arch code
like signal frame setup that uses access_ok() followed by __put_user()
or unsafe_*(). user_access_begin() no longer needs its own check.

What's still not covered: x86's get_user()/put_user(), which do their
own range check in asm, a few architecture-specific paths that call
__access_ok() directly (e.g. on alpha and sparc32), and arch code that
calls __get_user()/__put_user() without access_ok(), mostly trap
handlers for user-mode faults. Probably best tackled later.

>
> >> There are of course few enough of these left that I think
> >> we can consider doing the same thing here and turn them all
> >> into the checking version:
> >>
> >> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
> >> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> >> drivers/gpu/drm/i915/i915_gem.c
> >> drivers/gpu/drm/i915/i915_query.c
> >> drivers/usb/gadget/udc/atmel_usba_udc.c
> >> drivers/vhost/scsi.c
> >> drivers/vhost/vhost.c
> >> mm/kasan/kasan_test_c.c
> >> virt/kvm/kvm_main.c
> >
> > Agreed, I think we should clean those up, but that can be done
> > separately. This series already adds the check to the common
> > __copy_{from,to}_user() and __copy_{from,to}_user_inatomic() wrappers
> > in include/linux/uaccess.h (patches 7 and 8), so the KVM path is
> > covered without converting the callers first.
>
> Right, if dropping __copy_{from,to}_user() as global interfaces does
> not help add the check in a consistent way, that can wait as well.
> It looks like we are very slowly converting away from them already,
> as we have about half the call sites left compared to v5.0.
>
> There are probably few enough of these that we could address them
> by either adding current->mm checks or converting them to use
> the full versions instead where that is an obvious change like
> that usb gadget driver.

Sounds good. I'll send a separate series converting the obvious ones,
starting with the usb gadget driver. I think that will be useful.
Let's see how far I can get; hopefully I can drop
__copy_{from,to}_user() completely.

> >> As a quick fix I would probably start with just the 'if (!mm) return f=
alse'
> >> bit here to get something merged while we still discuss the other
> >> details.
> >
> > Making the same point as Sean[2] but with a little more detail, I had
> > thought about making the change in access_ok(), but:
> >
> >  - On x86-64 and powerpc, the masked user access paths don't call
> >    access_ok() at all. That includes copy_from_user(),
> >    strncpy_from_user(), strnlen_user() and every scoped_user_*_access()
> >    block, which is where many of the converted __get_user() users ended
> >    up.
>
> Ok. Apparently there is some of this on arm64 as well, using
> __uaccess_mask_ptr() instead of mask_user_address().
>
> >  - __copy_{from,to}_user() and __copy_from_user_inatomic() skip it too,
> >    and the KVM bug followed exactly that pattern: the range was checked
> >    once up front, and the access came much later from a different
> >    context.
>
> Arguably this is itself a TOCTOU issue and replacing
> all __copy_{from,to}_user() with copy_{from,to}_user() would be a better
> solution long-term, if we can do that.

Yeah, I agree, that's another reason to get rid of them.

> >  - access_ok() is also used as a plain range check where having no mm
> >    is fine. For example, copy_{from,to}_user_nofault() call
> >    __access_ok()/access_ok(), and BPF and perf legitimately call those
> >    from kernel threads, so a WARN there would fire on valid tracing.
>
> These at least could be easily worked around by just skipping the
> calls to copy_{from,to}_user_nofault() as mentioned above.

Yep, and v2 now does this.

Thanks, Arnd! I'll send a v2 early next week. I've kicked off
syzkaller against the new version too.
