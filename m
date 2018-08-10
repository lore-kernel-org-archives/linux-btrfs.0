Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:39317 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeHJOJH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 10:09:07 -0400
Received: by mail-it0-f66.google.com with SMTP id g141-v6so2197524ita.4
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 04:39:34 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a4719dd3-fae9-c81c-8f51-f59fceda14ba@gmail.com>
Date: Fri, 10 Aug 2018 07:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <20180809174811.GA27001@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-09 13:48, Tomasz Pala wrote:
> On Tue, Jul 31, 2018 at 22:32:07 +0800, Qu Wenruo wrote:
> 
>> 2) Different limitations on exclusive/shared bytes
>>     Btrfs can set different limit on exclusive/shared bytes, further
>>     complicating the problem.
>>
>> 3) Btrfs quota only accounts data/metadata used by the subvolume
>>     It lacks all the shared trees (mentioned below), and in fact such
>>     shared tree can be pretty large (especially for extent tree and csum
>>     tree).
> 
> I'm not sure about the implications, but just to clarify some things:
> 
> when limiting somebody's data space we usually don't care about the
> underlying "savings" coming from any deduplicating technique - these are
> purely bonuses for system owner, so he could do larger resource overbooking.
> 
> So - the limit set on any user should enforce maximum and absolute space
> he has allocated, including the shared stuff. I could even imagine that
> creating a snapshot might immediately "eat" the available quota. In a
> way, that quota returned matches (give or take) `du` reported usage,
> unless "do not account reflinks withing single qgroup" was easy to implemet.
> 
> I.e.: every shared segment should be accounted within quota (at least once).
I think what you mean to say here is that every shared extent should be 
accounted to quotas for every location it is reflinked from.  IOW, that 
if an extent is shared between two subvolumes each with it's own quota, 
they should both have it accounted against their quota.
> 
> And the numbers accounted should reflect the uncompressed sizes.
This is actually inconsistent with pretty much every other VFS level 
quota system in existence.  Even ZFS does it's accounting _after_ 
compression.  At this point, it's actually expected by most sysadmins 
that things behave that way.
> 
> 
> Moreover - if there would be per-subvolume RAID levels someday, the data
> should be accouted in relation to "default" (filesystem) RAID level,
> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
> data, and twice the data in an opposite scenario (like "dup" profile on
> single-drive filesystem).
This is irrelevant to your point here.  In fact, it goes against it, 
you're arguing for quotas to report data like `du`, but all of 
chunk-profile stuff is invisible to `du` (and everything else in 
userspace that doesn't look through BTRFS ioctls).
> 
> 
> In short: values representing quotas are user-oriented ("the numbers one
> bought"), not storage-oriented ("the numbers they actually occupy").
