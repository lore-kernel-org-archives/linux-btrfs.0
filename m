Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35390 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcCIVnD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:43:03 -0500
Received: by mail-io0-f175.google.com with SMTP id g203so82940893iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 13:43:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160310023627.2e915667@natsu>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
Date: Wed, 9 Mar 2016 14:43:01 -0700
Message-ID: <CAJCQCtQ-0KqCmfeV9n7VMnvFvN=K3uEhGsSJKMeHwTxjz3to6Q@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Chris Murphy <lists@colorremedies.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 9, 2016 at 2:36 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 9 Mar 2016 15:25:19 -0500
> Nicholas D Steeves <nsteeves@gmail.com> wrote:
>
>> grr.  Gmail is terrible :-/
>>
>> I understood that a btrfs RAID1 would at best grab one block from sdb
>> and then one block from sdd in round-robin fashion, or at worse grab
>> one chunk from sdb and then one chunk from sdd.  Alternatively I
>> thought that it might read from both simultaneously, to make sure that
>> all data matches, while at the same time providing single-disk
>> performance.  None of these was the case.  Running a single
>> IO-intensive process reads from a single drive.
>
> No RAID1 implementation reads from disks in a round-robin fashion, as that
> would give terrible performance giving disks a constant seek load instead of
> the normal linear read scenario.
>
> As for reading at the same time, there's no reason to do that either, since
> the data integrity is protected by checksums, and "the other" disk for a
> particular data piece is being consulted only in case the checksum did not
> match (or when you execute a 'scrub').
>
> It's a known limitation that the disks are in effect "pinned" to running
> processes, based on their process ID. One process reads from the same disk,
> from the point it started and until it terminates. Other processes by luck may
> read from a different disk, thus achieving load balancing. Or they may not,
> and you will have contention with the other disk idling. This is unlike MD
> RAID1, which knows to distribute read load dynamically to the least-utilized
> array members.

This is a better qualification than my answer.


>
> Now if you want to do some more performance evaluation, check with your dstat
> if both disks happen to *write* data in parallel, when you write to the array,
> as ideally they should. Last I checked they mostly didn't, and this almost
> halved write performance on a Btrfs RAID1 compared to a single disk.

I've found it to be about the same or slightly less than single disk.
But most of my writes to raid1 are btrfs receive.


-- 
Chris Murphy
