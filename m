Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47564 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3CCPll (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 10:41:41 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so5297132ieb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 07:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain> <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
 <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
 <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
 <20130225172719.GA2434@localhost.localdomain> <CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sun, 3 Mar 2013 16:41:18 +0100
Message-ID: <CAEx9m454t17kngaKv+PWL2V=DLYr6viT6J_eWEtHFfc10csioQ@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

I have some more questions following up on my previous e-mails.
I now do somewhat understand the place where extent entries get
cow'ed. But I am unclear about the order of operations.

Is it correct that the data extent written first, then the pointer in
the indirect block needs to be updated, so then it is cowed and
written to disk and so on recursively up the tree? Or is the entire
path from leaf to node that is going to be affected by the write cowed
first and then all the cowed extents are written to the disk and then
the rest of the metadata pointers, (for example, in checksum tree,
extent tree, etc., I am not sure about this)?

Also, I need to understand specifically how the data (leaf nodes) of a
file is written to disk v/s the metadata including the indirect nodes
of the file. In extent_writepage I only know the pages of a file that
are to be written. I guess, I can identify metadata pages based on the
inode of the page's owner. But is it possible to distinguish the pages
available in extent_writepage path as belonging to the leaf node or
internal node for a file? If it cannot be identified at this point,
where earlier in the path can this be decided?

Many thanks,
Aastha.

On 25 February 2013 20:00, Aastha Mehta <aasthakm@gmail.com> wrote:
> Ah okay, I now see how it works. Thanks a lot for your response.
>
> Regards,
> Aastha.
>
>
> On 25 February 2013 18:27, Josef Bacik <jbacik@fusionio.com> wrote:
>> On Mon, Feb 25, 2013 at 08:15:40AM -0700, Aastha Mehta wrote:
>>> Thanks again Josef.
>>>
>>> I understood that cow_file_range is called for a regular file. Just to
>>> clarify, in cow_file_range is cow done at the time of reserving
>>> extents in the extent btree for the io to be done in this delalloc? I
>>> see the following comment above find_free_extent() which is called
>>> while trying to reserve extents:
>>>
>>> /*
>>>  * walks the btree of allocated extents and find a hole of a given size.
>>>  * The key ins is changed to record the hole:
>>>  * ins->objectid == block start
>>>  * ins->flags = BTRFS_EXTENT_ITEM_KEY
>>>  * ins->offset == number of blocks
>>>  * Any available blocks before search_start are skipped.
>>>  */
>>>
>>> This seems to be the only place where a cow might be done, because a
>>> key is being inserted into an extent which modifies it.
>>>
>>
>> The key isn't inserted at this time, it's just returned with those values for us
>> to do as we please.  There is no update of the btree until
>> insert_reserved_extent/btrfs_mark_extent_written in btrfs_finish_ordered_io.
>> Thanks,
>>
>> Josef
