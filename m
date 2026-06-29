Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B24378824;
	Mon, 29 Jun 2026 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725393; cv=none; b=Q9K5WWFObcG2v39ulZslxLZxkJpgYEU0o9PVv+DZRCDiIzD6qcRJVb6Kvg3JJ3WJCy5yh/AS01EDbILL04/5JL5/TIXrYZbDR8kM3zNpJ3lqs+EvgUxkhf5q3ZLLpSB4ak82QEZ3nyfnWDE3V2nvjAr5chox9J0q+dKNrwyA1ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725393; c=relaxed/simple;
	bh=jSMKyhpwOoBN2kN4mXySQg7+N1xIK06zgQcIqssIhNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3wW7zdWHMULkuSSrvCt9ETJBtZUNCn/8oxlFUaoLV4ps1H5UE2EFX7gxQxwCnLW559Uf6Lw3OIk1WI5qXmuYTuQkMJ2h1PPJspSr6HCESSY9GsMN1YAx4/2qlF/lA+zwhl0DeC6FH1WDU8KSqWUJKaD0LYq/+W+Ah3BdvyBiY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtA7MjXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtA7MjXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047F41F00A3A;
	Mon, 29 Jun 2026 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782725392;
	bh=Npk92WP4+iddnwXb26xetSuG1nU9c64h3XFMA6XCVrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VtA7MjXRZVQaaJ9Ih/X8IeykXC9h1JN3ed+nWlG+FOYdWGYUVvUlIiRfl8oubtyCi
	 gOmZrcpZ7qUUKF3WHd8F3vWIfsakqRyVS0nU1BabmH05MWinufmuagmMR+lVYMj/Sh
	 9ISoLFdQ38FmmGnyJP1nwUcRyG0El5hYGkYeIa6RyCDutA2wHCodwkG3HhA7gvREzN
	 MsT+C+WV88u/DYSwuWI7DQ+2llBIY3R3Qte+cAsQs4hVNlZSfO9axLXh/C6eHPvdII
	 qSVdM5bqj/+BDniFj4HC3c2DUW0+1pD55OJ1rVvyJoYtl/NFw0Nax2r+VvCkGMmUgh
	 O6dPgtCAjuZSg==
Date: Mon, 29 Jun 2026 10:29:41 +0100
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
Message-ID: <akIjA_dqh4OHAYo4@lucifer>
References: <20260520150018.2491267-1-riel@surriel.com>
 <aj9yrlB0TrlYCLlf@lucifer>
 <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>

TL;DR - please don't send unfiltered LLM code to list _at all_. If you want
to share it, link to a repo.

On Sat, Jun 27, 2026 at 09:36:51AM -0400, Rik van Riel wrote:
> That is the one reason I sent out RFC code before it
> is ready. I am looking for feedback on the concepts
> in this series.
...
> Once I know what I need to do, coming up with a
> cleaner implementation is very doable.
...
> The mess in the RFC is the result of trying something
> that seemed right, watching it fail in some subtle
> way, and trying to fix it up.
...
> > But the execution has to be _completely_ rethought.
>
> There's no argument there.
...
> > Another issue here is maintainer time - even this _extremely_ light-
> > touch
> > review has taken me a few hours (of my weekend :). To review it in
> > detail
> > would take probably DAYS of dedicated work.
>
> I suspect there is a mismatch in expectations here.
>
> I already knew this code has to be totally redone.

I'm glad we are in agreement on this :)

But in general I feel you have sent this and at least one other series like this
without being as clear as you should have been.

I hate to belabour the point but just to be clear:

* You label one patch [DO-NOT-MERGE], but none of the others (implying they
  are candidates for being merged) [0] and the cover letter has TODOs,
  including trivia like naming, but nothing about the code.

* You sent a non-RFC series with identical code quality issues [1]
  recently.

* Until I pointed it out, you were responding to other review here as if
  the series was genuinely was intended for (eventual) merge:

  - "This is a userspace-visible removal. Writes to
     /proc/sys/vm/watermark_boost_factor will now return -ENOENT instead of
     being accepted, breaking userspace." [2]

     <-: "I'll just drop this patch for now." [3]

  - "I left a small code nit inline, but whether you take that suggestion
     or leave it, you can add Reviewed-by: ..." [4]

    <-: "I sent it with this series mostly because it's needed to make the
    series work, and to provide context on why it's needed. I'm happy to
    resend it with a GFP mask passed in by each caller. That would look
    better, indeed!" [5]

So to be concrete, if you send really rough code, Use [pre-RFC] or [DO NOT
MERGE] (on the series as a whole) to make that clear and say so in the
cover letter VERY VERY clearly.

Or, you can put it in a repo somewhere and link it in an email discussing
the concepts (like I did with scalable CoW for instance).

Also if people respond to the series as if it isn't pre-RFC, I'd suggest in
your replies saying something like 'I intend to completely rework all this
anyway' or something like that! :)

