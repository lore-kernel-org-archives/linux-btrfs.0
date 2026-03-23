Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DAE3B8BA5
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774281662; cv=none; b=LWrpgx6d2YpYCOUbBGo2llCnJ2dFNv8yssnqAlOlnLuxEnm5rFkBqgl3C/Yl0sF2clUegYFbLSRnm7FIAvrPCFtawrdkxlpKTwI2x5vLExveBzzc6eVpAuk69c52krrLQ64EAHAIHQp1cTtXFOtLxtSVYpArKd1LjQ7JVrUJSuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774281662; c=relaxed/simple;
	bh=Bz3Ots6yk9ZczWzMqmrxecnG8LNR/r4o3HZXwJKixbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPGskagaMUnwaVSUQDWhnfKh9++zoENfo8QEDSDe7DTkT+ruoR5f3b6+Nd4WOL6HLlR6UqgtXm9rPzFXEFb+zAqppJ+nW0GqOKU8HSC6RDyBk4RQdb495wefclaCg+ny9WmWPeLbfGdroclK4DcQRTBgCgE47lt1IY4/1tla8WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=R/Fh9/0s; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="R/Fh9/0s"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d7653db148so2420406a34.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 09:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281659; x=1774886459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7SscKSPRtp5r0bOyZYtc8orw97P+lM4BuDDRyRnpM2Q=;
        b=R/Fh9/0ssUIOYHHozupwIKg0grzxH1EcZe9DQ/Jf/sCyzphfrV4bq3Bgi3xOPu1tAU
         LEfPNurjS4EQOrYiFUTqeKQBy4mQmbA1KgPd1WKzazEwuAXD+6iYtGHNkqaNdRkc4pF8
         HJgrT0A5vU59fmZLsd6wbllkwEyv/pYYhvCb+Pkb3CSFxFYnRt4bG+js4tDiAeagGZtv
         zG3917v6MLlkzG0DsCrqnun4gnbgVlKd6iLCkp+SfLd9SBFgfaBs/qd95g3D+267JBnR
         f3AFkBSafT1OPVOyozkFk2a+G+U6MVmn4EgcxV2IXAlpEWN0KRzD45v7IJLd8lc6ABuy
         +RDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281659; x=1774886459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SscKSPRtp5r0bOyZYtc8orw97P+lM4BuDDRyRnpM2Q=;
        b=ATIk+ysfmTaDPbJtwMp4L78P0+4xgunHUsMxU/n0ZVD/KrC/hRSbRMxghPGfxeeBr4
         9WJnRHRK6xK3/ssyNpnGnKdSy4xj5efvoShE147rfZ4i/rujL4O36D1HkIr+zIUN0zeQ
         WB/apQOQ0sMYv6O/C1c+8AYrClGvJ8tfBV0SfT02Mlfx9fF3Nrju25Fvehw7rl1t0SlZ
         HmeF13yophWGNUKR7ESOpWO9nDg5/n3cemRrWzq8vglSIrZHk9alNww55+FBpbro3BHh
         OXtskRHchxrYqoCGce9akWqIkQFhMlwAzzlWTX47i+moZyHyQOVCR9RxWQc65kp00AbE
         LPnQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+njSLBDz+qSL5ocyorIe+DfAlybOO1vf32hDMQbX4Cv3hojVTiqlv/LwbZ21IDLQvTgvbN35xWZ0PfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJDzSdy1qBITcbVo5aKXYh/mkikVoJxGKVNqxguV0Deo1V+Zon
	p190t7Hv+mbNYMWTsGf8LVtPLlL95xqaQ6QC70QNGP5145c7QqFtOxLnb2iq+Rk8z+Y=
X-Gm-Gg: ATEYQzwCz2+ZWAm72WHRwOO/wWZBkXy1cDNhyC6bDUDHHzo+c0UJag0n/7qzNTHOuv7
	9kQox4qVyKAOmnIbxduLSTzK14VjvE270xyHTInMpfNihN3yoM7+ygDi3k/kE/wpMOBL65MxqQ8
	4oRV6UmlqEo337asHqXc65OD4yytx+vgOJiUCRI0wHQ266GDgUCpMWqNe+bxO+beP9k8oUVP/Zj
	Z8Kts2D7kKy+6k5F7QjsxMJue0XY6EJ1l9hF+kj2T0beNs2aTxItEQc5rMl4+ggfynC7YeIu8Vx
	qMBZVOEAYwWn5rDn15r5HprqClyzccJv6N7s8o93ov03Oj3UD5z9SpkuBmaIZb4meXmEhRYXc44
	zbKPO+HZEmxADIyRZOBEJoUaJ3aCpwfOAINtOE6Cwu8cM4lkm16lzRtcFQ0RB7LXuptPwQW9KiU
	2/T5OVueNo8lqQ3tpySpy14V3/xSlht00JtgRDenzyQRjTt1Xhm0FpV0cZudzWOXlrsg==
X-Received: by 2002:a05:6820:3091:b0:67d:9cc0:968 with SMTP id 006d021491bc7-67d9cc00e0dmr6486936eaf.63.1774281657494;
        Mon, 23 Mar 2026 09:00:57 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:00:56 -0700 (PDT)
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
Subject: [PATCH v2 00/19] tracepoint: Avoid double static_branch evaluation at guarded call sites
Date: Mon, 23 Mar 2026 12:00:19 -0400
Message-ID: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally re-evaluates the static_branch_unlikely() key.
Since static branches are patched binary instructions the compiler cannot
fold the two evaluations, so every such site pays the cost twice.

