Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795625055;
	b=PT0HFC+nEtttvuE7YCtgkW8R/Pbw9KNz6OZI44R4raJSix2pW0ucSEfgppNpZ/fA1DSI
	 mOWEWtn6zJBuxPWniy5szftD9I64yBylryJbf2VTVZBMu68BxEaTtpQL2/ms4hYf/FKI/
	 Z46f+hpISh08uOZCU7Wp53aYP51WELWa4vPSpH+2bKOPUdSxZP8NSxy6HLAFEd0p6YQ6A
	 MEP2KMrYrHeRx77rLaIs63EpWK0ULjIktJn5jr7hYOxezPOb42lIB7F9zV945NshPI0VU
	 Bhgl5MNjcKL2OYU0ZTcZg//ItfN7lLJ8Z4HV/M9iWOgti+/5ZxSzsLtMGUqCX254UPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625055;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
	b=Hwc4lJ79KvzyhGi5+pn3F0ZayB0WB9Limp4wiXW7ASGwoTKzE4i9qavu/hpXy3rybXvQ
	 b7Mvc8jBg4EsfMszIuLNJdpwIDNgQE4T9Mgc0Fz26MLiwc1qakXnvgL26Q+k/ThA51bXm
	 dnCzmUyH1iAHTa1xPrxn+n5XRj5IUxWXVN/tGbt5ImFMcLHLvY8wNes9comqR5l1Q0kC5
	 KlVQ5igYzArfJNQwsphmnD7rHitAL4jLZDoKEVKfzXHXsH28NFNBQpqPyB57p2rgyi+ay
	 bpyiuuMN2QrQ8jIP2HThaxLh25XB1xuTNymdjNqqKlkwbVmfizZ9S3vadYj6Zt7oeTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PKZ23RQe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED9606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AED9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PKZ23RQe
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c51a02ad3acso146648266b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 08:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795625054; cv=none;
        d=google.com; s=arc-20260327;
        b=cbLUBbweTUonDLaIfJJ1pQ6pGll3JtchIFmYZWQOKGUNX7kELrOl6UGrFzmYlR+wLL
         UavGKCxEXTznjmqf/soNTWNdLLw24kfWiqDEZZz3AuhoIKSb1WdFgC3ReO0fHJjLfW1B
         /NnYx9mK0H8N6dODOfIjOn+S8mVlhrGxumdzK31fejic0T+jMUOnoa1tfE3UbHTf+8Fj
         zfLNU7k+Kjek9fE3hV6K5wt38ggeXwocy2eDR8qTvdboq+t/9yXuVWNSiDtPW47qzaJe
         RDOK4VAui20rmISwKveh2BPSoUd2WH9EwtA7AXDGzZXVXrs4z9pYQQYUzWmyWxyJS41l
         ggDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        fh=Cv558qb8zcZAv3KYPrRAl4fA/BUWgNTN/WYdvxhy0u8=;
        b=DMq4fh08AQ2puzrxqRjzHW8y9O1lVDhx8cK5SxKFvm7SVKgwLp7fK3Ec3HVdzqF2GB
         pctjDjoayQu8KUMIRfxAtuKulAUo4GKUSyI/cnmFNUCWfO6zVxN/rl4ozQ2xSJ2VBeah
         JYJCrcDC1eVaHIHip7WNlAVhqT9bTwQ1W5jssW0YRaAvAgdJgGYRRjhqMUnR+H441+Xa
         hYmKqyRBLDIZoQCPUIFi3vS8ejnkW6zA8C2n5c9K4rfMd620Jf/5l5d9zM3cT1vmj264
         cshW4fTXUudME8fet9sCrBKO18cfM1NEuDfni5C3nkOHxuJQxMLnQCnpFGKaT7gVwjpX
         bfbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795625054; x=1796229854; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=PKZ23RQeMEttotX4OBPRP2DbbrMEB51nwAQlsHi3Clsl60+KLwydytyVzIwS3CPrsp
         gMCa0qLojqUmZPTj1WgDWb2vfDDzy8I3ouZC6AtzVQzGhYkAtsdS7I194LfKbKzPHVBH
         9FjnQKv/TdlaTy27yqxtS+FRu+TCtlSdjsR4QOyB9tkMnDrs00BEwfTTEGdJNrrE0d1S
         i0G3BgU+8ocwt4ScMKi+JN47+02WlDqK9aHu8g0fQCVcWCnmaTG9N306L0mPKog4H/f4
         BgsXgGhnHP8RFqRdmh8kRVgxVbHO2JS8qa43xqFnpf9P4Z4Esbd1QfxvoHuOMiibIYtV
         4BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795625054; x=1796229854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=0lnCQBdBaOb8IinOeEMiSdkNIsQWAP9XpWoDDa968AaJ/EthltxjQ3OpwfRohLS+b3
         30Gz5SJamj/fSaksXqS85DV/AJmmxpXRM6cAd+5LEMEBhzD91mcUZMs5qxGwHe7tJ0LW
         6ptp46WbXJumGang4BA1h2DF9NImZAAAFtmKJnlgcCeXSLrroEoE38hPf6dRbDeph5Qs
         CE5divnsxE/aio8eb4hKh4mY02epED7vDoZQPwsRXlHPRfKmSJ+GnKhHK/1kjG7CrBWB
         fgBEf/L/g+JZgsu7LdsTNx/ac17awK0H9urQFlyHD0QrvB/ItwS13kDzc+CyuO+AHeyk
         3OzA==
