Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793123182;
	b=Fqc7NV1fGmaoJFt1fVGf+Lv0snqC6FU4mN1snTRW5NztCkPEXO0jPgxNa8Xn4FJQTx3g
	 mFzLivT9gYcPQDBvJMHGjybT4T2GpvMSPq8VDj1FkcZ4O0QMlfl99YGbZPMHeMbJW6J55
	 Rd+UVDuxbHSfUXNXNE7p8WzWvpx0Tezx4ywRSH6XG/tbizKwmeuwItsUgWaSJ6nv6hbFi
	 1bXlO/BwY52wT8yNkneBcv5SHkBTpepYYDkHX/QPJWpDazNIxEw2i0voAHUgWGBRQADbG
	 vV3DQ/5KISSPxbJcySnkkYu5gx18nty77wA17Jjn5aktHDKMI/qsNqyv2o+xwR9cK5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
	b=Bkgz1sT6t8/GASPEV4RadOrJQZtZOgUj9YAPlxDKm+jPSIgpBokSueomx9f2kVsOpciE
	 6qOFIWDbbbTNvKON63pGFliVGHJrf5FwEsMDDhhrc4Y5JAaZflNd2NXI//cwdVXLLaVcl
	 x7EgpMqtaTwvosfe6u3JI2WY7qrcftzAWfhRMovLjifSAQKFl0pIjpJoCIQZiIPztrNfs
	 ttK5VZf3qJe6/75j/zR5JLDjWdgIwXIVApLuh3dzXsFeXhUr30m8A7dBRFhitB7Iia1Ka
	 isTSKEtX0+HH2YDfigQhOcCb+5H+qoUHCGSk/+vzRmlbbfp1oerk3n4H5NjKLooCreA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dJZrWgbc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43315606A322
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 17:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43315606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dJZrWgbc
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4550d8ab15so10972766b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 10:46:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123181; cv=none;
        d=google.com; s=arc-20260327;
        b=k3d6mZLeSMwdRqUCnrSDfO+5rytr28Adbk0G4iN+Y8GUxrUOXeb9Zla8+FQvYVNiFb
         EcQMMmaYV0BRgLs8ERpn3jiosAtVTS8XLPcBeJS//dj5D1e6ofC1nRHbR7Sd57jTqDd7
         kCNefj+O7+oD5wsuSwzt0rmmWkU4JoapHiuYwaLfDAIPrxLca80dOYMr3QBmMYGAVz6X
         bSkl5TZy1Xexd1FOCi5iU7+cuMGt1MDSZOTGj0UAknXtwcSJXx6Q0FZg0WDCWRnE5cuv
         I5gnUAnsn1An4IAlmZQjmNtK0Alwyzw7yTb5fsopi179mo2EfNqQufhnyg8G9tJrfLOa
         1cUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        fh=AartpBF1o2n2DO+642rn8hreZtfhNzNvf0w/xRGIkD4=;
        b=MTNPG6mgf0B/OcIjvSrGhF13G8gfNJRtru1iQN8SnY8FKJvqXqmFbuKbthbq1DKAJb
         hc+nmLSHeBHMR+V1Aj3qV5rmaKyDMFIn4CCFQ+S3DVNPpZzM58kEE+KTKn4Vjy2rFkI7
         xdsnLy/uTI4ue7Vwvme5NJczgZBPS3KHMRk5pdmV5qWg6Jljasb5hpsZB+363kNChI97
         kKhYwItBnSoX6Ju6AFygmYtlLfV6RvUBDHhaIaOIWGBNC6AGzu0Dudeb0RQigGpW+cpO
         49xxMQPjQ126ecFY+oso79iwJmHQg4ui44ngTpFN8NwqLcXb9xyfWK27Ngm2mPI2wWUX
         7HDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123181; x=1793727981; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=dJZrWgbceCcvybGI6S+yBWHGKTnRTkeoo+QAXarbXhuJJrcuUxjX6DL3VJxyeJguO7
         EIXUQuToxD9Oj2ADRK5huhz3YAPfLd6CErpWQOPm8uk8bar6rE79bi3bMLs3pZe51bGu
         X4MzPetzpkt4sIfnqO30iZNgo0TbdVmPtmqopEkvLhUnsg2bhmTSLgRVVzhYHy701dNf
         Q0OtvKJRnZ80/E3NbSjyx0npRgDvtmNSPb01SZjgkwzglNyd+xHEbqih3MUFsYvHWiHM
         BQc/ZWywC5lvAnEYkPeZz4JTWFyCYlKLP3X73YxsX8/hg+Ad4REwmoFnONsNmbYY7MNG
         Lt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123181; x=1793727981;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=2vSnhcoAdMzIBja4UR1OIvStc6mqrL3srPDLj8pCarzLTk0GrbVu6fymTGeh1o5zT6
         68k9QKe1R091aZI1aXoqkUhPDiRNS9xuajfSP50IpJKI7SxtTQJw/5bQlFGzPrVTP/6E
         tlPJx9kPND2c4vMYcOmYr6dhDWG426qHWYV08/FQ9Os12vCG0UqvaAUIdqjIIXGyXrvE
         lD5lvivJExlrzhlZe+AkfOfg4QxYzg87FpDt+juaW8x8N5VZGSOptYCfyiSk4Of3D6w0
         u6rg1k7aS1ufqTJWWErnY+MolLZDuoz6FzCpAg3RAgqQglKpxCvYq9tXgbUAhkgMiFoh
         NJsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzq7RiskK+ZmP8aZTd82+P4SHBbURnBi7E95KRz7r+8XdmZq+ru/EEVd8nI7vwgR3q5yoFrXsb6rA+pdQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIByxVTcj/PVQH/+J1ctbWJbIi2nDVHyTQo3EOnIt50PxZYeJAP
	iQovbsPMqs0IsNcvr0oh0n/e2KTlYtWuwZ1UQzUEK7pG/HBsKbzdVr/HcOk3EgM1EvyB3nIfYfe
	oIKA48yKPdKTBRY81Ebw23lC1mr7AUs6QmAQy/dAO
