Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949239D6E2
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349162; cv=none; b=hZOHZotAfPNV/0Q3bHzj5twse9Z4ewbKBIMZGaKJ27BUyqyq8Bpo20glsIW8dfyVze3U52Tp4VBFIqR9s6vmTIAgPd7qzSrqlquPaPVHkiANcvy95h56cQyji2583Ktm7IcsRaWMuNtaYOM5VncLAYkpGgbS85PFARRGtMDSTP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349162; c=relaxed/simple;
	bh=PrwDGX9XwNMQGWTQWwl8aSHX5AH5t6LcdhOrjL+I7yg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=D+8edTwiauYlfQUxDE+rUK+It7ZuiqhrNR/iqo9m77m8oAQUpaFFRfE7Fg8wt3azadtdgP58BYjdOBM+x1ZhF0xu7yz5AmSPyi+0aQBYvtRuLgy0TYcg3YRqdZzIOPkVoc53DW29Q7bPML9Gj+I2yaUxEMDSZZF4G8juwMGSMlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6948d83a548so17134305eaf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 00:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779349156; x=1779953956;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWKRtXiZ3vPr/SWGzquOclNiqgxO1IwRNyvP9OlYuFI=;
        b=QZ+D/BfuxURM+u1pX/G0c4LGNk/I9Mwx1pswiHVSWBqLrUseczt6N73+zqNIVpaDoE
         6KRSgn+s/MmQwd3HMH9kCf4MwMmHyorvfxAsJBO+CdvpHkxq26eLnrqWrYQB48sz1FCb
         t41ZFc5JNLm5RSKPXXrIWZJVw0yuqWOIEDIzWNB8AgUcL+qoyVRG8dl6Ai3YyTNYVWGx
         GTva4Xwcynfn80PoByI4Qup1nhqJma4eAtb+aSaJOFIATo/AIBdzdTR5/HxgwRRY/rY3
         /I/imKce46Pw5LOxtDlIvimwvgALCr4/y+lTdrpf1cGkQJ6Vvuibb2LOgeZZj3Kf0YTi
         kajQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XyY+1TJ75gNEno+QYEZSlx/57I8tyEhM/6oe3ECXlafAcuwrvtE9IqnaGIne10gHQxNP8ptfVIDVjXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyhfPr5n/pbhHG7Q7xyxpi+7FxvUUhcSUjANTNfxjvKFQI2bqF
	B5qgyy3SBb+hi7kNFDVVxxqSbvV4MywQtOsBZ9Op1IhbK0gwCtAEciXcVVpAwceWLCT1oNcClAi
	LhFkPlM8Ldgyd2NhkilkW9ihoonxnGucrJHubq9ibR4LSkB6Oo0A/7lInyFI=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f07:b0:696:72c4:5da3 with SMTP id
 006d021491bc7-69d6ee129d0mr701634eaf.15.1779349156267; Thu, 21 May 2026
 00:39:16 -0700 (PDT)
Date: Thu, 21 May 2026 00:39:16 -0700
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0eb6a4.170a0220.55718.0291.GAE@google.com>
Subject: [syzbot ci] Re: mm: reliable 1GB page allocation
From: syzbot ci <syzbot+cib9dcfd931f19159c@syzkaller.appspotmail.com>
To: boris@bur.io, clm@meta.com, david@kernel.org, dsterba@suse.com, 
	fvdl@google.com, hannes@cmpxchg.org, hnaz@cmpxchg.org, kernel-team@meta.com, 
	lenb@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, ljs@kernel.org, 
	pavel@kernel.org, rafael@kernel.org, riel@surriel.com, surenb@google.com, 
	usama.arif@linux.dev, willy@infradead.org, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: reliable 1GB page allocation