This series introduces trace_call__##name() as a companion to
trace_##name().  It calls __do_trace_##name() directly, bypassing the
redundant static-branch re-check, while preserving all other correctness
properties of the normal path (RCU-watching assertion, might_fault() for
syscall tracepoints).  The internal __do_trace_##name() symbol is not
leaked to call sites; trace_call__##name() is the only new public API.

  if (trace_foo_enabled() && cond)
      trace_call__foo(args);   /* calls __do_trace_foo() directly */

The first patch adds the three-location change to
include/linux/tracepoint.h (__DECLARE_TRACE, __DECLARE_TRACE_SYSCALL,
and the !TRACEPOINTS_ENABLED stub).  The remaining 18 patches
mechanically convert all guarded call sites found in the tree:
kernel/, io_uring/, net/, accel/habanalabs, cpufreq/, devfreq/,
dma-buf/, fsi/, drm/, HID, i2c/, spi/, scsi/ufs/, btrfs/,
net/devlink/, kernel/time/, kernel/trace/, mm/damon/, and arch/x86/.

This series is motivated by Peter Zijlstra's observation in the discussion
around Dmitry Ilvokhin's locking tracepoint instrumentation series, where
he noted that compilers cannot optimize static branches and that guarded
call sites end up evaluating the static branch twice for no reason, and
by Steven Rostedt's suggestion to add a proper API instead of exposing
internal implementation details like __do_trace_##name() directly to
call sites:

  https://lore.kernel.org/linux-trace-kernel/8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>

Changes in v2:
- Renamed trace_invoke_##name() to trace_call__##name() (double
  underscore) per review comments.
- Added 4 new patches covering sites missed in v1, found using
  coccinelle to scan the tree (Keith Busch):
    * net/devlink: guarded tracepoint_enabled() block in trap.c
    * kernel/time: early-return guard in tick-sched.c (tick_stop)
    * kernel/trace: early-return guard in trace_benchmark.c
    * mm/damon: early-return guard in core.c
    * arch/x86: do_trace_*() wrapper functions in lib/msr.c, which
      are called exclusively from tracepoint_enabled()-guarded sites
      in asm/msr.h

v1: https://lore.kernel.org/linux-trace-kernel/abSqrJ1J59RQC47U@kbusch-mbp/

Vineeth Pillai (Google) (19):
  tracepoint: Add trace_call__##name() API
  kernel: Use trace_call__##name() at guarded tracepoint call sites
  io_uring: Use trace_call__##name() at guarded tracepoint call sites
  net: Use trace_call__##name() at guarded tracepoint call sites
  accel/habanalabs: Use trace_call__##name() at guarded tracepoint call
    sites
  cpufreq: Use trace_call__##name() at guarded tracepoint call sites
  devfreq: Use trace_call__##name() at guarded tracepoint call sites
  dma-buf: Use trace_call__##name() at guarded tracepoint call sites
  fsi: Use trace_call__##name() at guarded tracepoint call sites
  drm: Use trace_call__##name() at guarded tracepoint call sites
  HID: Use trace_call__##name() at guarded tracepoint call sites
  i2c: Use trace_call__##name() at guarded tracepoint call sites
  spi: Use trace_call__##name() at guarded tracepoint call sites
  scsi: ufs: Use trace_call__##name() at guarded tracepoint call sites
  btrfs: Use trace_call__##name() at guarded tracepoint call sites
  net: devlink: Use trace_call__##name() at guarded tracepoint call
    sites
  kernel: time, trace: Use trace_call__##name() at guarded tracepoint
    call sites
  mm: damon: Use trace_call__##name() at guarded tracepoint call sites
  x86: msr: Use trace_call__##name() at guarded tracepoint call sites

 arch/x86/lib/msr.c                                |  6 +++---
 drivers/accel/habanalabs/common/device.c          | 12 ++++++------
 drivers/accel/habanalabs/common/mmu/mmu.c         |  3 ++-
 drivers/accel/habanalabs/common/pci/pci.c         |  4 ++--
 drivers/cpufreq/amd-pstate.c                      | 10 +++++-----
 drivers/cpufreq/cpufreq.c                         |  2 +-
 drivers/cpufreq/intel_pstate.c                    |  2 +-
 drivers/devfreq/devfreq.c                         |  2 +-
 drivers/dma-buf/dma-fence.c                       |  4 ++--
 drivers/fsi/fsi-master-aspeed.c                   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c            |  4 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 drivers/gpu/drm/scheduler/sched_entity.c          |  4 ++--
 drivers/hid/intel-ish-hid/ipc/pci-ish.c           |  2 +-
 drivers/i2c/i2c-core-slave.c                      |  2 +-
 drivers/spi/spi-axi-spi-engine.c                  |  4 ++--
 drivers/ufs/core/ufshcd.c                         | 12 ++++++------
 fs/btrfs/extent_map.c                             |  4 ++--
 fs/btrfs/raid56.c                                 |  4 ++--
 include/linux/tracepoint.h                        | 11 +++++++++++
 io_uring/io_uring.h                               |  2 +-
 kernel/irq_work.c                                 |  2 +-
 kernel/sched/ext.c                                |  2 +-
 kernel/smp.c                                      |  2 +-
 kernel/time/tick-sched.c                          | 12 ++++++------
 kernel/trace/trace_benchmark.c                    |  2 +-
 mm/damon/core.c                                   |  2 +-
 net/core/dev.c                                    |  2 +-
 net/core/xdp.c                                    |  2 +-
 net/devlink/trap.c                                |  2 +-
 net/openvswitch/actions.c                         |  2 +-
 net/openvswitch/datapath.c                        |  2 +-
 net/sctp/outqueue.c                               |  2 +-
 net/tipc/node.c                                   |  2 +-
 35 files changed, 74 insertions(+), 62 deletions(-)

-- 
2.53.0

