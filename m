Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76768C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4587520674
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AmuSwOyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfDXTqm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:46:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42890 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfDXTqm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 15:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4eVIy3czAn23vobeXz8xHXFrh4HunqErlYisbzn2mkA=; b=AmuSwOyLbSNnfdXnlzatsx9qY
        etKIJrLorbJq3EXK61vUd8O6UjB1tDm59T91RkmblHQHYL9kVvFLXBB4NDqQJ3e8J6cQsFpQ6RQPg
        x/0jl79kRahYdX1mB1OT1NUGOwigYBklCJuAC3e6Nf0kYdorKNltiBd3Mg+w2CdVUNE05cBwdHkkK
        93Ang+dOQJKq9RTFsMGIn1cJW44e8nUljTFZ34DeOmrCGMmUDz8DUDDvmxZPIBsaPUPbpNvhM3TYc
        S2sKs+5OOdj/eYDuOG6AvUfkGGsXC4DpfB0HcAgZAVEGWjd3kUZOzbB8LQ7ix9rfzhcBf1ceye29i
        ZUIRYwwWw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJNq6-0000yX-Cu; Wed, 24 Apr 2019 19:45:54 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 553DD203E8871; Wed, 24 Apr 2019 21:45:52 +0200 (CEST)
Date:   Wed, 24 Apr 2019 21:45:52 +0200
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
Subject: Re: [patch V2 19/29] lockdep: Simplify stack trace handling
Message-ID: <20190424194552.GS11158@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084254.819500258@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418084254.819500258@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 10:41:38AM +0200, Thomas Gleixner wrote:
> Replace the indirection through struct stack_trace by using the storage
> array based interfaces and storing the information is a small lockdep
> specific data structure.
> 

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
