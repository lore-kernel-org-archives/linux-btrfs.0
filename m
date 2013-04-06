Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163080Ab3DFAez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 20:34:55 -0400
Message-ID: <515F6DAA.60903@redhat.com>
Date: Fri, 05 Apr 2013 19:34:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How are userspace & kernelspace kept in sync?
References: <515F54D8.4050903@redhat.com> <20130406002027.GS1876@localhost.localdomain>
In-Reply-To: <20130406002027.GS1876@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/5/13 7:20 PM, Josef Bacik wrote:
> On Fri, Apr 05, 2013 at 04:48:56PM -0600, Eric Sandeen wrote:
>> One thing led to another in poking around the code, and I realized
>> that while userspace has lots of code copied from the kernel, it
>> was last copied in 2008, in many cases.  ;)
>>
>> What's the plan here, how are userspace & kernelspace to be kept
>> in sync?
>>
>> New features fairly obviously hit both, but what about bugfixes
>> that hit one codebase or the other?
>>
>> Is it clear (to anyone) which code needs to be synced?
>>
>> Should it be done as a wholesale sync-up/rebase from time to
>> time, or should commits be merged from one to the other?
>>
> 
> So having just had to bring back part of the free space cache code I'd say we
> just cherry pick stuff since it is a huge pain to just copy it over, especially
> when you start talking about the extent buffer stuff.  If maybe we could
> seperate out the really kernel specific stuff (like the stuff that does the
> reading/writing or interfaces with vfs) and the btrfs specific stuff then maybe
> it would be good to keep them in sync.  But honestly I think the core stuff is
> pretty solid right now so cherry-picking is probably our better bet.  Thanks,

Some of it is just different style, but there seem to be
some functional differences as well.

>From some spot-checking, I found a few things that were kind of uh, what?

Like comparing:

commit 95d3f20b51e9b2ee21822313ad4f31279396407b
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri May 29 16:35:30 2009 -0400
Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)

commit 5d4f98a28c7d334091c1b7744f48a1acdd2a4ae0
Author: Yan Zheng <zheng.yan@oracle.com>
Date:   Wed Jun 10 10:45:14 2009 -0400
Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)

had differences like:

convert_extent_item_v0, from userspace to kernelspace:

-       ret = btrfs_search_slot(trans, root, &key, path, new_size, 1);
+       ret = btrfs_search_slot(trans, root, &key, path,
+                               new_size + extra_size, 1);

Either that's incredibly subtle and undocumented, or just wrong
in one case or the other?

I mean, this is just one thing.  Seems like a plan to keep it
in sync is warranted, maybe keeping the kernel copies in
separate files, so diffs make some semblance of sense?

I dunno, I just worry about long-term maintainability of it
all.

-Eric



> Josef 
> 

