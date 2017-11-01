Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51272 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdKAAca (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 20:32:30 -0400
Subject: Re: Data and metadata extent allocators [1/2]: Recap: The data story
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
 <6296fd2d-87a3-7f59-2b4b-48e3e40d3593@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <61c7cd9c-3d35-d292-fc35-cf0fb714f731@mendix.com>
Date: Wed, 1 Nov 2017 01:32:25 +0100
MIME-Version: 1.0
In-Reply-To: <6296fd2d-87a3-7f59-2b4b-48e3e40d3593@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2017 02:12 AM, Qu Wenruo wrote:
> 
> On 2017年10月28日 02:17, Hans van Kranenburg wrote:
>> Hi,
>>
>> This is a followup to my previous threads named "About free space
>> fragmentation, metadata write amplification and (no)ssd" [0] and
>> "Experiences with metadata balance/convert" [1], exploring how good or
>> bad btrfs can handle filesystems that are larger than your average
>> desktop computer and/or which see a pattern of writing and deleting huge
>> amounts of files of wildly varying sizes all the time.
>>
>> This message is a summary of the earlier posts. So, for whoever followed
>> the story, only boring old news here. In the next message as a reply on
>> this one, I'll add some thoughts about new adventures with metadata
>> during the last weeks.
>>
>> My use case is using btrfs as filesystem for backup servers, which work
>> with collections of subvolumes/snapshots with related data, and add new
>> data and expire old snapshots daily.
>>
>> Until now, the following questions were already answered:
>>
>> Q: Why does the allocated but unused space for data keep growing all the
>> time?
>> A: Because btrfs keeps allocating new raw space for data use, while
>> there's more and more unused space inside already which isn't reused for
>> new data.
> 
> In fact, btrfs data allocator can split its data allocation request, and
> make them fit into smaller blocks.
> 
> For example, for highly fragmented data space (and of course, no
> unallocated space for new chunk), btrfs will use small space in existing
> chunks.

Yes, it will.

> Just as fstests, generic/416.
> 
> But I think it should be done in a more aggressive manner to reduce
> chunk allocation.
> 
> And balance under certain case can be very slow due to the amount of
> snapshots/reflinks, so personally I don't really like the idea of
> balance itself.
> 
> If it can be avoid by extent allocator, we should do it from the very
> beginning.

Well, the most urgent problem in the end is not how the distribution of
data over the data chunks is organized.

It's about this:

>> Q: Why would it crash the file system when all raw space is allocated?
>> Won't it start trying harder to reuse the free space inside?
>> A: Yes, it will, for data. The big problem here is that allocation of a
>> new metadata chunk when needed is not possible any more.

The real problem is that the separate allocation of raw space for data
and metadata might lead to a situation where you can't write any
metadata any more (because it wants to allocate a new chunk) while you
have a lot of data space available.

And to be honest, for the end user this is a very similar experience to
getting an out of space on ext4 while there's a lot of data space
available which makes you find out about the concept of inodes (which
you run out of) and df -i etc... (The difference is that on btrfs, in
most cases you can actually solve it in place. :D) We have no limits on
inodes, but we have a limit on space to store tree blocks... Unallocated
raw space available.

So if we can work around this and prevent it, it will mostly solve the
rest automatically. In theory a filesystem always keeps working as long
as you make sure you have about a GiB unallocated all the time so that
either the next data or metadata chunk can grab it.

I actually right now remember seeing something in the kernel code a
while ago that should make it try harder to push data in existing
allocated space instead of allocating a new data chunk if the
unallocated part was < 3% of total device size. Something like that
might help, only for some reason if the code is still in there it
doesn't actually work it seems.

Having the tetris allocator for data by default helps the situation
(preventing from running with fully allocated space too soon) from
occurring with certain workloads, e.g. by not showing the insane
behaviour like [0].

But, I can also still fill my disk with files and then remove half of
them in a way that leaves me with fully allocated raw space and all
chunks 50% filled. And what is the supposed behaviour if I start to
refill the empty space by metadata-hungry small files with long names again?

[0]
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4

-- 
Hans van Kranenburg
