Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C2BC282DA
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 141FE205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfDSSqw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbfDSSqw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:46:52 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B05EF85541;
        Fri, 19 Apr 2019 16:17:41 +0000 (UTC)
Received: from treble (ovpn-124-190.rdu2.redhat.com [10.10.124.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8459E5D9D2;
        Fri, 19 Apr 2019 16:17:32 +0000 (UTC)
Date:   Fri, 19 Apr 2019 11:17:30 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        linux-arch@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
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
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [patch V2 28/29] stacktrace: Provide common infrastructure
Message-ID: <20190419161730.zgpa3e5fhny42wq7@treble>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
 <20190419071843.GM4038@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1904191031390.3174@nanos.tec.linutronix.de>
 <20190419090717.GN7905@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190419090717.GN7905@worktop.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 19 Apr 2019 16:17:42 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 19, 2019 at 11:07:17AM +0200, Peter Zijlstra wrote:
> On Fri, Apr 19, 2019 at 10:32:30AM +0200, Thomas Gleixner wrote:
> > On Fri, 19 Apr 2019, Peter Zijlstra wrote:
> > > On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> > > 
> > > > +typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr,
> > > > +                                      bool reliable);
> > > 
> > > > +void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
> > > > +		     struct task_struct *task, struct pt_regs *regs);
> > > > +int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
> > > > +			     struct task_struct *task);
> > > 
> > > This bugs me a little; ideally the _reliable() thing would not exists.
> > > 
> > > Thomas said that the existing __save_stack_trace_reliable() is different
> > > enough for the unification to be non-trivial, but maybe Josh can help
> > > out?
> > > 
> > > >From what I can see the biggest significant differences are:
> > > 
> > >  - it looks at the regs sets on the stack and for FP bails early
> > >  - bails for khreads and idle (after it does all the hard work!?!)

That's done for a reason, see the "Success path" comments.

> > > The first (FP checking for exceptions) should probably be reflected in
> > > consume_fn(.reliable) anyway -- although that would mean a lot of extra
> > > '?' entries where there are none today.
> > > 
> > > And the second (KTHREAD/IDLE) is something that the generic code can
> > > easily do before calling into the arch unwinder.
> > 
> > And looking at the powerpc version of it, that has even more interesting
> > extra checks in that function.
> 
> Right, but not fundamentally different from determining @reliable I
> think.
> 
> Anyway, it would be good if someone knowledgable could have a look at
> this.

Yeah, we could probably do that.

The flow would need to be changed a bit -- some of the errors are soft
errors which most users don't care about because they just want a best
effort.  The soft errors can be remembered without breaking out of the
loop, and just returned at the end.  Most users could just ignore the
return code.

The only thing I'd be worried about is performance for the non-livepatch
users, but I guess those checks don't look very expensive.  And the x86
unwinders are already pretty slow anyway...

-- 
Josh
