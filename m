Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60387 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3FDLTh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 07:19:37 -0400
Received: by mail-wi0-f177.google.com with SMTP id hr14so67724wib.16
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jun 2013 04:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+a=Yy45WgYRvpwUZ4BTfvi8bA-OB=XcGGcm6XXA5fmUwvp+sw@mail.gmail.com>
References: <1370267902-9139-1-git-send-email-bergwolf@gmail.com>
 <1370267902-9139-5-git-send-email-bergwolf@gmail.com> <20130604083206.GL28112@mwanda>
 <CA+a=Yy45WgYRvpwUZ4BTfvi8bA-OB=XcGGcm6XXA5fmUwvp+sw@mail.gmail.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 4 Jun 2013 19:19:16 +0800
Message-ID: <CA+a=Yy5W45YyTVXVAsLHb9YsHjEpc2zoRDE_R5vxn1zq7V7TTw@mail.gmail.com>
Subject: Re: [PATCH 4/9] staging/lustre: clean up and remove libcfs/linux/linux-fs.c
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 4, 2013 at 6:23 PM, Peng Tao <bergwolf@gmail.com> wrote:
> On Tue, Jun 4, 2013 at 4:32 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> On Mon, Jun 03, 2013 at 09:58:17PM +0800, Peng Tao wrote:
>>>  int libcfs_kkuc_msg_put(struct file *filp, void *payload)
>>>  {
>>>       struct kuc_hdr *kuch = (struct kuc_hdr *)payload;
>>> +     ssize_t count = kuch->kuc_msglen;
>>> +     loff_t offset = 0;
>>> +     mm_segment_t fs;
>>>       int rc = -ENOSYS;
>>>
>>>       if (filp == NULL || IS_ERR(filp))
>>> @@ -165,11 +168,18 @@ int libcfs_kkuc_msg_put(struct file *filp, void *payload)
>>>               return -ENOSYS;
>>>       }
>>>
>>> -     {
>>> -             loff_t offset = 0;
>>> -             rc = filp_user_write(filp, payload, kuch->kuc_msglen,
>>> -                                  &offset);
>>> +     fs = get_fs();
>>> +     set_fs(KERNEL_DS);
>>> +     while ((ssize_t)count > 0) {
>>> +             rc = vfs_write(filp, (const void __user *)payload,
>>> +                            count, &offset);
>>> +             if (rc < 0)
>>> +                     break;
>>> +             count -= rc;
>>> +             payload += rc;
>>> +             rc = 0;
>>>       }
>>> +     set_fs(fs);
>>>
>>>       if (rc < 0)
>>>               CWARN("message send failed (%d)\n", rc);
>>
>> This was all there in the original code, it has just been shifted.
>> Still, I had some questions about it.  "payload" is a pointer to
>> kernel stack memory, wouldn't the access_ok() check in vfs_write()
>> fail every time on x86?
>>
I've run some tests and it turns out that access_ok() doesn't deny
vfs_write() when passed in allocated kernel memory (e.g.,
mdc_wr_kuc()). There is indeed a bug in mdc_wr_kuc() for which I will
send a fix later. However, I cannot test the specific stack memory
write path because of a known issue of Lustre
(https://jira.hpdd.intel.com/browse/LU-2489). And FYI, the Lustre hsm
feature is still under development.

Thanks,
Tao

> Thanks for reviewing. I am not familiar with access_ok() but I think
> you are right and I'll test to see if it really breaks. In the
> meantime, I took a look at other kernel callers of vfs_write() and
> btrfs is also calling vfs_write() to write kernel stack memory
> (fs/btrfs/send.c: send_header->write_buf->vfs_write). So I CC'ed btrfs
> list in case someone knows better than I do.
>
>> Some of the casting is not needed.  No need to cast "count" because
>> it is already ssize_t.  I haven't tested but I think Sparse will
>> complain about the __user cast until __force is added.  No need for
>> the cast to const.
>>
> Thanks. I will fix it.
>
>> I worry about partial writes and that this could be a forever loop
>> but I don't know enough about anything to say if that's possible.
>> Probably not.
>>
> For partial writes, both payload and count are advanced properly. So
> it won't loop forever.
>
> Thanks,
> Tao
