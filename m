Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34299 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbcKOM1C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 07:27:02 -0500
Received: by mail-it0-f68.google.com with SMTP id q124so22125127itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 04:27:01 -0800 (PST)
Subject: Re: Announcing btrfs-dedupe
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
 <20161114211013.GJ21290@hungrycats.org>
Cc: James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
Date: Tue, 15 Nov 2016 07:26:53 -0500
MIME-Version: 1.0
In-Reply-To: <20161114211013.GJ21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-14 16:10, Zygo Blaxell wrote:
> On Mon, Nov 14, 2016 at 02:56:51PM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-11-14 14:51, Zygo Blaxell wrote:
>>> Deduplicating an extent that may might be concurrently modified during the
>>> dedup is a reasonable userspace request.  In the general case there's
>>> no way for userspace to ensure that it's not happening.
>> I'm not even talking about the locking, I'm talking about the data
>> comparison that the ioctl does to ensure they are the same before
>> deduplicating them, and specifically that protecting against userspace just
>> passing in two random extents that happen to be the same size but not
>> contain the same data (because deduplication _should_ reject such a
>> situation, that's what the clone ioctl is for).
>
> If I'm deduping a VM image, and the virtual host is writing to said image
> (which is likely since an incremental dedup will be intentionally doing
> dedup over recently active data sets), the extent I just compared in
> userspace might be different by the time the kernel sees it.
>
> This is an important reason why the whole lock/read/compare/replace step
> is an atomic operation from userspace's PoV.
>
> The read also saves having to confirm a short/weak hash isn't a collision.
> The RAM savings from using weak hashes (~48 bits) are a huge performance
> win.
>
> The locking overhead is very small compared to the reading overhead,
> and (in the absence of bugs) it will only block concurrent writes to the
> same offset range in the src/dst inodes (based on a read of the code...I
> don't know if there's also an inode-level or backref-level barrier that
> expands the locking scope).
I'm not arguing that it's a bad thing that the kernel is doing this, I'm 
just saying that the locking overhead is minuscule in most cases 
compared to the data comparison.  It is absolutely necessary for exactly 
the reasons you are outlining.
>
> I'm not sure the ioctl is well designed for simply throwing random
> data at it, especially not entire files (it can't handle files over
> 16MB anyway).  It will read more data than it has to compared to a
> block-by-block comparison from userspace with prefetches or a pair of
> IO threads.  If userspace reads both copies of the data just before
> issuing the extent-same call, the kernel will read the data from cache
> reasonably quickly.
It still depends on the use case to a certain extent.  In the case I was 
using as an example, I know to a reasonably certain degree (barring 
tampering, bugs, or hardware failure) that any two files are identical, 
and I actually don't want to trash the page-cache just to deduplicate 
data faster (he data set in question is large, but most of it is idle at 
any given point in time), so there's no point in me prereading 
everything in userspace, which in turn makes the script I use much 
simpler (the most complex part is figuring out how to split extents for 
files bigger than the ioctl can handle such that I don't have tiny tail 
extents but still have a minimum number per file).
>
>> The locking is perfectly reasonable and shouldn't contribute that much to
>> the overhead (unless you're being crazy and deduplicating thousands of tiny
>> blocks of data).
>
> Why is deduplicating thousands of blocks of data crazy?  I already
> deduplicate four orders of magnitude more than that per week.
You missed the 'tiny' quantifier.  I'm talking really small blocks, on 
the order of less than 64k (so, IOW, stuff that's not much bigger than a 
few filesystem blocks), and that is somewhat crazy because it ends up 
not only taking _really_ long to do compared to larger chunks (because 
you're running more independent hashes than with bigger blocks), but 
also because it will often split extents unnecessarily and contribute to 
fragmentation, which will lead to all kinds of other performance 
problems on the FS.