https://lore.kernel.org/all/20260520150018.2491267-1-riel@surriel.com
* [RFC PATCH 01/40] mm: page_alloc: replace pageblock_flags bitmap with struct pageblock_data
* [RFC PATCH 02/40] mm: page_alloc: per-cpu pageblock buddy allocator
* [RFC PATCH 03/40] mm: page_alloc: split-path PCP free with local-trylock + remote-llist
* [RFC PATCH 04/40] mm: mm_init: fix zone assignment for pages in unavailable ranges
* [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
* [RFC PATCH 06/40] mm: page_alloc: async evacuation of stolen movable pageblocks
* [RFC PATCH 07/40] mm: page_alloc: track actual page contents in pageblock flags
* [RFC PATCH 08/40] mm: page_alloc: superpageblock metadata for 1GB anti-fragmentation
* [RFC PATCH 09/40] mm: page_alloc: support superpageblock resize for memory hotplug
* [RFC PATCH 10/40] mm: page_alloc: add superpageblock fullness lists for allocation steering
* [RFC PATCH 11/40] mm: page_alloc: steer pageblock stealing to tainted superpageblocks
* [RFC PATCH 12/40] mm: page_alloc: steer movable allocations to fullest clean superpageblocks
* [RFC PATCH 13/40] mm: page_alloc: extract claim_whole_block from try_to_claim_block
* [RFC PATCH 14/40] mm: page_alloc: add per-superpageblock free lists
* [RFC PATCH 15/40] mm: page_alloc: add background superpageblock defragmentation worker
* [RFC PATCH 16/40] mm: compaction: walk per-superpageblock free lists for migration targets
* [RFC PATCH 17/40] mm: page_alloc: superpageblock-aware contiguous and higher order allocation
* [RFC PATCH 18/40] mm: page_alloc: prevent atomic allocations from tainting clean SPBs
* [RFC PATCH 19/40] mm: page_alloc: aggressively pack non-movable allocs in tainted SPBs on large systems
* [RFC PATCH 20/40] mm: page_alloc: prefer reclaim over tainting clean superpageblocks
* [RFC PATCH 21/40] mm: page_alloc: adopt partial pageblocks from tainted superpageblocks
* [RFC PATCH 22/40] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for SPB counters
* [RFC PATCH 23/40] mm: page_alloc: targeted evacuation and dynamic reserves for tainted SPBs
* [RFC PATCH 24/40] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing in pageblocks
* [RFC PATCH 25/40] mm: trigger deferred SPB evac when atomic allocs would taint a clean SPB
* [RFC PATCH 26/40] mm: page_alloc: refuse fragmenting fallback for callers with cheap fallback
* [RFC PATCH 27/40] mm: page_alloc: cross-migratetype buddy borrow within tainted SPBs
* [RFC PATCH 28/40] mm: page_alloc: drive slab shrink from SPB anti-fragmentation pressure
* [RFC PATCH 29/40] mm: page_reporting: walk per-superpageblock free lists
* [RFC PATCH 30/40] mm: show_mem: collect migratetype letters from per-superpageblock lists
* [RFC PATCH 31/40] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cache
* [RFC PATCH 32/40] mm: debug: prevent infinite recursion in dump_page() with CMA
* [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free lists in mark_free_pages
* [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as movable
* [RFC PATCH 35/40] mm: page_alloc: refuse best-effort high-order allocs servable at lower orders
* [RFC PATCH 36/40] mm: page_alloc: set ALLOC_NOFRAGMENT on alloc_frozen_pages_nolock_noprof
* [RFC PATCH 37/40] mm: page_alloc: move spb_get_category and spb_tainted_reserve to mmzone.h
* [RFC PATCH 38/40] mm: compaction: skip empty tainted superpageblocks as migration source
* [RFC PATCH 39/40] mm: compaction: respect tainted SPB reserve in destination selection
* [RFC PATCH 40/40] mm: page_alloc: SPB tracepoint instrumentation [DO-NOT-MERGE]

and found the following issue:
WARNING in preempt_count_sub

Full report is available here:
https://ci.syzbot.org/series/8eef71e1-708c-40d0-9f9d-3a1bd637fc80

***

WARNING in preempt_count_sub

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      4b83cbc4c15f09b000cc06f033f64b0824b6dc87
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/de024c89-d472-4f06-b5be-4f75f2acd1d9/config

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(val > preempt_count())
WARNING: kernel/sched/core.c:5883 at preempt_count_sub+0x9e/0x170, CPU#0: kworker/0:0/9
Modules linked in:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events drain_vmap_area_work
RIP: 0010:preempt_count_sub+0xa5/0x170
Code: 29 31 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ff 50 9d 0e 00 75 13 48 8d 3d 32 37 a0 0e 48 c7 c6 c0 f8 cb 8b <67> 48 0f b9 3a 90 eb b8 90 e8 ed d6 1d 03 85 c0 74 2f 48 c7 c0 c4
RSP: 0000:ffffc900000e7590 EFLAGS: 00010246

RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881007d5880
RDX: 0000000000000000 RSI: ffffffff8bcbf8c0 RDI: ffffffff90341000
RBP: ffff888121042dc0 R08: ffffffff903129c3 R09: 1ffffffff2062538
R10: dffffc0000000000 R11: fffffbfff2062539 R12: 0000000000000020
R13: dffffc0000000000 R14: ffff888121042d80 R15: ffff88815fffbae8
FS:  0000000000000000(0000) GS:ffff88818dc7e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 free_frozen_page_commit+0x737/0x1290
 __free_frozen_pages+0x873/0x1070
 kasan_depopulate_vmalloc_pte+0x6d/0x90
 __apply_to_page_range+0xbdc/0x1420
 __kasan_release_vmalloc+0xa2/0xd0
 purge_vmap_node+0x220/0x960
 __purge_vmap_area_lazy+0x779/0xb40
 drain_vmap_area_work+0x27/0x40
 process_scheduled_works+0xb5d/0x1860
 worker_thread+0xa53/0xfc0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
