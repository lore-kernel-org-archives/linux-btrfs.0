Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48856 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA1Ad7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 19:33:59 -0500
Received: by mail-vb0-f46.google.com with SMTP id o19so3896325vbm.33
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 16:33:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140127174113.GC6498@twin.jikos.cz>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
	<1390829312-814-5-git-send-email-Gerhard@Heift.Name>
	<20140127174113.GC6498@twin.jikos.cz>
Date: Tue, 28 Jan 2014 01:33:58 +0100
Message-ID: <CACeaM898oNxquu8p4vaMV13Erbro_pPzt1gLRkGTP7JhpknVxw@mail.gmail.com>
Subject: Re: [PATCH RFCv2 4/6] btrfs: new ioctl TREE_SEARCH_V2
From: Gerhard Heift <gerhard@heift.name>
To: David Sterba <dsterba@suse.cz>, Gerhard Heift <gerhard@heift.name>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-27 David Sterba <dsterba@suse.cz>:
> On Mon, Jan 27, 2014 at 02:28:30PM +0100, Gerhard Heift wrote:
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2032,6 +2032,52 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
>>       return ret;
>>  }
>>
>> +static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
>> +                                        void __user *argp)
>> +{
>> +     struct btrfs_ioctl_search_args_v2 *args;
>> +     struct inode *inode;
>> +     int ret;
>> +     char *buf;
>> +     size_t buf_size;
>> +
>> +     if (!capable(CAP_SYS_ADMIN))
>> +             return -EPERM;
>> +
>> +     /* copy search header and buffer size */
>> +     args = memdup_user(argp, sizeof(*args));
>> +     if (IS_ERR(args))
>> +             return PTR_ERR(args);
>> +
>> +     buf_size = args->buf_size;
>> +
>> +     if (buf_size < sizeof(struct btrfs_ioctl_search_header)) {
>> +             kfree(args);
>> +             return -ENOMEM;
>
> ENOMEM does not seem correct here, it's not a memory allocation failure
> but rather an underflow of the buffer size, possibly EINVAL or EOVERFLOW
> as the other checks return.

Saw this to during the rewrite, fixed it for the new version.

>> +     }
>> +
>> +     /* limit memory */
>> +     if (buf_size > PAGE_SIZE * 32)
>> +             buf_size = PAGE_SIZE * 32;
>> +
>> +     buf = memdup_user(argp->buf, buf_size);
>
> Memory allocations are not that easy, getting a contiguous 32 * 4k = 128k
> buffer may often fail. And the point of the V2 ioctl was to avoid
> allocating the buffer, and do copy_to_user directly.
>
> Also, you remove this code in the next patch, I don't think this level
> of patch granularity is necessary.

In the new version I do it the other way around, first direct copy,
then the new ioctl, so this is not necessary any more.

>> +     if (IS_ERR(buf)) {
>> +             kfree(args);
>> +             return PTR_ERR(buf);
>> +     }
>> +
>> +     inode = file_inode(file);
>> +     ret = search_ioctl(inode, &args->key, buf_size, buf);
>> +     if (ret == 0 && (
>> +             copy_to_user(argp, args, sizeof(*args)) ||
>> +             copy_to_user(argp->buf, buf, buf_size)
>> +             ))
>> +             ret = -EFAULT;
>> +     kfree(buf);
>> +     kfree(args);
>> +     return ret;
>> +}
