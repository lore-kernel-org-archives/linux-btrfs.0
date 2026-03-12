Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3F53BED22
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327933; cv=none; b=nyUovOuYNlLP5eUWounGgoIjDYgtudCDkepd3PWZ50xfFg62yQ/15q9iOQa0tbKU1hWk+YxcTVyM9T8rQ+C3Ws/NjA5v2lw3Z7h/jRjQIQkkNa+QTSTcRLMBYLrubHwJmc6mzbBzG0i3WkDe5VRfSm6u6NmcCSQtmnm/VzUhtkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327933; c=relaxed/simple;
	bh=wFrH16wRP/ZRrLPrdvN9J5kV/62KiVf8oPQZXnkjAN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EXH5jeanR3yYuLA7SMErlVFGVagzy9ystU+N62GEHlBOt3mQVwYuWDZWCoSO21NSwegmaRrhGlDjTszRrWIh22c+2iMUr8UeLZOAaqu/BJzS0Bn24mQsMABCxHEZDfw7CbjOLKt0x+OGMjOKZmsxihDXIsk/fOusMkphRa/zn90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=OW/DV1AC; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="OW/DV1AC"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d743cd9e5bso770924a34.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 08:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773327931; x=1773932731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p/UukkhQcW1lhFqWI/Fw5V3bxdryulukbz8WWfM9zNY=;
        b=OW/DV1ACXgC1meD5kqUaAm+FZL1lWnMvkS4yVJbykbP7K5vclRgwIJ0xyKjX7imhp/
         JxxjkcYDPIFgCcRsHpsq5835/4tOiZXx4U2LrD/Jieum8wVn2Z6Z5nqk/9SiB45nd/qy
         /BuK9l4E6H6ktN13lZ0Hr7tfv7gU2Q/gQrPyh80u+hQmfQJHWoBipgWsTEkUGem3Rz81
         JNQzSDmb8/zc02tAEL+0aWPXdIdNl9rSHS9aSNKbrZ7DJXEXNUQ5AdKmtdWCkC9j1FJ2
         ratzAuFfZH/Mj07Ii9/24wDft/5/id9dHt4PadP+Rpp8ksPWtVWSLG+Lvf0x5+CB9K5Z
         62Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327931; x=1773932731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/UukkhQcW1lhFqWI/Fw5V3bxdryulukbz8WWfM9zNY=;
        b=MFUkNOB9b+qs8Ctk2qGmt/pah77NRWJgKULe7qWMH/qeTxbTJNaqsq9gLXrLkzceYq
         8kh/wj9U8hGIDfTJWKO70WalN3caS25RK/2O2VCAqeGlV8/LgsrKcTH8hLJb87HCCK11
         EcJmi0EoXK7YVQZUL7UWCdiUf+SZsgEUI/WEmSqEtUCDXXwAmUTtHujYm4NOeK9iCLwG
         6YflojBt9o+57kmvDURDOjvddevO+x/9VUDyhq9fNWY65plb2JlTzGJmHs8MaZ/srnbT
         4x988xD+9A969UUb3qf1/R5kXSMIL1zIdc/joaBFczyTVYlP2vM0HfZUxY1bbw84gNWw
         5TOA==
X-Forwarded-Encrypted: i=1; AJvYcCXGSKz+y8CyMuwOweOkJVxO88aUxQL1Yd+OGziMl15GzUDd0kF+d81pv/+rmR9yxAI3I8a9j1Q87br6vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDvGy+zrLSpMo+OfZ+vJwRDlR33weUND0vwKQnexpXJJ1X101F
	RFY+ag9USDkNpsnvYEM39syd0ND7zBp86LyFx49LU6shl22vFJljIKc4q752agAyHr4=
