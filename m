Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793127092;
	b=SWWHcMCnc2rN2zQ6VwhtMZBEzg5gNYmLHuphAQUE/K4xReVK3FZoXjUEv40gWc2LPZcV
	 TtBQl1yFxGBO4PPVT+NYskZg8EKAfeO1uZ/9aMqCroGG8ZQQ3j1pSAT2LAc4fxOWgTm6L
	 bE+44dmO40WwApSRnCUWIwqXxQF6WjKyeP1/TZlYFua9ljmqVEBtbk/qsOJvOa48W/BGN
	 j3Do8ryPy+FU8/qYzjAYc1zP+QjW/YHVkZFkn1vVwxQb5aBlxd+uG9W5J7GwJ6NKW4dAe
	 yefp9BEE2nrHj84ZJm9OFExrVIrO7zuXEEw0T7aDOQQKXKHWvQ857I8WEu5X5/58BMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
	b=TT6aiAyMQPIw6/nMNv2tgb2gs61vTFJjJOn2KJzlPm3xuke+mgO2TCltoYQBFNLE5trT
	 PfVQFePsgRA6oGjQ3hmFoEQi6VyEwiwvuKzJGCiNt+Ht03MhWU2bDUInjg77g0IjuogYD
	 OoZgBXqgXyP9KM+atvioo/+Xrc3BSYVb5KxiTQzMrd2OSWrzebkWQ6sM25+GdWE4JftN8
	 dbmOaGGp8H/1plQMOLIsThgDC4EMwiI6rWIbOIblfyFe23tr0p6YtNnBH7jatyXWAzHyZ
	 vZnP0WX9gM8qla3BU7l5QGGhNs1YXlnFH090vLuN2J4OZaVLUdL62q/FAwMCjMzXTWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HFK9DQOj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A02606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 18:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A02606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HFK9DQOj
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c3fd91337baso21458966b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 11:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793127090; cv=none;
        d=google.com; s=arc-20260327;
        b=hx6xBYmOJCStGRbFSjiOpc8t0FYm/loAPoJAQouShjKkSpJ+Lx/BU5eydyjOjXn15q
         vO7fm/7eTLVLmg5jWBFAlOFToXKZNHGVebQJRRp9pzDGeUWe0jKlXFzHl7oJbtvAxJYL
         6XeK8Rp5WptMkKhCASritConhVi1j6Mdg7GFwgHAWdITGU2JLE9C/pr6o8mghuJ9h1tp
         nxFNgDJVnEnGczMy342+Qs4FiBv1TnfJnAVC6Wh3wPVGmpA8KKr7X7FOiuHpuCgebOdx
         cj/7SkyKeex5NZu7T/9Ddl6kSx4bdlJJFzqXoXpQcZpuknFoUReo/e3JqPPy8dtFFanG
         vrJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        fh=vQgwKsLR0S9zll2Sqwuapm73VrdUe8eYNc3K5jsToTU=;
        b=EO0WdsPvDe0+CeiG5/3kZie7jaHObpawNdswcKimOLhnns41IJFMCy/vLg3HLKrZct
         LJMENrWC7FTjmZ490iHWEskUxROSbTmJ+VZ3rb5ZvAB0EEC3z10cawWa/eXj3sEZFoM/
         Wzp7t/miWtq6HNUf2uiviap61cFp9ZGRsIIu4vEG9oyR7J3KcYcB3ZFc9oV0lqB6rhAM
         39tl+9TBF+rhPMmZ7MeKRkRV0KZ2rTOyJE01fBRZuDgTaftP/8bun9okgJ8O5yeUDq+O
         s8fOV8hkWL903SW86+Bgz7FMUxHXwoCXRVtnFssR6PdEfzupz2vAeVn6US8EJTD2BdnT
         ZPUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793127090; x=1793731890; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=HFK9DQOjx55GzwyinowY3WKQr1IsXRiJeV+D7Z8hkiYPym2ZUBwoZvUifqN/FnkNGU
         pfa1ZewvhEMvZLoaCIPFZp4tA/umOO4oOn0eM3xlRhU2sdWIJfNsPw9HVJXR4LYjiytX
         dUAGwL90rw0Q5w+OWsW5iboZVP9RCytMSNYKe3ji15diP1zhAfgrHC9FvXhRMxxUMt35
         TQ2tHe1FHlUZ2NICIb0rhXxsSpvA5sFGf5zLgnOgSw/RZnKbxxQN9s376gQ8m4D1+J80
         lvL/AJdZ7uKnroRkKZncUslhbEYHXR8yj6xbpQX2rU8tK9ueLcaFgAw4VAp3h++AYDrG
         cmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127090; x=1793731890;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=FKbeXxCeDJgOz9f75YqaT7oXXOzx1041P1+rN8fg8qp5TAh4o0sZGjZuWosRiyp8s0
         mLWmLCDXZUB3V6Nwd6/DYK01k3ePSzR9dwj4rXryjX0+9J9xUglM7z3b0yIPd8UaFQmN
         Q31jXu4IsNKHyQ5AcGX+mHrtyK3RNWDujgVn3GMrE64BaM2tmpoALRrrKg5KaCowyr9K
         v59qlKTQBvm5oxogcrClXHc75COq7OQuyd98ZwbtM9UOxzJ1OZYyf1jDna6z0cKxn+mr
         XeLY5QKKKYpKYJIs90IsFOOdvVjb9VrjslDphcTU5UarW1nevHoZKSiA2hMEAfzfdR1N
         XpMA==
