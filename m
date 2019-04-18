Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7409FC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 22:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E38121479
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 22:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfDRWTp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 18:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfDRWTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 18:19:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 509352064A;
        Thu, 18 Apr 2019 22:19:41 +0000 (UTC)
Date:   Thu, 18 Apr 2019 18:19:38 -0400
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
Subject: Re: [patch V2 01/29] tracing: Cleanup stack trace code
Message-ID: <20190418181938.2e2a9a04@gandalf.local.home>
In-Reply-To: <20190418084253.142712304@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
        <20190418084253.142712304@linutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 18 Apr 2019 10:41:20 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:


> @@ -412,23 +404,20 @@ stack_trace_sysctl(struct ctl_table *tab
>  		   void __user *buffer, size_t *lenp,
>  		   loff_t *ppos)
>  {
> -	int ret;
> +	int ret, was_enabled;

One small nit. Could this be:

	int was_enabled;
	int ret;

I prefer only joining variables that are related on the same line.
Makes it look cleaner IMO.

>  
>  	mutex_lock(&stack_sysctl_mutex);
> +	was_enabled = !!stack_tracer_enabled;
>  

Bah, not sure why I didn't do it this way to begin with. I think I
copied something else that couldn't do it this way for some reason and
didn't put any brain power behind the copy. :-/ But that was back in
2008 so I blame it on being "young and stupid" ;-)

Other then the above nit and removing the unneeded +1 in max_entries:

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


>  	ret = proc_dointvec(table, write, buffer, lenp, ppos);
>  
> -	if (ret || !write ||
> -	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
> +	if (ret || !write || (was_enabled == !!stack_tracer_enabled))
>  		goto out;
>  
> -	last_stack_tracer_enabled = !!stack_tracer_enabled;
> -
>  	if (stack_tracer_enabled)
>  		register_ftrace_function(&trace_ops);
>  	else
>  		unregister_ftrace_function(&trace_ops);
> -
>   out:
>  	mutex_unlock(&stack_sysctl_mutex);
>  	return ret;
> @@ -444,7 +433,6 @@ static __init int enable_stacktrace(char
>  		strncpy(stack_trace_filter_buf, str + len, COMMAND_LINE_SIZE);
>  
>  	stack_tracer_enabled = 1;
> -	last_stack_tracer_enabled = 1;
>  	return 1;
>  }
>  __setup("stacktrace", enable_stacktrace);
> 

