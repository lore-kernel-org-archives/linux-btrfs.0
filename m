Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92038C282E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 22:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD8C217F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 22:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="efhWri0O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfDSWy3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 18:54:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbfDSWy0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 18:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M4U9lCHjwX+RI+C+4Qn3GQkY7/2O42PH32K/E1UYiUo=; b=efhWri0OqGFVL87uVOhTf0P8c
        VSvSxYJhAd6hWo8CmLsODUpgHy2FOdjPhzivpgzeDYDDeiD5oIiDpm5/7IbHgKjlq91wLpWzl1aD2
        91I3Ez2HBIUFPqmjTLYnv1ZBwWH/Qw3AsrWa3Rbc4zrTGp/lwd5liclNi1MQEvkxFpGtCo0tFht6C
        ylKfaemtfAjzZtz7n+nThE01KGuJI1R+8abPHEYloVasqEARRFqBwNStJEX8+DkrmdReR692/NWRH
        8Fb/ZC+LcMEtU9ngoXTQZys0EFT/JnwkdRRcHWVA/k49KlOl+ugsAq67JLMjnv0e+1/DskCXYRzRn
        lv2tg85gQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hHNnJ-0005As-Hx; Fri, 19 Apr 2019 07:18:45 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C26E229B52F44; Fri, 19 Apr 2019 09:18:43 +0200 (CEST)
Date:   Fri, 19 Apr 2019 09:18:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
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
Message-ID: <20190419071843.GM4038@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418084255.652003111@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:

> +typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr,
> +                                      bool reliable);

> +void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
> +		     struct task_struct *task, struct pt_regs *regs);
> +int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
> +			     struct task_struct *task);

This bugs me a little; ideally the _reliable() thing would not exists.

Thomas said that the existing __save_stack_trace_reliable() is different
enough for the unification to be non-trivial, but maybe Josh can help
out?

From what I can see the biggest significant differences are:

 - it looks at the regs sets on the stack and for FP bails early
 - bails for khreads and idle (after it does all the hard work!?!)

The first (FP checking for exceptions) should probably be reflected in
consume_fn(.reliable) anyway -- although that would mean a lot of extra
'?' entries where there are none today.

And the second (KTHREAD/IDLE) is something that the generic code can
easily do before calling into the arch unwinder.

Hmm?

