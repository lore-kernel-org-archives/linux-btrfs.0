Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:39164 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab3BYPQB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 10:16:01 -0500
Received: by mail-ia0-f173.google.com with SMTP id h37so2538781iak.4
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 07:16:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain> <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
 <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Mon, 25 Feb 2013 16:15:40 +0100
Message-ID: <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks again Josef.

I understood that cow_file_range is called for a regular file. Just to
clarify, in cow_file_range is cow done at the time of reserving
extents in the extent btree for the io to be done in this delalloc? I
see the following comment above find_free_extent() which is called
while trying to reserve extents:

/*
 * walks the btree of allocated extents and find a hole of a given size.
 * The key ins is changed to record the hole:
 * ins->objectid == block start
 * ins->flags = BTRFS_EXTENT_ITEM_KEY
 * ins->offset == number of blocks
 * Any available blocks before search_start are skipped.
 */

This seems to be the only place where a cow might be done, because a
key is being inserted into an extent which modifies it.

Thanks,
Aastha.

On 24 February 2013 02:39, Josef Bacik <josef@toxicpanda.com> wrote:
> On Thu, Feb 21, 2013 at 12:32 PM, Aastha Mehta <aasthakm@gmail.com> wrote:
>>
>> Thanks a lot for the prompt response. I had seen that, but I am still
>> not sure of where it really
>> happens within fill_delalloc. Could you help me a little further in that
>> path?
>>
>
> So we check the properties of the inode and do one of 3 things, either we
> call btrfs_cow_file_range directly in the case of a normal file,
> run_delalloc_nocow in the case of a file with prealloc extents or NOCOW, or
> we do the compression dance.  We make an ordered extent for this range and
> return.  And then the normal io path happens.
>
>>
>> Secondly, now I am confused between the btree_writepages and
>> btrfs_writepages/btrfs_writepage
>> methods. I thought btrfs_writepages was for writing the pages holding
>> inodes and btree_writepages
>> for writing the other indirect and leaf extents of the btree. Then, it
>> seems that the write operations
>> lead to update of the file system data structures in a top-down
>> manner, i.e. first changing the inode
>> and then the data extents. Is that correct?
>
>
> You are right that btrfs_writepages/writepage are for normal files and
> btree_writepages is for the metadata.  The write operations do start in data
> and then modify metadata later down the line if that is what you are getting
> at.
>
>>
>> Thirdly, it seems that the old extents maybe dropped before the new
>> extents are flushed to the disk.
>> What would happen if the write fails before the disk commit? What am I
>> missing here?
>>
>
> Yeah, the metadata isn't updated until the data is on the disk.  In
> ->fill_delalloc we setup an btrfs_ordered_extent that describes the range of
> the dirty pages we are writing.  When we've written all these pages we run
> btrfs_finish_ordered_io, which will drop the old extent entries if there are
> any and then add the new extent entries and update the references and such.
> So if something fails we just continue to point to the original file extent
> entries and return an EIO, we maintain consistency by making sure the
> metadata is updated only after the data is written out.  I hope that helps.
> Thanks,
>
> Josef



--
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org
