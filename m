Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:43179 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdKQSAK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 13:00:10 -0500
Received: by mail-qk0-f169.google.com with SMTP id j202so333528qke.10
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 10:00:10 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4][v6] Add the ability to do BPF directed error injection
Date: Fri, 17 Nov 2017 13:00:03 -0500
Message-Id: <1510941607-3997-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've reworked this to be opt-in only as per Igno and Alexei.  Still needs to go
through Dave because of the bpf bits, but I need tracing guys to weigh in and
sign off on my approach please.

v5->v6:
- add BPF_ALLOW_ERROR_INJECTION() tagging for functions that will support this
  feature.  This way only functions that opt-in will be allowed to be
  overridden.
- added a btrfs patch to allow error injection for open_ctree() so that the bpf
  sample actually works.

v4->v5:
- disallow kprobe_override programs from being put in the prog map array so we
  don't tail call into something we didn't check.  This allows us to make the
  normal path still fast without a bunch of percpu operations.

v3->v4:
- fix a build error found by kbuild test bot (I didn't wait long enough
  apparently.)
- Added a warning message as per Daniels suggestion.

v2->v3:
- added a ->kprobe_override flag to bpf_prog.
- added some sanity checks to disallow attaching bpf progs that have
  ->kprobe_override set that aren't for ftrace kprobes.
- added the trace_kprobe_ftrace helper to check if the trace_event_call is a
  ftrace kprobe.
- renamed bpf_kprobe_state to bpf_kprobe_override, fixed it so we only read this
  value in the kprobe path, and thus only write to it if we're overriding or
  clearing the override.

v1->v2:
- moved things around to make sure that bpf_override_return could really only be
  used for an ftrace kprobe.
- killed the special return values from trace_call_bpf.
- renamed pc_modified to bpf_kprobe_state so bpf_override_return could tell if
  it was being called from an ftrace kprobe context.
- reworked the logic in kprobe_perf_func to take advantage of bpf_kprobe_state.
- updated the test as per Alexei's review.

- Original message -

A lot of our error paths are not well tested because we have no good way of
injecting errors generically.  Some subystems (block, memory) have ways to
inject errors, but they are random so it's hard to get reproduceable results.

With BPF we can add determinism to our error injection.  We can use kprobes and
other things to verify we are injecting errors at the exact case we are trying
to test.  This patch gives us the tool to actual do the error injection part.
It is very simple, we just set the return value of the pt_regs we're given to
whatever we provide, and then override the PC with a dummy function that simply
returns.

Right now this only works on x86, but it would be simple enough to expand to
other architectures.  Thanks,

Josef
