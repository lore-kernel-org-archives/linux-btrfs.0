Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793054553;
	b=HMz2DAafbhMLECn/6YDL0ITQEsWSt9/JWAsA9K9agaOy5C/jLmlISLZHkZ0/LVKU5v6E
	 FeLb5pBY8000tQbA+ao8jSZoQBs4gf5fUJC56vwzaGGNCDkfp4nXev+2cfiG5Mp368KXw
	 TKpvV8B0ULkpBWs0w9ZYCGFmXQJEi1r+lrCD+hCR4gpVzqH4WWOjIP8TcgcwqRccWpswL
	 CLNANP1sbvbUiyjTSR2W1qBwrFR/cYzmeO++sQhwMHHZl+UjuP/Wl6CqaFMd6u+HvhXe7
	 kOkjVcw3W9cCUdfYp8INzOpIrqW9j22rQuxVskeOV2ZuoilGV2VXusYnUYbBh9F3yNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
	b=UxabJgSS9Vn9o70Xrz5YZoj7JgoJ/TaDpcoRwvv72NnhdjBCgOKXeu258VftGoj6AUBZ
	 dS4cq3Q/ceACElQd9hc4oCO2Z1EBp3rD/gAbhdm8ommaDTk6LrpxYKpvsoEemyhbDblLp
	 ahLMns0gnZYSX9iugmM96xzq/r9boVfFIBLA8BlPg9iY3pwYjM6PxduQD7DxlLZEvOabF
	 tTop7MEQpSXXumlfSbTNX/kT6lsB1YRMXHWpYjbGboHEhjuVgXfp1ZoejIBKcxp60X/mh
	 tfB5LAC1b/VeQSGCLTrK0UKbgt+Ex8U8v/T7xw2gHSpsc03SUaeuHbz9dkUuzy5kr5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Ho8+h6Mf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54011606A323
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 22:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54011606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Ho8+h6Mf
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso519486166b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 15:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054552; cv=none;
        d=google.com; s=arc-20260327;
        b=eWwOQAVA+sDPgR8yr6lJHm6/BRq5xGiHbR7/ROowSO6Kacm5MvaLXOGIGJGJexWjTv
         33dBybZoA84F9N6UrMu2dvZqASxQ6I2vosuvnJmgNrrO6QoLrBKSS5Tv7/P1YH0wbj3s
         JWoZ6YGFNbMtv75b8BVRNZgXLlkUte1zNoTLJoiKiPWfWgdJhx3t/D8NMFnz3jyibb+u
         YptzM9VxhDujDAaYytO6VsxN7Kpd5ozOUBu3pECV0dM2mjkTqhBTCtB2lHfiR4i5zM30
         04ise1S3zv8dKd+QKDNg5GHGoZ3y1mMAb2apuOrfYffKIvzEu/K/R0DF5j7G6g6wQDHt
         AG6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        fh=sauPnNNoVhU2Igyk5VGvm6lVrn7o/pAWA5d6CS3EF5g=;
        b=EpESYwyeAHVV9JZU53yORg4GbpaPaTbOP+dqniW7gvY+qDHrRPTuLIDeQf6d0yV7TB
         cPKPZWALOjQt+bikxG15L0iEaA5LOd1qbyPk1JE6K+6T6YDh3nY90t1rVBWM08yR01ju
         X6KqJalGMP4yZ/ZxMjJFtbMRVBaxHgBBbw+yGaN0Gbe8IT5JBf1Q9ZeVO4yOpppHjS6H
         q8oL1coZsv20yJDoYwfeYZXzKElClneRaqLp2PNs/+dWqX6Htj9mBNB8mdmjg9Qh63vy
         fXIpSQPUZ1G9WqDkIywz9BbovSLYg2Bn+7/LY4QkA4wbtrjvCVJQt8tATsUveA4i0os5
         1n6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793054552; x=1793659352; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=Ho8+h6MfzfNYBnYXWcB1Csn7RkH5FDAzc185C3faxOFFVI5Ip8rPZvUVVS9a7mPz36
         24gi8R8N3yA+KvfwmaRReqCQoQsNezGiPP1Bp7GiihlQBrxNS9eCbaY93g0l7+W+vIC0
         voQ2Heu+uMnZMYR6TuMnUotBhMhKn8fZO7YhZJ/VGMtSyWbiopW5EZJQ5vT2/6dOt2QP
         h6y7P/JEcSU5qhjYmxEPNqjJ3oooD2zuidI/sWorRbLSpg0w4GfbG7VlXLnZBZNxscre
         60kjozBonZXdnmTiD0g6qsMUd7kqNlcLdjiG7bhzjYU1/2dfEHHIUzSVvBAgpzwQCCET
         IiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054552; x=1793659352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=Bmdb0lUy6BdRQgLs3uyhUCRY8s3/scYaQHWvWNYpXkqqCyh/nV00fI2pVnqFWQUZsP
         Arz8uzTW91D2xzJHqj65NOwcXBTOhnm5zG1TL+XcTKIoBJmmLKnKV03iN00LAjs33E9r
         Hg7vahYVYPA0HPNKm9uGTtMpLWA6a1O39sMtl44r4E8X2ekr4if1pKa8Lh4/lSRpkhzJ
         CJhEyvRy0o948wNiMRm+3wHol9f/TpXvPfKodoOaHOuDuCDrHaFyFfjw7gqibk8ZWPER
         T5wXobRcJpif+d43f0C8J2LADKp7Jhhh8ciD9Dz6VWyu+QqgusA3KWr4HeUVANuWalPk
         ovbw==
