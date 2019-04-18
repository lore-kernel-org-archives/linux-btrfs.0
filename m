Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225BAC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA9752183F
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfDRNkV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388535AbfDRNkT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77CD12083D;
        Thu, 18 Apr 2019 13:40:15 +0000 (UTC)
Date:   Thu, 18 Apr 2019 09:40:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
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
Subject: Re: [patch V2 20/29] tracing: Simplify stacktrace retrieval in
 histograms
Message-ID: <20190418094014.7d457f29@gandalf.local.home>
In-Reply-To: <20190418084254.910579307@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
        <20190418084254.910579307@linutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


[ Added Tom Zanussi ]

On Thu, 18 Apr 2019 10:41:39 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The indirection through struct stack_trace is not necessary at all. Use the
> storage array based interface.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Looks fine to me

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

 But...

Tom,

Can you review this too?

Patch series starts here:

  http://lkml.kernel.org/r/20190418084119.056416939@linutronix.de

Thanks,

-- Steve

> ---
>  kernel/trace/trace_events_hist.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -5186,7 +5186,6 @@ static void event_hist_trigger(struct ev
>  	u64 var_ref_vals[TRACING_MAP_VARS_MAX];
>  	char compound_key[HIST_KEY_SIZE_MAX];
>  	struct tracing_map_elt *elt = NULL;
> -	struct stack_trace stacktrace;
>  	struct hist_field *key_field;
>  	u64 field_contents;
>  	void *key = NULL;
> @@ -5198,14 +5197,9 @@ static void event_hist_trigger(struct ev
>  		key_field = hist_data->fields[i];
>  
>  		if (key_field->flags & HIST_FIELD_FL_STACKTRACE) {
> -			stacktrace.max_entries = HIST_STACKTRACE_DEPTH;
> -			stacktrace.entries = entries;
> -			stacktrace.nr_entries = 0;
> -			stacktrace.skip = HIST_STACKTRACE_SKIP;
> -
> -			memset(stacktrace.entries, 0, HIST_STACKTRACE_SIZE);
> -			save_stack_trace(&stacktrace);
> -
> +			memset(entries, 0, HIST_STACKTRACE_SIZE);
> +			stack_trace_save(entries, HIST_STACKTRACE_DEPTH,
> +					 HIST_STACKTRACE_SKIP);
>  			key = entries;
>  		} else {
>  			field_contents = key_field->fn(key_field, elt, rbe, rec);
> 

