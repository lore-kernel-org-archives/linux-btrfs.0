Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F474315F;
	Sat, 27 Jun 2026 09:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782552499; cv=none; b=n/RnqbcMOYmUMSWeo9mKhGx16gEr3Dd3XMNNdEh36DD7F1OX/MaiV47Ol0SpGoSIEi39ZOTxAiJBCdy05oNthcjLsIGDGVRMFvAe1PNo8qAGHESXHHfiB+HUV+FvyrjzDKnOgnmD9p/sAWIXjHShwkaBtFxe0JuElaOMmRKTVA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782552499; c=relaxed/simple;
	bh=Nl9pUHyxEiGt4xwCkLiF2Adwkn5J3l0qSlEeyvXATaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pLyMs3S4StsXJuDwkxeCRJA/F9tlehE9g+vWQlvcGdb9W7y/7vYMUjgEkGbh465WtkpAvoriDqaulcfGBY4407dw8hN2hJGJmE3NxCrmPT49KAU8MbwrCdt8gQROaXs9a62xiQnY2jElz1Eql2tCDgHdJIIdEAjgxlId7uK/WRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DM6+8uqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DM6+8uqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35901F000E9;
	Sat, 27 Jun 2026 09:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782552497;
	bh=Q/0eNKdsfHvMtaLK/+9iF7k4NRMMJLn2GG9LrFdj48c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DM6+8uquXvI1/gQKEkpBES+99zxwXEQ4MnBHTJ5IRcAo3irxTIvUJDeQ508zoZket
	 gE7HELLevawOhknvOp+FWmGfaUTD6+YdeYVGxI4JxplCyltgBbOwOr0/81bpPXHD22
	 Q7lqg+IIcPqkQ45zE/vnlALV2Y+s2Vdl58+fGg12LFBAd6eGxtU9EGbb5yp8SP82PR
	 6bxGIkqLo/++QwsXyPP6lv/vjcAZWbbtMOGDgkpzn7VE7iwF+6PtZCNDiSz/omcqQm
	 TV2A64LuQiZX1xvamlShq6XJjm5f0IruTf2VMJmetF96xiO6WjUn+EuLUeYQT2WwnD
	 SOQms8oQy7x/w==
Date: Sat, 27 Jun 2026 10:28:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-cxl@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
Message-ID: <aj9yrlB0TrlYCLlf@lucifer>
References: <20260520150018.2491267-1-riel@surriel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>

+cc missing maintainers.
+cc Linus for general issues raised.

(Apologies, this email is VERY long, even for me)

Hi Rik,

I appreciate this is an RFC, but obviously part of that is early
feedback. So if this is meant to be an (EXTREMELY) rough pre-RFC
proof-of-concept then fine (however your 'todo' suggests otherwise).

And of course, before I get critical :) thank you for looking into this,
it's very interesting work. I want this feature to land. BUT :)

So if this in any way resembles what you plan to send upstream un-RFC'd I
need to pour a fairly large bucket of very cold water over this.

TL;DR: The series is completely unmergeable as it stands. Not even close.

Before we get into the code, please please please make sure you cc- the
right people. You're doing very invasive, very major work here.

You failed to even cc- the page allocator maintainer (Vlastimil) for a
series that radically alters page allocation.

MAKE SURE you cc- Vlastimil and all other maintainers and reviewers + lists
on future (RFC!!) revisions of this please.

If you want to do a quiet off-list pre-RFC that's fine, but it's
unforgivable to leave Vlastimil out of this even for that.

It's 30 seconds running a script (filtering for maintainers alone to save
on noise):

