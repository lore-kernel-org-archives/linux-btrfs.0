Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793143050;
	b=v9d9njSOjQD0MSVvLspIjO3sp71iAzUpzIo8R3Z5mwNPxTr8gTdojobApp5f+TZhzf34
	 WkdT0LFDFzqmfxRXRmiyYXKr3IrQ/T0uSqO13R/OL5fpAnHbRmcegqFIaq57X7JBP4Ef2
	 rqDDet1POWnNvTM8viifjwskyRcN8N5FwbwbNOFOYwHU0VyIqvhfDUzFIq9CX1vF+rc/P
	 lCf1IypbdumZAsKbHS7WszBXMi7Dx+rEpBicO1HypQC0Sdt1PUJ8nKjouIZwrNQge+7N4
	 8cN+kC+HMazPq9KtP2NpSaNIsDRhT8nDxOcU8qcclv4P+WHp5NaX6ovPc+mI3BSSS+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793143050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
	b=PQsH7vjcAoiDQ0pKMvY3zniZnC4DVljo3lBwUnb3ZiL9jCSjZHUXvTLlrHjX0YPrRm9R
	 iZgdB2VPhWIFEiGhCOUJAsQlbLJA1h+u3QUpl9prJjpfmDnQPHFSRPvCbvcyG2KYcvit+
	 rm67yI9cLwSszMHAr2257Oap4nmIfW6C8rg24ibNPf9fmqxb3AESeUBLNYyznZ/PNcD2C
	 G+OCWqrBC9tuZsFO3pFfuNKNDZ874bl3avYTqmp17HRs1YJmrFI/D4Hfh42KhyEk057iG
	 HFIBdKBHLusCx3Qctg1feX+m7RHTCC8FPqZQaxRrWnBxF1fyeZRSUdKkJNE/n9JFsUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="PE/zx+6A";
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76E606A31F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 23:17:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD76E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PE/zx+6A
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a01e2962a1so488904b3a.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 16:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793143049; x=1793747849; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
        b=PE/zx+6Af4cB6kwCb3KWCo2kLDvj8fl2ys7izWUyFpH5zLYmX810u3AzXitpejplQE
         /jQClQeXVkg24Hq2EtapZZmYZqBqVAzhuerBOXqcEml3pCLmsPFzhUKaKVVRYh78e5jo
         h8KkCLUPmxBFXlpb/JITMIblABhQ7NlF7KMjGGjdd9IyszPk9+1oO7oOT2MoBvY5XheR
         C7sZ+dVfMbfS+HyT7uTrugl1sk73k+pwHG2Pfa3KfOiBB28qEE/Udtp4Y7cVn9gp7foT
         HEcU/cZ1gEdP98XXJk+xlaxcfEGrza6u+gZED9q0MMpJmn/0VM46cFjFyrKNEI0geaag
         VHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793143049; x=1793747849;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
        b=pgukk71WFkob8gm5E1TMg3McI597CXvj8xNmDFf5H41HtyJfPU3Rp7Pk9V6AnjOr6J
         fQc/fm5THenoSR5Pi/rGhBVAFJBZarf4a9qGT2Bnar9w+KPcgKGF880I5npgr/T6U0mH
         TraZ5Rsmwbeju92eYlqDKvnmb237jf7ecKkAjEXIAlyUaZIGsRK3FQ7TwQG0TUv9KhlZ
         FZCm6UmwNHQdyZ24bD1dRAXkF1dThnTEAKb4I0ZfnoVHIThxHdzAGl72jVjoqb+vGj8x
         ej+y5N/ncIYVYtTzMgJ/AdZe0x9u0qsP9a+66dXwxG57hO/93n2CEHBWm8crZaknTylT
         Hg1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzvlJxB/qoQgvaHQ1VXoCTK19a4s6ceIcP2vovaaJX6+odW25ZQivqh3tckR0HlkuyfcCpGTyRCsIenOg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK0OIF5yPeXanCgNqL6caVtvBMg4W4V64X6eQD4lo2B48h87Rya
	AoiHGA5mmRAGAaQmAJnZ2kZE5W7u6tpDElBbOgW1XZ8RofTqhUYpfKSt1tUW8I67WkjuPr4gkuV
	5VoI4YqhW9oCXmBGdpqYuLQ==
