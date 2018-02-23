Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36325 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbeBWQfq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 11:35:46 -0500
Received: by mail-vk0-f41.google.com with SMTP id q7so5749520vkh.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 08:35:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+EzBbCronNb25yxmn8zsSUwQqJC26fWJ+XmFo-jdBHSd9s3uA@mail.gmail.com>
References: <CA+EzBbCronNb25yxmn8zsSUwQqJC26fWJ+XmFo-jdBHSd9s3uA@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Fri, 23 Feb 2018 10:35:44 -0600
Message-ID: <CA+EzBbADyzoLcDDPV_z4GStFgPG3_mbGZXnf37o-UVz7mSq6OQ@mail.gmail.com>
Subject: Re: btrfs crash consistency bug : Blocks allocated beyond eof are lost
To: linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[Fsync issue in btrfs]
In addition to the above, I would like to bring to your notice that :
After doing a fallocate or fallocate zero_range with keep size option,
a fsync() operation would have no effect at all. If we crash after the
fsync, on recovery the blocks allocated due to the fallocate call are
lost. This aligns with a patch work here[1] for a similar issue with
punch_hole. A simple test scenario that reproduces this bug is :

1. write (0-16K) to a file foo
2. sync()
3. fallocate keep_size (16K - 20K)
4. fsync(foo)
5. Crash

On recovery, all blocks allocated in step 3 are lost (this is the true
even when fallocate is replaced by zero_range operation supported in
kernel 4.16 )
Could you explain why a fsync() of the file would still not persist
the metadata(block count in this case), across power failures?

[1] https://patchwork.kernel.org/patch/5830801/


Thanks,
Jayashree Mohan





On Wed, Feb 21, 2018 at 8:23 PM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
> Hi,
>
> On btrfs (as of kernel 4.15), say we fallocate a file with keep_size
> option, followed by fdatasync() or fsync(). If we now crash, on
> recovery we see a wrong block count and all the blocks allocated
> beyond the eof are lost. This bug was reported(xfstest generic/468)
> and patched on ext4[1], and a variant of this, that did not recover
> the correct file size was patched in f2fs[2]. I am wondering why this
> is still not fixed in btrfs. You can reproduce this bug on btrfs using
> a tool called CrashMonkey that we are building at UT Austin, which is
> a test harness for filesystem crash consistency checks[3]
>
> To reproduce the bug, simply run :
>  ./c_harness -f /dev/sda -d /dev/cow_ram0 -t btrfs -e 102400  -v
> tests/generic_468.so
>
> Is there a reason why this is not yet patched in btrfs? I don't see
> why even after a fsync(), losing the blocks allocated beyond the eof
> are acceptable.
>
> [1] https://patchwork.kernel.org/patch/10120293/
> [2] https://sourceforge.net/p/linux-f2fs/mailman/message/36104201/
> [3] https://github.com/utsaslab/crashmonkey
>
> Thanks,
>
> Jayashree Mohan
> 2nd Year PhD in Computer Science
> University of Texas at Austin.
