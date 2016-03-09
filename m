Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37415 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcCIWvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 17:51:36 -0500
Received: by mail-wm0-f49.google.com with SMTP id p65so5812516wmp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 14:51:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtShrmtnO-d3u+jnFOWqct5QQ0oKErJpDeC+0pw-XiECBA@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<CAJCQCtShrmtnO-d3u+jnFOWqct5QQ0oKErJpDeC+0pw-XiECBA@mail.gmail.com>
Date: Wed, 9 Mar 2016 17:51:34 -0500
Message-ID: <CAD=QJKgtjgJoH2=d2i2OhK2YD8eWyCeAfX36B04-G33vbW-TXw@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 March 2016 at 16:36, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 9 Mar 2016 15:25:19 -0500
> Nicholas D Steeves <nsteeves@gmail.com> wrote:
>
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

On 9 March 2016 at 16:26, Chris Murphy <lists@colorremedies.com> wrote:
> It's normal and recognized to be sub-optimal. So it's an optimization
> opportunity. :-)
>
> I see parallelization of reads and writes to data single profile
> multiple devices as useful also, similar to XFS allocation group
> parallelization. Those AGs are spread across multiple devices in
> md/lvm linear layouts, so if you have processes that read/write to
> multiple AGs at a time, those I/Os happen at the same time when on
> separate devices.

Chris, yes, that's exactly how I thought that it would work.  Roman,
when I said round-robin--please forgive my naïvité--I meant hoped
there would be a chunk A1 from disk0 read at the same time as chunk A2
from disk1.  Can you use the btree associated with chunk A1 to put
disk B to work readingahead, but searching the btree associated with
chunk A1?  Then, when disk0 finishes reading A1 into memory, A2 gets
contatinated.

If disk0 is finishes reading chunk A1, change the primary read disk
for PID to disk1 and let reading A2 continue, and put disk0 to work
using the same method as disk1 was previously, but on chunk A3.  Else,
if disk1 reading A2 finishes before disk0 finishes A1, then disk0
remains the primary read disk for PID and disk1 begins reading A3.

That's how I thought that it would work, and that the scheduler could
interrupt the readahead operation for non-primary disk.  Eg: disk1
would becoming primary reading disk for PID2, where disk0 would
continue as primary for PID1.  And if there's a long queue of reads or
writes then this simplest-case would be limited in the following way:
disk0 and disk1 never actually get to read or write to the same chunk
<- Is this the explanation why, for practical reasons, dstat shows the
behaviour it shows?

If this is the case, would it be possible for the non-primary read
disk for PID1 to tag the A[x] chunk it wrote to memory with a request
for the PID to use what it wrote to memory from A[x]?  And also for
the "primary" disk to resume from location y in A[x] instead beginning
from scratch with A[x]?  Roman, in this case, the seeks would be
time-saving, no?

Unfortunately, I don't know how to implement this, but I had imagined
that the btree for a directory contained pointers (I'm using this term
loosely rather than programically) to all extents associated with all
files contained underneath it.  Or does it point to the chunk, which
then points to the extent?  At any rate, is this similar to the
dir_index of ext4, and is this the method btrfs uses?

Best regards,
Nicholas
