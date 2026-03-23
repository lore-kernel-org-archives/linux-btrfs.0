Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04B3BD62B
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774281684; cv=none; b=lerm1ZqKemwsPB1/gqdK/Lu4g9VNJiAVEuAyDbhUNxOMJKM7flnvOWCYzgouarH9ibScivaTYjg6TClMbp5Phyd4wlCNazTZPV5vHsA3CI6XveYGUn+ftvL7XDLNy1mXVSJYlaL80c8cVOw05S70fZncexOQDxkYGeZ0fVmyutQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774281684; c=relaxed/simple;
	bh=0DPJh0DJ3iDimFvMQsoeZlDl8P4qbc82fRy/khoEFVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhuS3ZOC0R/dECY2riZ1R1OT7yKSQRsQ+0coxN8lPh0KsPZZYftBzo62B+xqJnbujeBtMl6ZhTnRs6vJIsdqVBgdMXYUFOpWKFgq4x9AGyzm0avbYtcj7UsV1h9n36d85t5Ce327LUBgdnX/XvslJFED1g1u9/6WYykPKxC6dhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=d/p7OssV; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="d/p7OssV"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c648bc907ebso3052091a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 09:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281682; x=1774886482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eViZzzv8Sc/M5QSGBQX9CwMHZ/34uumJnzvDlBpaGpc=;
        b=d/p7OssVJT0YuiaYN+bIeT4edJ2+JHZEHNRPYBVl8deeAayWuSb6xeuolV32K/hlG4
         UCl3cOhn0ndSX9VpNQmJXqxWRTKLHBsuPjCZk3RZXKzZ4EaGnViwQB6Wg9gpez0wyooY
         tKxq8IB6okGYTuZLLW1sWJrOsKZyzMxNx04k6yMYlrff4QWHFXN6YAFwBMQmpy3qUxxZ
         9W8RiuF00NHje7Y5cQhKw2UfFzbWEoELGddC7SiSsOHMWXJb7vY3mXx85u11BERZzkGy
         SZsKV5DkWl3KwMIewhXTtCgNKSnorTvnYHv4l84l56A9FIDPRQ9G0cH52LlZO5fWTrZq
         idtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281682; x=1774886482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eViZzzv8Sc/M5QSGBQX9CwMHZ/34uumJnzvDlBpaGpc=;
        b=Xn+wOkyHFP9FnGJetidKmJQoEQwMvH1lEISK9gPXHojwDASCj3UPYuZq/gUxa0s+Ds
         EfnQXnQCcXQFNZMNaN6hqU83P6k6rY/ebZT3ci+HPo3WGOo27haSEohcGtqWKUW5z4rd
         7HLpFzDUDsIwOpNjaOIwAI0ef4zcswVnj7pGY/rZucDwGAlf6K/J0RJYYSVfduL2mgtn
         CYJ/ltEDXTgSuAuvTStu7jcUlMnXTjdcdxWJP+vb3RjMn8WRMqhIpaTR4X9kN3/RrkNt
         mn2m4W/0pIwey+sJVXG5qy6vB4rjXkBWo6QAYSlGVvdg1/TvoKMhTaJMH8rtrWfTOE8J
         R1KA==
X-Forwarded-Encrypted: i=1; AJvYcCVlSV9Ng+L79oqScAFtGX8xFZhvmVCSUvrX2Xr3Zgc71B6pnv7oiRqlA3CVEdYcScLg23ZiAYiptvnQ5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ7HRAV8DGHOrRiCr9OAtgLSWwEey1KSrcgTLXrdD+na1H0Hpv
	RtGwOuECxC3IWiozwehdlz4lY0oGNNiRoM+8dAZ8xrtd8su5aVE85D+lk3SN/fjbQ04=
X-Gm-Gg: ATEYQzy6zqKrlzcglg2z501Qa0yHraKqbcL8JE858Q4m0eGH69YhM+3mHjdZP/no7TU
	cKIheG1H6X/APneSbSBnEke+AimtqUm/01lU2Sfq8bMnnM83ftu5EhvoHnlnuN+lcdce7VYQcEj
	ybuFcPtkofnqgDBCcpDjslNR7CkbBShCpkH9ioG/SywuuvGWPuM6O8qCKhVLdFvIp3nSAJ1ml1F
	hzRHpuo4PIOABEX5I93e3Fk5xUPx9xU1P0Z26pJ60zl6+SbhHez4rEJ0ovW4o+NikQXrmgo0817
	EOlqDc01pTz60KowOuQArjnLx48MyVOWstb6VYSEFuWR0hUBBlL1ApSIma2pm/A6CrLNNoXEaA2
	jnHPgwPD9ZhVvnA/4S4lFTjQhMvXurnPOk4CAxsQ5W6d+tCQekdKb1C3Htmq3RY4WvVJWK3Yquk
	CS+j17vTKTaP4iHJ4ZFD7YDoNt7Mz9wFzCc4ptAH5JcjL7Oe9VNEByjS/CP2GU9zod7w==
X-Received: by 2002:a05:620a:198a:b0:8cd:8d4c:aa0c with SMTP id af79cd13be357-8cfc7a796e7mr1828317285a.0.1774281661473;
        Mon, 23 Mar 2026 09:01:01 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:01:00 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	dev@openvswitch.org,
	Jiri Pirko <jiri@resnulli.us>,
	Oded Gabbay <ogabbay@kernel.org>,
	Koby Elbaz <koby.elbaz@intel.com>,
	dri-devel@lists.freedesktop.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Len Brown <lenb@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-pm@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org,
	Eddie James <eajames@linux.ibm.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>,
	linux-fsi@lists.ozlabs.org,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-i2c@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	linux-spi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/19] tracepoint: Add trace_call__##name() API
Date: Mon, 23 Mar 2026 12:00:20 -0400
Message-ID: <20260323160052.17528-2-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add trace_call__##name() as a companion to trace_##name().  When a
caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally repeats the static_branch_unlikely() test, which
the compiler cannot fold since static branches are patched binary
instructions.  This results in two static-branch evaluations for every
guarded call site.

trace_call__##name() calls __do_trace_##name() directly, skipping the
redundant static-branch re-check.  This avoids leaking the internal
__do_trace_##name() symbol into call sites while still eliminating the
double evaluation:

  if (trace_foo_enabled() && cond)
      trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

Three locations are updated:
- __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
  the LOCKDEP RCU-watching assertion.
- __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
- !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
  when tracepoints are compiled out.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 include/linux/tracepoint.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 22ca1c8b54f32..ed969705341f1 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_call__##name(proto)			\
+	{								\
+		__do_trace_##name(args);				\
 	}
 
 #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
@@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_call__##name(proto)			\
+	{								\
+		might_fault();						\
+		__do_trace_##name(args);				\
 	}
 
 /*
@@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void trace_call__##name(proto)			\
+	{ }								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto),		\
 			      void *data)				\
-- 
2.53.0

