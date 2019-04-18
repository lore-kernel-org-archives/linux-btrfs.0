Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73575C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE5E21872
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389293AbfDROwP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60865 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbfDROwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 10:52:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C39BB3078AD9;
        Thu, 18 Apr 2019 14:52:13 +0000 (UTC)
Received: from treble (ovpn-124-190.rdu2.redhat.com [10.10.124.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 518AE1001DC0;
        Thu, 18 Apr 2019 14:52:03 +0000 (UTC)
Date:   Thu, 18 Apr 2019 09:52:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
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
Message-ID: <20190418145201.mjzyqbmkjcghqzex@treble>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190418084255.652003111@linutronix.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 18 Apr 2019 14:52:14 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> All architectures which support stacktrace carry duplicated code and
> do the stack storage and filtering at the architecture side.
> 
> Provide a consolidated interface with a callback function for consuming the
> stack entries provided by the architecture specific stack walker. This
> removes lots of duplicated code and allows to implement better filtering
> than 'skip number of entries' in the future without touching any
> architecture specific code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-arch@vger.kernel.org

This is a step in the right direction, especially if it allows us to get
rid of the 'skip' stuff.  But I'm not crazy about the callbacks.

Another idea I had (but never got a chance to work on) was to extend the
x86 unwind interface to all arches.  So instead of the callbacks, each
arch would implement something like this API:


struct unwind_state state;

void unwind_start(struct unwind_state *state, struct task_struct *task,
		  struct pt_regs *regs, unsigned long *first_frame);

bool unwind_next_frame(struct unwind_state *state);

inline bool unwind_done(struct unwind_state *state);


Not only would it avoid the callbacks (which is a nice benefit already),
it would also allow the interfaces to be used outside of the
stack_trace_*() interfaces.  That would come in handy in cases like the
ftrace stack tracer code, which needs more than the stack_trace_*() API
can give.

Of course, this may be more work than what you thought you signed up for
;-)

-- 
Josh
