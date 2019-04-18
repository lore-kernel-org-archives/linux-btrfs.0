Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA7AC282DD
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 807B121850
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfDRJGv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:06:51 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:33654 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388344AbfDRJGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:06:50 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH2zW-0001ls-Ty; Thu, 18 Apr 2019 11:05:59 +0200
Message-Id: <20190418084119.056416939@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:19 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
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
Subject: [patch V2 00/29] stacktrace: Consolidate stack trace usage
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an update to V1:

 https://lkml.kernel.org/r/20190410102754.387743324@linutronix.de

Struct stack_trace is a sinkhole for input and output parameters which is
largely pointless for most usage sites. In fact if embedded into other data
structures it creates indirections and extra storage overhead for no
benefit.

Looking at all usage sites makes it clear that they just require an
interface which is based on a storage array. That array is either on stack,
global or embedded into some other data structure.

Some of the stack depot usage sites are outright wrong, but fortunately the
wrongness just causes more stack being used for nothing and does not have
functional impact.

Fix this up by:

  1) Providing plain storage array based interfaces for stacktrace and
     stackdepot.

  2) Cleaning up the mess at the callsites including some related
     cleanups.

  3) Removing the struct stack_trace based interfaces

  This is not yet changing the struct stack_trace interfaces at the
  architecture level, but it removes the exposure to the usage sites.

The last two patches are extending the cleanup to the architecture level by
replacing the various save_stack_trace.* architecture interfaces with a
more unified arch_stack_walk() interface. x86 is converted, but I have
worked through all architectures already and it removes lots of duplicated
code and allows consolidation across the board. The rest of the
architecture patches are not included in this posting as I want to get
feedback on the approach itself. The diffstat of cleaning up the remaining
architectures is currently on top of the current lot is:

   47 files changed, 402 insertions(+), 1196 deletions(-)

Once this has settled, the core interfaces can be improved by adding
features, which allow to get rid of the imprecise 'skip number of entries'
approach which tries to remove the stack tracer and the callsites themself
from the trace. That's error prone due to inlining and other issues. Having
e.g. a _RET_IP_ based filter allows to do that far more reliable.

The series is based on:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/stacktrace

which contains the removal of the inconsistent and pointless ULONG_MAX
termination of stacktraces.

It's also available from git:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git WIP.core/stacktrace

   up to:  131038eb3e2f ("x86/stacktrace: Use common infrastructure")

Changes vs. V1:

   - Applied the ULONG_MAX termination cleanup in tip

   - Addressed the review comments

   - Fixed up the last users of struct stack_trace outside the stacktrace
     core and architecture code (livepatch, tracing)

   - Added the new arch_stack_walk() model and converted x86 to it

Thanks,

	tglx

---
 arch/x86/Kconfig                              |    1 
 arch/x86/kernel/stacktrace.c                  |  116 +--------
 drivers/gpu/drm/drm_mm.c                      |   22 -
 drivers/gpu/drm/i915/i915_vma.c               |   11 
 drivers/gpu/drm/i915/intel_runtime_pm.c       |   21 -
 drivers/md/dm-bufio.c                         |   15 -
 drivers/md/persistent-data/dm-block-manager.c |   19 -
 fs/btrfs/ref-verify.c                         |   15 -
 fs/proc/base.c                                |   14 -
 include/linux/ftrace.h                        |   18 -
 include/linux/lockdep.h                       |    9 
 include/linux/stackdepot.h                    |    8 
 include/linux/stacktrace.h                    |   80 +++++-
 kernel/backtracetest.c                        |   11 
 kernel/dma/debug.c                            |   13 -
 kernel/latencytop.c                           |   17 -
 kernel/livepatch/transition.c                 |   22 -
 kernel/locking/lockdep.c                      |   81 ++----
 kernel/stacktrace.c                           |  323 ++++++++++++++++++++++++--
 kernel/trace/trace.c                          |  105 +++-----
 kernel/trace/trace.h                          |    8 
 kernel/trace/trace_events_hist.c              |   12 
 kernel/trace/trace_stack.c                    |   76 ++----
 lib/Kconfig                                   |    4 
 lib/fault-inject.c                            |   12 
 lib/stackdepot.c                              |   50 ++--
 mm/kasan/common.c                             |   30 --
 mm/kasan/report.c                             |    7 
 mm/kmemleak.c                                 |   24 -
 mm/page_owner.c                               |   79 ++----
 mm/slub.c                                     |   12 
 31 files changed, 664 insertions(+), 571 deletions(-)