X-Forwarded-Encrypted: i=1; AKwUvBzeV3oqWD0e2njXpd4KJHb4d6SUyojvfHD3q3uTZK0KbRsHHZ7JFhrOV6RdCV6SBNgIyx5zxdHSUlDzLQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI1N1+jHyyE+695Ty6PlOF9NYltdmf2rO7ivysDrDS8eaDV7rkv
	XWpUigxSJi5mzo4vqB2IF9LXubMdocV4gfuqKEZCgIYqj6eNQtRFFbPS6paSkalWo+w0Z4yLrxy
	7azO2cbGXZtT4czeftIc4H+57Knv3JCGAdF6OJcp9
X-Gm-Gg: AYBFou1P1uMz8ZsoCrH/AAT/hcq/huRRWdz0MmGWMSDYeJrGCG6d6PSFDpL7+e/XRKP
	o/Sazf5/xl7jnAIQ/fIPLpmGZ80gf4dfq4jhWqX71Mn2VHwTFNIQaU9iJUn7YETwGISsvmCWrZv
	CgRfh5xbuaybiY2ETkQyq6rHh+g3+yEnb+BsXA7QcTi2B8bpv442IOWnNYUqzVxFQe5zDKjOYMu
	4StOeeRtahCH0fL2HjbH6W4SFIqGOIhiBQLKuOF6ItcyZrhLjD3znYC3Pn/6ZfHbKMFWWrP5h/h
	yNiQkexPSjIGKPItRdVoWOb/VLF8Vq2CByiB2rnhZH9WBjgVS+i3do2mzwiHJV0XhTnwBOS8cjp
	yNMFftazGP1Pvma73eH+3UXRVL9ckll78Bl1AdguYPST1R1rbOUsDlqkgnEa+tH08UeK7nqMSS0
	8T/uNmcRMzee6nYeA5QNeYjqPZRdNbIURkzVNPXHwQbQkfCUGZMiNKVaSA9+K3V9W5b/8PjNwGy
	LjDw+mypMEUE/CJTpaiMowPRxWRLuSR4A==
X-Received: by 2002:a17:907:a08a:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c49bdb68d78mr15531766b.5.1793127089381; Tue, 27 Oct 2026
 11:51:29 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-4-jthoughton@google.com> <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
