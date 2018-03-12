Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:55998 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbeCLPVk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 11:21:40 -0400
Subject: Re: [BUGFIX PATCH bpf-next] error-injection: Fix to prohibit jump
 optimization
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexei Starovoitov <ast@fb.com>, Josef Bacik <jbacik@fb.com>,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, Josef Bacik <josef@toxicpanda.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
References: <152084884886.1536.4464134247603910765.stgit@devbox>
 <20180312192738.77061ec53f9437d960b437d9@kernel.org>
 <c5e08b3e-069c-5160-a1d2-10c2dbac229e@iogearbox.net>
 <20180312230625.cea180f66d44dc1ea4930fa7@kernel.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79a6cf73-8e37-fe49-da96-dac70978f226@iogearbox.net>
Date: Mon, 12 Mar 2018 16:21:27 +0100
MIME-Version: 1.0
In-Reply-To: <20180312230625.cea180f66d44dc1ea4930fa7@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2018 03:06 PM, Masami Hiramatsu wrote:
> On Mon, 12 Mar 2018 11:44:21 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 03/12/2018 11:27 AM, Masami Hiramatsu wrote:
>>> On Mon, 12 Mar 2018 19:00:49 +0900
>>> Masami Hiramatsu <mhiramat@kernel.org> wrote:
>>>
>>>> Since the kprobe which was optimized by jump can not change
>>>> the execution path, the kprobe for error-injection must not
>>>> be optimized. To prohibit it, set a dummy post-handler as
>>>> officially stated in Documentation/kprobes.txt.
>>>
>>> Note that trace-probe based BPF is not affected, because it
>>> ensures the trace-probe is based on ftrace, which is not
>>> jump optimized.
>>
>> Thanks for the fix! I presume this should go via bpf instead of bpf-next
>> tree since 4b1a29a7f542 ("error-injection: Support fault injection framework")
>> is in Linus' tree as well. Unless there are objection I would rather route
>> it that way so it would be for 4.16.
> 
> Ah, right! It should go into 4.16. It should be applicable cleanly either tree
> since there is only the above commit on kernel/fail_function.c :)

Applied to bpf tree, thanks Masami!