X-Gm-Gg: ATEYQzwqQKOg92b4hlxZXEMQOd/WS5ZauZDxHN8MfexZaNynJfsS8UsU4Bb8Yd/rRTv
	GFmDYrGUfieioG6KgTOAwkYSGNW3G3Si8jpi9XsN8lidgQ/5oA0hnBKtuUM+0w+J+cg28YX83WF
	SowEA+7o8QLJOwEu0P7Ek6TZcBZdRE5QE8l7df2zyQY5/c7rR53U6o/KxA5xmBzvtc3ZINztU0e
	I8s4RX5rm9HOKqKrsCl7p8GUipJobTsQymA7aHi8mvIIPTlR0R26v0nNX8SxL/NVygg7yyfz/UB
	efareT/IJe6DkPRJFxw8IQHiOJikZrMHKJ9oRENwRn2Y98aSWnLrfeLS7am4ACbOGhr5F7sVMjU
	WjiSO3yPmP2n4LtJ29tcs+Xx632kdjxJQy/xw4npyanicIO4mcluzDaLQgp03ffItjcaMc7UfNe
	pGQWfdPTbyL5t0KcA8HhdOI+bvloIv8N00K8/W8oPFXKhb7Rhjh5lv3NAT9mFm4s8z3w==
X-Received: by 2002:a05:6830:488d:b0:7d5:1101:9196 with SMTP id 46e09a7af769-7d76a6bdefamr3754389a34.6.1773327930614;
        Thu, 12 Mar 2026 08:05:30 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aedae57sm4321776a34.28.2026.03.12.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:05:29 -0700 (PDT)
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
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation at guarded call sites
Date: Thu, 12 Mar 2026 11:04:55 -0400
Message-ID: <20260312150523.2054552-1-vineeth@bitbyteword.org>
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

This series introduces trace_invoke_##name() as a companion to
trace_##name().  It calls __do_trace_##name() directly, bypassing the
redundant static-branch re-check, while preserving all other correctness
properties of the normal path (RCU-watching assertion, might_fault() for
syscall tracepoints).  The internal __do_trace_##name() symbol is not
leaked to call sites; trace_invoke_##name() is the only new public API.

  if (trace_foo_enabled() && cond)
      trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

The first patch adds the three-location change to
include/linux/tracepoint.h (__DECLARE_TRACE, __DECLARE_TRACE_SYSCALL,
and the !TRACEPOINTS_ENABLED stub).  The remaining 14 patches
mechanically convert all guarded call sites found in the tree:
kernel/, io_uring/, net/, accel/habanalabs, cpufreq/, devfreq/,
dma-buf/, fsi/, drm/, HID, i2c/, spi/, scsi/ufs/, and btrfs/.

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

Vineeth Pillai (Google) (15):
  tracepoint: Add trace_invoke_##name() API
  kernel: Use trace_invoke_##name() at guarded tracepoint call sites
  io_uring: Use trace_invoke_##name() at guarded tracepoint call sites
  net: Use trace_invoke_##name() at guarded tracepoint call sites
  accel/habanalabs: Use trace_invoke_##name() at guarded tracepoint call
    sites
  cpufreq: Use trace_invoke_##name() at guarded tracepoint call sites
  devfreq: Use trace_invoke_##name() at guarded tracepoint call sites
  dma-buf: Use trace_invoke_##name() at guarded tracepoint call sites
  fsi: Use trace_invoke_##name() at guarded tracepoint call sites
  drm: Use trace_invoke_##name() at guarded tracepoint call sites
  HID: Use trace_invoke_##name() at guarded tracepoint call sites
  i2c: Use trace_invoke_##name() at guarded tracepoint call sites
  spi: Use trace_invoke_##name() at guarded tracepoint call sites
  scsi: ufs: Use trace_invoke_##name() at guarded tracepoint call sites
  btrfs: Use trace_invoke_##name() at guarded tracepoint call sites

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
 net/core/dev.c                                    |  2 +-
 net/core/xdp.c                                    |  2 +-
 net/openvswitch/actions.c                         |  2 +-
 net/openvswitch/datapath.c                        |  2 +-
 net/sctp/outqueue.c                               |  2 +-
 net/tipc/node.c                                   |  2 +-
 30 files changed, 62 insertions(+), 50 deletions(-)

-- 
2.53.0

