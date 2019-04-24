Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E656FC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBFE520674
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 19:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbfDXTvt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:51:49 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55610 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfDXTvs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 15:51:48 -0400
Received: from p5de0b374.dip0.t-ipconnect.de ([93.224.179.116] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJNv9-0005Zr-Gt; Wed, 24 Apr 2019 21:51:07 +0200
Date:   Wed, 24 Apr 2019 21:51:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20190424194505.GR11158@hirez.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.21.1904242148480.1762@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de> <20190418084254.729689921@linutronix.de> <20190424194505.GR11158@hirez.programming.kicks-ass.net>
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

On Wed, 24 Apr 2019, Peter Zijlstra wrote:
> On Thu, Apr 18, 2019 at 10:41:37AM +0200, Thomas Gleixner wrote:
> > There is only one caller of check_prev_add() which hands in a zeroed struct
> > stack trace and a function pointer to save_stack(). Inside check_prev_add()
> > the stack_trace struct is checked for being empty, which is always
> > true. Based on that one code path stores a stack trace which is unused. The
> > comment there does not make sense either. It's all leftovers from
> > historical lockdep code (cross release).
> 
> I was more or less expecting a revert of:
> 
> ce07a9415f26 ("locking/lockdep: Make check_prev_add() able to handle external stack_trace")
> 
> And then I read the comment that went with the "static struct
> stack_trace trace" that got removed (in the above commit) and realized
> that your patch will consume more stack entries.
> 
> The problem is when the held lock stack in check_prevs_add() has multple
> trylock entries on top, in that case we call check_prev_add() multiple
> times, and this patch will then save the exact same stack-trace multiple
> times, consuming static resources.
> 
> Possibly we should copy what stackdepot does (but we cannot use it
> directly because stackdepot uses locks; but possible we can share bits),
> but that is a patch for another day I think.
> 
> So while convoluted, perhaps we should retain this code for now.

Uurg, what a mess.