$ scripts/get_maintainer.pl --nogit --nogit-fallback --nor 20260520150018.2491267-1-riel@surriel.com.mbx
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE)
David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - CORE)
Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
Chris Mason <clm@fb.com> (maintainer:BTRFS FILE SYSTEM)
David Sterba <dsterba@suse.com> (maintainer:BTRFS FILE SYSTEM)
Vlastimil Babka <vbabka@kernel.org> (maintainer:MEMORY MANAGEMENT - PAGE ALLOCATOR)
Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)
Masami Hiramatsu <mhiramat@kernel.org> (maintainer:TRACING)
"Rafael J. Wysocki" <rafael@kernel.org> (maintainer:HIBERNATION (aka Software Suspend, aka swsusp))
Oscar Salvador <osalvador@suse.de> (maintainer:MEMORY HOT(UN)PLUG)
Mike Rapoport <rppt@kernel.org> (maintainer:MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION)
Johannes Weiner <hannes@cmpxchg.org> (maintainer:MEMORY MANAGEMENT - RECLAIM)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
linux-doc@vger.kernel.org (open list:DOCUMENTATION)
linux-kernel@vger.kernel.org (open list)
linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
linux-trace-kernel@vger.kernel.org (open list:TRACING)
linux-pm@vger.kernel.org (open list:HIBERNATION (aka Software Suspend, aka swsusp))
linux-cxl@vger.kernel.org (open list:MEMORY HOT(UN)PLUG)
HIBERNATION (aka Software Suspend, aka swsusp) status: Supported
SUSPEND TO RAM status: Supported

OK, so getting into the code. You didn't include an overall diffstat. So let's
see:

$ git checkout e1914add2799
...
$ b4 shazam 20260520150018.2491267-1-riel@surriel.com
...
$ git format-patch --cover-letter HEAD~40
...
$ tail -31 0000-cover-letter.patch
 Documentation/admin-guide/sysctl/vm.rst |   21 -
 Documentation/mm/physical_memory.rst    |   13 +-
 fs/btrfs/extent_io.c                    |   69 +-
 fs/btrfs/extent_io.h                    |    4 +-
 fs/btrfs/inode.c                        |    2 +-
 fs/btrfs/ioctl.c                        |    2 +-
 fs/btrfs/raid56.c                       |    6 +-
 fs/btrfs/relocation.c                   |    2 +-
 fs/btrfs/scrub.c                        |    3 +-
 include/linux/mmzone.h                  |  236 +-
 include/linux/page-flags.h              |    9 +
 include/linux/pageblock-flags.h         |   10 +
 include/linux/vm_event_item.h           |   10 +
 include/trace/events/kmem.h             |  373 ++
 kernel/power/snapshot.c                 |   35 +-
 mm/compaction.c                         |  360 +-
 mm/debug.c                              |   19 +-
 mm/internal.h                           |   39 +
 mm/memory_hotplug.c                     |    4 +
 mm/mm_init.c                            |  400 +-
 mm/page_alloc.c                         | 5064 ++++++++++++++++++++---
 mm/page_reporting.c                     |  149 +-
 mm/show_mem.c                           |   27 +-
 mm/sparse.c                             |    3 +-
 mm/vmscan.c                             |  115 +-
 mm/vmstat.c                             |   71 +-
 26 files changed, 6131 insertions(+), 915 deletions(-)

This is completely insane :) I do hope the omission of the diffstat was not
to hide this, but at any rate, adding ~5,000 lines of code to page_alloc.c
is a complete non-starter.

In any case I think clearly more files are required, mm/super_pageblock.c
or whatever it'll be, but at any rate this much code being added to me
clearly indicates something is terribly wrong here anyway.

And you added no tests whatsoever. I get that some things are hard to test
in the kernel and mm, but not even an attempt? Surely you have some
localised stuff that you've been using to exercise this, couldn't some of
that be made into selftests?

Certainly if tests are not present, this needs to be justified in the cover
letter.

(Again I appreciate this is an RFC, so perhaps those are coming.)

Anyway let's look at some of this code. Johannes's patches all look
reasonable, but as soon as we start seeing:

Assisted-by: Claude:claude-opus-4.7

Things start to go awry.

The series is full of extremely dense comments that contain far too much
specific information to be parseable. E.g.:

