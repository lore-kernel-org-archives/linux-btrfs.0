Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:50818 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdK1S6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 13:58:43 -0500
Date: Tue, 28 Nov 2017 11:58:41 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Josef Bacik <josef@toxicpanda.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v7 1/5] add infrastructure for tagging functions as
 error injectable
Message-ID: <20171128115841.4958113d@lwn.net>
In-Reply-To: <1511385814-20863-2-git-send-email-josef@toxicpanda.com>
References: <1511385814-20863-1-git-send-email-josef@toxicpanda.com>
        <1511385814-20863-2-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Nov 2017 16:23:30 -0500
Josef Bacik <josef@toxicpanda.com> wrote:

> From: Josef Bacik <jbacik@fb.com>
> 
> Using BPF we can override kprob'ed functions and return arbitrary
> values.  Obviously this can be a bit unsafe, so make this feature opt-in
> for functions.  Simply tag a function with KPROBE_ERROR_INJECT_SYMBOL in
> order to give BPF access to that function for error injection purposes.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/include/asm/asm.h        |   6 ++
>  include/asm-generic/vmlinux.lds.h |  10 +++
>  include/linux/bpf.h               |  11 +++
>  include/linux/kprobes.h           |   1 +
>  include/linux/module.h            |   5 ++
>  kernel/kprobes.c                  | 163 ++++++++++++++++++++++++++++++++++++++
>  kernel/module.c                   |   6 +-
>  7 files changed, 201 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index b0dc91f4bedc..340f4cc43255 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -85,6 +85,12 @@
>  	_ASM_PTR (entry);					\
>  	.popsection
>  
> +# define _ASM_KPROBE_ERROR_INJECT(entry)			\
> +	.pushsection "_kprobe_error_inject_list","aw" ;		\
> +	_ASM_ALIGN ;						\
> +	_ASM_PTR (entry);					\
> +	.popseciton

So this stuff is not my area of greatest expertise, but I do have to wonder
how ".popseciton" can work ... ?

Thanks,

jon
