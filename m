Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793055393;
	b=Dw3iIDDd4GMKLcZbgGhptMkVNH66KUtcbTIVQTxfhVOlDSEWeanN1MnThQSn1kIKcFzx
	 3Z5Zipe0NekyHq+hw4lLBbGiOIHN2BSqkRmbxlWPeaaCd10aVHY3+F/xQZZlIwCUzG4ng
	 mU0iqfzfSTYsG54sjcziE19STWRUh5cqyi5HlPGyTvAm5PV8ZXBtxr7yra7GRYLX/uQag
	 ZUJbEaWGa38ioG2ZXQMRGF5ZJM6K5FBKT06kpnkslh+KnfB6yVfgeeh/wvfVE0MS7rnGE
	 f3UbQ55XML8dGzC1OdDfWZ40qeIP6ASPxpwJTQv9ZEeadG4t3W0jnGL6URuEoXdqEdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793055393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
	b=fnhlWNWDwio10hL4zgiZRSKOElyzZFkybGLB2+XGMaiCeAbsHUKhwgyhqX903Wm10crO
	 DfJ/yHvW2/tZqlecRqHsejBLS7CWu41uJA92NuTVerhNZfHBT8GGM5hPWh5oV7i+zMbeH
	 GHe8qBbQ5Oh0BOYW1o4FAlKDt4rwLFigPpTjmYA9eNQrsOvUj3V9+43p+fv/OB2VTvbPQ
	 opeBlXCS3glpx3aGnJvRn+KaatTKfFnyL4tS4CrBOANowL4+3u3Rx+zISlBnqG78vWhDU
	 07d2l/rtOleb6cGU4oBTuh8zt9yfPFBm9npENJnL92V39YsDOPfHYlH6OAeicShFRMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s8grGiR3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248BB606A327
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 22:56:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 248BB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s8grGiR3
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c418e215671so458895166b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 15:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793055391; cv=none;
        d=google.com; s=arc-20260327;
        b=NAdkPkooPePhK0xppdWjmlbMVzBghPvmq16MKu98hiarPVyVja47pf2RKcUo9rCbRS
         vBE+Gszkfos7nT+X8lytBNGecgixhmfemy6ERzPS5jBz8O3LTVFz2xadc2dmUcidOC29
         rjhAujIgJCea6tTsEWPpc+nwI4esqXJOrqvYnppozMw3jGMxfqlqWueMrMLvmEty8LwF
         SB4+LPx1TC86gC6rH9E0FgYftxRHut0IwyjRNT1Mkixh3nZRwnvfvdsxaeEza2QU0hRc
         IYkJ1rtEve++/0qptLf6CN3Now7Q6NIbr6+dTwN8GaYmIMAc5rXF+qraqvudIs//lpXA
         Wnng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        fh=jXWwLPyuxnonT3tlY1P5yTZtWd35YydhHp3YYw5ANRQ=;
        b=Qq1d2Z3dSXz06hnjCnY9qp1qMiLp3sWO/YTaX8+YKEsp8kwog6jBbK/ih3m2YwE5AZ
         dAS7i7GvlX0CJ4N9Gsc9xwaa+W9/O5RePj41ow/XoRcCcKVqf9tz4v4z5Xc6wiqqf1/S
         I/xHqCynN66ucYrb1lfuvgmThN3cRPCl8OGSQAl+o0fhsDkEP5YWmH/g0gT3VyZ3kM+b
         +rgc01jDKkbWAUh2nY2p+x/2WjPsgXWcirSwXSiCGRXvHKXioeLwY9DF/FRfr/iYwTKg
         cNzp+A7WpXIjtMIjzcU/Yg6o0AlYYQ8fiq7Ad/cO0mKhm9qBJeKAWoJ/cNDTqaQngSKB
         Koyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793055391; x=1793660191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=s8grGiR3jmOk9ry50/nEnZjaxWjWOPyppi2m4MHQTMfb5el8k0obk5/UMSWfPsQmIM
         HPtLzsEa12OcSsVXiRmiCNw+UUDDo1UYyS6DiU9bwXoKmoGF82ns9DjJzrfs9pJWdjkT
         dIxIeAf/R+LNQl/XTj1bdocyLOLlTkNfh75pW2KuZcZpn6JGMaXwZms8i83nnm2msMhG
         qxuIapSALuC5I4z0EKwNizZvGG6PaVYwrsYFc03clQ+zaffY9Yi7+Rd9DeVq8TqQMsPo
         mOa9KjkQgAnBHYiQJzjduIMO8ab1In9zxpTDESz20wql691IHa3z4eYMgIiR+VfFmdpS
         4rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793055391; x=1793660191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=thymeigz3Kpbmn0W+TT3z5+RcxdaW4jQ6PgnRdUVnt7groYBYB/zulvNMKZaERHxTR
         olCMtRAce0GJ4FKSaJcP/aDQrzTmJ7RLjtidOSn7xUy7Y4nZ2z9z8Cub1VATjDVtJ9ZV
         fzJe9+P+sU8pKdAjpklDJ3OCsENPK06dLWKe4oXeW1SZbpliM/Fx0Qoibu5vI6VnKBX/
         pw/W8AvPogcY5DZyOYV/cYXb/tgMvp9rsrrxY9eZYEUDc2v6uS1vrOwTnlb36Tv/YNUo
         7cSgL6A2Ai1gTcbCws0RU7Rz/8o7mBRW1OVeFYSE+PLnug2lpPQT1YJuHmjtu2hwXS/r
         aePQ==