+	 *  - owner_cpu == this CPU (or no owner): take the local PCP
+	 *    lock with spin_trylock and enqueue normally. The trylock
+	 *    fails only on rare local self re-entry (IRQ/NMI fires
+	 *    while the interrupted task already holds the lock) or
+	 *    while a remote drain is active; either way, fall back to
+	 *    free_one_page (or the zone-llist for FPI_TRYLOCK). No
+	 *    irqsave: the trylock cannot block on self, and remote
+	 *    CPUs never take this pcp->lock (they go via free_llist),
+	 *    so an interruption cannot deadlock against another freer.

This isn't readable. This isn't acceptable. It matches exactly what I've
found LLMs to do, adding far too much detail in way that isn't
human-readable.

You must redo all of these.

The patches are all quite dense. 40 patches is already far too many IMO for
a series this massive, but you're also piling in tonnes of complexity in
every patch.

The series should really be broken out into separate series that each
slowly build up the prerequisites, so they are reviewable, parseable, can
be seen in action before we move to the superblock concept and each having
tests or means of asserting that they in fact function.

It feels that there are patches that indeed can be broken out sensibly like
this,
e.g. https://lore.kernel.org/all/20260520150018.2491267-5-riel@surriel.com/
(which also seems to be a fix? So maybe should be sent as one with
appropriate tags?), so I think that's really the only viable way to land
something this huge.

I see Usama commented on you breaking userspace, and you said you are not
going to do that after all (thanks)... but it worries me that you
essentially render the watermark boost broken? I don't think that's OK?

The code in general dumps large blocks of code into already existing huge
functions but, even more unforgivably, turns small, maintainable, easily
understood functions into completely disgusting horror shows.

For instance, __rmqueue_smallest() goes from ~20 lines to 604 lines. This
is completely insane and totally unacceptable.

The code is also full of software engineering 101 fails. For instance in
__rmqueue_sb_find_fallback():

	if (search_cats & SB_SEARCH_PREFERRED) {
		...
		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
			list_for_each_entry(sb,
					    &zone->spb_lists[cat][full], list) {
				...
				if (movable && cat == SB_TAINTED &&
				    sb->nr_free <= spb_tainted_reserve(sb))
					continue;
				...
				for (i = 0; i < MIGRATE_PCPTYPES - 1; i++) {
					...
					if (page) {
						...
					}
				}
			}
		}
	}

Note the mix of insane nesting AND guard clauses to make it even more
indecipherable.

There's no world in which I, or any other mm maintainer (I would venture to
say) want to maintain stuff like this.

A particularly concerning patch is
https://lore.kernel.org/all/20260520150018.2491267-15-riel@surriel.com/ -

The commit messages suffer from the same issue as the comments - incredibly
dense material that is far too detailed to the point of absolutely
clarifying nothing. E.g.:

"The SPB list heads (zone->spb_empty and the spb_lists[cat][full] matrix)
 are initialized only by setup_superpageblocks(), which is __init and runs
 only at boot.  Hot-add into a previously-empty zone invokes
 init_one_superpageblock() with zero-initialized list_heads, and the
 inlined list_add_tail() NULL-derefs walking ->next->prev."

Is just complete word salad. It may as well be written in Egyptian
hieroglyphs.

You're explaining spaghetti code using English language which makes it even
more indecipherable, and not getting to the root of what you are actually
doing.

Again this feels very LLM-generated. I've noticed that they tend to do this
'write out the code again but in English' stuff (and is why I do not
allow LLMs to generate code or comments for me!)

You need to make commit messages and comments as succinct as possible and
as clear as possible for _human beings_ :)

I also notice you have this huge blocks of word salad comments all over the
place but I haven't seen a single kdoc comment (EDIT: noticed at least 1 later!)

This is a far more helpful, structured, form of describing functions and
for anything put in a header you really do need to provide them.

Back to the patch. The diffstat is:

 include/linux/mmzone.h |  10 +
 mm/compaction.c        |  36 +-
 mm/internal.h          |  10 +
 mm/mm_init.c           | 146 +++++--
 mm/page_alloc.c        | 853 ++++++++++++++++++++++++++++++++---------
 mm/vmstat.c            |  66 ++--
 6 files changed, 883 insertions(+), 238 deletions(-)

This is (generally speaking, and certainly in this case) far, far too much
for a single patch.

