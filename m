Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65433 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3CBVHQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2013 16:07:16 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so3272410wgl.18
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2013 13:07:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
	<20130220175410.GB2062@localhost.localdomain>
	<CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
	<CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
	<CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
	<20130225172719.GA2434@localhost.localdomain>
	<CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
Date: Sat, 2 Mar 2013 23:07:14 +0200
Message-ID: <CAOcd+r1C_tHGzZ3WQejkW3xycFhNLisOpk7BtUv70pog5Og6xQ@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
I hope it's ok to piggy back on this thread for the following question:

I see that in btrfs_cross_ref_exist()=>check_committed_ref() path,
there is the following check:

if (btrfs_extent_generation(leaf, ei) <=
    btrfs_root_last_snapshot(&root->root_item))
	goto out;

So this basically means that after we have taken a snap of a subvol,
then all subvol's extents must be COW'ed, even if we delete the snap a
minute later.
I wonder, why is that so?
Is this because file extents can be shared indirectly, like when we
create a snap, we only COW the root and only mark all root's
*immediate* children shared in the extent tree?
Can the new backref walking code be used here to check more
accurately, if the extent is shared by anybody else?

Thanks,
Alex.



On Mon, Feb 25, 2013 at 9:00 PM, Aastha Mehta <aasthakm@gmail.com> wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