X-Forwarded-Encrypted: i=1; AKwUvBxBkiS0Ty/VQw1N+n96H//6Xab6Ma8lJO+1HyJxWdpqEUdnzWy5VWpnHjbvsPd1RCfkpv5Dd9eDXL6f6w==@vger.kernel.org
X-Gm-Message-State: AFq9FYI93XxXpDbto2qNvAS8L+4XfgizO4Te9XiHzUjR8oJEXTTDkPWP
	hBslVtPDPJUyUMsJ8ZcZuddDsyFa098iRSBxbzlOpEj9j/R5uLOJ9vbna3I/RxT1L/svJGLs4vk
	VORIOMMo/CHu8PtUN9OYJys/4ug1hjI7k0uZvyBRb
X-Gm-Gg: AYBFou23ONktGg2UIq+NfUrAP+Oj5KDWvcbdc2u+6yx7mPR8qxDAxtMBcRBWgt/Ytw6
	6ECxG3Bu4Q5TXWrwtE0r83Jm3ODm2XEMyafj4jtD1xhJOi7GFmRGVo4NrVMHftAxIMyLDUDMhY1
	vjq1gD6WY4BF4+RDAFO0vNsUxdh2nVSdIP6wE1Gg57WOxxBtzt0l45s9UGC1ZUxw0w8g1HJywH7
	AJJgsXYEiNMCSdb82HKVz8RwHrObTmFln8cebzO/Nl1mro4UGwCy/88Ks0U5GXZ9WtOXmgGqa7P
	nip9tt7Eh0kVj0Fe7R4+QX0VYOWm1Vl4quuATLiwwHwK/kWn84mE3QMULpg+41EAkNfKDLCdj9F
	raDE7GApiuXM4MJr6ak8s295QkZZHm0XOSCkYsXoxbZKjSJznz+7Np034J+tMxwkeV1F8uDdkC6
	UvXAY6Wr3iRXf6uBD2emvOV3Et+faZiBzwYvHLEKVw4/jttDc+c9yZdN7GIehNQQ8IvtLXdVZAL
	IvJoCli
X-Received: by 2002:a17:906:9c8a:b0:c2e:7da8:f54f with SMTP id
 a640c23a62f3a-c46bde874d7mr911731866b.38.1793055390933; Mon, 26 Oct 2026
 15:56:30 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-5-jthoughton@google.com> <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
In-Reply-To: <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:55:53 -0700
X-Gm-Features: AclHuK_4pEIR4EnpfJkK690R4CHqdS4wt-7zneGKcf5MW03i114xuH5q5kcZiJk
Message-ID: <CADrL8HXeYRC8w7F7e_6ZXK6MHd6FRepN_zD632j0JPjNUDrLZw@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without
 an mm
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, tglx@kernel.org, 
	peterz@infradead.org, kees@kernel.org, arnd@arndb.de, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	jmattson@google.com, axboe@kernel.dk, asml.silence@gmail.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, dsterba@suse.com, 
	mason@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 3:30=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > stacktrace: Don't unwind the user stack without an mm
>
> TL;DR: Commit message only: the Fixes: tag may point at the wrong commit;
> 7e8e6816c649, which dropped the !current->mm check, looks like the real
> culprit rather than 214d8ca6ee85.
>
> > stacktrace: Don't unwind the user stack without an mm
> >
> > stack_trace_save_user() only refuses to unwind the user stack of tasks
> > with PF_KTHREAD set. That doesn't cover all tasks without an mm:
> >  - A user task that has already gone through exit_mm(), e.g. when an
> >    event fires from exit_files(), exit_task_work() or the final context
> >    switch in do_exit().
> >  - PID 1 before it execs init, and usermode helper children before they
> >    exec, which are created with user_mode_thread() and don't have
> >    PF_KTHREAD set. E.g. booting with trace_options=3Duserstacktrace and
> >    an event enabled with trace_event=3D unwinds PID 1's "user stack"
> >    during initcalls.
> > With the ftrace userstacktrace option enabled, the architecture
> > unwinders then read the user stack without an mm. That access does not
> > reliably fail: the user half of the address space belongs to whatever
> > mm happens to be lazily loaded, if any, so the unwinder may read
> > another task's memory.
> > Use is_user_task() instead, which also checks current->mm, as perf
> > already does for the same reason since commit 76ed27608f7d ("perf:
> > sched: Fix perf crash with new is_user_task() helper"). This also stops
> > unwinding the user stack of PF_USER_WORKER threads, which never run in
> > user space, matching perf.
> > Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Is the Fixes: tag pointing at the right commit?
>
> When 214d8ca6ee85 added the ARCH_STACKWALK version of
> stack_trace_save_user(), it guarded the unwind with:
>
>         /* Trace user stack if not a kernel thread */
>         if (!current->mm)
>                 return 0;
>
> That check already covers both cases described above (a task past exit_mm=
(),
> and PID 1 or usermode helpers before exec, which have mm =3D=3D NULL).
>
> The check was replaced by commit 7e8e6816c649 ("stacktrace: Use PF_KTHREA=
D to
> check for kernel threads"), which switched it to:
>
>         if (current->flags & PF_KTHREAD)
>                 return 0;
>
> That dropped the no-mm protection, which looks like what this patch resto=
res
> via is_user_task().
>
> Should this be:
>
>   Fixes: 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to check for kernel th=
reads")

Thank you, yes that appears to be correct. Updated in v2.