But as per above this is the patch where you commit what are essentially
code war crimes against __rmqueue_smallest(), adding code so densely nested
that you have to lop off the end of code to fit:

+	if (!movable && !is_migrate_cma(migratetype)) {
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				if (!sb->nr_free)
+					continue;
+				for (current_order = max_t(unsigned int,
+						order, pageblock_order);
+				     current_order < NR_PAGE_ORDERS;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, MIGRATE_MOVABLE);
+					if (!page)
+						continue;
+					if (get_pageblock_isolate(page))
+						continue;
+					if (is_migrate_cma(
+					    get_pageblock_migratetype(page)))
+						continue;
+					page = claim_whole_block(zone, page,
+						current_order, order,
+						migratetype, MIGRATE_MOVABLE);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
+	}

I mean in what world are we taking code like this?

https://lore.kernel.org/all/20260520150018.2491267-22-riel@surriel.com/ has
what seem to be more human comments (good!) but then so densely nested that
they have to be cropped (bad).

using smaller, separate, functions and a structured programming approach
here is the way to go.

There's random smaller issues too like
https://lore.kernel.org/all/20260520150018.2491267-23-riel@surriel.com/
seems to assume the compiler can't figure out to remove dead code (note the
wild inconsistency too in comments)

You seem in some commits to undo or correct stuff you did in previous ones
like
https://lore.kernel.org/all/20260520150018.2491267-24-riel@surriel.com/

I mean perhaps I'm mistaken, but otherwise, can you instead rebase your
series please?

And again we see the world salad:

+ * Maximum tainted superpageblock candidates per spb_evacuate_for_order call.
+ * Collected under zone->lock, then evacuated without it. Larger than the
+ * contig-allocation candidate cap because evacuation runs from the slowpath
+ * after reclaim/compaction failed: we need a meaningful chance of freeing a
+ * non-MOV-claimable pageblock before the slowpath escalates to dropping
+ * ALLOC_NOFRAGMENT (which lets __rmqueue_claim taint clean SPBs). Sized to
+ * scan a meaningful fraction of a typical tainted-pool population.

No kdocs, some functions/complicated logic missing any comments at all,
then piles of words thrown at you like a rock.

This isn't pleasant to read, it adds no clarity, it just makes the whole
thing a mess.

The code in that one is at least vaguely ok (though still too nested).

I feel like where you've manually written code the quality substantially
improves, where the LLM has, the quality nosedives into oblivion.

For instance
https://lore.kernel.org/all/20260520150018.2491267-26-riel@surriel.com/
seems to be radically better, albeit adding far too much code. So I assume
that was more manual.

Stuff like
https://lore.kernel.org/all/20260520150018.2491267-27-riel@surriel.com/
shows more of a structural issue.

In:

+	 * Mark callers that have a cheap fallback if the page allocator returns
+	 * NULL, so __rmqueue can refuse to taint a clean SPB when an existing
+	 * tainted SPB still has free pageblocks waiting to be evacuated.
+	 *
+	 * Two shapes qualify:
+	 *
+	 *  1. Explicit fallback declaration: __GFP_NORETRY without
+	 *     __GFP_RETRY_MAYFAIL. Used by THP, slab high-order refill,
+	 *     skb_page_frag_refill on full sockets, etc.
+	 *
+	 *  2. Atomic-context shape: no __GFP_DIRECT_RECLAIM, no __GFP_NOMEMALLOC,
+	 *     no __GFP_NOFAIL. These callers (GFP_ATOMIC, GFP_NOWAIT, including
+	 *     ALLOC_HIGHATOMIC consumers) have implicit fallbacks: drop the
+	 *     packet, demote the slab order, return ENOMEM up the slowpath,
+	 *     retry from process context with GFP_KERNEL, etc. ALLOC_HIGHATOMIC
+	 *     callers also get a second crack at the dedicated MIGRATE_HIGHATOMIC
+	 *     reserve in rmqueue_buddy after __rmqueue returns NULL.
+	 *     Tainting a 1 GiB SPB to satisfy any of them is a long-lived
+	 *     fragmentation event for short-lived data.
+	 *

