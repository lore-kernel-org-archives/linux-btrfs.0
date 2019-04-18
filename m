Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E04C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B3B2183E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388823AbfDRLyG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:54:06 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:35705 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfDRLyG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:54:06 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH5bc-000615-N4; Thu, 18 Apr 2019 13:53:28 +0200
Date:   Thu, 18 Apr 2019 13:53:26 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
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
Subject: Re: [patch V2 09/29] mm/kasan: Simplify stacktrace handling
In-Reply-To: <5b77992a-52b6-807e-f77d-9cf3e648c71f@virtuozzo.com>
Message-ID: <alpine.DEB.2.21.1904181350080.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de> <20190418084253.903603121@linutronix.de> <5b77992a-52b6-807e-f77d-9cf3e648c71f@virtuozzo.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 18 Apr 2019, Andrey Ryabinin wrote:
> On 4/18/19 11:41 AM, Thomas Gleixner wrote:
> > Replace the indirection through struct stack_trace by using the storage
> > array based interfaces.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Acked-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > Cc: Alexander Potapenko <glider@google.com>
> > Cc: kasan-dev@googlegroups.com
> > Cc: linux-mm@kvack.org
> 
> Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> 
> >  
> >  static inline depot_stack_handle_t save_stack(gfp_t flags)
> >  {
> >  	unsigned long entries[KASAN_STACK_DEPTH];
> > -	struct stack_trace trace = {
> > -		.nr_entries = 0,
> > -		.entries = entries,
> > -		.max_entries = KASAN_STACK_DEPTH,
> > -		.skip = 0
> > -	};
> > +	unsigned int nr_entries;
> >  
> > -	save_stack_trace(&trace);
> > -	filter_irq_stacks(&trace);
> > -
> > -	return depot_save_stack(&trace, flags);
> > +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
> > +	nr_entries = filter_irq_stacks(entries, nr_entries);
> > +	return stack_depot_save(entries, nr_entries, flags);
> 
> Suggestion for further improvement:
> 
> stack_trace_save() shouldn't unwind beyond irq entry point so we wouldn't
> need filter_irq_stacks().  Probably all call sites doesn't care about
> random stack above irq entry point, so it doesn't make sense to spend
> resources on unwinding non-irq stack from interrupt first an filtering
> out it later.

There are users which care about the full trace.

Once we have cleaned up the whole architeture side, we can add core side
filtering which allows to

   1) replace the 'skip number of entries at the beginning

   2) stop the trace when it reaches a certain point

Right now, I don't want to change any of this until the whole mess is
consolidated.

Thanks,

	tglx