X-Gm-Gg: AYBFou3YLThbnuwsvwlb/zehSsY3eyhdkdJY9LqTqnnYWuuuCgEITV5WMVvyTpLtZrS
	oS0Hmomg2DEuk027UqsWRWW/Zql0KNQ1NJTPkhtHtAvpP2g5C1f+Jxhk3dgLYDSZ3F2+kmw48+i
	UZ8x7I+2nGgBvgYp3dCZDRlqZ8VXj/3o6xT7p+TiKE+xPXtGrNW6uLUI0JjZZ23Gghndur/3UMA
	mQo4TzJNBkF6SNDZwt27uicWijPLFtxPwx9S2ce4nQOtxBKUlT+YsykFIZpcCRKpZyROYADPN0t
	po6J5TT3teFZ1tJFfAUEZ9K5YnjpNFYF+7H7PUl906RFaNvMmJY0kjz2/tG9pXiWiayCBvqq62q
	l+/fMrwWLQyn+jHGnzH4cuU9+PxcM4vQXGMiu7vi3sb+qKX6tD7YY77cv1hURAaHxIEec78QVrz
	b7ANax8rWXpzPn4tPNfaim8rxC4/H5Y790mMweCSFSmcNhgjCyy/T0EEtpRGNB/2+kfS9sT726E
	To3+7lLOgCYV1jyI2xequvZ/CXLvsc8lg==
X-Received: by 2002:a17:907:7b9e:b0:c41:b94c:4538 with SMTP id
 a640c23a62f3a-c46bdec03f8mr1197886866b.47.1793123179946; Tue, 27 Oct 2026
 10:46:19 -0700 (PDT)
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
 <20261026215226.3713941-6-jthoughton@google.com> <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
In-Reply-To: <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:45:43 -0700
X-Gm-Features: AclHuK-GDZyG6m8BFpUMWxfSIBXFJlvlZbCjTm5c1oLpEFzow0OEe9cdwDWWw7s
Message-ID: <CADrL8HXtBxf=qixBZV5-iz1sqfZAqSrMR4ZsJTFXS0N84G+nkw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without
 an mm
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
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

On Tue, Oct 27, 2026 at 4:09=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Mon, Oct 26, 2026 at 09:52:21PM +0000, James Houghton wrote:
> > get_perf_callchain() only checks is_user_task(current) when the regs it
> > is given aren't user mode regs. However, BPF's bpf_get_task_stack() (an=
d
> > bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called =
on
> > the current task, which are user mode regs for a user task, even if tha=
t
> > task has already gone through exit_mm(), e.g. when called from a progra=
m
> > attached to exit_files() or to the dying task's final sched_switch.
> >
> > perf_callchain_user() then unwinds the user stack without an mm. That
> > access does not reliably fail: the user half of the address space
> > belongs to whatever mm happens to be lazily loaded, if any, so the
> > unwinder may read another task's memory. This affects e.g. arm64,
> > riscv, loongarch and csky, whose perf_callchain_user() doesn't check
> > current->mm itself. perf events themselves are not affected, as
> > perf_callchain() already clears the user callchain request when
> > current is not a user task with an mm.
> >
> > Check is_user_task(current) regardless of the regs' mode.
> >
> > Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  kernel/events/callchain.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> > index 9d24b6e0c91f..a451ca2a5573 100644
> > --- a/kernel/events/callchain.c
> > +++ b/kernel/events/callchain.c
> > @@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool ker=
nel, bool user,
> >       }
> >
> >       if (user && !crosstask) {
> > -             if (!user_mode(regs)) {
> > -                     if (!is_user_task(current))
> > -                             goto exit_put;
> > +             /*
> > +              * Even if @regs are user mode regs, e.g. task_pt_regs(cu=
rrent)
> > +              * passed in by bpf_get_task_stack(), current may already=
 have
> > +              * gone through exit_mm().
> > +              */
> > +             if (!is_user_task(current))
> > +                     goto exit_put;
> > +             if (!user_mode(regs))
> >                       regs =3D task_pt_regs(current);
> > -             }
> >
> >               if (defer_cookie) {
> >                       /*
>
> We have perf_event_exit_task() before exit_mm().
>
> Still, it doesn't hurt to be cautious. So no real objection, but perhaps
> adjust the Changelog?

Right, perf events can't get here, since perf_event_exit_task() runs
before exit_mm() (and CPU-wide events go through perf_callchain()'s
is_user_task() check).

The case this fixes is BPF: bpf_get_task_stack() calls
get_perf_callchain() directly with task_pt_regs(current), so a program
attached to e.g. exit_files() or the task's final sched_switch would
unwind the user stack without an mm.

I've added this paragraph to the start of the changelog to make it a
little clearer that the perf event case isn't the interesting one:

  get_perf_callchain() only checks is_user_task(current) when the regs it
  is given aren't user mode regs. That's fine for perf events: a task's
  own events are torn down by perf_event_exit_task() before exit_mm(), and
  samples from CPU-wide events go through perf_callchain(), which already
  skips the user callchain if current isn't a user task with an mm.

Are you happy with that?

Thanks for the feedback. :)
