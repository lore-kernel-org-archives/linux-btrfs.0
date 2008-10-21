From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 14:13:33 +0200
Message-ID: <87vdvmdu36.fsf@basil.nowhere.org>
References: <20081021132322.271ad728.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021132322.271ad728.skraw@ithnet.com> (Stephan von Krawczynski's message of "Tue, 21 Oct 2008 13:23:22 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Stephan von Krawczynski <skraw@ithnet.com> writes:

> reading the list for a while it looks like all kinds of implementational
> topics are covered but no basic user requests or talks are going on. Since I
> have found no other list on vger covering these issues I choose this one,
> forgive my ignorance if it is the wrong place.
> Like many people on the planet we try to handle quite some amounts of data
> (TBs) and try to solve this with several linux-based fileservers.
> Years of (mostly bad) experience led us to the following minimum requirements
> for a new fs on our servers:

If that are the minimum requirements, what are the maximum ones?

Also you realize that some of the requirements (like parallel read/write
aka a full cluster file system) are extremly hard?

Perhaps it would make more sense if you extracted the top 10 items
and ranked them by importance and posted again.

-Andi

-- 
ak@linux.intel.com
