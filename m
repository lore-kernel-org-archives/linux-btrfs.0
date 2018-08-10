Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:60372 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbeHJUwQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 16:52:16 -0400
Date: Fri, 10 Aug 2018 20:21:16 +0200
From: Tomasz Pala <gotar@polanet.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes
 with quota
Message-ID: <20180810182115.GA922@polanet.pl>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <a4719dd3-fae9-c81c-8f51-f59fceda14ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <a4719dd3-fae9-c81c-8f51-f59fceda14ba@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 07:39:30 -0400, Austin S. Hemmelgarn wrote:

>> I.e.: every shared segment should be accounted within quota (at least once).
> I think what you mean to say here is that every shared extent should be 
> accounted to quotas for every location it is reflinked from.  IOW, that 
> if an extent is shared between two subvolumes each with it's own quota, 
> they should both have it accounted against their quota.

Yes.

>> Moreover - if there would be per-subvolume RAID levels someday, the data
>> should be accouted in relation to "default" (filesystem) RAID level,
>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>> data, and twice the data in an opposite scenario (like "dup" profile on
>> single-drive filesystem).
>
> This is irrelevant to your point here.  In fact, it goes against it, 
> you're arguing for quotas to report data like `du`, but all of 
> chunk-profile stuff is invisible to `du` (and everything else in 
> userspace that doesn't look through BTRFS ioctls).

My point is user-point, not some system tool like du. Consider this:
1. user wants higher (than default) protection of some data,
2. user wants more storage space with less protection.

Ad. 1 - requesting better redundancy is similar to cp --reflink=never
- there are functional differences, but the cost is similar: trading
  space for security,

Ad. 2 - many would like to have .cache, .ccache, tmp or some build
system directory with faster writes and no redundancy at all. This
requires per-file/directory data profile attrs though.

Since we agreed that transparent data compression is user's storage bonus,
gains from the reduced redundancy should also profit user.


Disclaimer: all the above statements in relation to conception and
understanding of quotas, not to be confused with qgroups.

-- 
Tomasz Pala <gotar@pld-linux.org>
