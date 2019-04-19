Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAECC282E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 22:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79569217F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 22:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i1Hy/GRW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfDSWyW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 18:54:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfDSWyV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 18:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L7eq8Aug6+D0Uzgmn7vgZITr6hThHMPewFsEW47cNZg=; b=i1Hy/GRW9HiWiapoFoRTCdgu1
        cUt7Er7sr71bgd43+dYv+n0Lv5GqnvJ+fSpYP2kjtQcZK4KSH9eqZMuPMywNyKvmhH64/AJZF28Kd
        AlhoxD9/xO4V7UsOg/7MAE2EeVnrnoWM0Pi7ybOHHUHP44EMSsIwE6Jwu+NXpJ/AgQnIsAxNgPdAJ
        Ota/ejkQQY1W48qZZdy3Q4RNzTzjM7hk86diK53SIfg/s2qF6MI2J0OScfSmfawFdDLDzngU6/tDG
        13MF/x52A68J+MK67YWX2NX2H2bIpQcWWr4GQXNqFjTBedeNIaoV6M4g88Nvr+yKVzWJBaI25hvyv
        9aVlwsorw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hHNXI-00007w-SC; Fri, 19 Apr 2019 07:02:13 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5B5DB29B52F42; Fri, 19 Apr 2019 09:02:11 +0200 (CEST)
Date:   Fri, 19 Apr 2019 09:02:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
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
Message-ID: <20190419070211.GL4038@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
 <20190418145201.mjzyqbmkjcghqzex@treble>
 <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 05:42:55PM +0200, Thomas Gleixner wrote:
> On Thu, 18 Apr 2019, Josh Poimboeuf wrote:

> > Another idea I had (but never got a chance to work on) was to extend the
> > x86 unwind interface to all arches.  So instead of the callbacks, each
> > arch would implement something like this API:

> I surely thought about that, but after staring at all incarnations of
> arch/*/stacktrace.c I just gave up.
> 
> Aside of that quite some archs already have callback based unwinders
> because they use them for more than stacktracing and just have a single
> implementation of that loop.
> 
> I'm fine either way. We can start with x86 and then let archs convert over
> their stuff, but I wouldn't hold my breath that this will be completed in
> the forseeable future.

I suggested the same to Thomas early on, and I even spend the time to
convert some $random arch to the iterator interface, and while it is
indeed entirely feasible, it is _far_ more work.

The callback thing OTOH is flexible enough to do what we want to do now,
and allows converting most archs to it without too much pain (as Thomas
said, many archs are already in this form and only need minor API
adjustments), which gets us in a far better place than we are now.

And we can always go to iterators later on. But I think getting the
generic unwinder improved across all archs is a really important first
step here.
