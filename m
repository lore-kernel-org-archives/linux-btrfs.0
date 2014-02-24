Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40243 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBXOlC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 09:41:02 -0500
Received: by mail-ie0-f173.google.com with SMTP id lx4so3509365iec.32
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 06:41:01 -0800 (PST)
Message-ID: <530B59FA.3010909@gmail.com>
Date: Mon, 24 Feb 2014 09:40:58 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Allow forced conversion of metadata to dup profile
 on multiple devices
References: <5304D781.6020309@gmail.com>	<20140220165743.GT16073@twin.jikos.cz>	<CAOi1vP9hEqBcDgY-zthijx37+_cowhoMQaTZyWG9OUqOQvJR2A@mail.gmail.com>	<530B4CB4.5010909@gmail.com> <CAOi1vP9-sFDxomB7E-xspfufoUn5iqjgtW=3oFfkdjq_=cmzmg@mail.gmail.com>
In-Reply-To: <CAOi1vP9-sFDxomB7E-xspfufoUn5iqjgtW=3oFfkdjq_=cmzmg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-02-24 09:12, Ilya Dryomov wrote:
> On Mon, Feb 24, 2014 at 3:44 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2014-02-24 08:37, Ilya Dryomov wrote:
>>> On Thu, Feb 20, 2014 at 6:57 PM, David Sterba <dsterba@suse.cz> wrote:
>>>> On Wed, Feb 19, 2014 at 11:10:41AM -0500, Austin S Hemmelgarn wrote:
>>>>> Currently, btrfs balance start fails when trying to convert metadata or
>>>>> system chunks to dup profile on filesystems with multiple devices.  This
>>>>> requires that a conversion from a multi-device filesystem to a single
>>>>> device filesystem use the following methodology:
>>>>>     1. btrfs balance start -dconvert=single -mconvert=single \
>>>>>        -sconvert=single -f /
>>>>>     2. btrfs device delete / /dev/sdx
>>>>>     3. btrfs balance start -mconvert=dup -sconvert=dup /
>>>>> This results in a period of time (possibly very long if the devices are
>>>>> big) where you don't have the protection guarantees of multiple copies
>>>>> of metadata chunks.
>>>>>
>>>>> After applying this patch, one can instead use the following methodology
>>>>> for conversion from a multi-device filesystem to a single device
>>>>> filesystem:
>>>>>     1. btrfs balance start -dconvert=single -mconvert=dup \
>>>>>        -sconvert=dup -f /
>>>>>     2. btrfs device delete / /dev/sdx
>>>>> This greatly reduces the chances of the operation causing data loss due
>>>>> to a read error during the device delete.
>>>>>
>>>>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>>>> Reviewed-by: David Sterba <dsterba@suse.cz>
>>>>
>>>> Sounds useful. The muliple devices + DUP is allowed setup when the
>>>> device is added, this patch only adds the 'delete' counterpart. The
>>>> imroved data loss protection during the process is a good thing.
>>>
>>> Hi,
>>>
>>> Have you actually tried to queue it?  Unless I'm missing something, it won't
>>> compile, and on top of that, it seems to be corrupted too..
>> The patch itself was made using git, AFAICT it should be fine.  I've
>> personally built and tested it using UML.
> 
> It doesn't look fine.  It was generated with git, but it got corrupted
> on the way: either how you pasted it or the email client you use is the
> problem.
> 
> On Wed, Feb 19, 2014 at 6:10 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> Currently, btrfs balance start fails when trying to convert metadata or
>> system chunks to dup profile on filesystems with multiple devices.  This
>> requires that a conversion from a multi-device filesystem to a single
>> device filesystem use the following methodology:
>>     1. btrfs balance start -dconvert=single -mconvert=single \
>>        -sconvert=single -f /
>>     2. btrfs device delete / /dev/sdx
>>     3. btrfs balance start -mconvert=dup -sconvert=dup /
>> This results in a period of time (possibly very long if the devices are
>> big) where you don't have the protection guarantees of multiple copies
>> of metadata chunks.
>>
>> After applying this patch, one can instead use the following methodology
>> for conversion from a multi-device filesystem to a single device
>> filesystem:
>>     1. btrfs balance start -dconvert=single -mconvert=dup \
>>        -sconvert=dup -f /
>>     2. btrfs device delete / /dev/sdx
>> This greatly reduces the chances of the operation causing data loss due
>> to a read error during the device delete.
>>
>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> ---
>>  fs/btrfs/volumes.c | 21 +++++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 07629e9..38a9522 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3152,10 +3152,8 @@ int btrfs_balance(struct btrfs_balance_control
>> *bctl,
> 
> ^^^, that should be a single line
> 
>>                 num_devices--;
>>         }
>>         btrfs_dev_replace_unlock(&fs_info->dev_replace);
>> -       allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
>> -       if (num_devices == 1)
>> -               allowed |= BTRFS_BLOCK_GROUP_DUP;
>> -       else if (num_devices > 1)
>> +       allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
>> +       if (num_devices > 1)
>>                 allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
>>         if (num_devices > 2)
>>                 allowed |= BTRFS_BLOCK_GROUP_RAID5;
>> @@ -3221,6 +3219,21 @@ int btrfs_balance(struct btrfs_balance_control
>> *bctl,
> 
> ^^^, ditto
> 
>>                                 goto out;
>>                         }
>>                 }
>> +               if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
>> +                   (bctl->sys.target & ~BTRFS_BLOCK_GROUP_DUP) ||
>> +                   (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
>> +                   (bctl->meta.target & ~BTRFS_BLOCK_GROUP_DUP)) &&
>> +                   (num_devs > 1)) {
>> +                       if (bctl->flags & BTRFS_BALANCE_FORCE) {
>> +                               btrfs_info(fs_info, "force conversion of metadata "
>> +                                          "to dup profile on multiple devices");
>> +                       } else {
>> +                               btrfs_err(fs_info, "balance will reduce metadata "
>> +                                         "integrity, use force if you want this");
>> +                               ret = -EINVAL;
>> +                               goto out;
>> +                       }
>> +               }
>>         } while (read_seqretry(&fs_info->profiles_lock, seq));
>>         if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
> 
> ^^^, there should be 3 lines of context here.  It looks like an empty
> line between "} while ..." and "if (bctl..." is missing.
> 
> There is probably more, those just stand out.
> 
> Thanks,
> 
>                 Ilya
> 
I'll rebase and regenerate the patch tonight when I get off of work, I'm
thinking my mail client might have mangled it somehow.