X-Received: from pgcgn27-n2.prod.google.com ([2002:a05:6a02:6a1b:20b0:cda:df40:b50f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:b7a6:b0:3e2:4c65:5905 with SMTP id adf61e73a8af0-3e902404531mr513567637.60.1793143048797;
 Tue, 27 Oct 2026 16:17:28 -0700 (PDT)
Date: Tue, 27 Oct 2026 23:17:28 +0000
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
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027231728.1466446-1-jthoughton@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: James Houghton <jthoughton@google.com>
To: arnd@arndb.de
Cc: James.Bottomley@hansenpartnership.com, acme@kernel.org, 
	akpm@linux-foundation.org, asml.silence@gmail.com, ast@kernel.org, 
	axboe@kernel.dk, bpf@vger.kernel.org, daniel@iogearbox.net, david@kernel.org, 
	dsterba@suse.com, io-uring@vger.kernel.org, jmattson@google.com, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, jthoughton@google.com, 
	kees@kernel.org, kvm@vger.kernel.org, liam@infradead.org, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org, mason@kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, mhocko@suse.com, 
	mingo@redhat.com, mkp@kernel.org, namhyung@kernel.org, pbonzini@redhat.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, seanjc@google.com, 
	surenb@google.com, tglx@kernel.org, vbabka@kernel.org, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 27, 2026 at 11:32 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> > On Mon, Oct 26, 2026 at 5:13 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> >> the current process is only set in user_access_begin() and would
> >> not point to any task here. Without ttbr0_pan, it should be
> >> covered by cpu_set_reserved_ttbr0() turning off all user space access
> >> for kernel threads.
> >>
> >> Should this perhaps be addressed in architecture specific code
> >> instead of in a common place?
> >
> > You're right that whether corruption can actually occur depends on the
> > architecture and config. I'll write a note about this in the v2 cover
> > letter.
> >
> > That being said, I still think the right thing to do is to have the
> > new check(s) in common code. Instances of improper uaccesses are still
> > bugs, even if no corruption occurs.
>
> I agree we have to do something to prevent the problem for most
> configurations and find any newly introduced bugs.  The questions
> that need to be properly decided are
>
>  - does there need to be any compile-time configuration to skip
>    the extra checks and/or the warnings?

Since patch 10 moves the warning out of line, it costs nothing on the
fast path, so making the WARN configurable wouldn't save anything. The
question is really whether the mm check itself should be configurable,
and that check is also what makes the access safe.

The text size increase seems manageable[1], but it would be great to
hear other people's thoughts. For the runtime cost, I'll do some
performance testing. My guess is that a load of current->mm and a
well-predicted branch per user access will be negligible, but I'll get
numbers.

>  - are there any cheaper ways to make it safe than to add a
>    condition on each user access?
>    E.g. the original lazy mm switch was intended to avoid
>    expensive TLB flushes when switching to a kernel thread and
>    back to the original task on 32-bit x86. On modern CPUs,
>    the MMU can deal with multiple ASIDs cheaply, so turning
>    off user access in a kernel thread may be cheaper than
>    adding code to uaccess depending on the architecture.

That's a fair point. If user memory were inaccessible in kernel threads
and after exit_mm(), every such access would fault, and the fault
handler could WARN about it (x86's do_user_addr_fault() already has a
!mm branch), so it could still be loud without a check on every access.

I'll look into disabling lazy mm switching on x86 and doing some
performance testing with that (like comparing the per-uaccess check
with the added cost of non-lazy mm switching).

Other than the performance difference, I see these issues with making
uaccess safe entirely with the mm switch mechanics:

 - It only helps on architectures (and configs) that implement it,
   while the common check works everywhere today.

 - The fault handler would need to tell legitimate faults apart from
   bugs, e.g. copy_from_user_nofault() from BPF or perf in a kernel
   thread is fine and must stay quiet. The series handles that today by
   checking current->mm in the nofault helpers (patch 6).

The two approaches are mostly complementary: if non-lazy switching
turns out to be cheap enough, an architecture that does this will have
better defense against uaccess bugs. But I'd still like the common
check so that these bugs are reported on every architecture.

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

Agreed, I think we should clean those up, but that can be done
separately. This series already adds the check to the common
__copy_{from,to}_user() and __copy_{from,to}_user_inatomic() wrappers
in include/linux/uaccess.h (patches 7 and 8), so the KVM path is
covered without converting the callers first.

> > I do think user_access_begin() should have the new check though, so
> > I've added it in the v2.
>
> I had the details confused here. Seing that user_access_begin()
> and the other accessors always call access_ok() at some
> point, maybe that would be enough?:
>
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

Making the same point as Sean[2] but with a little more detail, I had
thought about making the change in access_ok(), but:

 - On x86-64 and powerpc, the masked user access paths don't call
   access_ok() at all. That includes copy_from_user(),
   strncpy_from_user(), strnlen_user() and every scoped_user_*_access()
   block, which is where many of the converted __get_user() users ended
   up.

 - __copy_{from,to}_user() and __copy_from_user_inatomic() skip it too,
   and the KVM bug followed exactly that pattern: the range was checked
   once up front, and the access came much later from a different
   context.

 - access_ok() is also used as a plain range check where having no mm
   is fine. For example, copy_{from,to}_user_nofault() call
   __access_ok()/access_ok(), and BPF and perf legitimately call those
   from kernel threads, so a WARN there would fire on valid tracing.

Even the quiet 'if (!mm) return false' version would have missed the
KVM case, because of the first two points. I don't think there's really
a "small" fix here, unfortunately. :/

Thanks again for all the feedback, Arnd. I really hope we can get this
series into a mergeable state. :)

[1] https://lore.kernel.org/linux-mm/CADrL8HUZ3t8RdMEeBPfqsy1_1rN0Ty9B2c4iP6OzNS12te6vOg@mail.gmail.com/
[2] https://lore.kernel.org/kvm/auEVMrMDqVuKtDqh@google.com/
