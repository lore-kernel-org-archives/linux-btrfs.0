Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A982DC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 853F42183E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388775AbfDROxl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388301AbfDROxk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 10:53:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35831206B6;
        Thu, 18 Apr 2019 14:53:36 +0000 (UTC)
Date:   Thu, 18 Apr 2019 10:53:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-arch@vger.kernel.org
Subject: Re: [patch V2 21/29] tracing: Use percpu stack trace buffer more
 intelligently
Message-ID: <20190418105334.5093528d@gandalf.local.home>
In-Reply-To: <20190418084254.999521114@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
        <20190418084254.999521114@linutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 18 Apr 2019 10:41:40 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The per cpu stack trace buffer usage pattern is odd at best. The buffer has
> place for 512 stack trace entries on 64-bit and 1024 on 32-bit. When
> interrupts or exceptions nest after the per cpu buffer was acquired the
> stacktrace length is hardcoded to 8 entries. 512/1024 stack trace entries
> in kernel stacks are unrealistic so the buffer is a complete waste.
> 
> Split the buffer into chunks of 64 stack entries which is plenty. This
> allows nesting contexts (interrupts, exceptions) to utilize the cpu buffer
> for stack retrieval and avoids the fixed length allocation along with the
> conditional execution pathes.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |   77 +++++++++++++++++++++++++--------------------------
>  1 file changed, 39 insertions(+), 38 deletions(-)
> 
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2749,12 +2749,21 @@ trace_function(struct trace_array *tr,
>  
>  #ifdef CONFIG_STACKTRACE
>  
> -#define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
> +/* 64 entries for kernel stacks are plenty */
> +#define FTRACE_KSTACK_ENTRIES	64
> +
>  struct ftrace_stack {
> -	unsigned long		calls[FTRACE_STACK_MAX_ENTRIES];
> +	unsigned long		calls[FTRACE_KSTACK_ENTRIES];
>  };
>  
> -static DEFINE_PER_CPU(struct ftrace_stack, ftrace_stack);
> +/* This allows 8 level nesting which is plenty */

Can we make this 4 level nesting and increase the size? (I can see us
going more than 64 deep, kernel developers never cease to amaze me ;-)
That's all we need:

 Context: Normal, softirq, irq, NMI

Is there any other way to nest?

-- Steve

> +#define FTRACE_KSTACK_NESTING	(PAGE_SIZE / sizeof(struct ftrace_stack))
> +
> +struct ftrace_stacks {
> +	struct ftrace_stack	stacks[FTRACE_KSTACK_NESTING];
> +};
> +
> +static DEFINE_PER_CPU(struct ftrace_stacks, ftrace_stacks);
>  static DEFINE_PER_CPU(int, ftrace_stack_reserve);
>  
> 
