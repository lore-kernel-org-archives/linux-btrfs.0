Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135925;
	b=UNtgQwTi5XnCCE1Qw79VERlvf1Twbm0GNfxHYJLQjS7IpeBQ24tr/P1NtBNTVsLKQacg
	 LXt1P5LyfjGB7kQ+qPESVpZxRZDpsgKTC2MfdzWXUqEIvAsv3D5GRpxyTQlJDdc5WmSQS
	 Y9pFBnXejp6g6ESHDVdIx4ze3FbnRympzTvIZqQSSYUUqLLAZqPFAZBCmW84ablvPoAZb
	 bsTjreVlsCEpvPGmB7iFNvoD3r4yvivmRRXf+sDeKFX7adNmrcwa13mMgGXxjX2QNqWgW
	 eMFGvSST/VLlquZt8Y5eo0aHbpz32gslemunO4JtuJafKJuafh9+w+/BXUiFon6552g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
	b=fGNXXpnKyzU9xtaMgwXJGOCnjA3tK+kiiBixCiiOpg+bJ3X6Q+5Vroe+cOitqAj61FwG
	 RotsNPs0aFzvA9xm/Hq6q8ySlSnEgjiYF339a+ArU/MFP1mnjfws8ZSOPtgE464cTA3Lg
	 ddByUeB/A+cbPaLQ/iLOp5RGqyAquFDSuCmYUphuK4b/PlW4TGTYgz+aRrGIFQoRzYEfb
	 LqKO6/bazPIxROnblantpOsIrGApycnUvmTNuFCWBtg+6U76XqRmeBaRt9z3UxFY2swQG
	 ozBkDfg5tB2ZBCXmJuGepBAAOzFaJYkWb5qT9c4huJ7rRzN9spmBd+5JU3redc+KMjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O9t1oNxh;
	arc=none smtp.remote-ip=209.85.216.69
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A29606A324
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79A29606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O9t1oNxh
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso306754a91.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793135924; x=1793740724; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=O9t1oNxhj7Xw67fxZOhJmZ8vNAdxWgxOGEEZGK9oId6/aVHLsnFtQlbNQ6bzhC9B0E
         f9O/mJB1tznoMWpJP5vr6IAfWd7OYL3+vqog/K86lyrB9hPII1dxM6rPxBJ9Kby9+ucJ
         q3hnsiNT2ru8vSf8egpVYYGw35wKVG80Vu3ezvTOK/2hErKcg9OsAoYftXOMXvmgvOsE
         USSlpzb9cbn2+MUY6DGfb3+M18AMUDB5o3XD1HYrd07vSA1sr+KPFgLsCAHlt3yIU0CJ
         46wb1/8vXqcmincC/gKw4zIHqOkFMeY2f47UtXQrgsFIIglqeYn4Rz2uN2mV+APvhSlW
         0LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135924; x=1793740724;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=el6XUCrnNjr5v27cA973d/qk3g9naC20CgbEO4HBL02xMTG91TvgkJFayHur43geJV
         i3eAnPzl5ATEIYM1rdKG76RazJFyGKpTuDtPRg2e1THMQ6Xl6e97xmUk+4xfLjD5Vd5W
         elmSIYXNvqrriY95pbzblEfaZ9J2R+93wwHh3UqxVjYZ6fX7VmgEJFEOoqGiKrDuCA4p
         8SvOMcRWcmNy24NY/Fs5BF6dvNOOtvB70Qbf9ScwF1NX0nWjFzNEFm85qIhcxznDgeMh
         lQ/EpiPct7Uo8WzU+TH4z0h5EMptrqKjMth3UPPY3OU5ySky1hU8ZOJWwoaIq8T174AH
         wpkw==
X-Forwarded-Encrypted: i=1; AKwUvBzOXGpkNQ3mF094GJ+UF65C96KDWhLKsgXSgKMcfcSY+TQT/1d3MzSEA0dBOqhSIoVJPurul0BTx5FTkg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJY5BMTJ/j4m/Sj5E+UWkIvWt0PFF8rbnBIwkIpYyq9y1gYEjXX
	YDgg9UF55Ztr3gfMBOBdSPwZQqmTefQeSzQ2pdYx8imY+C7u8F3SQmSE3pZEB0+5+5xo5NTa1Si
	tYNyslw==
X-Received: from pjvv8.prod.google.com ([2002:a17:90b:5888:b0:3ad:850b:6f1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288a:b0:3ac:9706:7739
 with SMTP id 98e67ed59e1d1-3ae5819e5afmr211698a91.17.1793135923585; Tue, 27
 Oct 2026 14:18:43 -0700 (PDT)
Date: Tue, 27 Oct 2026 14:18:42 -0700
In-Reply-To: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com> <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
 <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
Message-ID: <auEVMrMDqVuKtDqh@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 27, 2026, Arnd Bergmann wrote:
> On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> >> I would think that user_access_begin() is a more natural place
> >> for the added checks, as this should be called exactly once for
> >> any function that accesses user space and also stays out of the
> >> way of the copy_from_kernel_nofault() etc.
> >
> > user_access_begin() isn't used in a lot of places that I want to
> > catch, including the KVM case. Roughly:
> >
> >   kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()
> >
> > There's no user_access_begin() in there. :/
> 
> Good point, yes. After the changes described in
> https://lwn.net/Articles/1102061/, I had assumed that all
> __copy_{from,to}_user() are going from common code, but it looks
> like the series so far only touches __{get,put}_user().
> 
> There are of course few enough of these left that I think
> we can consider doing the same thing here and turn them all
> into the checking version:
> 
> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> drivers/gpu/drm/i915/i915_gem.c
> drivers/gpu/drm/i915/i915_query.c
> drivers/usb/gadget/udc/atmel_usba_udc.c
> drivers/vhost/scsi.c
> drivers/vhost/vhost.c
> mm/kasan/kasan_test_c.c
> virt/kvm/kvm_main.c
> 
> > I do think user_access_begin() should have the new check though, so
> > I've added it in the v2.
> 
> I had the details confused here. Seing that user_access_begin()
> and the other accessors always call access_ok() at some
> point, maybe that would be enough?:

It would help, but it wouldn't cover everything, e.g. KVM "caches" the access_ok()
checks well in advance of actually performing a user access.  I don't know that I
would fixate on KVM too much though, as KVM's memslots infrastructure that begets
that behavior is quite unique, i.e. it's unlikely other subsystems will have these
types of bugs *and* elide access_ok() checks at the time of access.  And KVM has
natural chokepoints for these accesses, so it's easy enough to harden KVM itself.

The counter-argument is that _if_ there are other subsystems that are caching
access_ok() checks, then those are probably the subsystems that are most likely
to mess this up and thus would benefit the most from common hardening.

> --- a/include/asm-generic/access_ok.h
> +++ b/include/asm-generic/access_ok.h
> @@ -33,6 +33,9 @@ static inline int __access_ok(const void __user *ptr, unsigned long size)
>         unsigned long limit = TASK_SIZE_MAX;
>         unsigned long addr = (unsigned long)ptr;
>  
> +       if (WARN_ONCE(!current->mm))
> +               return false;
> +
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> (plus the few extra copies of access_ok()/__access_ok())
> 
> As a quick fix I would probably start with just the 'if (!mm) return false'
> bit here to get something merged while we still discuss the other
> details.