X-Forwarded-Encrypted: i=1; AKwUvBxOh8JLrB/5OfZkzJJLZI9pnV3ihcywvXbnsyrwHqR6Nbg4zKft4UI3fytYd30hRQyhwLIGGsyUfa262Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLQuMnndwWihDVuSkNZWdhz74MlifvvPrMED7Fq6EtMPkLzMqQE
	GUqRn3jaVPB7MdY7ci6lqxZeDzw0B8KzNHluRLa+T8DsxhYqX9FaChVTXGbpAjxPk3Ll1nj4mvm
	rBHtgtV2VtlwIgS0JUol8/uYLgkmYaTlGQF1GluCD
X-Gm-Gg: AYBFou1VYtVSC1G1qmzjo5oZSZCJAxCEjzInrtAK3D7Lqnbpr2e2dN+ngBz0NB0DuaT
	WN2EqR/rKAEc1VUSY7UrVlUeEq/3NX2mTetgN//2GOLYNeEMmCNNvOZBZbuxLivMDZFMPCqDm5y
	fqHHNiVEo23d9g1TzvceNCF3qfNd5EV2ID1FWnLH17mXTWEcY4qWBxbi9KzuuHUPGxR+GgToq5n
	JQj0Jao8IQ7PlXN0/0g8yOfXOGoR4o296A8C0vO4UbWRaQeNZtkUZ1y7WHGDIK6I1/xIQX0q5Y3
	HLxo04U2ufqD9OgwkaKnOj3bUL84n/HdGHPaKzpc2mV1U0tx4U2O9ufC3cC8c8Q65zjNA0dCiiQ
	OsysYqn795CV1AdXlnFdPW+WI3ONvgVtwdJ+jMt/GttOdTOC4G5tTGfMSeMv5CtDJxgsho2E3Wp
	K1mlFJkvWKjmagMF0wMA489+6vpJPW2f2CLAR4ZJOEup1isus6lIJqXh/8Gfxp2s/Bo0yGY37k6
	F5E92Ul
X-Received: by 2002:a17:906:4fcb:b0:c46:8733:642b with SMTP id
 a640c23a62f3a-c46bdeba20dmr991156866b.43.1793054551213; Mon, 26 Oct 2026
 15:42:31 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-9-jthoughton@google.com> <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
In-Reply-To: <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:41:52 -0700
X-Gm-Features: AclHuK9NQf_DmtP280VFWB18VLK39ZMzdxZm9Qsh_-4Snm7U1eOCkiznChHcSHY
Message-ID: <CADrL8HXA3KVX9agtcExpPuaBLC-zAEWx6QgsRnQ6+cb4AZZrFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic()
 without an mm
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
> > uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
>
> TL;DR: Commit message only: it names kvm_read_guest_atomic(), which no lo=
nger
> exists in this tree; the review suggests kvm_vcpu_read_guest_atomic() ins=
tead.
>
> >     uaccess: Refuse and warn on __copy_from_user_inatomic() without an =
mm
> >
> >     __copy_from_user_inatomic() never called should_fail_usercopy(), so=
 the
> >     NULL current->mm check added to uaccess_should_fail() does not cove=
r it.
> >     It is used e.g. by KVM's kvm_read_guest_atomic(), by several
> >     architectures' perf callchain and stack trace code, and by the gene=
ric
> >     copy_from_user_inatomic_nontemporal().
> >
> >     Split the NULL mm check out of uaccess_should_fail() into
> >     uaccess_without_mm(), and use it in __copy_from_user_inatomic() to =
warn
> >     and refuse the copy.
> >
> >     Don't use uaccess_should_fail() there, as that would also start inj=
ecting
> >     failures into __copy_from_user_inatomic(), which some callers don't
> >     expect to fail in practice, e.g. __wp_page_copy_user() warns if the=
 copy
> >     fails twice.
> >
> >     copy_from_user_nofault() already fails quietly when current->mm is =
NULL,
> >     and the generic user stack unwinding entry points (perf_callchain()=
,
> >     get_perf_callchain() and stack_trace_save_user()) only unwind the u=
ser
> >     stack of a user task with an mm, so neither is affected.
> >
> >     Signed-off-by: James Houghton <jthoughton@google.com>
>
> The changelog names kvm_read_guest_atomic() as a user of
> __copy_from_user_inatomic(), but that function no longer exists in this t=
ree.
> It was removed by commit ef82eddc0e31 ("KVM: Remove kvm_read_guest_atomic=
()").
>
> The KVM user is now kvm_vcpu_read_guest_atomic() in virt/kvm/kvm_main.c,
> which calls the static __kvm_read_guest_atomic():
>
>     static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_=
t gfn,
>                                        void *data, int offset, unsigned l=
ong len)
>     {
>         ...
>         pagefault_disable();
>         r =3D __copy_from_user_inatomic(data, (void __user *)addr + offse=
t, len);
>         pagefault_enable();
>
> A grep for kvm_read_guest_atomic only finds __kvm_read_guest_atomic() and
> kvm_vcpu_read_guest_atomic().
>
> Could the changelog say kvm_vcpu_read_guest_atomic() instead?

Yes, that is correct. I've applied this fix in v2.
