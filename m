Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6536E3F23CD
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331744; cv=pass; b=HGmWUmSpBV4YnFAbGzE409XOIMU/FrHTxNPy8N+vDB4YUGj+rnzpLnlTSBBr0RnOJhv0EDsYMOW6rwhOygfX4FElsPyc+pHQtqCfjZ2lvpa6EomoZD5Q0/8d2DIJN79vk2KzNQTcGN0e1TGXdRTPEdiGuboucxga16E+rD+LRFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331744; c=relaxed/simple;
	bh=/9ZhlXnE8IpHyY7rKGq8AMXoEoLmeVmAM+IAe1Oezhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rwVM9tV12CvDAX3YFseBfOV5085cJJjZh7PkY7UydIqkCdhODDtA0Gh4guCKa4LBfl5o0NSzhzliMD4MhE9gx3+JgMHxNOR93NFc+BUfV+aAtYDb7F4HIa/WbqDmyFXpVANyF84+oskUy2qr4bD2LDp5bBV6aYcZ1Uh6nLBy9lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=m1ki3q6s; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="m1ki3q6s"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7985ce90542so12999607b3.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 09:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773331741; cv=none;
        d=google.com; s=arc-20240605;
        b=Mb4srPXpTnD1bZwXKyxAc3G5yVwyalmPbN16+bT7Vit4ToW9C618oO+yzqUibyBHeW
         e49L8p91ZShdWQDP8vaz0lmzCc8sGC3A25o3gbHYGUQGNX1rba1GrAPUNmG+f7CXusuw
         U+oQCbW4krLnnuXmG6nVWjRVCbBujU3tW0mEmwzNZBbPCOp6ICTPIb+04gEzxhm3144t
         d2U9QyE/AxzU5OhJhdk1vc1N3eZMEvAkXnEQRm5fR2onuhelFwKejj4LCk+sPSP0ZVuj
         Zt31/maV3leyP/QWrdJot8RbRjNKDHzkphvMHmfx4oNaWx8OGuHC5ZDWbnY6MsyoydjO
         4srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        fh=318l5xG04toXJvZBk08TEpQiwpQ3+/WDvHIT2rFODk0=;
        b=MPTmW70zIIG0V5UZVuQQPhfJcOHLlndxdGj12djIJhVNH7O+vCeTQXMh0saGScu0Aq
         5r5dakRhII1Ni+xrXZIvzfrPqPAtn0k3y+SjQZPzgKX3lisPEyz6TH6Ij2FQxEb8bntO
         +BlfHOpffpvLNgdmZW+tE2nohLn2hWdtW2I2j9G2XBIJF6f1rIKd6X9oFfD/owhNQ+tt
         vGlNlbUQVH7zg4iStDXQi35BpG3GcagHIIaOtgO9+NRFX2G76cTely4e5HvBMiwHyAKY
         jnMHKdJ9yAJE+r2g5AQ6R69QkrwFrCIJedAlGylFO+EMnkf5IvlqWczaQE1rIvqBlmAg
         X7qw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773331741; x=1773936541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        b=m1ki3q6sM4E2UACesTTqdadtI+Q0abqlUwfIdHI+OjmsRX2whEFMpQZptypVWhQx7h
         QD04yZlyfzP3xSivF9scjOrX5/FKYwiLrKA2X7JGefZSd1ksKzyMr15sFt8BUlBtCA1S
         qJU7H/z8w1uO+F9Lf0dqC/P0kEVsXjabxHZfvBx9uTBgICn+qEBxH7rHMoE2jVFa285u
         ZgHMmgqvOB2dgKagDrzwCVgXrpWT6UXW/+5qlE/3A3PliRynwsbURLgRm9zWpjrvx8vj
         l50ZunSLyn6Bt2c18cyLVOhmld8Lw2f3Z/Tl83A9P3MTDzd0bDNTqIw9vU+Apak8seEn
         KC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331741; x=1773936541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        b=dsr2yAbksze97iFholetVBOSzo18FnDzGUMMrO5JvP29zw2Qx/K6u30DqE+SdkuORD
         juGF7XRFF5VTuE/b5RmBz6fX/W3GJ1gv5Q40qfEp56C0zyMv/9i3RCbkuMBFpol9tzRf
         EootCJ/L5QtNRjKY8TqrA04sDqCbBHPZ5/gSEHgmBBjcWJBrbhtX2rOBeW4H+0xyP0wR
         eRETKih3YPA84IRMCGVmMe4PZA6eKziH9qLVW/FYLWm6/IuNIvQ8ih66MP+ZUfieHr5A
         PnnV30qXdW2TwLu3wTqnQlkNCEbdyy9cfvfcV9f1akusH/O/nc8Z3nlBZ54gyjeIS10q
         lvyA==
