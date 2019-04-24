Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7709FC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D1520652
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jnXyb2lO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfDXTph (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:45:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfDXTph (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 15:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nXNCzgXPp/MC/y/PJgs7pmMKbFnjx8a6N8WFYhwtNcs=; b=jnXyb2lOVttIJoTmHH09wDdgf
        n8NwsMb9Q8EZ9BhZYTUEmA/PHtyPiQZOmqBu9mXa6yS7FNimIsZTp3th5+3stcuYygHbNmLLYqBGT
        QahsATylTqjWyQwmQWDXx0qU89AA6/OXLd2NCoPGpUOZ+2qhJ4st3eHGbksMYs7v8Vz1EtlVHBU/V
        0d2uWTvtE1ut2NEV0rW9PoEWWmPOPkZ6B4Ll/v8YqCWjQwzFWcsIDvwui3aaYqTf72W1WXM1j/0xM
        JpCvyP3P7MY/egBVMNbkcye19upsSYlZcw08/CLq5k4oepPII8zRfmSr6JNXtPbV5jb8VqzdiXZp7
        XpWmu0naw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJNpM-0005aH-OA; Wed, 24 Apr 2019 19:45:08 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E5F80203E8871; Wed, 24 Apr 2019 21:45:05 +0200 (CEST)
Date:   Wed, 24 Apr 2019 21:45:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [patch V2 18/29] lockdep: Move stack trace logic into
 check_prev_add()
Message-ID: <20190424194505.GR11158@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084254.729689921@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418084254.729689921@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 10:41:37AM +0200, Thomas Gleixner wrote:
> There is only one caller of check_prev_add() which hands in a zeroed struct
> stack trace and a function pointer to save_stack(). Inside check_prev_add()
> the stack_trace struct is checked for being empty, which is always
> true. Based on that one code path stores a stack trace which is unused. The
> comment there does not make sense either. It's all leftovers from
> historical lockdep code (cross release).

I was more or less expecting a revert of:

ce07a9415f26 ("locking/lockdep: Make check_prev_add() able to handle external stack_trace")

And then I read the comment that went with the "static struct
stack_trace trace" that got removed (in the above commit) and realized
that your patch will consume more stack entries.

The problem is when the held lock stack in check_prevs_add() has multple
trylock entries on top, in that case we call check_prev_add() multiple
times, and this patch will then save the exact same stack-trace multiple
times, consuming static resources.

Possibly we should copy what stackdepot does (but we cannot use it
directly because stackdepot uses locks; but possible we can share bits),
but that is a patch for another day I think.

So while convoluted, perhaps we should retain this code for now.
