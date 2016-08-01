Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35372 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbcHAWFj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 18:05:39 -0400
Received: by mail-io0-f181.google.com with SMTP id m101so195885162ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 15:05:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 1 Aug 2016 19:00:51 +0100
Message-ID: <CAL3q7H6Wo85Z8KV1m8JNrZALOVO+KhXo8AP2vy3X_XN4BsNySQ@mail.gmail.com>
Subject: Re: Btrfs send to send out metadata and data separately
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 1:40 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Hi Filipe, and maintainers,
>
> I'm recently working on the root fix to free send from calling backref walk.
>
> My current idea is to send data and metadata separately, and only do clone
> detection inside the send subvolume.
>
> This method needs two new send commands:
> (And new send attribute, A_DATA_BYTENR)
> 1) SEND_C_DATA
>    much like SEND_C_WRITE, with a little change in the 1st TLV.
>
>    TLVs:
>    A_DATA_BYTENR:        bytenr of the data extent
>    A_FILE_OFFSET:        offset inside the data extent
>    A_DATA:               real data
>
> 2) SEND_C_CLONE_DATA
>    A little like SEND_C_CLONE, with unneeded parameters striped
>
>    TLVs:
>    A_PATH:               filename
>    A_DATA_BYTENR:        disk_bytenr of the EXTENT_DATA
>    A_FILE_OFFSET:        file offset
>    A_FILE_OFFSET:        offset inside the EXTENT_DATA
>    A_CLONE_LEN:          num_bytes of the EXTENT_DATA
>
>
> The send part is different in how to sending out a EXTENT_DATA.
> The send work follow is:
>
> 1) Found a EXTENT_DATA to send.
>    Check rb_tree of "disk_bytenr".
>    if "disk_bytenr" in rb_tree
>      goto 2) Reflink data
>    /* Initiate a SEND_C_DATA */
>    Send out the *whole* *uncompressed* extent of "disk_bytenr".
>    Adds "disk_bytenr" into rb_tree
>
>
> 2) Reflink data
>    /* Initiate a SEND_C_CLONE_DATA */
>    Filling disk_bytenr, offset and num_bytes, and send out the command.
>
> That's to say, send will send out extent data and referencer separately.
>
> So for kernel part, it's quite easy and *NO* time consuming backref walk
> ever.
> And no other part is modified.
>
>
> The main trick happens in the receive part.
>
> Receive will do the following thing first before recovering the
> subvolume/snapshot:
>
> 0) Create temporary dir for data extents
>    Create a new dir with temporary name($data_extent), to put data extents
> into it.
>
> Then for SEND_C_DATA command:
> 1) Create file with file name $filename under $data_extent dir
>    filename = $(printf "0x%x" $disk_bytenr)
>    $disk_bytenr is the first u64 TLV of SEND_A_DATA command.
> 2) Write data into $data_extent/$filename
>
> Then handle the SEND_C_CLONE_DATA command
> It would be like
>   xfs_io -f -c "reflink $data_extent/$disk_bytenr $extent_offset
>                 $file_offset $num_bytes" $filename
> disk_bytenr=2nd TLV (string converted to u64, with "0x%x")
> extent_offset=3rd TLV, u64
> file_offset=4th TLV, u64
> num_bytes=5th TLV, u64
> filename=1th TLV, string
>
> Finally, after the snapshot/subvolume is recovered, remove the $data_extent
> directory.
>
>
> The whole idea is to completely remove the time consuming backref walk in
> send.
>
> So pros:
> 1) No backref walk, no soft lockup, no super long execution time
>    Under worst case O(N^2), best case O(N)
>    Memory usage worst case O(N), best case O(1)
>    Where N is the number of reference to extents.
>
> 2) Almost the same metadata layout
>    Including the overlap extents
>
> Cons:
> 1) Not full fs clone detection
>    Such clone detection is only inside the send snapshot.
>
>    For case that one extent is referred only once in the send snapshot,
>    but also referred by source subvolume, then in the received
>    subvolume, it will be a new extent, but not a clone.
>
>    Only extent that is referred twice by send snapshot, that extent
>    will be shared.
>
>    (Although much better than disabling the whole clone detection)
> 2) Extra space usage
>    Since it completely recovers the overlap extents
> 3) As many fragments as source subvolume
> 4) Possible slow recovery due to reflink speed.
>
>
> I am still concerned about the following problems:
>
> 1) Is it OK to add not only 1, but 2 new send commands?
> 2) Is such clone detection range change OK?
>
> Any ideas and suggestion is welcomed.


Qu,

I don't like the idea at all, for several reasons:

1) Too complex to implement. We should really avoid making things more
complex than they are already.
   Your earlier suggestion to cache backref lookups is much simpler
and solves the problem for the vast majority of cases (assuming a
bounded cache of course).
    There's really no need for such high complexity.

2) By adding new commands to the stream, you break backwards compatibility.
   Think about all the tools out there that interpret send streams and
not just the receive command (for example snapper).

3) By requiring a new different behaviour for the receiver, suddenly
older versions of it will no longer be able to receive from new
kernels.

4) By keeping temporary files on the receiver end that contains whole
extents, you're creating periods of time where stale data is exposed.

Thanks.

>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
