Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933599AbeEWPmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:42:02 -0400
Subject: Re: [PATCH 2/2] btrfs: always wait on ordered extents at fsync time
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
References: <20180522174723.13620-1-josef@toxicpanda.com>
 <20180522174723.13620-2-josef@toxicpanda.com>
 <20180523122427.GA6649@twin.jikos.cz>
 <CAEzrpqdWd1173cQNpz11zNAPyyjPwfO32MKDXtiSYg6KRzvSmQ@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fd978f4f-7ad8-af98-0122-c38a9b1e0888@suse.com>
Date: Wed, 23 May 2018 18:41:58 +0300
MIME-Version: 1.0
In-Reply-To: <CAEzrpqdWd1173cQNpz11zNAPyyjPwfO32MKDXtiSYg6KRzvSmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 18:38, Josef Bacik wrote:
> It's just removing all of the code that is no longer needed with the
> unconditional wait_ordered_extents, it's not that complicated.

Just because something is painfully obvious to you doesn't mean it's the
same for others. Especially given the current complexity of fsync code.
Even your 1 sentence reply that you are removing code which is obsoleted
by unconditional wait_ordered_extents is more revealing (albeit frankly
this needs a lot more explanation how the code is intertwined etc...)
than : "Fix this by getting rid of all of the logged extents magic and
simply wait on ordered extent before we star the tree log stuff"

> Thanks,
> 
> Josef
> 
> On Wed, May 23, 2018 at 8:24 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Tue, May 22, 2018 at 01:47:23PM -0400, Josef Bacik wrote:
>>> From: Josef Bacik <jbacik@fb.com>
>>>
>>> There's a priority inversion that exists currently with btrfs fsync.  In
>>> some cases we will collect outstanding ordered extents onto a list and
>>> only wait on them at the very last second.  However this "very last
>>> second" falls inside of a transaction handle, so if we are in a lower
>>> priority cgroup we can end up holding the transaction open for longer
>>> than needed, so if a high priority cgroup is also trying to fsync()
>>> it'll see latency.
>>>
>>> Fix this by getting rid of all of the logged extents magic and simply
>>> wait on ordered extent before we star the tree log stuff.  This code has
>>> changed a lot since I first wrote it and really isn't the performance
>>> win it was originally because of the things we had to do around getting
>>> the right checksums.  Killing all of this makes our lives easier and
>>> gets rid of the priority inversion.
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>>> ---
>>>  fs/btrfs/file.c              |  56 ++-------------
>>>  fs/btrfs/ordered-data.c      | 123 --------------------------------
>>>  fs/btrfs/ordered-data.h      |  20 +-----
>>>  fs/btrfs/tree-log.c          | 166 ++++---------------------------------------
>>>  include/trace/events/btrfs.h |   1 -
>>>  5 files changed, 19 insertions(+), 347 deletions(-)
>>
>> Seriously. Just by the diffstat, this patch is going to bring more
>> problems than it's supposed to solve. Please split it into reviewable
>> pieces and write less vague changelogs so also other people can
>> understand and review the actual changes made to the code. Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
