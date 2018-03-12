Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751238AbeCLOG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 10:06:29 -0400
Date: Mon, 12 Mar 2018 23:06:25 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@fb.com>, Josef Bacik <jbacik@fb.com>,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, Josef Bacik <josef@toxicpanda.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [BUGFIX PATCH bpf-next] error-injection: Fix to prohibit jump
 optimization
Message-Id: <20180312230625.cea180f66d44dc1ea4930fa7@kernel.org>
In-Reply-To: <c5e08b3e-069c-5160-a1d2-10c2dbac229e@iogearbox.net>
References: <152084884886.1536.4464134247603910765.stgit@devbox>
        <20180312192738.77061ec53f9437d960b437d9@kernel.org>
        <c5e08b3e-069c-5160-a1d2-10c2dbac229e@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 12 Mar 2018 11:44:21 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> Hi Masami,
> 
> On 03/12/2018 11:27 AM, Masami Hiramatsu wrote:
> > On Mon, 12 Mar 2018 19:00:49 +0900
> > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > 
> >> Since the kprobe which was optimized by jump can not change
> >> the execution path, the kprobe for error-injection must not
> >> be optimized. To prohibit it, set a dummy post-handler as
> >> officially stated in Documentation/kprobes.txt.
> > 
> > Note that trace-probe based BPF is not affected, because it
> > ensures the trace-probe is based on ftrace, which is not
> > jump optimized.
> 
> Thanks for the fix! I presume this should go via bpf instead of bpf-next
> tree since 4b1a29a7f542 ("error-injection: Support fault injection framework")
> is in Linus' tree as well. Unless there are objection I would rather route
> it that way so it would be for 4.16.

Ah, right! It should go into 4.16. It should be applicable cleanly either tree
since there is only the above commit on kernel/fail_function.c :)

Thanks,

> 
> Thanks,
> Daniel
> 
> > Thanks,
> > 
> >>
> >> Fixes: 4b1a29a7f542 ("error-injection: Support fault injection framework")
> >> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> >> ---
> >>  kernel/fail_function.c |   10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/kernel/fail_function.c b/kernel/fail_function.c
> >> index 21b0122cb39c..1d5632d8bbcc 100644
> >> --- a/kernel/fail_function.c
> >> +++ b/kernel/fail_function.c
> >> @@ -14,6 +14,15 @@
> >>  
> >>  static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs);
> >>  
> >> +static void fei_post_handler(struct kprobe *kp, struct pt_regs *regs,
> >> +			     unsigned long flags)
> >> +{
> >> +	/*
> >> +	 * A dummy post handler is required to prohibit optimizing, because
> >> +	 * jump optimization does not support execution path overriding.
> >> +	 */
> >> +}
> >> +
> >>  struct fei_attr {
> >>  	struct list_head list;
> >>  	struct kprobe kp;
> >> @@ -56,6 +65,7 @@ static struct fei_attr *fei_attr_new(const char *sym, unsigned long addr)
> >>  			return NULL;
> >>  		}
> >>  		attr->kp.pre_handler = fei_kprobe_handler;
> >> +		attr->kp.post_handler = fei_post_handler;
> >>  		attr->retval = adjust_error_retval(addr, 0);
> >>  		INIT_LIST_HEAD(&attr->list);
> >>  	}
> >>
> > 
> > 
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
