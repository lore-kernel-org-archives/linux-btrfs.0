Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793058730;
	b=2myvmqXIg24h0UJFIwvFxP8FEM09Zi4Kz95g1PURT187XFDGtts1UGZkyR3xo8PRBtqx
	 bLwgyh9VI6zpbdmDP9Q2+lXTchCv9H5G4ZFCTTJnSpYyFqQ0m9ZY1fzKweW+Q4k2KdJlP
	 vobeeHE3F8Ot/gg+v8NWE0ZABnTH9Q1wYCJ9wYvnm4EVLXnenC6EPiL1iKaBGOwMu6vHQ
	 WlqRWdoB3yVA4reLn96WIcppluwgEmiVo6cgJcc11CLsos5P8HPmYrYXOCOUXTWU9Gkct
	 AzTqVcLLvV4HsNqIMUfh6Rm18WiF9OHlzCMjeuu8BKcnmjQBKj4n1QkJhiBrGZ9RVfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058730;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
	b=ZzemCyn9P7rIKq/aKdHvI5Z8LiTmI9ivOz3RYhiRk19dHkxqlyVA62SUGpR0Rk53CNOe
	 AlERlK3yDxaTzS2rqAsA9rJaD3xUOF4KuvJi2J6eqN3Z2Q+OYKz90b5ffROyTbomsTeeA
	 g8Qac6jWA0uullUVJdup3I+BitFttmEZOEov2qIApHs/Nt7sJB3StkU5MQ+LgId14eHgS
	 +9FaIdvkX5DGGdxCSIpi8i5GGworwGWgG4LatWThQK3IhdTRycoOsuhoWP6k5uxbilnCp
	 orUlhcrKqWqqoBOU+qkGe63vijQZ5h/recxB30Q3acfQEoJjXYkhFEXw+kCAZuvSPeQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=IrwijN25;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02384606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 23:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02384606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=IrwijN25
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c3fd91337baso507206766b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793058728; cv=none;
        d=google.com; s=arc-20260327;
        b=FjZ95g+5X7mMjBwMvXQZmPW8XRySscd9hlBHUCDfSBeq5BquHe49BIZ/2wsmA6Kkqk
         P6yjfFvgRHIqjH2ci7/7vBcJHVI0/9hEIZ4Pd1F6NgR7MZ46JGnZMdowJcVsm1NhmCzk
         0o2tYATTsJGgcAcxGg+hPs1xfnyd3dJhjzDzg6oV9ly4pLDToNN9AVJ40j+Z6sDgZxRQ
         yaVQlaWG+qI/fTXva9ZJvuFH5YYPorYYKBSbNaIDi9H+YhaQUr1veCW8i9NQHh8S1S+1
         SJNw3mCxHDd5CU7zEeWXGC0c9M5PR9Gl2qe27d/awyI1m816RGAxeE83QT+++XhuxNii
         2gEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        fh=eSeIJdnAX+LC2Uv/lCSv7lt12PuBJ/FNRhbHuFoIXLE=;
        b=C9lEZXs/NsXbdXDT3kj4DRbWo0wHI0ED2QpKApUAG8ffA3bz686wiCLl8roQBahomU
         TSleCBzQwRbX5WArHIALc9AOdc5f9u/1xQWarV09m3LFqHP/IYdPkMo5cRjl8hQ6Gply
         XnuAGhaRWBSxBpzA1/REUtMKyN7b1ZEYxvJeWKnKAUVqSrhA6o+lmdBAAh3LLA+Z4/HB
         k0OdCHIPxYU/ByjKoHY10oVwXSt7WA4Rj19LNf9dFUgJlWgr11ZHqW/dD0Kxwrm/bCnP
         uB4AtdjKADrenibuhkOGu7qczJOknUkwfr5ZWn4oa8UpHzCpQaW+pr07wCoiyoMOVo0g
         06cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793058728; x=1793663528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=IrwijN25Y5XuhkNoEvpxTGUzu2F8Fw7yumOC6bQX+sv9sI5cIkUQ+8qDyW8Rn0leIE
         KD/M3UgHYaJH9qxw5QEzap4cvaO8QRp4WvUy/b8d8qlbP4zjT/NLwA46mVK4rk5TE67Z
         hbcIs7JRXy3S3BU1Zp46QexhDFTfTqhgb9F5yDiJoNepIvxVOAnGlUkvuMj53pVOulEq
         nY7AospiQUxyoh3b4b1zlSlhp0Xm7S9U0DWHUHqyywQpS6V9BxBGr6qPvm7+SL/x95K4
         vKS38fvl7h/D+VqUiNNcMPjyNlpB+LfGZlaoNjHo8oTsgp0eeolgiheQhrTjRg97kEV2
         ylBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793058728; x=1793663528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=tDCJYywEmzF57ob8u6rYUe1RaHUe5PcFutWeSrCszW+PuN3aeAfCb3d6s7beV0PPaV
         t0oof/vMHRVqmFDoAvGK5xK8HilCmF9oaymxAVAPtg/JfLaZiGz8ggGZclG4Ce5OgZ4d
         PQ4i0VrJTgQLVh7aWzIYOoT0WazNPPIzHlifNEkNLCsKzewzMWE0nPT1sy8FP7EdYimz
         craK6IdoZhI+p+gvLzVjYLiE/04l24jTUNJx1UuZFnpstr0I22L5eJwQO+lmxK8TWsQU
         0A5gpMGYL1CAVcM3uVr7TopW8gnr7MbE+cL77Crb11U1Erx2ZJAkIdmR5tPYxG2D/pVM
         r10w==
