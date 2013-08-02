Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50360 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3HBFCe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 01:02:34 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi8so158970wib.5
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 22:02:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$4a6c0$5f5b3ad0$c61266cc$feaf3eba@cox.net>
References: <pan$4a6c0$5f5b3ad0$c61266cc$feaf3eba@cox.net>
Date: Fri, 2 Aug 2013 01:02:32 -0400
Message-ID: <CAPs0Bihgip2L9qGrtqnUMozRHtDraCW-qyHXGV3eQsYwwpPVBQ@mail.gmail.com>
Subject: Re: filefrag and btrfs filesystem defragment and maybe snapshots
From: Sandy McArthur <sandymac@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 1, 2013 at 10:27 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Sandy McArthur posted on Thu, 01 Aug 2013 17:18:50 -0400 as excerpted:
>
>> While exploring some btrfs maintenance with respect to defragmenting I
>> ran the following commands:
>>
>> # filefrag /path/to/34G.file /path/to/5.7G.file
>> /path/to/34G.file: 2406 extents found
>> /path/to/5.7G.file: 572 extents found
>>
>> Thinking those mostly static files could be less fragmented I ran:
>> # btrfs filesystem defragment -c /path/to/34G.file
>> # btrfs filesystem defragment -c /path/to/5.7G.file
>>
>> and to my surprise the number of fragments/extends doubled:
>>
>> # filefrag /path/to/34G.file /path/to/5.7G.file
>> /path/to/34G.file: 6324 extents found
>> /path/to/5.7G.file: 1079 extents found
>>
>> Did I actually improve these files?
>>
>> I do have a number rolling readonly snapshots on the subvolume these
>> files are on. I can imagine how that might be related but I'm not sure.
>> When the pre-defrag snapshots are purged will the filefrag extents count
>> drop.
>
> I can't answer the snapshot angle, but do you have btrfs compression
> turned on?  I've read that filefrag always sees btrfs compressed files of
> sufficient size as fragmented, due to the way btrfs compression works.

Compress at the mount options is not enabled. The '-c' in the defrag
command is to attempt compression during the defrag process.

I found that `btrfs filesystem defragment -c /path/to/5.7G.file` (with
compression) take a while every time you run it repeatedly. Presumably
to re-compress the file each time. But `btrfs filesystem defragment
/path/to/5.7G.file` (without compression) will return instantly after
the first defrag suggesting it knows when to avoid unnecessary work.


I also observed compression does increase filefrag extents count. I
think snapshots can keep the filefrag extents count high:

# filefrag /path/to/5.7G.file
/path/to/5.7G.file: 1173 extents found

# btrfs subvolume delete /path/to/.snapshots/*
Delete subvolume '/path/to/.snapshots/2013....'
[...]

# filefrag /path/to/5.7G.file
/path/to/5.7G.file: 556 extents found

Purging the old snapshots above reduced extents count.


# btrfs filesystem defragment -c /path/to/5.7G.file
# filefrag /path/to/5.7G.file
/path/to/5.7G.file: 1260 extents found

Compressing the file "increases" extents count.


# btrfs filesystem defragment /path/to/5.7G.file
# filefrag /path/to/5.7G.file
/path/to/5.7G.file: 597 extents found

Uncompressing file lowers extents count.

# /snapshop-script.sh
# filefrag /path/to/5.7G.file
/path/to/5.7G.file: 597 extents found

Taking a snapshot didn't directly increase the extents count.

I don't know how to intentionally fragment a file to test other
permutations of snapshots and defrag behavior.

-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