The comment is vastly better than most, but you seem to be tying far too
much up in assumptions about what particular workloads do.

This is indicative perhaps of a need to refactor to more reasonably
determine these.

Adding a function and state, say, that expresses these properties would
allow you to break out these concepts and have the code be self-documenting
(as well as adding suitable actual documentation in comments that would be
more succinct).

https://lore.kernel.org/all/20260520150018.2491267-29-riel@surriel.com/
also shows some real issues with how you've implemented this, e.g.:

+ * Called from each PASS_1/2/2B/2C/2D success path after a successful
+ * allocation against a tainted SPB. If the SPB is below its shrink
+ * high-water mark, queue the SPB-driven slab shrink and try to start
+ * the per-SPB defrag worker. Both have their own cooldown gates inside,
+ * so this is cheap to call on every such allocation.

Now you're putting information from one gargantuan function with labels
about 'passes' (rather reminiscent of VMA merge 'cases') into another.

This is a clear sign of a broken abstraction and the code not being
structured correctly.

You should _express_ state encoded in these 'passes' in the _actual code_,
break that code up sensibly and in a way that can be assessed for
correctness, not put a bit-rotting comment on top of a function whose
correctness is much harder to confirm.

Again this patch has similar issues with ridiculously dense indecipherable
comments, e.g.:

+	 * Last-chance defrag trigger before tainting a fresh clean SPB.
+	 * Walk the tainted-SPB list and try to wake the per-SPB defrag
+	 * worker on each. Catches SPBs that are stuck in expired-cooldown
+	 * state because no allocator activity has touched them recently
+	 * (the routine event-driven trigger from spb_update_list only
+	 * fires on bucket transitions, not on every alloc). Once the
+	 * cooldown has expired, spb_maybe_start_defrag() will requeue
+	 * work; otherwise the gate inside spb_needs_defrag() no-ops
+	 * cheaply. Bounded by nr_tainted_spbs and only runs when we are
+	 * already on the slow path of fragmenting the clean pool.

The spoondecker is montiplexed in the fradupple complex dedadderated in the
splunkyfied concratanator underfined by the transpontaculatoration
matrixifier... :)

I think this is symptomatic of the abstraction being fundamentally broken.

If you have to establish vast swathes of cognitive context like this mid
way through a huge function (again poor __rmqueue_smallest() who will never
forgive you), then you've basically failed to abstract it.

Please I beg you ADD FUNCTIONS :) structured programming is a thing,
struct's are a thing, abstraction is a thing :)

Pouring spaghetti into a single function is something you expect to see on
a 1990's PHP website, not in core mm code ;)

https://lore.kernel.org/all/20260520150018.2491267-30-riel@surriel.com/
seems to be another example of you just rethinking parts of what you
already submitted midway through the series.

Again I might be missing something here, but if you are doing this, please
just rebase your series to use $NEWIDEA from the start.

https://lore.kernel.org/all/20260520150018.2491267-35-riel@surriel.com/ is
another wall of text (newlines! Please :) but it seems like something you
can break out separately no?

It seems at least reviewable :)

https://lore.kernel.org/all/20260520150018.2491267-36-riel@surriel.com/
contains more of the same broken abstraction stuff, terrible nesting stuff,
word salad stuff but is at least mercifully smaller.

https://lore.kernel.org/all/20260520150018.2491267-37-riel@surriel.com/ is
almost emblematic of the terrible (LLM I hope?) comment issue in the
series. Overly dense hieroglyphs.

https://lore.kernel.org/all/20260520150018.2491267-38-riel@surriel.com/ is
another 'why didn't you rebase?' patch (again maybe I'm missing something
here!)

https://lore.kernel.org/all/20260520150018.2491267-39-riel@surriel.com/
seems more reasonable although newlines please :)

And finally
https://lore.kernel.org/all/20260520150018.2491267-40-riel@surriel.com/ -
while it's a do-not-merge patch in an RFC that changes tracing so maybe
unfair, but the comments are suffering the same symptoms as the rest of the
series.

~

