Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C05AC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 10:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE0720656
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 10:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbfDRKji (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 06:39:38 -0400
Received: from relay.sw.ru ([185.231.240.75]:53410 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388369AbfDRKji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 06:39:38 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hH4Rp-0002dq-HX; Thu, 18 Apr 2019 13:39:17 +0300
Subject: Re: [patch V2 09/29] mm/kasan: Simplify stacktrace handling
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.903603121@linutronix.de>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <5b77992a-52b6-807e-f77d-9cf3e648c71f@virtuozzo.com>
Date:   Thu, 18 Apr 2019 13:39:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190418084253.903603121@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/18/19 11:41 AM, Thomas Gleixner wrote:
> Replace the indirection through struct stack_trace by using the storage
> array based interfaces.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: kasan-dev@googlegroups.com
> Cc: linux-mm@kvack.org

Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

>  
>  static inline depot_stack_handle_t save_stack(gfp_t flags)
>  {
>  	unsigned long entries[KASAN_STACK_DEPTH];
> -	struct stack_trace trace = {
> -		.nr_entries = 0,
> -		.entries = entries,
> -		.max_entries = KASAN_STACK_DEPTH,
> -		.skip = 0
> -	};
> +	unsigned int nr_entries;
>  
> -	save_stack_trace(&trace);
> -	filter_irq_stacks(&trace);
> -
> -	return depot_save_stack(&trace, flags);
> +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
> +	nr_entries = filter_irq_stacks(entries, nr_entries);
> +	return stack_depot_save(entries, nr_entries, flags);

Suggestion for further improvement:

stack_trace_save() shouldn't unwind beyond irq entry point so we wouldn't need filter_irq_stacks().
Probably all call sites doesn't care about random stack above irq entry point, so it doesn't
make sense to spend resources on unwinding non-irq stack from interrupt first an filtering out it later.

It would improve performance of stack_trace_save() called from interrupt and fix page_owner which feed unfiltered
stack to stack_depot_save(). Random non-irq part kills the benefit of using the stack_deopt_save().
