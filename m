Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B52A3FB7D3;
	Mon, 29 Jun 2026 10:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727428; cv=none; b=l6t2//POIFFZ34FVQvdaflR/jJPAp1m21vrnpxWe37yzJ5dSq4Zbt1kPZz73Di78pRw7tl5wl0h/cgztQmvnR+/cUYf6XaRBxAzH7calYOk0BFXdWzX08q0PpWSUw6gLan/TdmGFpD7GGAzAJKQJdi9f3y9HJXFrzB3ZWA/a+8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727428; c=relaxed/simple;
	bh=bwXLL+XJvWMAXziHSYZE2po8bOEpQlV1khCY0EzhTyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQ252thFgR2Iz7PfFLfn1V6BBoZht0MsEZENW9OVj1IU1a8iOvlDnSZEp3xQLq7QN7vzMY5r9kmvQM5ii1LaHAcau6r1NHQNLyrtR6augq4TeA/LDw/oOxQAc8T4dHGUNddkSSLcDL2KnY7TW+QG0jWZ44AZB+uV/eozJeYIn48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoarWmxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoarWmxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DD01F000E9;
	Mon, 29 Jun 2026 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727427;
	bh=Jd+hmxLURQiD9Sgh35jmlQ8k1qpegebRuBU4J3XstSM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KoarWmxWjVDe2EjBPztEGnT09eM0m6YQTFgIHSu01qGRWVz6iiIBSvc2hxB0aVpA+
	 Wuf+esX0EphxkjbdxfFD1lboJUsG94uCFUGTIyd8yxNorQozTn6vvDsgpR/rpNdL4o
	 HByjVHsUeDPVTYKR1Sifft2E/47evt1V26MI06NT49+UAug0JkOuVEbGQ6VLksEqk3
	 +18uw2WA6RcmwawTnahlR77ecg/pVNMLKWjLN+O0I2tsf6vegWhlM03opgOpxEfxNs
	 R0erYHaOrtSuXcJi+hQRduGwhqYFQincxnCDCDTyPEcNn07kccpBtJmSpWhSBBT66W
	 q3Iq4tTUkOsUQ==
Message-ID: <361fd2e5-a5f9-42fe-90fc-bc0af109553e@kernel.org>
Date: Mon, 29 Jun 2026 12:03:39 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org,
 david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 linux-doc@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-cxl@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <20260520150018.2491267-1-riel@surriel.com>
 <aj9yrlB0TrlYCLlf@lucifer>
 <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>
 <akIjA_dqh4OHAYo4@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <akIjA_dqh4OHAYo4@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/29/26 11:29, Lorenzo Stoakes wrote:
> TL;DR - please don't send unfiltered LLM code to list _at all_. If you want
> to share it, link to a repo.
> 
> On Sat, Jun 27, 2026 at 09:36:51AM -0400, Rik van Riel wrote:
>> That is the one reason I sent out RFC code before it
>> is ready. I am looking for feedback on the concepts
>> in this series.
> ...
>> Once I know what I need to do, coming up with a
>> cleaner implementation is very doable.
> ...
>> The mess in the RFC is the result of trying something
>> that seemed right, watching it fail in some subtle
>> way, and trying to fix it up.
> ...
>> > But the execution has to be _completely_ rethought.
>>
>> There's no argument there.
> ...
>> > Another issue here is maintainer time - even this _extremely_ light-
>> > touch
>> > review has taken me a few hours (of my weekend :). To review it in
>> > detail
>> > would take probably DAYS of dedicated work.
>>
>> I suspect there is a mismatch in expectations here.
>>
>> I already knew this code has to be totally redone.
> 
> I'm glad we are in agreement on this :)
> 
> But in general I feel you have sent this and at least one other series like this
> without being as clear as you should have been.
> 
> I hate to belabour the point but just to be clear:
> 
> * You label one patch [DO-NOT-MERGE], but none of the others (implying they
>   are candidates for being merged) [0] and the cover letter has TODOs,
>   including trivia like naming, but nothing about the code.
> 
> * You sent a non-RFC series with identical code quality issues [1]
>   recently.
> 
> * Until I pointed it out, you were responding to other review here as if
>   the series was genuinely was intended for (eventual) merge:
> 
>   - "This is a userspace-visible removal. Writes to
>      /proc/sys/vm/watermark_boost_factor will now return -ENOENT instead of
>      being accepted, breaking userspace." [2]
> 
>      <-: "I'll just drop this patch for now." [3]
> 
>   - "I left a small code nit inline, but whether you take that suggestion
>      or leave it, you can add Reviewed-by: ..." [4]
> 
>     <-: "I sent it with this series mostly because it's needed to make the
>     series work, and to provide context on why it's needed. I'm happy to
>     resend it with a GFP mask passed in by each caller. That would look
>     better, indeed!" [5]
> 
> So to be concrete, if you send really rough code, Use [pre-RFC] or [DO NOT
> MERGE] (on the series as a whole) to make that clear and say so in the
> cover letter VERY VERY clearly.

Yes please. [POC NOT-FOR-MERGE] perhaps?

> Or, you can put it in a repo somewhere and link it in an email discussing
> the concepts (like I did with scalable CoW for instance).

Indeed.

