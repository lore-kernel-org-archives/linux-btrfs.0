Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9812 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751049AbdBUAZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 19:25:54 -0500
Subject: Re: [PATCH] btrfs: Handle btrfs_reloc_clone_csums error correctly to
 avoid deadlock
To: <fdmanana@gmail.com>
References: <20170215084924.10587-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H4gTkwjRSNtexur6BMiKiU55CpeDnp45yScOn89dsw6_Q@mail.gmail.com>
 <74726a82-01ec-4501-acb3-133083904f7d@cn.fujitsu.com>
 <CAL3q7H65Zfj3cx3kYJBH3x_O+mJeAbvMrPLp3fZPhPsiz77gyg@mail.gmail.com>
 <6fa6ed2a-8d0c-682c-dda8-eefe20519264@cn.fujitsu.com>
 <CAL3q7H444G-6V9wcG3E3dXY9Jw8WoSUyaQV7kGw_h0-7hQHh4g@mail.gmail.com>
 <dd22be88-1fc0-7ccf-f6b8-bec58170af3d@cn.fujitsu.com>
 <CAL3q7H7vrLzP3ynk1X=NRjvYHjDjOsOWo7F9-WdSp1Y4zmgbGQ@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <356d5a5f-866f-f370-f20e-e5b42bf79738@cn.fujitsu.com>
Date: Tue, 21 Feb 2017 08:25:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7vrLzP3ynk1X=NRjvYHjDjOsOWo7F9-WdSp1Y4zmgbGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/20/2017 09:43 PM, Filipe Manana wrote:
> On Mon, Feb 20, 2017 at 12:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 02/17/2017 11:25 PM, Filipe Manana wrote:
>>>
>>> On Fri, Feb 17, 2017 at 12:37 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>
>>>
>>> In case of an error the endio handler is called only for the first
>>> page, and not for whole range for which one or more ordered extents
>>> were created. So the ordered extents will be around forever.
>>
>>
>> That's the same thing I'm trying to fix.
>>
>> While I'm asking the reason the cleanup previously created ordered extent,
>> which didn't encounter any error.
>
> Any error in the loop requires cleaning up previously created ordered
> extents, because if that function returns an error no bio is submitted
> and therefore the ordered extents won't be removed, except for the
> case where only one ordered extent is created and the delalloc range
> is a single page.
>
>>
>>
>>>
>>>>
>>>> Or is this a designed behavior for things like fsync?
>>>> Success for all or failure if any fails?
>>>
>>>
>>> This is unrelated to fsync. It's about leaving ordered extents which
>>> can make any task get them and hang on them forever.
>>
>>
>> However in the case of btrfs_reloc_clone_csum(), if it fails, there is only
>> one ordered extent really needs to clean.
>
> The problem is more generic and you can forget about
> btrfs_reloc_clone_csum(). It's about the delalloc callback returning
> an error and one or more ordered extents were created by past
> iterations of the loop before the error happened.

While the only possible problem we can hit after submitting an ordered 
extent is btrfs_reloc_clone_csum().

>
>>
>> Previously created ordered extent can finish without problem, so we only
>> need to clean the last created one, and no need to cleanup all ordered
>> extent that it created.
>>
>> For a more specific example of this case:
>>
>> We are relocating one data block group, whose size is 1G, containing 8 128M
>> file extents.
>>
>> For run_delalloc_nocow(), it's called on root DATA_RELOC inode 257, range is
>> [0,1G),
>>
>> And for first loop, it handles the first [0, 128M) without problem.
>> 1st ordered extent is submitted and can finish even before submitting 2nd
>> ordered extent.
>
> The ordered extent is submitted but not a bio for it. It's when the
> bio completes (writeback finishes) that the endio callback is invoked,
> which wakes up every task waiting on the ordered extent, sets IO
> errors bit if needed, removes the ordered extent, etc.
>
>>
>> Then when we are submitting 2nd ordered extent, ranged from [128M, 256M),
>> btrfs_reloc_clone_csum() fails. we must cleanup at least 2nd ordered extent
>> or it will hang forever.
>>
>> If I understand your right, you mean we must cleanup all ordered extent in
>> the range [0, 1G).
>
> Yes.
>
>>
>> My point is, since 1st ordered extent can be submitted and finished before
>> 2nd ordered extent submission without problem, I didn't see the point to
>> cleanup 1st ordered extent and non-exist 3rd~8th ordered extent.
>
> As said before in this reply, if the delalloc callback
> (cow_file_range, run_dellaloc_nocow) returns an error, no bios are
> submitted for any ordered extents it might have created before an
> error happened. Check __extent_writepage() - it calls
> writepage_delalloc() which calls our delalloc callback, and if that
> returns an error, it won't call __extent_writepage_io(), which is what
> submits bios.
>
>>
>> Or I missed or misunderstand something else?
>
> You missed a lot of things I suppose, namely that bios aren't
> submitted if the dealloc function returns an error.

That's the point. I misunderstand the bio submission timing, so in that 
case you're right about cleanup the whole range.

I'll update the patch to address it.

Thanks,
Qu

