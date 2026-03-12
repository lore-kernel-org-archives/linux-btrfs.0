Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F63DC4B9
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331551; cv=pass; b=UIgAUIe5QmtzkmISAdTCcXF6ynGqmEN09wfAIyh4HwzsTao8Pe+eTSIriIt/sMMUI7nbnGWcNJwvTi7Bg4naG60+2Lbux8QS19prlTVMYScCLWlYC5+bnw7nc6+oelbS1khHAfll7lvubb33rpyRNoP8MjclBZ35Lk5bwuUJJgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331551; c=relaxed/simple;
	bh=uXwIo7R/AWmUX8v9NfNe8o8eyYKkzsQlLFxRYRKmo54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITtDgL1p7rbkjnk7rLlZXTrv9sOO5sffWt3zAAqyhpxYE38lQqfOIGjXxL2Ja1Ef0AGb2pmePfqkc9efCpB6GQx5JAwpOMMBGKo0I7cky0EXt6EnYk17FxyoW78YfvKYfw1u6HARCeCnJ6seEhNVmMiJf7Ea5NYGeJe516mFtFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=ZV71t7Yr; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="ZV71t7Yr"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64c9c8f8783so1433658d50.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 09:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773331548; cv=none;
        d=google.com; s=arc-20240605;
        b=RIdfgo8rNyH8MSTrzpZBWjKcrTcpJ9+SJn4RPX3ol+FNamsnM3yiB1CrpjjmMPN1LK
         T0N2uP+jIy7xS+D8pFsRF/w8TUsGtXeD9gLS3+yyQ4WEKnyvfW3a3xl8C+nuWpv5isB1
         ellxZ8IvG2a6FIbWYk9KOjuiJB6Emoa3cNX3AJnYCaQ+hcAHz13mu76a5YhtkuMNPPhq
         vcNeqCFcSy9SU8A+zRnF5pa85JYClHTe33TFV/V6U+BYOhuHeGGYLzM4H+c2OZMdVFHM
         bnpjtfTRW6T8xM3uRsX6fW7eeYGcNHO4p+I1FCtn4NBD30OoneUB3+IstwmzIMCCS3t+
         hdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        fh=BFpiyjPsEYLpjh0pZVN49dHkDyIosyv9Kx3Lgrge4xs=;
        b=AJMj1165tBuvLVXHagEIhdjfqltahjZJxWsHiOqQWVt5aYiqjAYjiWqJo4o58QDlIm
         XZ3k5SDN1kpaWEMwLdSfcYlZxfIkZL1jJTOCN7Ec1ZnnzabrEBs820wXQg9iwrssV1H0
         VrKsNqnIYOuEMOuRCwiY1LNeEbx+8XJ6IAgEiSmBmws81H7frKGms29hyhhkgV5KYV9e
         ZuxHwtBSb/yXANlPERNy+JxrFFBwHkrvpJS97KTOaYtVzOfJf5OQ+uKvMCrVLCOnSO+X
         nCvSLL2q6/qVTKoWyvP2kLgc2R0q3htjn5JeolYSpnymiNX84VF8AASK7kq2+ZJtzykx
         +5VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773331548; x=1773936348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        b=ZV71t7Yr1bKEaCrw5G92Jfwsdtqtd7yVBewYsWTdMu4hlPrngoMiOi9Tg98BUXGj7V
         J8zfT8WZvuSQVQoHqLeSQshOj58obuQHxEJH3i8/pbu12eU6C7Ce24M/UJLLYQE6Gyj4
         MBJKDgq3YAhHELLZd+5LiW+wYl057MgHnzcIvUsegkYPkvlEfdww7dLPjrHlDmsadUdM
         wSRYkiv5Ntk9U+9jkH4To9xPIEAmJ9iWvbmxM8yMdXibURUG9CU4usIPwIAMNK/zJ+LU
         w3EzMZjLrprjIUB0o8QsaOC68H8pgsKxw2R93SbRJDixW4oABx/etf2ISufqJ1uZrO5X
         OKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331548; x=1773936348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        b=Ld0tc+jyAlkImVmD0n6JL+Okta93oyFYBsO93ZbIwAUFkpGSFqlsNLKT0mc+tDM9RK
         MnJzm3KNhfGWephAng6Tb6rZR0IQ1zV9sz3s7e3A6oMYW2IUP9l45BlPXYOLvQ5jVMA8
         W9qjw3L5APdkOJ1gnOEkm5mtNuVlRaEs7c/b7TGC7NxCwJWGgFIYjiyyfDMua1q39P6u
         FRXpc6FiKGALqRYyCd8DXGajDuUH4ui2L4+zy06Ew1mOlgvLVzZ4Dku+ntM3ZYNM6KMi
         FqZEviUIjNVGv7IVHklK9re21ymf/LrJfDB0P5CyJcTqxuJEkwhoe1Q5pUvGo558o/55
         Jp8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1WxDhsUTaNBTVdKnNxHcipK9NFRk3VfKMiLbdQsm3i66ToUOxfOe3E5vKTjhELbt0GyU5/uvnFs11QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxnMXRJKnWf1nX+ZrVt3wPyna5DomVS0Z6eFhYKqtpHgf70Qjz
	YDb8OhcSkoBsxc57UNXb5sNO9gxtakOmFxhcojCHa3nZVXQIiJ5EuuZkVgn8XXpXyinrSJBe/a9
	8H/8UmpP0KypV/moiE8V9yJLgwIX7J+8WDTwnKUITzA==
