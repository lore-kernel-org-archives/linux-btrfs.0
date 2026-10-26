Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051573;
	b=U50QXf0iut+9KZEO8/pV1UBdf+9aad1/V8/dhuwOd6dTEYgMUjYN5C5FiXVn6ZBhvn1k
	 Qt5A/rCuVOntpiMElHXZRQwZaZ6J/K5D5Rs69rJYqzYH9Z8pG/Oq29x3lrWuij/A1E1lg
	 MP7cLUwhhf9eDLxsjT11+jHNsfV8GxI8jXc9fkDztK09W0ZmZevBVOVCbpqbHuRd0154K
	 0oZWaYZhjP6BOewrIosHeZ6aN6GO7cGkre0XPxfqcOM/SQidWCoLRF07LNMYV+UBVKyI+
	 AIFXf/dqN56mzH2yTt5KGZ5rDnne1QLidUS3bkwhtOPXNWUGUBLCcFCrbbZPhWE3kvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051573;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
	b=vYc4vT1oMwrWXNALs92Kmj2ogn4e4DL1kNrjENAASYSVqm8b5uRIZ0mlgGJJ/AQnTjyr
	 CeJcGTO3LkRR6cnl5j9SUKQhgPYvuFIU4HsBS1D9ONYNBGLzC2K0WP+v/m8Kp07NgGsu2
	 ewJHk8o21WClkJQKX7EBTWOw+PjbdPgJRz5mn9JxB9QrOjm3dqMOJf+B5n1mhs58Ob4C8
	 7JwamPBRxxrqh4KxdH26smr+HPGE5MMCgqu3iJRgRepiUJj8WkjWRoXkSaeF2OVcoL5Bo
	 MsOWMTcRjnoomcMWhtJyHXY4GKt3h9pbmOwoAhyn7bkAVY0DCFEYqyHNV9c/Uh6Uyqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ApDjmBZ2;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABF60A3824
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 21:52:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6ABF60A3824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ApDjmBZ2
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab27eb38d6so3293436a91.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051572; x=1793656372; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
        b=ApDjmBZ2P5IY9M07VtIw4q1PCPK6CpIgTYTWQMTnhd4WbvnSeK4y3f8atnn7QA9cjB
         pATuIJVRmfxmUb6DVTcY2TSWeqihjk7sAkqWl2p7EJ+Outh4lOM6tfOP5bdm3xMdvvxm
         Gz5j1WDaxuKn1Qo4ZRLEMmGLuAM8u+S9GjSAdvAH/B5Z9aOkw665P34Qp/haslR+DdAh
         6Cf+TsLq3VxdxXfhvV5luqaTWzWAuM2gDcXBE0x9iCsw+vaQTyRrV4cFglmiecBVNbcN
         5aCJa8Oo3N1GkKfrvyeHtHj7KXN2+Rosy5Vsb+br/0l+WNOkW/XGL3x3Tqqyd1sNMI9t
         cLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051572; x=1793656372;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
        b=WUHU7xy/cCpETIlrTNa4n8ebwGguHJ8IdetgjWWTy1OMITJVWTASOyWrwDprjmqcEr
         5W1taMunZETgZK9x9sFnjDX1KTxYMWdWgdryxu9QkvTFtqI2//FkYfddHEaJ9/v+nrcj
         vbtFKczb0kcoH28XCu61Fd3Yy7tThXjDeWo0Lu5pkB6sWrBsBZay5hB9Wm4zc9wgFVeq
         nHNmAy7GGEIiXUweW1T61J4cNCfsxQcmrxnp5Pql5DkkBbTC8IeuC7mdOVQjCGmO4xbz
         zB13VL+GOn0HqBHlmWOx8P8+0NLIsdTFPkALWqqEJ/zySMDti8gDzlHKhXTKyS0obCmP
         hDyA==
X-Forwarded-Encrypted: i=1; AKwUvBwv4qIo3GDlTOZIaNjktcZgWY4wd+UEHU0M0P4JC3qDnE6rHo62zZOi943BfPQ2axMbzSd/B2ixmeg2ig==@vger.kernel.org
X-Gm-Message-State: AFq9FYLE64SRaGJ9iM7R04xQdZZ9DiP/gKyecVAzuhaRTbTSrHn9ETQc
	OhHzLRYYQV0ZmyB/z/XH3om0aIA23aatVfgoXO8zvspKqxhzhu+0ppkTgbHawxohohpLMTgoVQk
	B30LjEu0Dv7MHxJoWS3iekg==
X-Received: from pjbee5.prod.google.com ([2002:a17:90a:fc45:b0:3ad:f864:f94f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d8c:b0:3ac:a521:95e with SMTP id 98e67ed59e1d1-3adead4f7ebmr6876350a91.47.1793051572060;
 Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:21 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-6-jthoughton@google.com>
Subject: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without an mm
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

get_perf_callchain() only checks is_user_task(current) when the regs it
is given aren't user mode regs. However, BPF's bpf_get_task_stack() (and
bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called on
the current task, which are user mode regs for a user task, even if that
task has already gone through exit_mm(), e.g. when called from a program
attached to exit_files() or to the dying task's final sched_switch.

perf_callchain_user() then unwinds the user stack without an mm. That
access does not reliably fail: the user half of the address space
belongs to whatever mm happens to be lazily loaded, if any, so the
unwinder may read another task's memory. This affects e.g. arm64,
riscv, loongarch and csky, whose perf_callchain_user() doesn't check
current->mm itself. perf events themselves are not affected, as
perf_callchain() already clears the user callchain request when
current is not a user task with an mm.

Check is_user_task(current) regardless of the regs' mode.

Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 kernel/events/callchain.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 9d24b6e0c91f..a451ca2a5573 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
 	}
 
 	if (user && !crosstask) {
-		if (!user_mode(regs)) {
-			if (!is_user_task(current))
-				goto exit_put;
+		/*
+		 * Even if @regs are user mode regs, e.g. task_pt_regs(current)
+		 * passed in by bpf_get_task_stack(), current may already have
+		 * gone through exit_mm().
+		 */
+		if (!is_user_task(current))
+			goto exit_put;
+		if (!user_mode(regs))
 			regs = task_pt_regs(current);
-		}
 
 		if (defer_cookie) {
 			/*
-- 
2.56.0.307.g5fe7bd680c-goog

