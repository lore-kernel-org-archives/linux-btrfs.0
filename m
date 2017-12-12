Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36164 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752728AbdLLRiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 12:38:21 -0500
Subject: Re: [PATCH v9 0/5] Add the ability to do BPF directed error injection
To: Josef Bacik <josef@toxicpanda.com>, <rostedt@goodmis.org>,
        <mingo@redhat.com>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, <linux-btrfs@vger.kernel.org>
References: <1513010210-30594-1-git-send-email-josef@toxicpanda.com>
From: Alexei Starovoitov <ast@fb.com>
Message-ID: <1366bd39-4862-2f75-851c-a96d8de9648c@fb.com>
Date: Tue, 12 Dec 2017 09:37:50 -0800
MIME-Version: 1.0
In-Reply-To: <1513010210-30594-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/17 8:36 AM, Josef Bacik wrote:
> This is the same as v8, just rebased onto the bpf tree.
>
> v8->v9:
> - rebased onto the bpf tree.
>
> v7->v8:
> - removed the _ASM_KPROBE_ERROR_INJECT since it was not needed.
>
> v6->v7:
> - moved the opt-in macro to bpf.h out of kprobes.h.
>
> v5->v6:
> - add BPF_ALLOW_ERROR_INJECTION() tagging for functions that will support this
>   feature.  This way only functions that opt-in will be allowed to be
>   overridden.
> - added a btrfs patch to allow error injection for open_ctree() so that the bpf
>   sample actually works.
>
> v4->v5:
> - disallow kprobe_override programs from being put in the prog map array so we
>   don't tail call into something we didn't check.  This allows us to make the
>   normal path still fast without a bunch of percpu operations.
>
> v3->v4:
> - fix a build error found by kbuild test bot (I didn't wait long enough
>   apparently.)
> - Added a warning message as per Daniels suggestion.
>
> v2->v3:
> - added a ->kprobe_override flag to bpf_prog.
> - added some sanity checks to disallow attaching bpf progs that have
>   ->kprobe_override set that aren't for ftrace kprobes.
> - added the trace_kprobe_ftrace helper to check if the trace_event_call is a
>   ftrace kprobe.
> - renamed bpf_kprobe_state to bpf_kprobe_override, fixed it so we only read this
>   value in the kprobe path, and thus only write to it if we're overriding or
>   clearing the override.
>
> v1->v2:
> - moved things around to make sure that bpf_override_return could really only be
>   used for an ftrace kprobe.
> - killed the special return values from trace_call_bpf.
> - renamed pc_modified to bpf_kprobe_state so bpf_override_return could tell if
>   it was being called from an ftrace kprobe context.
> - reworked the logic in kprobe_perf_func to take advantage of bpf_kprobe_state.
> - updated the test as per Alexei's review.
>
> - Original message -
>
> A lot of our error paths are not well tested because we have no good way of
> injecting errors generically.  Some subystems (block, memory) have ways to
> inject errors, but they are random so it's hard to get reproduceable results.
>
> With BPF we can add determinism to our error injection.  We can use kprobes and
> other things to verify we are injecting errors at the exact case we are trying
> to test.  This patch gives us the tool to actual do the error injection part.
> It is very simple, we just set the return value of the pt_regs we're given to
> whatever we provide, and then override the PC with a dummy function that simply
> returns.
>
> Right now this only works on x86, but it would be simple enough to expand to
> other architectures.  Thanks,

Applied, thanks Josef!

While applying in the patch "bpf: add a bpf_override_function helper"
I moved ifdef CONFIG_BPF_KPROBE_OVERRIDE few lines,
so when it's not set the program will fail at load time with error
"unknown func bpf_override_return#58"
instead of returning EINVAL at run-time.
That's more standard way of adding new helpers.

Thanks

