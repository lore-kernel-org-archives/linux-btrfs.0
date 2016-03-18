Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62353 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964AbcCRAip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 20:38:45 -0400
Subject: Re: [PATCH] btrfs-progs: add stat check in open_ctree_fs_info
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <1458141971-56355-1-git-send-email-ahferroin7@gmail.com>
 <56EA7314.2080104@cn.fujitsu.com> <56EA935C.1040408@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56EB4E09.6090703@cn.fujitsu.com>
Date: Fri, 18 Mar 2016 08:38:33 +0800
MIME-Version: 1.0
In-Reply-To: <56EA935C.1040408@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S. Hemmelgarn wrote on 2016/03/17 07:22 -0400:
> On 2016-03-17 05:04, Qu Wenruo wrote:
>>
>>
>> Austin S. Hemmelgarn wrote on 2016/03/16 11:26 -0400:
>>> Currently, open_ctree_fs_info will open whatever path you pass it and
>>> try to interpret it as a BTRFS filesystem.  While this is not
>>> nessecarily dangerous (except possibly if done on a character device),
>>> it does result in some rather cryptic and non-sensical error messages
>>> when trying to run certain commands in ways they weren't intended to be
>>> run.  Add a check using stat(2) to verify that the path we've been
>>> passed is in fact a regular file or a block device.
>>>
>>> This causes the following commands to provide a helpful error message
>>> when run on a FIFO, directory, character device, or socket:
>>>      * btrfs check
>>>      * btrfs restore
>>>      * btrfs-image
>>>      * btrfs-find-root
>>>      * btrfs-debug-tree
>>>
>>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>>> ---
>>> This has been build and runtime tested on an x86-64 system with glibc.
>>> It has been build tested on x86-64 with uclibc.
>>> It has not been tested on Android or with musl, although it should work
>>> there also.
>>>
>>> There are other tools that have similarly bad behavior when called
>>> incorrectly (btrfs rescue immediately comes to mind), but they don't
>>> use open_ctree_fs_info, so this doesn't affect them.  I may do followup
>>> patches to fix those too if I have the time.
>>>
>>> open_ctree_fs_info is also used in cmds-filesystem.c, although I'm not
>>> at all sure what exactly is going on there, and btrfs filesystem appears
>>> from my testing to behave exactly the same with this change, so I don't
>>> think this will have any effect on any of the btrfs filesystem commands.
>>>
>>>   disk-io.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/disk-io.c b/disk-io.c
>>> index e520d80..d35153d 100644
>>> --- a/disk-io.c
>>> +++ b/disk-io.c
>>> @@ -1310,6 +1310,13 @@ struct btrfs_fs_info *open_ctree_fs_info(const
>>> char *filename,
>>>       int fp;
>>>       struct btrfs_fs_info *info;
>>>       int oflags = O_CREAT | O_RDWR;
>>> +    struct stat sb;
>>> +
>>> +    stat(filename, &sb);
>>> +    if (!(((sb.st_mode & S_IFMT) == S_IFREG) || ((sb.st_mode &
>>> S_IFMT) == S_IFBLK))) {
>>> +        fprintf (stderr, "%s is not a regular file or block
>>> device\n", filename);
>>> +        return NULL;
>>> +    }
>>
>> This one seems to be too restrict.
>>
>> I prefer to block char/pipe/dir and some other obvious wrong ones other
>> than only allowing regular and block ones.
> Running against a directory gives a cryptic error about the superblock
> having bad info.  Running against a pipe is nonsensical, as it can't
> contain a filesystem.  Running against a character device is potentially
> dangerous (read operations are not guaranteed to be idempotent on
> character devices, depending on what hardware it is connected to, you
> could cause all kinds of odd things to happen).
>
> Everything this function gets called on is trying to get info from a
> unmounted filesystem image, which means that it only makes sense to try
> to parse things that can contain a unmounted filesystem image.

Yes, I understand what you are doing.

Just as I alreayd mentioned, the problem is, your current patch only 
allowing regular and block device and will block valid soft link.
Just as Duncan mentioned, soft link should be allowed too.

I mean to *block/prevent* char/pipe/dir instead of *only allowing* 
regular/block device.

Thanks,
Qu
>>
>> Thanks,
>> Qu
>>>
>>>       if (!(flags & OPEN_CTREE_WRITES))
>>>           oflags = O_RDONLY;
>>>
>>
>>
>
>
>


