Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:60063 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaIKJsU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 05:48:20 -0400
Received: by mail-la0-f51.google.com with SMTP id gi9so10523265lab.24
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 02:48:19 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5411280A.9010601@jp.fujitsu.com>
References: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
	<5411280A.9010601@jp.fujitsu.com>
Date: Thu, 11 Sep 2014 10:48:19 +0100
Message-ID: <CAL3q7H41wCtJ08h=91+wqzXK+DyBRLhNQBK1PtR9882Ddb1EKQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
From: Filipe David Manana <fdmanana@gmail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 11, 2014 at 5:41 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> Hi Filipe,
>
> (2014/09/11 0:10), Filipe Manana wrote:
>> The behaviour of a 'chattr -c' consists of getting the current flags,
>> clearing the FS_COMPR_FL bit and then sending the result to the set
>> flags ioctl - this means the bit FS_NOCOMP_FL isn't set in the flags
>> passed to the ioctl. This results in the compression property not being
>> cleared from the inode - it was cleared only if the bit FS_NOCOMP_FL
>> was set in the received flags.
>>
>> Reproducer:
>>
>>      $ mkfs.btrfs -f /dev/sdd
>>      $ mount /dev/sdd /mnt && cd /mnt
>>      $ mkdir a
>>      $ chattr +c a
>>      $ touch a/file
>>      $ lsattr a/file
>>      --------c------- a/file
>>      $ chattr -c a
>>      $ touch a/file2
>>      $ lsattr a/file2
>>      --------c------- a/file2
>>      $ lsattr -d a
>>      ---------------- a
>>
>> Reported-by: Andreas Schneider <asn@cryptomilk.org>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>   fs/btrfs/ioctl.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index a010c44..8e6950c 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -333,6 +333,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>
>>       } else {
>>               ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>> +             ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>
> IMHO, this patch is going on a wrong way since this patch
> changes the meaning of chattr. Here is the correct behavior.
>
> flag | BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS |
> =====+======================+========================+
> +c   |        set           |         unset          |
> -c   |       unset          |         unset          |
>
> However, by your change, chattr -c results in unset
> BTRFS_INODE_COMPRESS and *set* BTRFS_INODE_NOCOMPRESS.

Right, for the reason mentioned below it's not a big deal, but
nevertheless better to not break the expectations and behaviour from
pre-properties era.

> It's because btrfs_set_prop() will finally lead to
> prop_compression_apply() with setting its value to "".
> It's the behavior of calling ioctl() with FS_NOCOMP_FL.
>
> Please note that inode flag without both BTRFS_INODE_COMPRESS
> nor BTRFS_INODE_NOCOMPRESS has its own meaning: whether file
> is compress or not is decided by "compress" mount option.

Right, which will set NOCOMPRESS if compression of the first write is
worthless (compressed size >= uncompressed size).
The fs has the right of setting NOCOMPRESS/FS_NOCOMP_FL if it wishes
to (due to lack of any specification that forbids it).

>
> My suggestion is as follows and I'll write a patch based
> on it soon.
>
>  - Change the meaning of btrfs.compression == "" to mean
>    unset both BTRFS_INODE_COMPRESS and BTRFS_INODE_NOCOMPRESS,
>    for chattr -c.

Do that and you're breaking existing semantics - existing apps or
users might already depend on the current semantics/apis (i.e. not a
good idea).
However you can add a new value that implements those semantics.

>  - Add new value of "btrfs.compression" property, for example
>    "no" or "off", to mean unset BTRFS_INODE_COMPRESS and set
>    BTRFS_INODE_NOCOMPRESS. It's for ioctl() with FS_NOCOMP_FL.
>  - Unify duplicated code of changing inode flags to props.c.
>
> Thanks,
> Satoru
>
>> +             if (ret && ret != -ENODATA)
>> +                     goto out_drop;
>>       }
>>
>>       trans = btrfs_start_transaction(root, 1);
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