So really, you need to start again, from scratch, and without the use of an
LLM for generating code, or at least with it kept on a (very very short)
leash.

And to be clear, I _want_ this concept of GB superpageblocks to land. It's
a really exciting concept.

Pulling compaction kicking and screaming into 2026 stands to significantly
benefit linux users and developers.

But the execution has to be _completely_ rethought.

I also worry about correctness - I simply cannot see how you can have sense
of it, given the state of the code. For something so invasive and so
critical to kernel functionality, code quality is simply not optional here.

Practical thoughts on how to rework the series:

- Properly abstract the concepts
- Properly separate out functions and data structures
- Add _human-readable_ comments that are succinct + clear as possible
- If a function becomes too nested, separate into smaller functions
- Add tests, if at all or in any way possible (and justify if you can't)
- Clarify commit messages, don't just rewrite code in English
- Use newlines for new paragraphs everywhere :)
- Refactor existing code in preparation for your changes
- Add a new file to contain your changes (+ add to page alloc MAINTAINERS
  section)
- Add kdocs for anything not static, and clearly describe static functions
- Split into separate series as much as possible, gradually building
  foundations for your changes
- Make everything less dense and more abstracted

In general, write the series with reviewers and other kernel developers in
mind - write clear explanations in comments and commit messages, have the
series slowly build to what you're implementing.

That way, we can see that correctness is maintained throughout, can review
what's there sensibly, and the series becomes upstreamable.

IOW I say we take off and nuke the entire site from orbit. It's the only
way to be sure :)

~

Another issue here is maintainer time - even this _extremely_ light-touch
review has taken me a few hours (of my weekend :). To review it in detail
would take probably DAYS of dedicated work.

In general, I'm concerned that we're going to get caught in a cycle of LLM
code sent - reviewers spending hours reviewing - LLM generates new revision
- etc.

This simply isn't scalable, maintainers cannot do this in the face of the
sheer quantity and complexity of code that LLMs can generate.

We are simply going to have to NAK. And that helps nobody.

Luckily for me, this isn't in a sub-(sub-)system I maintain, so I am not
obliged, but I do have empathy for my fellow maintainers, and am VERY
concerned about this trend.

There has recently been an absolute wave of LLM code, some acked as such
(and I think you for doing so here!) but others unacknowledged entirely,
and the workload, which was already too much, has risen significantly (Jon
has noted the rise in commit count for instance in LWN).

Treating maintainer time as without value was already an issue, but I fear
that we'll see a significant increase in maintainer stress and sadly,
burnout.

As such, I feel that we will have to implement measures at some point to
deprioritise/quickly dismiss such series, unfortunately.

But series from smart and capable engineers such as yourselfk who are well
respected in the communityk will likely not bek and thus will suffer from
this issue indefinitely.

So on that basis, I ask respectfully that you account for this when using
this tooling.

(Also, I appreciate that this is an RFC, but your recent non-RFC GUP series
https://lore.kernel.org/all/20260616190300.1509639-1-riel@surriel.com/
(revision v2 at
https://lore.kernel.org/all/20260625015053.2445008-1-riel@surriel.com/) has
all the same hallmarks as this one, so I feel this point needs to be
underlined).

~

Speaking more generally across the industry, I've been reading about
companies generating code blindly and running into terrible problems with
software that ends up becoming totally unmanageable.

I won't tolerate this happening happening in mm, and strongly object to the
concept (held by some AI proponents) that code is simply an unimportant
byproduct of AI.

The kernel's code (and especially mm's) is _critically_ important, quite
literally, as it forms the basis of the world's critical technical
infrastructure.

I am not opposed to the use of LLMs, but they _must_ serve as tools to
_assist_ experts at their job, not a means by which code bases are
degraded.

~

OK with all that said - to be absolutely clear - I respect you a great
deal, and I KNOW you're (much, much) better than this.

And, to repeat, this idea is very exciting and I _want_ to see this land.

But I feel you've rather let the LLM run amok and it's selling you (very,
very) short, given just how smart and capable you are.

Let's try again :)

Thanks, Lorenzo