> As above, firstly make it clear that the code you are sending for review is
> not to be reviewed so people don't waste highly contended maintainer time
> on that! :)
> 
> Also, you didn't respond to my point regarding cc'ing the right people -
> but that's clearly something you need to get right if you want this kind of
> feedback to start with.
> 
> For instance, you didn't cc- the page allocator maintainer (Vlastimil) on a
> series that is fundamentally changing the page allocator. That's not going
> to help with feedback.

Right! Thanks a lot for adding me, Lorenzo.

> In general, this area of the page allocator and compaction isn't my
> specialism in the kernel so I can't give you the in-depth feedback you need
> on that.
> 
> But I do have thoughts in general as to how to achieve what you want here:
> 
> Firstly - you should try to summarise what you're doing here and what
> you're changing alongside the trade-offs as clearly as you can in the cover
> letter.
> 
> Then highlight what it is you need feedback on, broken out into clear
> questions or points that make it easy for people to respond to.

Yep.

> And _you have already done this_ in your reply here:
> 
> * "How do people feel about splitting up the free lists, so each gigabyte
>    (well, PUD sized) chunk of memory has its own free lists?"

My immediate response is that now we'd need to search multiple sets of lists
instead of a single one? What about the overhead?

Having a POC (even vibe-coded) for measuring that overhead might be actually
useful to quickly figure out whether the idea is viable or not.

But then the code doesn't need to be sent as a huge series if it's not for
review. As Lorenzo said, git repo link is enough.

> * "How can we balance the desire for higher-order kernel allocations,
>   against the desire to preserve gigabyte sized chunks of memory that can
>   be used for user space?"
> 
> * "How do we balance the desire to keep compaction overhead low with the
>    desire to do higher order allocations almost everywhere?"

How can we have a cake and eat it too? :)

> I think a really good way of doing this would be to start out with
> something like:
> 
> 	Right now compaction often fails to achieve what we need, with
> 	fragmentation occurring anyway and (for instance) THP stalling on
> 	the availability of higher order folios.
> 
> etc. etc.
> 
> Summarising _the problem_.
> 
> Then a section about your proposed solution, e.g.:
> 
> 	I propose a means by which we proactively achieve gigabyte-sized
> 	pageblocks with logic which maintains these as physically
> 	contiguous under both ordinary and contended workloads
> 
> Then list out the "secret sauce" of your approach, e.g.:
> 
> 	This works by arranging memory such that unmovable allocations are
> 	grouped at <blah blah blah> etc.
> 
> Then raise your questions e.g.:
> 
> 	I'd like to ask the community - how do people feel about splitting
> 	up the free lists, so each gigabyte (well, PUD sized) chunk of
> 	memory has its own free lists? <etc. etc.>
> 
> Then make it clear whether this is an RFC that is ready for primetime or
> not:
> 
> 	This series is simply intended as a proof-of-concept - PLEASE DO
> 	NOT REVIEW THE CODE per-se, but rather comment on the concepts!
> 
> (And obviously as above, if that _is_ what you intend, underline it with
> [DO NOT MERGE] or [pre-RFC] or something like that).

Ack.

> I'd also very strongly suggest (as I did in my original reply) breaking out
> parts that can be broken out as prerequisite series.
> 
> If you're doing something good or useful _anyway_ then just send that
> separately first, and have later work rely on the earlier work.

Ack.

> There's no rush, this is huge and will take time.
> 
> A final KEY point:
> 
> NEVER submit unfiltered code generated by an LLMs to the list in _any_
> form. If you want people to access code like that to test or something,
> then put it in a remote repo and link to it.
> 
> The code is SO overly complicated and SO messy that it's really difficult
> for people to understand what's actually going on.
> 
> At the heart of what you need here is CLARITY.
> 
> You need to CLEARLY communicate what it is you're doing so busy maintainers
> can examine it. That's the _only_ way you're going to get something like
> this merged.
> 
> The LLM-generated code is so awful that ain't nobody got the time to try to
> understand what it's doing.

Indeed.

> The workload for this really has to be on submitters, not maintainers.
> 
> And what you've done, even if not intended, is workslopping, and that's
> really not acceptable. Quoting the kernel process on tool-generated content
> [6]:
> 
> "If tools permit you to generate a contribution automatically, expect
> additional scrutiny in proportion to how much of it was generated.
> 
> As with the output of any tooling, the result may be incorrect or
> inappropriate. You are expected to understand and to be able to defend
> everything you submit. If you are unable to do so, then do not submit the
> resulting changes.
> 
> If you do so anyway, maintainers are entitled to reject your series without
> detailed review."
> 
> As per this and my previous reply, AI slop doesn't scale, even as an RFC -
> I won't have time to reply like this in future, and we will just have to
> reject your series out of hand, which helps nobody.

True. Thanks a lot for going out of your way on this!

>>
>>
>> --
>> All Rights Reversed.
> 
> Thanks, Lorenzo
> 
> [0]:https://lore.kernel.org/all/20260520150018.2491267-41-riel@surriel.com/
> [1]:https://lore.kernel.org/linux-mm/20260616190300.1509639-1-riel@surriel.com/
> [2]:https://lore.kernel.org/all/20260526140204.1390573-1-usama.arif@linux.dev/
> [3]:https://lore.kernel.org/all/2ecf71858845e7d14c718b1a6845389cb78b986e.camel@surriel.com/
> [4]:https://lore.kernel.org/all/20260520174749.GA1458531@zen.localdomain/
> [5]:https://lore.kernel.org/all/daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com/
> [6]:https://docs.kernel.org/process/generated-content.html