In-Reply-To: <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 11:50:52 -0700
X-Gm-Features: AclHuK8M0uftDAMQJptfiH_zotg0NLNK0vqcV1a8EUqq1l3N0gBPNm3WO8H3TD0
Message-ID: <CADrL8HVHCVoh3AToNzFCe7KP=yC8byCGCzGYzzBEGYtYNC4fJw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when
 current->mm is NULL
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
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
>
> TL;DR: Commit message only: the security_file_release() example of a slee=
pable
> program running from a kworker looks inaccurate, since such a program app=
ears
> not to be attachable there. The fix itself looks justified.
>
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
> >
> > Sleepable BPF programs can run on behalf of a kernel thread, or of a
> > task that has already gone through exit_mm(). For example, bpf_wq
> > callbacks always run from a kworker, bpf_task_work callbacks queued
> > late enough run from exit_task_work(), and lsm.s or fentry.s programs
> > may be attached to functions called during exit_files(),
> > exit_task_work() or from kernel threads (e.g. security_file_release()
> > from a kworker running delayed_fput()).
> > In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
> > bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
> > call copy_from_user() or strncpy_from_user() without an mm. That access
> > does not reliably fail: the user half of the address space belongs to
> > whatever mm happens to be lazily loaded, if any, so the program may rea=
d
> > another task's memory.
> > As there is no user memory to read from in this case, fail with -EFAULT
> > without attempting the access.
> > Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
> > Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
> > Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> The commit message gives security_file_release() as an example of a place
> where an lsm.s or fentry.s program can run from a kworker:
>
> > (e.g. security_file_release() from a kworker running delayed_fput())
>
> Is this example accurate for the tree being patched?
>
> bpf_lsm_file_release is not in the sleepable_lsm_hooks set in
> kernel/bpf/bpf_lsm.c, so btf_id_allow_sleepable() rejects a sleepable
> BPF_PROG_TYPE_LSM program there.  bpf_lsm_file_free_security, the other h=
ook
> reached from __fput() through file_free(), is in untrusted_lsm_hooks rath=
er
> than the sleepable set.
>
> For a BPF_PROG_TYPE_TRACING program, check_attach_sleepable() requires
> within_error_injection_list(addr) (or a syscall prefix when
> CONFIG_FUNCTION_ERROR_INJECTION is off), or an fmodret set with
> KF_SLEEPABLE.  Neither security_file_release() nor bpf_lsm_file_release()
> has ALLOW_ERROR_INJECTION, and the only fmodret sets are in
> net/bpf/test_run.c, net/mptcp/bpf.c and bpf_testmod.
>
> That suggests a program attached to security_file_release() is never
> sleepable and cannot call bpf_copy_from_user() or the KF_SLEEPABLE copy
> kfuncs.

Great catch. Yeah, the examples aren't right (but the fix is still correct)=
.

> The fix itself still looks justified, since bpf_wq callbacks run from a
> kworker and is_async_cb_sleepable() is true for them.  Only the example
> appears to be off.
>
> Would an example that is actually reachable keep the changelog accurate?
> For instance, bpf_lsm_task_alloc() when kthreadd forks a kernel thread
> (current is kthreadd), or bpf_lsm_kernel_read_file() and bpf_lsm_file_ope=
n()
> when a kworker loads firmware with kernel_read_file().  All three hooks a=
re
> in sleepable_lsm_hooks.

I've adjusted the first paragraph of the changelog to:

  Sleepable BPF programs can run on behalf of a kernel thread, or of a
  task that has already gone through exit_mm(). For example, bpf_wq
  callbacks always run from a kworker, bpf_task_work callbacks queued late
  enough run from exit_task_work(), lsm.s programs may be attached to
  hooks reached from kernel threads or from exit_task_work() (e.g.
  bpf_lsm_inode_free_security() when the final __fput() of an unlinked
  file runs from delayed_fput() or from exit_task_work(), or
  bpf_lsm_bprm_check_security() during a usermode helper's
  kernel_execve()), and fentry.s programs may be attached to
  error-injectable functions called from kernel threads (e.g.
  btrfs_should_cancel_balance() from the btrfs-balance kthread).

I think all the Fixes are still accurate. The first Fixes isn't very
obvious; re-checking it with Claude provided a pretty clear
explanation for why it's accurate:

    This is the subtle one. In 07be4c4a3e7a (v5.10) the sleepable LSM
    set was just bpf_lsm_file_mprotect and bpf_lsm_bprm_committed_creds,
    and both always run with an mm. The LSM examples above only became
    sleepable later, in 423f16108c9d ("bpf: Augment the set of sleepable
    LSM hooks", v5.11), and bpf_wq only arrived in 81f1d7a583fa ("bpf:
    wq: add bpf_wq_set_callback_impl", v6.10).

    However, fentry.s was already allowed on any ALLOW_ERROR_INJECTION
    function other than __add_to_page_cache_locked, should_fail_alloc_page
    and should_failslab, and that list already included
    btrfs_should_cancel_balance() (called from the btrfs-balance kthread
    via balance_kthread() -> btrfs_balance() -> __btrfs_balance()), as
    well as btrfs_check_node() and btrfs_check_leaf_full() (called from
    the btrfs end-io workers). So bpf_copy_from_user() could be called
    without an mm from the moment it existed, and 07be4c4a3e7a is the
    right commit to blame rather than 423f16108c9d.
