Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdCFXcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 18:32:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 953CE20212
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2017 23:31:46 +0000 (UTC)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com [209.85.223.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C75220160
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2017 23:31:45 +0000 (UTC)
Received: by mail-io0-f182.google.com with SMTP id f84so123680645ioj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 15:31:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170303184842.GB26129@lim.localdomain>
References: <1436888088-8631-1-git-send-email-fdmanana@kernel.org>
 <20170302221821.GA26698@lim.localdomain> <20170303003642.GB26698@lim.localdomain>
 <CAL3q7H6rdt_CYO8NAmBmMx6cgL=HJ01L_jOcWHDXfDXBjA2F-w@mail.gmail.com> <20170303184842.GB26129@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Mar 2017 23:31:44 +0000
Message-ID: <CAL3q7H5f5Bt7+EZ=B6Yv0iC2ytV7jHjJhCOTiywB=x41JJdU=A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix file corruption after cloning inline extents
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 3, 2017 at 6:48 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Mar 03, 2017 at 03:36:36PM +0000, Filipe Manana wrote:
>> On Fri, Mar 3, 2017 at 12:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > On Thu, Mar 02, 2017 at 02:18:21PM -0800, Liu Bo wrote:
>> >> On Tue, Jul 14, 2015 at 04:34:48PM +0100, fdmanana@kernel.org wrote:
>> >> > From: Filipe Manana <fdmanana@suse.com>
>> >> >
>> >> > Using the clone ioctl (or extent_same ioctl, which calls the same extent
>> >> > cloning function as well) we end up allowing copy an inline extent from
>> >> > the source file into a non-zero offset of the destination file. This is
>> >> > something not expected and that the btrfs code is not prepared to deal
>> >> > with - all inline extents must be at a file offset equals to 0.
>> >> >
>> >>
>> >> Somehow I failed to reproduce the BUG_ON with this case.
>> >>
>> >> > For example, the following excerpt of a test case for fstests triggers
>> >> > a crash/BUG_ON() on a write operation after an inline extent is cloned
>> >> > into a non-zero offset:
>> >> >
>> >> >   _scratch_mkfs >>$seqres.full 2>&1
>> >> >   _scratch_mount
>> >> >
>> >> >   # Create our test files. File foo has the same 2K of data at offset 4K
>> >> >   # as file bar has at its offset 0.
>> >> >   $XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 4K" \
>> >> >       -c "pwrite -S 0xbb 4k 2K" \
>> >> >       -c "pwrite -S 0xcc 8K 4K" \
>> >> >       $SCRATCH_MNT/foo | _filter_xfs_io
>> >> >
>> >> >   # File bar consists of a single inline extent (2K size).
>> >> >   $XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2K" \
>> >> >      $SCRATCH_MNT/bar | _filter_xfs_io
>> >> >
>> >> >   # Now call the clone ioctl to clone the extent of file bar into file
>> >> >   # foo at its offset 4K. This made file foo have an inline extent at
>> >> >   # offset 4K, something which the btrfs code can not deal with in future
>> >> >   # IO operations because all inline extents are supposed to start at an
>> >> >   # offset of 0, resulting in all sorts of chaos.
>> >> >   # So here we validate that clone ioctl returns an EOPNOTSUPP, which is
>> >> >   # what it returns for other cases dealing with inlined extents.
>> >> >   $CLONER_PROG -s 0 -d $((4 * 1024)) -l $((2 * 1024)) \
>> >> >       $SCRATCH_MNT/bar $SCRATCH_MNT/foo
>> >> >
>> >> >   # Because of the inline extent at offset 4K, the following write made
>> >> >   # the kernel crash with a BUG_ON().
>> >> >   $XFS_IO_PROG -c "pwrite -S 0xdd 6K 2K" $SCRATCH_MNT/foo | _filter_xfs_io
>> >> >
>> >>
>> >> On 4.10, after allowing to clone an inline extent to dst file's offset greater
>> >> than zero, I followed the test case manually and got these
>> >>
>> >> [root@localhost trinity]# /home/btrfs-progs/btrfs-debugfs -f /mnt/btrfs/foo
>> >> (257 0): ram 4096 disk 12648448 disk_size 4096
>> >> (257 4096): ram 2048 disk 0 disk_size 2048 -- inline
>> >> (257 8192): ram 4096 disk 12656640 disk_size 4096
>> >> file: /mnt/btrfs/foo extents 3 disk size 10240 logical size 12288 ratio 1.20
>> >>
>> >> [root@localhost trinity]# xfs_io -f -c "pwrite 6k 2k" /mnt/btrfs/foo
>> >> wrote 2048/2048 bytes at offset 6144
>> >> 2 KiB, 1 ops; 0.0000 sec (12.520 MiB/sec and 6410.2564 ops/sec)
>> >>
>> >> [root@localhost trinity]# sync
>> >> [root@localhost trinity]# /home/btrfs-progs/btrfs-debugfs -f /mnt/btrfs/foo
>> >> (257 0): ram 4096 disk 12648448 disk_size 4096
>> >> (257 4096): ram 4096 disk 12582912 disk_size 4096
>> >> (257 8192): ram 4096 disk 12656640 disk_size 4096
>> >> file: /mnt/btrfs/foo extents 3 disk size 12288 logical size 12288 ratio 1.00
>> >>
>> >>
>> >> Looks like we now are able to cope with these inline extents?
>> >
>> > I went back to test against v4.1 and v4.5, it turns out that we got the below
>> > BUG_ON() in MM and -EIO when writing to the inline extent, because of the fact
>> > that, when writing to the page that covers the inline extent, firstly it reads
>> > page to get an uptodate page for writing, in readpage(), for inline extent,
>> > btrfs_get_extent() always goes to search fs tree to read inline data out to page
>> > and then tries to insert a em, -EEXIST would be returned if there is an existing
>> > one.
>> >
>> > However, after commit 8dff9c853410 ("Btrfs: deal with duplciates during
>> > extent_map insertion in btrfs_get_extent"), we have that fixed, so now we can
>> > read/write inline extent even they've been mixed with other regular extents.
>> >
>> > But...I'm not 100% sure whether such files (with mixing inline with regular)
>> > would have any other problems rather than read/write.  Let me know if you could
>> > think of a corruption due to that.
>>
>> Without thinking too much and after doing some quick tests that passed
>> successfully, I'm not seeing where things can go wrong.
>> However it's odd to have a mix of inline and non-inline extents, since
>> the only cases where we create inline extents is for zero offsets and
>> their size is smaller than page_size. I am not entirely sure if, even
>> after the side effects of that commit, it would be safe to allow clone
>> operation to leave inline extents at the destination like this. A lot
>> more testing and verification should be done.
>>
>
> I got the same odd feeling about it, as you mentioned above, offset must be zero
> and it depends on the file's isize when creating inline extents, I think the
> only benefit of having inline extent is to save us a read from disk, with mixed
> stuff we lose that benefit however, so at least such mixed behavior is not
> recommended even though btrfs can tolerate it.
>
> I came accross this when I was debugging a last_size != new_size problem, so we
> can have this mixed stuff by doing these without NO_HOLES,
>
> xfs_io -f -c "pwrite 0 8" foo
> xfs_io -c "falloc 4 8188" foo
>
> offset 4 is rounded down to offset 0 and before allocating blocks we wait for
> any dirty stuff starting at offset 0, since the isize is not yet updated, the
> inline extent is created as is again.  Now we have an inline extent from 0 to 8
> and a prealloc extent from 4096 to 8192, AND its isize is 8192.

That should never happen, as the inline extent should be converted to
a regular extent and padded with zeroes.
I think you either found what leads to a read corruption of compressed
inline extents followed by holes (just search the mailing list for
such case from Zygo) or at least you are very close to it.

>
> This leads to another question for doing fallocate against inline extent:
> - Has it broken fallocate's behavior?

I think so.

thanks

> (since we don't reserve space for the first block from 0 to 4096.)
>
> Thanks,
>
> -liubo
