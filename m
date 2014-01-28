Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:62641 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaA1Af2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 19:35:28 -0500
Received: by mail-vb0-f45.google.com with SMTP id m10so3884173vbh.18
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 16:35:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140127181134.GD6498@twin.jikos.cz>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
	<1390829312-814-6-git-send-email-Gerhard@Heift.Name>
	<20140127181134.GD6498@twin.jikos.cz>
Date: Tue, 28 Jan 2014 01:35:27 +0100
Message-ID: <CACeaM8-BezLJqx1mOM9z3N9okz1nuw+5c9XS0Ga32C8WF+cqsA@mail.gmail.com>
Subject: Re: [PATCH RFCv2 5/6] btrfs: search_ioctl: direct copy to userspace
From: Gerhard Heift <gerhard@heift.name>
To: David Sterba <dsterba@suse.cz>, Gerhard Heift <gerhard@heift.name>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-27 David Sterba <dsterba@suse.cz>:
> On Mon, Jan 27, 2014 at 02:28:31PM +0100, Gerhard Heift wrote:
>> By copying each found item seperatly to userspace, we only need a small buffer
>> in the kernel. This allows to run a large search inside of a single call.
>>
>> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
>> ---
>>  fs/btrfs/ioctl.c | 107 ++++++++++++++++++++++++++++++++++++-------------------
>>  1 file changed, 71 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index c44fcdd..38403e6 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1905,20 +1908,47 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>>               sh.transid = found_transid;
>>
>>               /* copy search result header */
>> -             memcpy(buf + *sk_offset, &sh, sizeof(sh));
>> +             if (copy_to_user(buf + *sk_offset, &sh, sizeof(sh))) {
>> +                     ret = -EFAULT;
>> +                     goto err;
>> +             }
>> +
>>               *sk_offset += sizeof(sh);
>>
>>               if (item_len) {
>> -                     char *p = buf + *sk_offset;
>> +                     /* resize internal buffer if needed */
>> +                     if (content_buffer_size < item_len) {
>> +                             kfree(content_buffer);
>> +
>> +                             content_buffer_size =
>> +                                     ALIGN(item_len, PAGE_SIZE);
>> +
>> +                             content_buffer = kmalloc_track_caller(
>> +                                     content_buffer_size, GFP_KERNEL);
>
> So that's another allocation. I see it's due to read_extent_buffer()
> that wants a kernel memory, and the buffer size is again up to the item
> size, potentially spanning multiple pages.
>
>> +                             if (!content_buffer) {
>> +                                     content_buffer_size = 0;
>> +                                     ret = -ENOMEM;
>> +                                     goto err;
>> +                             }
>> +                     }
>> +
>>                       /* copy the item */
>> -                     read_extent_buffer(leaf, p,
>> +                     read_extent_buffer(leaf, content_buffer,
>>                                          item_off, item_len);
>
> My suggestion is to introduce read_extent_buffer_user that does
> copy_to_user instead of the memcpy. It is code duplication, but we can
> clean it in a separate patch.

This was an approach I have already tried, but it did not work for me.
After a few calls the kernel was frozen. I did not know, what caused
the freeze, perhaps it was a wrong change I made while testing.

I check, if it works now.

>> +
>> +                     if (copy_to_user(buf + *sk_offset,
>> +                                      content_buffer, item_len)) {
>> +                             ret = -EFAULT;
>> +                             goto err;
>> +                     }
>> +
>>                       *sk_offset += item_len;
>>               }
>>               (*num_found)++;
>>
>>               if (ret) /* -EOVERFLOW from above */
>> -                     goto overflow;
>> +                     goto err;
>>
>>               if (*num_found >= sk->nr_items)
>>                       break;
>> @@ -1936,14 +1966,25 @@ advance_key:
>>               key->objectid++;
>>       } else
>>               ret = 1;
>> -overflow:
>> +err:
>> +     /*
>> +         0: all items from this leaf copied, continue with next
>> +         1: more items can be copied, but buffer is too small or all items
>> +            were found. Either way, it will stops the loop which iterates to
>> +            the next leaf
>> +         -EOVERFLOW: item was to large for buffer
>> +         -ENOMEM: could not allocate memory for a temporary extent buffer
>> +         -EFAULT: could not copy extent buffer back to userspace
>> +     */
>
> Please use the kernel style for comments.

Fixed.

>> +     kfree(content_buffer);
>> +
>>       return ret;
>>  }
>>
>> @@ -2011,34 +2053,39 @@ err:
>>  static noinline int btrfs_ioctl_tree_search(struct file *file,
>>                                          void __user *argp)
>>  {
>> -      struct btrfs_ioctl_search_args *args;
>> -      struct inode *inode;
>> -      int ret;
>> +     struct btrfs_ioctl_search_args __user *usarg;
>> +     struct btrfs_ioctl_search_key *sk;
>> +     struct inode *inode;
>> +     int ret;
>>
>>       if (!capable(CAP_SYS_ADMIN))
>>               return -EPERM;
>>
>> -     args = memdup_user(argp, sizeof(*args));
>> -     if (IS_ERR(args))
>> -             return PTR_ERR(args);
>> +     usarg = (struct btrfs_ioctl_search_args __user *)argp;
>> +
>> +     sk = memdup_user(&usarg->key, sizeof(*sk));
>
> Search key is 13x u64 = 104 bytes, you can use a local variable. This is
> usually possible in ioctl functions, the stack is not deep at this
> moment and will usually not grow too much. Removing the allocation makes
> it a bit more resilient against ENOMEM conditions.

Thanks for the hint. In the new version I will use local variables for
the search argument in both versions.

>> +     if (IS_ERR(sk))
>> +             return PTR_ERR(sk);
>>
>>       inode = file_inode(file);
>> -     ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
>> +     ret = search_ioctl(inode, sk, sizeof(usarg->buf), usarg->buf);
>
> Ok, v1 ioctl uses the same code in the end.
>
>> +     /* the origin ioctl does handle too large results by returning an item
>> +     * with a len of 0 */
>>       if (ret == -EOVERFLOW)
>>               ret = 0;
>> -     if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
>> +     if (ret == 0 && copy_to_user(argp, sk, sizeof(*sk)))
>>               ret = -EFAULT;
>> -     kfree(args);
>> +     kfree(sk);
>>       return ret;
>>  }
