Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37520 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbcHCJF7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 05:05:59 -0400
Received: by mail-it0-f45.google.com with SMTP id f6so225454819ith.0
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Aug 2016 02:05:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <9489e87c-9b54-2808-0d0c-66b80de3920d@cn.fujitsu.com>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com> <CAL3q7H6Wo85Z8KV1m8JNrZALOVO+KhXo8AP2vy3X_XN4BsNySQ@mail.gmail.com>
 <9489e87c-9b54-2808-0d0c-66b80de3920d@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 3 Aug 2016 10:05:13 +0100
Message-ID: <CAL3q7H6jUAT0ReSur_a4SX0mYZ=9w-SF3GPnbjKT8hhu2CRNAg@mail.gmail.com>
Subject: Re: Btrfs send to send out metadata and data separately
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 2, 2016 at 2:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 08/02/2016 02:00 AM, Filipe Manana wrote:
>>
>> On Fri, Jul 29, 2016 at 1:40 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>> Hi Filipe, and maintainers,
>>>
>>> I'm recently working on the root fix to free send from calling backref
>>> walk.
>>>
>>> My current idea is to send data and metadata separately, and only do
>>> clone
>>> detection inside the send subvolume.
>>>
>>> This method needs two new send commands:
>>> (And new send attribute, A_DATA_BYTENR)
>>> 1) SEND_C_DATA
>>>    much like SEND_C_WRITE, with a little change in the 1st TLV.
>>>
>>>    TLVs:
>>>    A_DATA_BYTENR:        bytenr of the data extent
>>>    A_FILE_OFFSET:        offset inside the data extent
>>>    A_DATA:               real data
>>>
>>> 2) SEND_C_CLONE_DATA
>>>    A little like SEND_C_CLONE, with unneeded parameters striped
>>>
>>>    TLVs:
>>>    A_PATH:               filename
>>>    A_DATA_BYTENR:        disk_bytenr of the EXTENT_DATA
>>>    A_FILE_OFFSET:        file offset
>>>    A_FILE_OFFSET:        offset inside the EXTENT_DATA
>>>    A_CLONE_LEN:          num_bytes of the EXTENT_DATA
>>>
>>>
>>> The send part is different in how to sending out a EXTENT_DATA.
>>> The send work follow is:
>>>
>>> 1) Found a EXTENT_DATA to send.
>>>    Check rb_tree of "disk_bytenr".
>>>    if "disk_bytenr" in rb_tree
>>>      goto 2) Reflink data
>>>    /* Initiate a SEND_C_DATA */
>>>    Send out the *whole* *uncompressed* extent of "disk_bytenr".
>>>    Adds "disk_bytenr" into rb_tree
>>>
>>>
>>> 2) Reflink data
>>>    /* Initiate a SEND_C_CLONE_DATA */
>>>    Filling disk_bytenr, offset and num_bytes, and send out the command.
>>>
>>> That's to say, send will send out extent data and referencer separately.
>>>
>>> So for kernel part, it's quite easy and *NO* time consuming backref walk
>>> ever.
>>> And no other part is modified.
>>>
>>>
>>> The main trick happens in the receive part.
>>>
>>> Receive will do the following thing first before recovering the
>>> subvolume/snapshot:
>>>
>>> 0) Create temporary dir for data extents
>>>    Create a new dir with temporary name($data_extent), to put data
>>> extents
>>> into it.
>>>
>>> Then for SEND_C_DATA command:
>>> 1) Create file with file name $filename under $data_extent dir
>>>    filename = $(printf "0x%x" $disk_bytenr)
>>>    $disk_bytenr is the first u64 TLV of SEND_A_DATA command.
>>> 2) Write data into $data_extent/$filename
>>>
>>> Then handle the SEND_C_CLONE_DATA command
>>> It would be like
>>>   xfs_io -f -c "reflink $data_extent/$disk_bytenr $extent_offset
>>>                 $file_offset $num_bytes" $filename
>>> disk_bytenr=2nd TLV (string converted to u64, with "0x%x")
>>> extent_offset=3rd TLV, u64
>>> file_offset=4th TLV, u64
>>> num_bytes=5th TLV, u64
>>> filename=1th TLV, string
>>>
>>> Finally, after the snapshot/subvolume is recovered, remove the
>>> $data_extent
>>> directory.
>>>
>>>
>>> The whole idea is to completely remove the time consuming backref walk in
>>> send.
>>>
>>> So pros:
>>> 1) No backref walk, no soft lockup, no super long execution time
>>>    Under worst case O(N^2), best case O(N)
>>>    Memory usage worst case O(N), best case O(1)
>>>    Where N is the number of reference to extents.
>>>
>>> 2) Almost the same metadata layout
>>>    Including the overlap extents
>>>
>>> Cons:
>>> 1) Not full fs clone detection
>>>    Such clone detection is only inside the send snapshot.
>>>
>>>    For case that one extent is referred only once in the send snapshot,
>>>    but also referred by source subvolume, then in the received
>>>    subvolume, it will be a new extent, but not a clone.
>>>
>>>    Only extent that is referred twice by send snapshot, that extent
>>>    will be shared.
>>>
>>>    (Although much better than disabling the whole clone detection)
>>> 2) Extra space usage
>>>    Since it completely recovers the overlap extents
>>> 3) As many fragments as source subvolume
>>> 4) Possible slow recovery due to reflink speed.
>>>
>>>
>>> I am still concerned about the following problems:
>>>
>>> 1) Is it OK to add not only 1, but 2 new send commands?
>>> 2) Is such clone detection range change OK?
>>>
>>> Any ideas and suggestion is welcomed.
>>
>>
>>
>
> Hi Filipe,
>
> Thanks for your comment, it helps to refine the idea to fix the problem.
>
> New idea is stated at the ending of the mail, hopes it will address all your
> conern.
>
>> Qu,
>>
>> I don't like the idea at all, for several reasons:
>>
>> 1) Too complex to implement. We should really avoid making things more
>> complex than they are already.
>
>
> Yes, new command new TLV new receiver behavior, the whole idea itself is
> complex.
>
> But the core function for clone detection is simple.
> Rb_tree for sent extent bytenr, and avoid sending sent extents.
> At least it avoids doing expensive backref walk at all.
>
> My new idea will keep the core function, while stripe all the new
> command/TLV/receiver behavior.
>
>>    Your earlier suggestion to cache backref lookups is much simpler
>> and solves the problem for the vast majority of cases (assuming a
>> bounded cache of course).
>
>
> In fact, my earlier suggestion is not to cache backref walk result, but just
> like this one, implement a internal, simpler backref mapper.
>
> The biggest problem of backref cache is, it conflicts with snapshot.
> Any snapshot will easily trash backrefs of a tree.
>
> It means either we do a full tree walk to trash all backref cache, making
> snapshot much slower, or a broken cache.
> (And it adds more complexity to the already complex backref walk)
>
>>     There's really no need for such high complexity.
>>
>> 2) By adding new commands to the stream, you break backwards
>> compatibility.
>>    Think about all the tools out there that interpret send streams and
>> not just the receive command (for example snapper).
>>
>> 3) By requiring a new different behaviour for the receiver, suddenly
>> older versions of it will no longer be able to receive from new
>> kernels.
>
>
> That's the real problem, I'd try to get rid of these new commands.
> My original plan is to introduce new send flag, and make "btrfs send"
> command to try to use new flag if possible.
>
> But the incompatibility is still here.
>
>>
>> 4) By keeping temporary files on the receiver end that contains whole
>> extents, you're creating periods of time where stale data is exposed.
>
>
>
> At least, I didn't see direct objection against the changed clone range.
> (From original parent/send subvol range to send subvol range only)
> That's a good news, the core idea behind the fix is still OK.
>
>
> Then the new idea, plan B.
>
> Plan B is much like the original plan A, with same clone detection
> range(inside the send subvolume, not cross subvolumes).
>
> The modification is, this time, we don't only record extent disk bytenr into
> rb_tree at send time, but more things:
> 1) extent disk bytenr
> 2) extent offset
> 3) extent nr bytes
> 4) file offset
> 5) path
>
> So that, we can reuse original write and clone command, no new command/TLV
> is needed at all.
>
> But at the cost of keeping the rb_tree sync with other operations, like
> unlink.

I don't get it. The snapshots used by a send operation are read-only -
it's not possible to unlink files/extents while send is in progress.

> And it causes higher memory usage.
>
> The new commands in plan A is just used to avoid such complex rb_tree nor
> complex sync.
>
> What do you think about this Plan B?

Lets not rush until things are simple.
A (bounded) cache of backref lookups, on the send side and per inode,
is simple and solves your original use case.

>
> Thanks,
> Qu
>
>
>
>
>>
>> Thanks.
>>
>>>
>>> Thanks,
>>> Qu
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>
>



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
