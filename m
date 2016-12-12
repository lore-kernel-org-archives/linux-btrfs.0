Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752356AbcLLSBF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 13:01:05 -0500
Date: Mon, 12 Dec 2016 19:00:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix disable backtrace assert error
Message-ID: <20161212180059.GZ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161207012944.10545-1-quwenruo@cn.fujitsu.com>
 <05213ee7-ecb9-8171-d4b3-eec45204ff25@suse.de>
 <2a57f567-8c04-0050-f319-c85a69061dd1@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2a57f567-8c04-0050-f319-c85a69061dd1@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 08:18:44AM +0800, Qu Wenruo wrote:
> > On 12/06/2016 07:29 PM, Qu Wenruo wrote:
> >> Due to commit 00e769d04c2c83029d6c71(btrfs-progs: Correct value printed
> >> by assertions/BUG_ON/WARN_ON), which changed the assert_trace()
> >> parameter, the condition passed to assert/WARN_ON/BUG_ON are logical
> >> notted for backtrace enabled and disabled case.
> >>
> >> Such behavior makes us easier to pass value wrong, and in fact it did
> >> cause us to pass wrong condition for ASSERT().
> >>
> >> Instead of passing different conditions for ASSERT/WARN_ON/BUG_ON()
> >> manually, this patch will use BUG_ON() to implement the resting
> >> ASSERT/WARN_ON/BUG(), so we don't need to pass 3 different conditions
> >> but only one.
> >>
> >> And to further info the review for the fact that the condition should be
> >> different, rename "assert_trace" to "bugon_trace", as unlike assert, we
> >> will only trigger the bug when condition is true.
> >>
> >> Also, move WARN_ON() out of the ifdef branch, as it's completely the
> >> same for both branches.
> >>
> >> Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >> ---
> >>  kerncompat.h | 19 +++++++++++--------
> >>  1 file changed, 11 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/kerncompat.h b/kerncompat.h
> >> index e374614..be77608 100644
> >> --- a/kerncompat.h
> >> +++ b/kerncompat.h
> >> @@ -277,7 +277,7 @@ static inline long IS_ERR(const void *ptr)
> >>  #define vfree(x) free(x)
> >>
> >>  #ifndef BTRFS_DISABLE_BACKTRACE
> >> -static inline void assert_trace(const char *assertion, const char *filename,
> >> +static inline void bugon_trace(const char *assertion, const char *filename,
> >>  			      const char *func, unsigned line, long val)
> >>  {
> >>  	if (!val)
> >
> > To keep confusion to the minimum, you can call this *condition instead
> > of *assertion.
> 
> Right, I'll update it.
> 
> >
> >> @@ -287,17 +287,20 @@ static inline void assert_trace(const char *assertion, const char *filename,
> >>  	exit(1);
> >>  }
> >>
> >> -#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> >> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> >> -#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
> >> -#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
> >> +#define BUG_ON(c) bugon_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> >>  #else
> >>  #define BUG_ON(c) assert(!(c))
> >> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> >> -#define ASSERT(c) assert(!(c))
> >> -#define BUG() assert(0)
> >>  #endif
> >>
> >> +#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> >> +/*
> >> + * TODO: ASSERT() should be depercated. In case like ASSERT(ret == 0), it
> >> + * won't output any useful value for ret.
> >> + * Should be replaced by BUG_ON(ret);
> >> + */
> >> +#define	ASSERT(c) BUG_ON(!(c))
> >
> > I am not sure of this. As you are stating, this (double negation) will
> > kill the value of the condition. Won't it be better to remove all
> > ASSERTs first instead of putting this TODO?
> 
> IIRC the ASSERT/BUG_ON will be removed step by step.
> And we have about 60+ ASSERT in current code base, not an easy thing to 
> fix soon.
> 
> So I prefer to mark ASSERT() deprecated and remove them in later cleanups.

But asserts have their meaning. We want to get rid of BUG_ON that are
abused for error not-handling. The asserts eg. catch programmer errors
like incorrect combinations of function parameters, "explicit checks for
implicit assumptions", and other "never happens" conditions.  Anything
that depends on external output must not be hadled via assert/bug_on.
I have some write ups in progress about the coding conventions, will be
put to git once it's more or less complete, so we're all on the same
page.
