Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:43428 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752722AbeDYMgP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 08:36:15 -0400
Received: by mail-vk0-f48.google.com with SMTP id v134so13698740vkd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 05:36:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHWVdUXeDs+M1HeyiPxLbQHhw8BCW2SXeOGf69Er4_EQP4tgDA@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <CAJCQCtT7S9Qb-m3-7EXJPwtMT9nuUJjDykHi915KU+fc4fB-aQ@mail.gmail.com> <CAHWVdUXeDs+M1HeyiPxLbQHhw8BCW2SXeOGf69Er4_EQP4tgDA@mail.gmail.com>
From: Ashlie Martinez <ashmrtn@utexas.edu>
Date: Wed, 25 Apr 2018 07:36:14 -0500
Message-ID: <CAFk8rvbzwUyiT0Ey1TkVKAJ6TKoFRgb72z8DwjYaYzATCSEG_A@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Cc: Chris Murphy <lists@colorremedies.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't really know all that much about the btrfs code, but I was
digging around to try and find the cause of this. Given the fact that
inserting a sleep between the fsyncs gives correct behavior, do you
think the issue could be related to how btrfs determines whether or
not to log a change to an inode? I found some code in
btrfs_log_inode_parent() (part of the fsync path for both files and
directories) that appears to check if the inode being fsync-ed is
already in the log and, if it is, returns BTRFS_NO_LOG_SYNC [1]. Since
in both cases we saw issues where the same inode was either changed
parent directories (rename) or was present in multiple directories
(hard link), it seems plausible that this could be the problem. Do you
have any thoughts on this?

[1] https://www.google.com/url?q=https://elixir.bootlin.com/linux/v4.16-rc7/source/fs/btrfs/tree-log.c%23L5563&sa=D&source=hangouts&ust=1524702498584000&usg=AFQjCNE_KadcgkZ7xiIhLOzQCFQoet8Lqw

Thanks,
Ashlie

On Tue, Apr 24, 2018 at 10:16 PM, Vijaychidambaram Velayudhan Pillai
<vijay@cs.utexas.edu> wrote:
> Hi Chris,
>
> On Tue, Apr 24, 2018 at 10:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> I don't have answer to your question, but I'm curious exactly how you
>> simulate a crash? For my own really rudimentary testing I've been doing
>> crazy things like:
>>
>> # grub-mkconfig -o /boot/efi && echo b > /proc/sysrq-trigger
>>
>> And seeing what makes it to disk - or not. And I'm finding a some
>> non-determinstic results are possible even in a VM which is a bit confusing.
>> I'm sure with real hardware I'd find even more inconsistency.
>
> We are using software we developed called CrashMonkey [1]. It
> simulates the state on storage after a crash (taking into accounts
> FLUSH and FUA flags). Talk slides on how it works can be found here
> [2].
>
> It is similar to dm-log-writes if you have used that in the past.
>
> [1] https://github.com/utsaslab/crashmonkey
> [2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf
>
> Thanks,
> Vijay Chidambaram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
