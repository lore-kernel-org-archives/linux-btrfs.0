Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA16C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 15:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D6B2083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 15:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbfDRPni (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:43:38 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:36803 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPni (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 11:43:38 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH9Bh-0004nI-GJ; Thu, 18 Apr 2019 17:42:57 +0200
Date:   Thu, 18 Apr 2019 17:42:55 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
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
In-Reply-To: <20190418145201.mjzyqbmkjcghqzex@treble>
Message-ID: <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de> <20190418084255.652003111@linutronix.de> <20190418145201.mjzyqbmkjcghqzex@treble>
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

On Thu, 18 Apr 2019, Josh Poimboeuf wrote:

> On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> > All architectures which support stacktrace carry duplicated code and
> > do the stack storage and filtering at the architecture side.
> > 
> > Provide a consolidated interface with a callback function for consuming the
> > stack entries provided by the architecture specific stack walker. This
> > removes lots of duplicated code and allows to implement better filtering
> > than 'skip number of entries' in the future without touching any
> > architecture specific code.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: linux-arch@vger.kernel.org
> 
> This is a step in the right direction, especially if it allows us to get
> rid of the 'skip' stuff.  But I'm not crazy about the callbacks.
> 
> Another idea I had (but never got a chance to work on) was to extend the
> x86 unwind interface to all arches.  So instead of the callbacks, each
> arch would implement something like this API:
> 
> 
> struct unwind_state state;
> 
> void unwind_start(struct unwind_state *state, struct task_struct *task,
> 		  struct pt_regs *regs, unsigned long *first_frame);
> 
> bool unwind_next_frame(struct unwind_state *state);
> 
> inline bool unwind_done(struct unwind_state *state);
> 
> 
> Not only would it avoid the callbacks (which is a nice benefit already),
> it would also allow the interfaces to be used outside of the
> stack_trace_*() interfaces.  That would come in handy in cases like the
> ftrace stack tracer code, which needs more than the stack_trace_*() API
> can give.

I surely thought about that, but after staring at all incarnations of
arch/*/stacktrace.c I just gave up.

Aside of that quite some archs already have callback based unwinders
because they use them for more than stacktracing and just have a single
implementation of that loop.

I'm fine either way. We can start with x86 and then let archs convert over
their stuff, but I wouldn't hold my breath that this will be completed in
the forseeable future.

> Of course, this may be more work than what you thought you signed up for
> ;-)

I did not sign up for anything. I tripped over that mess by accident and me
being me hated it strong enough to give it at least an initial steam blast.

Thanks,

	tglx
	
