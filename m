Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33661 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbDUC0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 22:26:24 -0400
Received: by qkx62 with SMTP id 62so199670684qkx.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 19:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5535119E.3050005@redhat.com>
References: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
	<5535119E.3050005@redhat.com>
Date: Tue, 21 Apr 2015 10:26:23 +0800
Message-ID: <CAPBX1x+0kHqhWeq91X3f1XV7RR5=GrOjs1c7t7k+P+nyyk2_XQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: fix btrfs quota rescan failed on PPC64 arch
From: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for review.

On Mon, Apr 20, 2015 at 10:47 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/20/15 12:33 AM, xuw2015@gmail.com wrote:
>> From: George Wang <xuw2015@gmail.com>
<snip>
>> This means the value "_IOW*" will be negative when we store it in the int
>> variables. Such as the "BTRFS_IOC_QGROUP_CREATE", it will be "0x4010942e" on
>> X86_64, but "0x8010942e" on PPC64.
>> Notice that the IOC values are the "unsigned long" type, so we use the
>> "unsigned long" to store it, and this can insure the comparison between the
>> variable and BTRFS_IOC_* valid.
>
> Looks good - very strange that the manpage states that the interface takes
> an int.  :(

I think maybe the manpage of ioctl is stale. But int can also work
except for comparison.
And fortunately the kernel interface is unsigned int, such as btrfs:

5217 long btrfs_ioctl(struct file *file, unsigned int
5218         cmd, unsigned long arg)

>
> But - an "unsigned int" would be enough, right?  I don't think it needs
> to be an unsigned long.  *shrug*

unsigned int will be OK. But the btrfs-progs is user space, so the
ioctl I think it should be
consistent with the glibc:
/usr/include/sys/ioctl.h:extern int ioctl (int __fd, unsigned long int
__request, ...) __THROW;
unsigned long int is same with unsigned long. So maybe the unsigned
long will be better?

Thanks,
George