> How do people feel about splitting up the free lists,
> so each gigabyte (well, PUD sized) chunk of memory
> has its own free lists?
>
> How can we balance the desire for higher-order kernel
> allocations, against the desire to preserve gigabyte
> sized chunks of memory that can be used for user space?
...
> That's another big question. How do we balance the
> desire to keep compaction overhead low with the desire
> to do higher order allocations almost everywhere?
>
> >
...
>
> I am just hoping to figure out what I should be
> doing on a conceptual level, before figuring out
> how to do it cleanly.
>
...
>
> I was looking for feedback on the basic concepts
> and design in the patch series, but failed to
> clearly communicate that.
>
> You provided some detailed feedback on the code,
> but as of yet nobody has really provided any
> opinions on things like whether it is desirable
> at all to have the free lists per gigablock,
> or whether we need to come up with some totally
> different approach.
>
> How do we better communicate that kind of thing
> in the future?
>
> Is that something to spell out more clearly in
> the cover letter?
>
> Is that kind of feedback something developers
> could even reasonably ask for? (if not, how do
> we figure out what maintainers want?)

As above, firstly make it clear that the code you are sending for review is
not to be reviewed so people don't waste highly contended maintainer time
on that! :)

Also, you didn't respond to my point regarding cc'ing the right people -
but that's clearly something you need to get right if you want this kind of
feedback to start with.

For instance, you didn't cc- the page allocator maintainer (Vlastimil) on a
series that is fundamentally changing the page allocator. That's not going
to help with feedback.

In general, this area of the page allocator and compaction isn't my
specialism in the kernel so I can't give you the in-depth feedback you need
on that.

But I do have thoughts in general as to how to achieve what you want here:

Firstly - you should try to summarise what you're doing here and what
you're changing alongside the trade-offs as clearly as you can in the cover
letter.

Then highlight what it is you need feedback on, broken out into clear
questions or points that make it easy for people to respond to.

And _you have already done this_ in your reply here:

* "How do people feel about splitting up the free lists, so each gigabyte
   (well, PUD sized) chunk of memory has its own free lists?"

* "How can we balance the desire for higher-order kernel allocations,
  against the desire to preserve gigabyte sized chunks of memory that can
  be used for user space?"

* "How do we balance the desire to keep compaction overhead low with the
   desire to do higher order allocations almost everywhere?"

I think a really good way of doing this would be to start out with
something like:

	Right now compaction often fails to achieve what we need, with
	fragmentation occurring anyway and (for instance) THP stalling on
	the availability of higher order folios.

etc. etc.

Summarising _the problem_.

Then a section about your proposed solution, e.g.:

	I propose a means by which we proactively achieve gigabyte-sized
	pageblocks with logic which maintains these as physically
	contiguous under both ordinary and contended workloads

Then list out the "secret sauce" of your approach, e.g.:

	This works by arranging memory such that unmovable allocations are
	grouped at <blah blah blah> etc.

Then raise your questions e.g.:

	I'd like to ask the community - how do people feel about splitting
	up the free lists, so each gigabyte (well, PUD sized) chunk of
	memory has its own free lists? <etc. etc.>

Then make it clear whether this is an RFC that is ready for primetime or
not:

	This series is simply intended as a proof-of-concept - PLEASE DO
	NOT REVIEW THE CODE per-se, but rather comment on the concepts!

(And obviously as above, if that _is_ what you intend, underline it with
[DO NOT MERGE] or [pre-RFC] or something like that).

I'd also very strongly suggest (as I did in my original reply) breaking out
parts that can be broken out as prerequisite series.

If you're doing something good or useful _anyway_ then just send that
separately first, and have later work rely on the earlier work.

There's no rush, this is huge and will take time.

A final KEY point:

NEVER submit unfiltered code generated by an LLMs to the list in _any_
form. If you want people to access code like that to test or something,
then put it in a remote repo and link to it.

The code is SO overly complicated and SO messy that it's really difficult
for people to understand what's actually going on.

At the heart of what you need here is CLARITY.

You need to CLEARLY communicate what it is you're doing so busy maintainers
can examine it. That's the _only_ way you're going to get something like
this merged.

The LLM-generated code is so awful that ain't nobody got the time to try to
understand what it's doing.

The workload for this really has to be on submitters, not maintainers.

And what you've done, even if not intended, is workslopping, and that's
really not acceptable. Quoting the kernel process on tool-generated content
[6]:

"If tools permit you to generate a contribution automatically, expect
additional scrutiny in proportion to how much of it was generated.

As with the output of any tooling, the result may be incorrect or
inappropriate. You are expected to understand and to be able to defend
everything you submit. If you are unable to do so, then do not submit the
resulting changes.

If you do so anyway, maintainers are entitled to reject your series without
detailed review."

As per this and my previous reply, AI slop doesn't scale, even as an RFC -
I won't have time to reply like this in future, and we will just have to
reject your series out of hand, which helps nobody.

>
>
> --
> All Rights Reversed.

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260520150018.2491267-41-riel@surriel.com/
[1]:https://lore.kernel.org/linux-mm/20260616190300.1509639-1-riel@surriel.com/
[2]:https://lore.kernel.org/all/20260526140204.1390573-1-usama.arif@linux.dev/
[3]:https://lore.kernel.org/all/2ecf71858845e7d14c718b1a6845389cb78b986e.camel@surriel.com/
[4]:https://lore.kernel.org/all/20260520174749.GA1458531@zen.localdomain/
[5]:https://lore.kernel.org/all/daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com/
[6]:https://docs.kernel.org/process/generated-content.html