X-Forwarded-Encrypted: i=1; AJvYcCUCA/DSasvrFIjBQtScwousTcEk74UhkJ2Eb1H4+qWpu9wHZLQ0BxcNpQpB/ZYsljiUId6jKP0dHAeE+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsgC3HUMY030t58IihrOZ0JoBW5luBuQ3MTvd75V+yY239+dYi
	/YBx6tDo9bCxeVjHxJjH88gr3q4gLPwa8T5zO2uKU8jo6tHDLaoeFFsAhvC/DzLsnWO5GVtQPQ8
	8NoAwqxy5966Fe3ZrLKFXVFLdtUSa2Nr3F0squTaOBQ==
X-Gm-Gg: ATEYQzyQ2abAKdgSWOcaDnlSDThCCdX/vl9IfA4z/nZmMrIrpM0ENe3mxf4U3y80rBj
	UMVwqPWFQTowuz7zR4tNgAHYmioH3WJSWGY65hXYB1Mllrv/N2U07z997ZPlRVLByW8+KkVKKVN
	18Po7/B8tFDN7AH3ewegnpyRVfgzH+gd+Gru+AD9MJLpKtGKO38d2lK4LJm1ZTV4mA6X7SiTlZA
	Y7MO0JPPDHbo7SDGWfolhgL6JVazrJGqE1LOqS86LJgxq5Ot3ppiMrNfBh74SIgK4LpYqvm8TCR
	jJfCVb4=
X-Received: by 2002:a05:690e:448d:b0:64a:e799:1d9c with SMTP id
 956f58d0204a3-64e63079bb0mr62693d50.60.1773331741406; Thu, 12 Mar 2026
 09:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com> <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com> <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
In-Reply-To: <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 12 Mar 2026 12:08:49 -0400
X-Gm-Features: AaiRm50l09G2avZYKQas6kLTqrDst8ZjnHTnngudy3h6MyVa79lzABXaRh3Trz0
Message-ID: <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
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

On Thu, Mar 12, 2026 at 11:49=E2=80=AFAM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2026-03-12 11:40, Steven Rostedt wrote:
> > On Thu, 12 Mar 2026 11:28:07 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >
> >>> Note, Vineeth came up with the naming. I would have done "do" but whe=
n I
> >>> saw "invoke" I thought it sounded better.
> >>
> >> It works as long as you don't have a tracing subsystem called
> >> "invoke", then you get into identifier clash territory.
> >
> > True. Perhaps we should do the double underscore trick.
> >
> > Instead of:  trace_invoke_foo()
> >
> > use:  trace_invoke__foo()
> >
> >
> > Which will make it more visible to what the trace event is.
> >
> > Hmm, we probably should have used: trace__foo() for all tracepoints, as
> > there's still functions that are called trace_foo() that are not
> > tracepoints :-p
>
> One certain way to eliminate identifier clash would be to go for a
> prefix to "trace_", e.g.
>
> do_trace_foo()
> call_trace_foo()

This was the initial idea, but it had conflict in the existing source:
call_trace_sched_update_nr_running. do_trace_##name also had
collisions when I checked. So, went with trace_invoke_##name. Did not
check rest of the suggestions here though.

Thanks,
Vineeth

> emit_trace_foo()
> __trace_foo()
> invoke_trace_foo()
> dispatch_trace_foo()
>
> Thanks,
>
> Mathieu
>
>
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com