X-Forwarded-Encrypted: i=1; AKwUvByGJjyuPQRKLy1K1w65M2Hde5xFqKhg6AUK2B5A84UJSSfbrqiGNaiNAbG+WmNCScUR3zmOKhCc42GJrg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLAYq/EEtx72R1c/euKCX0Nk7uOCO4++TO1T2crEeNWhgdMKLff
	ae+3OiZkOp6WH7O9hFoCSNAMEMeHJGH3qNs0cg+z3LQMm4uw0GUenzFb2dH5Cy4N9c70K9gwSEW
	JDkknq+8vqFcYFO3mv+/9qPrtnOxd7uKB7FaCm/8w
X-Gm-Gg: AYBFou0yTLkxHGU5fcZBAABm430LTE33X99wqouGIe4hWR69GgLq3+B1W8nmx1UpMFP
	nE9nrToSXikBG80FohdmYJ1nB0Zxa+l6a5XlQMrFmUADpG42iiNSHpvcfhsBQzzAA+jCavtfTRD
	V0q7XG+U99XwTpLZiuabX4gyhZwvKR1om2Y2AIUNmeDmXDnuxySixtKAPOog2CVYyxj9JeuDA/I
	d1lfbj10PoCF/9ldxVG2UrnDkQixdnmf3BNFUJyZJogGEaET5hwv7Rc+rWhkpRkaS4jdEZlQfAc
	/c2UapWNbFUHW0IcusytQYr2MzaIXmSKy+2VVLDddTqHlUOKQcMVYXKS5TtNb94Z7euP+peJn24
	iQnsTBIRoFvI9q+iZBNTUm+a9jEXoNFSaSOpqzss3Cy9t/bTPy6p+Cqj4TirZnFfxsg2Mc1j5Rp
	1MV6iK8jgfuVhRn/XjySfIgawDZ9+f35Y+DGFTnLioJjzQ497pvhNxD9kH+WT+VfeqW6m69azhN
	uq5ujMwfg==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr943075666b.39.1793058727681; Mon, 26 Oct 2026
 16:52:07 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-11-jthoughton@google.com> <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
In-Reply-To: <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 16:51:31 -0700
X-Gm-Features: AclHuK-Nhf6TYTDNWSq0v6hReecRKBdo5ExoV8oZWGVCIO9BK-126Jv082Kq0QQ
Message-ID: <CADrL8HUZ3t8RdMEeBPfqsy1_1rN0Ty9B2c4iP6OzNS12te6vOg@mail.gmail.com>
Subject: Re: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 4:03=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> > uaccess_without_mm() is inlined into every user copy, including every
> > copy_{to,from}_user() call site on architectures that define
> > INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
> > own __bug_table entry.
> >
> > Keep the NULL current->mm check inline, but move the warning into a
> > single out-of-line, __cold function, uaccess_warn_without_mm().
> >
> > The trade-off is that only the first offending access in the system
> > warns, rather than the first one from each call site. The stack trace
> > still identifies the caller, and the access is refused either way.
> >
> > Compared to the base of this series, with defconfig + KVM:
> >
> >                      inline WARN_ON_ONCE()    out-of-line warning
> >   x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
> >   arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)
> >
> > On arm64, this removes the ~16 KB of __bug_table growth, while text
> > size is unchanged, as a call is the same size as the inline brk. On
> > x86_64, the call is larger than the inline ud2 and causes more .cold
> > splitting, so this is a slight regression.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > NOTE: This patch is included for reference only, to show the cost of th=
e
> >       inline warning.
>
> I would suspect that the growth is larger on architectures that
> don't implement __WARN_FLAGS() but rely on the generic WARN_ON().
>
> This would mainly affect 32-bit arm and mips machines, some of which
> are very memory limited, most of the 64-bit architectures have it.

Thanks, Arnd! I ran some build tests on 32-bit arm and mips:

arm (multi_v7_defconfig):
 - base: 31,913,726 B
 - patches 1-9: +64,816 B (+0.20%)
 - patches 1-10: +23,193 B (+0.07%)

mips (malta_defconfig):
 - base: 11,830,177 B
 - patches 1-9: +61,168 B (+0.52%)
 - patches 1-10: +25,881 B (+0.22%)

I think it makes sense to include patch 10 with these results; cutting
>50% of the size increase for arm and mips seems worth the trade-off
of only WARNing on the violating callstack. Let me know what you
think.

Is the increase even with patch 10 too much for mips or arm? I can add
a Kconfig in that case.
