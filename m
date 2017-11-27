Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36193 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdK0NuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 08:50:01 -0500
Received: by mail-it0-f41.google.com with SMTP id y71so9488038ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 05:50:01 -0800 (PST)
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20171127094156.GC29491@fnst.localdomain>
 <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
 <2de2ce9f-5b6e-664c-a7ce-c319767e7cec@gmail.com>
 <3b52d261-7802-8f01-b853-2d55d52fe2bd@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <17a73ae3-e297-0aef-33cb-165136b6f4fe@gmail.com>
Date: Mon, 27 Nov 2017 08:49:58 -0500
MIME-Version: 1.0
In-Reply-To: <3b52d261-7802-8f01-b853-2d55d52fe2bd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-27 08:17, Qu Wenruo wrote:
> 
> 
> On 2017年11月27日 21:02, Austin S. Hemmelgarn wrote:
>> On 2017-11-27 05:13, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年11月27日 17:41, Lu Fengqi wrote:
>>>> Hi all,
>>>>
>>>> As we all know, under certain circumstances, it is more appropriate to
>>>> create some subvolumes rather than keep everything in the same
>>>> subvolume. As the condition of demand change, the user may need to
>>>> convert a previous directory to a subvolume. For this reason，how about
>>>> adding an ioctl to convert a directory to a subvolume?
>>>
>>> The idea seems interesting.
>>>
>>> However in my opinion, this can be done quite easily in (mostly) user
>>> space, thanks to btrfs support of relink.
>>>
>>> The method from Hugo or Chris is quite good, maybe it can be enhanced a
>>> little.
>>>
>>> Use the following layout as an example:
>>>
>>> root_subv
>>> |- subvolume_1
>>> |  |- dir_1
>>> |  |  |- file_1
>>> |  |  |- file_2
>>> |  |- dir_2
>>> |     |- file_3
>>> |- subvolume_2
>>>
>>> If we want to convert dir_1 into subvolume, we can do it like:
>>>
>>> 1) Create a temporary readonly snapshot of parent subvolume containing
>>>      the desired dir
>>>      # btrfs sub snapshot -r root_subv/subvolume_1 \
>>>        root_subv/tmp_snapshot_1
>>>
>>> 2) Create a new subvolume, as destination.
>>>      # btrfs sub create root_subv/tmp_dest/
>>>
>>> 3) Copy the content and sync the fs
>>>      Use of reflink is necessary.
>>>      # cp -r --reflink=always root_subv/tmp_snapshot_1/dir_1 \
>>>        root_subv/tmp_dest
>>>      # btrfs sync root_subv/tmp_dest
>>>
>>> 4) Delete temporary readonly snapshot
>>>      # btrfs subvolume delete root_subv/tmp_snapshot_1
>>>
>>> 5) Remove the source dir
>>>      # rm -rf root_subv/subvolume_1/dir_1
>>>
>>> 5) Create a final destination snapshot of "root_subv/temporary_dest"
>>>      # btrfs subvolume snapshot root_subv/tmp_dest \
>>>        root_subv/subvolume_1/dir_1
>>>
>>> 6) Remove the temporary destination
>>>      # btrfs subvolume delete root_subv/tmp_dest
>>>
>>>
>>> The main challenge is in step 3).
>>> In fact above method can only handle normal dir/files.
>>> If there is another subvolume inside the desired dir, current "cp -r" is
>>> a bad idea.
>>> We need to skip subvolume dir, and create snapshot for it.
>>>
>>> But it's quite easy to write a user space program to handle it.
>>> Maybe using "find" command can already handle it well.
>>>
>>> Anyway, doing it in user space is already possible and much easier than
>>> doing it in kernel.
>>>
>>>>
>>>> Users can convert by the scripts mentioned in this
>>>> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is
>>>> it easier to use the off-the-shelf btrfs subcommand?
>>>
>>> If you just want to integrate the functionality into btrfs-progs, maybe
>>> it's possible.
>>>
>>> But if you insist in providing a new ioctl for this, I highly doubt if
>>> the extra hassle is worthy.
>>>
>>>>
>>>> After an initial consideration, our implementation is broadly divided
>>>> into the following steps:
>>>> 1. Freeze the filesystem or set the subvolume above the source directory
>>>> to read-only;
>>>
>>> Not really need to freeze the whole fs.
>>> Just create a readonly snapshot of the parent subvolume which contains
>>> the dir.
>>> That's how snapshot is designed for.
>>>
>>>> 2. Perform a pre-check, for example, check if a cross-device link
>>>> creation during the conversion;
>>>
>>> This can be done in-the-fly.
>>> As the check is so easy (only needs to check if the inode number is 256).
>>> We only need a mid-order iteration of the source dir (in temporary
>>> snapshot), and for normal file, use reflink.
>>> For subvolume dir, create a snapshot for it.
>>>
>>> And for such iteration, a python script less than 100 lines would be
>>> sufficient.
>> On that note, see the function convert_dir_to_subv() in:
>> https://github.com/Ferroin/btrfs-subv-backup/blob/master/btrfs-subv-backup.py
>>
>>
>> For an example of how to do it in Python (albeit with some extra code to
>> handle the case of not having the reflink module from PyPI, and without
>> anything to prevent the source from being modified).
>>
>> It would still be nice to be able to do this atomically though, or at
>> least get cross-rename support in BTRFS, which would allow the final
>> rename to replace the source with a subvolume to be atomic (assuming of
>> course you could cross-rename a directory and subvolume).
> 
> The problem behind cross-rename is, btrfs doesn't follow the
> one-inode-one-tree organization used by most filesystems.
> 
> This prevents inode from being referred outside of its subvolume.
> 
> 
> And since btrfs uses one-subvolume-one-tree solution, which greatly
> simplify the snapshot implementation, it's pretty hard or almost
> impossible to do real rename-across-subvolume.
I seriously doubt that that matters in almost all real-world use cases. 
Everything I've seen that uses cross-rename does it with a temporary 
file in the same directory as the target file, using it to avoid the 
non-atomic nature of creating a backup and replacing a file without 
needing extra I/O (yes, reflinks help here, but still aren't perfect).

Just supporting it within a subvolume and returning whatever errno gets 
returned for trying to call rename(2) across filesystem boundaries 
should be more than sufficient for most use cases, even if it doesn't 
work with what I had suggested (which I believe probably qualifies as 
'novel' usage), and in theory would side-step the issues with inodes not 
being globally unique within the filesystem.
> 
> But at least we can reflink, reducing huge amount of data IO, making us
> only need to handle inode creation/link.
> 
> (Although such one-subvolume-one-tree also makes metadata concurrency
> very low, further slowing down the metadata operation)
> 
> Thanks,
> Qu
> 
>>>
>>> Thanks,
>>> Qu
>>>
>>>> 3. Perform conversion, such as creating a new subvolume and moving the
>>>> contents of the source directory;
>>>> 4. Thaw the filesystem or restore the subvolume writable property.
>>>>
>>>> In fact, I am not so sure whether this use of freeze is appropriate
>>>> because the source directory the user needs to convert may be located
>>>> at / or /home and this pre-check and conversion process may take a long
>>>> time, which can lead to some shell and graphical application suspended.
>>>>
>>>> Please give your comments if any.
>>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

