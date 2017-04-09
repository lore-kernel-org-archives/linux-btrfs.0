Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48064 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdDIUPV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 16:15:21 -0400
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Chris Murphy <lists@colorremedies.com>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <CAJCQCtScqmKRHZpv3aaN8DjSFU0My4sjsvr=_c9Ch7BOfc3wVw@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <9d228917-1095-9ba0-62ed-ea214b6790e1@mendix.com>
Date: Sun, 9 Apr 2017 22:15:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtScqmKRHZpv3aaN8DjSFU0My4sjsvr=_c9Ch7BOfc3wVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2017 08:10 PM, Chris Murphy wrote:
> On Sat, Apr 8, 2017 at 2:19 PM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> After changing to nossd, another thing happened. The expiry process,
>> which normally takes about 1.5 hour to remove ~2500 subvolumes (keeping
>> it queued up to a 100 orphans all the time), suddenly took the entire
>> rest of the day, not being done before the nightly backups had to start
>> again at 10PM...
> 
> Is this 'btrfs sub del' with 100 subvolumes listed? What happens if
> the delete command is issued with all 2500 at once? Deleting snapshots
> is definitely expensive, and deleting them one at a time is more
> expensive in total time than deleting them in one whack. But I've
> never deleted 100 or more at once.

It doesn't really matter how many, because it stil cleans only one at a
time, in the order that they were submitted.

(And this also means that if you delete 1000 snapshots of the same huge
subvolume, it will do all the inefficient backref walking 1000 times etc.)

Doing a subvolume delete (or multiple) on the command line will only
append them to this list, besides removing some tree items so that it's
not visible anymore as normal subvolume. The list of subvolume ids
queued for cleaning can be found in tree 1 with keys of
(ORPHAN_OBJECTID, ORPHAN_ITEM_KEY, <subvolid>)

The 100 is a bit of an arbitrarily chosen number that makes sure it'll
be working full speed all the time, and also give me a somewhat
acceptable time to wait for finishing when interrupting it.

Here's some more and a snippet of example code (at the end of the commit
message) which looks almost 100% like what I have in my backup expiry code:

https://github.com/knorrie/python-btrfs/commit/9d697ba7d4782afbb070bf057aa4ff3e3aa51be0

-- 
Hans van Kranenburg