X-Gm-Gg: ATEYQzzSMSR8+60bs5NasaXK714l4sEbKA2NMk49/Bk3Uuw3zUCd/Cb7Xh1AqD0BrxH
	1tENqWJm8J1onoO5KmL+ZUPkf3BLQxlnIRExbUWLGAFfPTRVkNFuXCUY9u1oai9Dm8S+isD2ANJ
	CwVBv7YmEiIBRK5JLrvnaFXX+7Uxa8g6DMPgUcTyz9S18BARtneyLL8uoF2r7WgyZiNXUnVdcy7
	l/NkpwAooPex8W1gE1zJpC6easwVTE/gwP7/rP9WNJ0zfxQ4DTboMD+9Y7tIlQoqkNgVjqkFgEL
	PZaIlMU=
X-Received: by 2002:a53:df06:0:b0:646:9ddf:5f2 with SMTP id
 956f58d0204a3-64e62869514mr137952d50.31.1773331547890; Thu, 12 Mar 2026
 09:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-2-vineeth@bitbyteword.org> <20260312111255.7925b4e2@gandalf.local.home>
 <CAO7JXPhg-Etspj9YahZrq8cmZ2K6AGWDrMnHO+oD96P_SmOLBw@mail.gmail.com> <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
In-Reply-To: <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 12 Mar 2026 12:05:37 -0400
X-Gm-Features: AaiRm52SVVT4jiV0FzOGXISct6FMh2E9oWpuKL1FA2qkv7l8yLE2a6rVIE8wyUY
Message-ID: <CAO7JXPiu8-LE_gG001_GQLoGVYakPdzmH2SXLqfzJjEUxbn1Rw@mail.gmail.com>
Subject: Re: [PATCH 01/15] tracepoint: Add trace_invoke_##name() API
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>, 
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	dev@openvswitch.org, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>, 
	dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Len Brown <lenb@kernel.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, 
	linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 11:53=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Thu, Mar 12, 2026 at 11:39:06AM -0400, Vineeth Remanan Pillai wrote:
> > On Thu, Mar 12, 2026 at 11:13=E2=80=AFAM Steven Rostedt <rostedt@goodmi=
s.org> wrote:
> > >
> > > On Thu, 12 Mar 2026 11:04:56 -0400
> > > "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
> > >
> > > > Add trace_invoke_##name() as a companion to trace_##name().  When a
> > > > caller already guards a tracepoint with an explicit enabled check:
> > > >
> > > >   if (trace_foo_enabled() && cond)
> > > >       trace_foo(args);
> > > >
> > > > trace_foo() internally repeats the static_branch_unlikely() test, w=
hich
> > > > the compiler cannot fold since static branches are patched binary
> > > > instructions.  This results in two static-branch evaluations for ev=
ery
> > > > guarded call site.
> > > >
> > > > trace_invoke_##name() calls __do_trace_##name() directly, skipping =
the
> > > > redundant static-branch re-check.  This avoids leaking the internal
> > > > __do_trace_##name() symbol into call sites while still eliminating =
the
> > > > double evaluation:
> > > >
> > > >   if (trace_foo_enabled() && cond)
> > > >       trace_invoke_foo(args);   /* calls __do_trace_foo() directly =
*/
> > > >
> > > > Three locations are updated:
> > > > - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retain=
s
> > > >   the LOCKDEP RCU-watching assertion.
> > > > - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> > > > - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
> > > >   when tracepoints are compiled out.
> > > >
> > > > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > > > Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> > > > Assisted-by: Claude:claude-sonnet-4-6
> > >
> > > I'm guessing Claude helped with the other patches. Did it really help=
 with this one?
> > >
> >
> > Claude wrote and build tested the whole series based on my guidance
> > and prompt :-). I verified the series before sending it out, but
> > claude did the initial work.
>
> That seems like an unreasonable waste of energy. You could've had claude
> write a Coccinelle script for you and saved a ton of tokens.

Yeah true, Steve also mentioned this to me offline. Haven't used
Coccinelle before, but now I know :-)

Thanks,
Vineeth
