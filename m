Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:33560 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932862AbcILN6d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:58:33 -0400
Received: by mail-it0-f54.google.com with SMTP id x192so3769031itb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 06:58:33 -0700 (PDT)
Subject: Re: btrfs kernel oops on mount
To: Jeff Mahoney <jeffm@suse.com>, moparisthebest <admin@moparisthebest.com>,
        linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
 <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>
 <e03a83f1-1a1e-30f7-379a-47f8de057187@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b0243e96-fe39-94b8-d79c-d7f742541177@gmail.com>
Date: Mon, 12 Sep 2016 09:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <e03a83f1-1a1e-30f7-379a-47f8de057187@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 09:27, Jeff Mahoney wrote:
> On 9/12/16 2:54 PM, Austin S. Hemmelgarn wrote:
>> On 2016-09-12 08:33, Jeff Mahoney wrote:
>>> On 9/9/16 8:47 PM, Austin S. Hemmelgarn wrote:
>>>> A couple of other things to comment about on this:
>>>> 1. 'can_overcommit' (the function that the Arch kernel choked on) is
>>>> from the memory management subsystem.  The fact that that's throwing a
>>>> null pointer says to me either your hardware has issues, or the Arch
>>>> kernel itself has problems (which would probably mean the kernel image
>>>> is corrupted).
>>>
>>> fs/btrfs/extent-tree.c:
>>> static int can_overcommit(struct btrfs_root *root,
>>>                           struct btrfs_space_info *space_info, u64 bytes,
>>>                           enum btrfs_reserve_flush_enum flush)
>>>
>> OK, my bad there, but that begs the question: why does a BTRFS function
>> not have a BTRFS prefix?  The name blatantly sounds like a mm function
>> (and I could have sworn I can across one with an almost identical name
>> when I was trying to understand the mm code a couple months ago), and
>> the lack of a prefix combined with that heavily implies that it's a core
>> kernel function.
>>
>> Given this, it's almost certainly the balance choking on corrupted
>> metadata that's causing the issue.
>
> Because it's a static function and has a namespace limited to the
> current C file.  If we prefixed every function in a local namespace with
> the subsystem, the code would be unreadable.  At any rate, the full
> symbol name in the Oops is:
>
> can_overcommit+0x1e/0x110 [btrfs]
>
> So we do identify the proper namespace in the Oops already.
Which somehow I missed...

Again, apologies for the confusion, I'm not used to reading an OOPS out 
of a picture of a CRT, and less so when trying to get someone help as 
quick as possible.
>
>>>> 3. In general, it's a good idea to keep an eye on space usage on your
>>>> filesystems.  If it's getting to be more than about 95% full, you should
>>>> be looking at getting some more storage space.  This is especially true
>>>> for BTRFS, as a 100% full BTRFS filesystem functionally becomes
>>>> permanently read-only because there's nowhere for the copy-on-write
>>>> updates to write to.
>>>
>>> The entire point of having the global metadata reserve is to avoid that
>>> situation.
>> Except that the global metadata reserve is usually only just barely big
>> enough, and it only works for metadata.  While I get that this issue is
>> what it's supposed to fix, it doesn't do so in a way that makes it easy
>> to get out of that situation.  The reserve itself is often not big
>> enough to do anything in any reasonable amount of time once the FS gets
>> beyond about a hundred GB and yous tart talking about very large files.
>
> Why would it need to apply to data?  The reserve is used to meet the
> reservation requirements to CoW metadata blocks needed to release the
> data blocks.  The data blocks themselves aren't touched; they're only
> released.  The size of the file really should only matter in terms of
> how many extent items need to be released but it shouldn't matter at all
> in terms of how many blocks the file's data occupies.  E.g. a 100 GB
> file that uses a handful of extents would be essentially free in this
> context.
I'm not saying it needs to apply to data, but it would be nice if things 
didn't blow up such that you immediately have to start deleting files or 
add more space when the data chunks become full.

As far as the sizing, I have had multiple times where the largest file 
in the filesystem couldn't be deleted because of the number of extents 
when the rest of the FS was full and GlobalReserve was being used for 
metadata operations (I don't know if it's significant, but I only saw 
this on filesystems with compress=lzo).
