Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6C6C43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFFD216C8
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfDYN3w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:29:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49513 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfDYN3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 09:29:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B577307B4B0;
        Thu, 25 Apr 2019 13:29:50 +0000 (UTC)
Received: from treble (ovpn-123-99.rdu2.redhat.com [10.10.123.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 390A060141;
        Thu, 25 Apr 2019 13:29:39 +0000 (UTC)
Date:   Thu, 25 Apr 2019 08:29:35 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-arch@vger.kernel.org
Subject: Re: [patch V3 21/29] tracing: Use percpu stack trace buffer more
 intelligently
Message-ID: <20190425132935.ae35l5oybby5ddgl@treble>
References: <20190425094453.875139013@linutronix.de>
 <20190425094803.066064076@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190425094803.066064076@linutronix.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 25 Apr 2019 13:29:51 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 11:45:14AM +0200, Thomas Gleixner wrote:
> @@ -2788,29 +2798,32 @@ static void __ftrace_trace_stack(struct
>  	 */
>  	preempt_disable_notrace();
>  
> -	use_stack = __this_cpu_inc_return(ftrace_stack_reserve);
> +	stackidx = __this_cpu_inc_return(ftrace_stack_reserve);
> +
> +	/* This should never happen. If it does, yell once and skip */
> +	if (WARN_ON_ONCE(stackidx >= FTRACE_KSTACK_NESTING))
> +		goto out;
> +
>  	/*
> -	 * We don't need any atomic variables, just a barrier.
> -	 * If an interrupt comes in, we don't care, because it would
> -	 * have exited and put the counter back to what we want.
> -	 * We just need a barrier to keep gcc from moving things
> -	 * around.
> +	 * The above __this_cpu_inc_return() is 'atomic' cpu local. An
> +	 * interrupt will either see the value pre increment or post
> +	 * increment. If the interrupt happens pre increment it will have
> +	 * restored the counter when it returns.  We just need a barrier to
> +	 * keep gcc from moving things around.
>  	 */
>  	barrier();
> -	if (use_stack == 1) {
> -		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
> -		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
> -
> -		if (regs)
> -			save_stack_trace_regs(regs, &trace);
> -		else
> -			save_stack_trace(&trace);
> -
> -		if (trace.nr_entries > size)
> -			size = trace.nr_entries;
> -	} else
> -		/* From now on, use_stack is a boolean */
> -		use_stack = 0;
> +
> +	fstack = this_cpu_ptr(ftrace_stacks.stacks) + (stackidx - 1);

nit: it would be slightly less surprising if stackidx were 0-based:

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d3f6ec7eb729..4fc93004feab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2798,10 +2798,10 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	preempt_disable_notrace();
 
-	stackidx = __this_cpu_inc_return(ftrace_stack_reserve);
+	stackidx = __this_cpu_inc_return(ftrace_stack_reserve) - 1;
 
 	/* This should never happen. If it does, yell once and skip */
-	if (WARN_ON_ONCE(stackidx >= FTRACE_KSTACK_NESTING))
+	if (WARN_ON_ONCE(stackidx > FTRACE_KSTACK_NESTING))
 		goto out;
 
 	/*
@@ -2813,7 +2813,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	barrier();
 
-	fstack = this_cpu_ptr(ftrace_stacks.stacks) + (stackidx - 1);
+	fstack = this_cpu_ptr(ftrace_stacks.stacks) + stackidx;
 	trace.entries		= fstack->calls;
 	trace.max_entries	= FTRACE_KSTACK_ENTRIES;
 
