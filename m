Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:40145 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbeHJVTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 17:19:24 -0400
Received: by mail-io0-f172.google.com with SMTP id l14-v6so8488225iob.7
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 11:48:19 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <a4719dd3-fae9-c81c-8f51-f59fceda14ba@gmail.com>
 <20180810182115.GA922@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5b00bed1-44cd-8b63-e720-85995e91feae@gmail.com>
Date: Fri, 10 Aug 2018 14:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <20180810182115.GA922@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-10 14:21, Tomasz Pala wrote:
> On Fri, Aug 10, 2018 at 07:39:30 -0400, Austin S. Hemmelgarn wrote:
> 
>>> I.e.: every shared segment should be accounted within quota (at least once).
>> I think what you mean to say here is that every shared extent should be
>> accounted to quotas for every location it is reflinked from.  IOW, that
>> if an extent is shared between two subvolumes each with it's own quota,
>> they should both have it accounted against their quota.
> 
> Yes.
> 
>>> Moreover - if there would be per-subvolume RAID levels someday, the data
>>> should be accouted in relation to "default" (filesystem) RAID level,
>>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>>> data, and twice the data in an opposite scenario (like "dup" profile on
>>> single-drive filesystem).
>>
>> This is irrelevant to your point here.  In fact, it goes against it,
>> you're arguing for quotas to report data like `du`, but all of
>> chunk-profile stuff is invisible to `du` (and everything else in
>> userspace that doesn't look through BTRFS ioctls).
> 
> My point is user-point, not some system tool like du. Consider this:
> 1. user wants higher (than default) protection of some data,
> 2. user wants more storage space with less protection.
> 
> Ad. 1 - requesting better redundancy is similar to cp --reflink=never
> - there are functional differences, but the cost is similar: trading
>    space for security,
> 
> Ad. 2 - many would like to have .cache, .ccache, tmp or some build
> system directory with faster writes and no redundancy at all. This
> requires per-file/directory data profile attrs though.
> 
> Since we agreed that transparent data compression is user's storage bonus,
> gains from the reduced redundancy should also profit user.
Do you actually know of any services that do this though?  I mean, 
Amazon S3 and similar services have the option of reduced redundancy 
(and other alternate storage tiers), but they charge 
per-unit-data-per-unit-time with no hard limit on how much space they 
use, and charge different rates for different storage tiers.  In 
comparison, what you appear to be talking about is something more 
similar to Dropbox or Google Drive, where you pay up front for a fixed 
amount of storage for a fixed amount of time and can't use more than 
that, and all the services I know of like that offer exactly one option 
for storage redundancy.

That aside, you seem to be overthinking this.  No sane provider is going 
to give their users the ability to create subvolumes themselves (there's 
too much opportunity for a tiny bug in your software to cost you a _lot_ 
of lost revenue, because creating subvolumes can let you escape qgroups) 
  That means in turn that what you're trying to argue for is no 
different from the provider just selling units of storage for different 
redundancy levels separately, and charging different rates for each of 
them.  In fact, that approach is better, because it works independent of 
the underlying storage technology (it will work with hardware RAID, 
LVM2, MD, ZFS, and even distributed storage platforms like Ceph and 
Gluster), _and_ it lets them charge differently than the trivial case of 
N copies costing N times as much as one copy (which is not quite 
accurate in terms of actual management costs).

Now, if BTRFS were to have the ability to set profiles per-file, then 
this might be useful, albeit with the option to tune how it gets accounted.
> 
> Disclaimer: all the above statements in relation to conception and
> understanding of quotas, not to be confused with qgroups.
> 