X-Forwarded-Encrypted: i=1; AL+hErEFxEN5fG3oLrmV9F0fvs+VktIFAEk/Jt8YqAaO7TEBiCJHs0nUfn92w16krk1KLXjKk2lXnbIPI0MHNQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9fq37aiitsGMdbnOadKef4HI7oxg//FmvoNx3KJQn6NMqAwHW/
	j798IR2P+yVv6VJkJJw6jX5HrWnOu12irD47QaQvly3KWvvpAudv5e6aSNyBQ9dUPqQFIoHdFPz
	ppGgDLQVmaB27cn2gcFjHCt+33tJPWNLPhEJTqTzQ
X-Gm-Gg: AZFdTZf7ehOxeDt1waSNrhHMjhHhoM6l09VRpDeiLs6uvIkRM84+DRJtLhs+GQd6Lai
	1UQPsUHw1JLrA6vsZOEI/IaZ9zmMgmfs9HfqDE6DlQ/IjzH3kGu6b8LGskBUH7RJWN+zccvRj9k
	IFyJxytnlfwTM+KVe2r4AH+GmWL6JjW23q7PpRzLfAFd8T+ZjY5f5mdeKPc+vWhibsd/Jvo96hY
	OEvppzAiQ9dSzMNBlm46Q5cs6le8HM+HNDacPPSJgwiieFZMs0rL97Llkpa/nF7ng+O00ULdtvQ
	H6j3hCjQ7Ynqy8RK7suOK7QFyIzCYtWuOBABZMPVqSeFzy78wGup5lnUsoeBcJk4Yj6xvN1djON
	D0vx7ApPQSLkOyzKZ2qc/KLef/6pWGi5PE5kzllWVLUpdf1pSEb+2sfuIeUT24mNON1V917pnML
	mqF4nMmtU5e4vpqfEgLZZEQtw7wUCEc+Gm4jejOrU/kz+lbu2/s6M=
X-Received: by 2002:a17:907:6d22:b0:c51:40e:847a with SMTP id
 a640c23a62f3a-c513a1e6fdfmr1639688066b.0.1795625053094; Wed, 25 Nov 2026
 08:44:13 -0800 (PST)
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
 <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com> <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
In-Reply-To: <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:43:36 -0500
X-Gm-Features: Aa3M54qTCDON0Zo2YJDXp5pBtwrXjTcYjv8NoqDjQS_XV_tl8JrBb-LQVlKEL3Q
Message-ID: <CADrL8HUOZs-vWRyM9p+Na-=arRU+Gx_cWMLbxHmUYnho4fAUXg@mail.gmail.com>
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

On Tue, Nov 24, 2026 at 5:02=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Tue, Nov 24, 2026, at 22:10, James Houghton wrote:
> > On Wed, Oct 28, 2026 at 7:14=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
> >> On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:
>
> > So now in v2, the _nofault() helpers themselves do not check current->m=
m.
> >
> > I've uploaded a draft version of v2 here, in case you want to take a lo=
ok:
> >   https://github.com/48ca/linux uaccess-v2-wip
>
> I read through this now and it all looks good to me so far.

Wow you looked at that really quickly, thank you so much!

> >> Since in principle every user access should go through both
> >> access_ok/mask_user_address and current->mm check at some point,
> >> so combining the two as much as possible should help long-term
> >> maintainability.
> >
> > You're right, and v2 has been restructured like this.
> >
> > - The check is in access_ok() itself: the generic version, plus the
> > arm64 and riscv versions. __access_ok() remains a plain range check.
> > - The callers of mask_user_address()/masked_user_*_access_begin()
> > check current->mm explicitly. There are about a dozen such callers.
> > - The unchecked accessors, __copy_{from,to}_user()
> > and__copy_{from,to}_user_inatomic() (and arm64's
> > copy_from_user_flushcache(), which also relies on an earlier
> > access_ok()), keep an explicit check for now. Once their users are
> > converted to the checked versions, those checks can be dropped.
>
> Ok, sounds all good. If we get more than handful of mask_user_address()
> and masked_user_*_access_begin(), we can always revisit that interface
> to make sure the check can't be skipped, but for now this seems
> like a good tradeoff.

Great!

> > Compared to v1, this also covers get_user()/put_user()/clear_user() on
> > arm64, powerpc, riscv and the asm-generic architectures, and arch code
> > like signal frame setup that uses access_ok() followed by __put_user()
> > or unsafe_*(). user_access_begin() no longer needs its own check.
> >
> > What's still not covered: x86's get_user()/put_user(), which do their
> > own range check in asm, a few architecture-specific paths that call
> > __access_ok() directly (e.g. on alpha and sparc32), and arch code that
> > calls __get_user()/__put_user() without access_ok(), mostly trap
> > handlers for user-mode faults. Probably best tackled later.
>
> ok
>
> >> There are probably few enough of these that we could address them
> >> by either adding current->mm checks or converting them to use
> >> the full versions instead where that is an obvious change like
> >> that usb gadget driver.
> >
> > Sounds good. I'll send a separate series converting the obvious ones,
> > starting with the usb gadget driver. I think that will be useful.
> > Let's see how far I can get; hopefully I can drop
> > __copy_{from,to}_user() completely.
>
> Ok, perfect!

Thanks, Arnd! FWIW, there have been no syzkaller issues so far with
this WIP v2. :)