>
> Honestly I don't know how to explain things better to you, and was
> hopping this was easier to understand using the direct IO write error
> path as an example.
>
> thanks
>
>>
>> Thanks,
>> Qu
>>
>>
>>
>>
>>>
>>> thanks
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>>
>>>>>> In that case, since we haven't unlock pages/extent, there will no race
>>>>>> nor
>>>>>> new ordered extent, and we are ensured to have only one ordered extent
>>>>>> need
>>>>>> cleanup.
>>>>>>
>>>>>>>
>>>>>>> Also, for any created ordered extent, you want to set the bit
>>>>>>> BTRFS_ORDERED_IOERR on it before removing it, since there might be
>>>>>>> concurrent tasks waiting for it that do error handling (like an fsync,
>>>>>>> since when running delalloc the inode isn't locked).
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Fsync is not affected IIRC, as btrfs_reloc_clone_csum() is only called
>>>>>> for
>>>>>> DATA_RELOC tree inode, which we don't call fsync on it.
>>>>>>
>>>>>>>
>>>>>>> Look at the direct IO write path error handling and
>>>>>>> btrfs_endio_direct_write_update_ordered() for a very similar scenario.
>>>>>>> And the same problem happens in the cow case
>>>>>>> (inode.c:cow_file_range()).
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> BTW, I have already done it in cow_file_range(), check the beginning
>>>>>> lines
>>>>>> of inode.c of this patch.
>>>>>
>>>>>
>>>>>
>>>>> Indeed. I missed it.
>>>>>
>>>>> Thanks.
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Thanks.
>>>>>>>
>>>>>>>> +       }
>>>>>>>>         btrfs_free_path(path);
>>>>>>>>         return ret;
>>>>>>>>  }
>>>>>>>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>>>>>>>> index 041c3326d109..dba1cf3464a7 100644
>>>>>>>> --- a/fs/btrfs/ordered-data.c
>>>>>>>> +++ b/fs/btrfs/ordered-data.c
>>>>>>>> @@ -650,6 +650,31 @@ void btrfs_remove_ordered_extent(struct inode
>>>>>>>> *inode,
>>>>>>>>         wake_up(&entry->wait);
>>>>>>>>  }
>>>>>>>>
>>>>>>>> +void btrfs_clean_ordered_extent(struct inode *inode, u64
>>>>>>>> file_offset,
>>>>>>>> +                               u64 ram_len)
>>>>>>>> +{
>>>>>>>> +       struct btrfs_ordered_extent *entry;
>>>>>>>> +       struct btrfs_root *root = BTRFS_I(inode)->root;
>>>>>>>> +
>>>>>>>> +       entry = btrfs_lookup_ordered_range(inode, file_offset,
>>>>>>>> ram_len);
>>>>>>>> +       if (!entry || entry->file_offset != file_offset ||
>>>>>>>> +           entry->len != ram_len)
>>>>>>>> +               goto not_found;
>>>>>>>> +
>>>>>>>> +       /* Same as btrfs_finish_ordered_io() */
>>>>>>>> +       btrfs_remove_ordered_extent(inode, entry);
>>>>>>>> +       btrfs_put_ordered_extent(entry);
>>>>>>>> +       btrfs_put_ordered_extent(entry);
>>>>>>>> +       return;
>>>>>>>> +
>>>>>>>> +not_found:
>>>>>>>> +       WARN_ON(1);
>>>>>>>> +       btrfs_err(root->fs_info,
>>>>>>>> +       "failed to find and clean ordered extent: root %llu ino %llu
>>>>>>>> file_offset %llu len %llu",
>>>>>>>> +                 root->objectid, btrfs_ino(inode), file_offset,
>>>>>>>> ram_len);
>>>>>>>> +       return;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>  static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
>>>>>>>>  {
>>>>>>>>         struct btrfs_ordered_extent *ordered;
>>>>>>>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
>>>>>>>> index 5f2b0ca28705..7a989778aa89 100644
>>>>>>>> --- a/fs/btrfs/ordered-data.h
>>>>>>>> +++ b/fs/btrfs/ordered-data.h
>>>>>>>> @@ -163,6 +163,16 @@ btrfs_ordered_inode_tree_init(struct
>>>>>>>> btrfs_ordered_inode_tree *t)
>>>>>>>>  void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
>>>>>>>>  void btrfs_remove_ordered_extent(struct inode *inode,
>>>>>>>>                                 struct btrfs_ordered_extent *entry);
>>>>>>>> +
>>>>>>>> +/*
>>>>>>>> + * Function to cleanup an allocated ordered extent in error routine.
>>>>>>>> + *
>>>>>>>> + * As error handler in run_delalloc_range() will clear all related
>>>>>>>> pages
>>>>>>>> + * and skip their IO, we have no method to finish inserted ordered
>>>>>>>> extent.
>>>>>>>> + * So we must use this function to clean it up.
>>>>>>>> + */
>>>>>>>> +void btrfs_clean_ordered_extent(struct inode *inode, u64
>>>>>>>> file_offset,
>>>>>>>> +                               u64 ram_len);
>>>>>>>>  int btrfs_dec_test_ordered_pending(struct inode *inode,
>>>>>>>>                                    struct btrfs_ordered_extent
>>>>>>>> **cached,
>>>>>>>>                                    u64 file_offset, u64 io_size, int
>>>>>>>> uptodate);
>>>>>>>> --
>>>>>>>> 2.11.1
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-btrfs"
>>>>>>>> in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>>
>
>
>


