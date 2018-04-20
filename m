Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:38412 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754470AbeDTJlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:41:35 -0400
Received: by mail-vk0-f42.google.com with SMTP id b16so4890726vka.5
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 02:41:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A84EA5CF@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <516DDBE5B1D92D42BCF7A2E37F045A5D01A84EA5CF@G08CNEXMBPEKD02.g08.fujitsu.local>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 20 Apr 2018 10:41:34 +0100
Message-ID: <CAL3q7H6AEj_x87qSjhSs=Lfw6vdkKdCKvx4AtdWDRQH0Vwv1DA@mail.gmail.com>
Subject: Re: [bug report] btrfs fail when run xfstests-dev/btrfs/007
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 10:23 AM, Gu, Jinxiang <gujx@cn.fujitsu.com> wrote:
> Hi,
>
> Here's a bug report.
> Kernel v4.17-rc1 failed xfstests-dev/btrfs/007.
> It is not always happens.( occurred times/test times: 1/20)

You don't need to check how many times it fails... You have a fsstress
seed from the .full file, that's all that matters.

I'll take a look at it, it's due to a missing truncate operation.

thanks

>
> And I confirmed this test using kernel v4.16-rc1.
> It also occurred sometimes.
>
> LOG when using kernel v4.17-rc1.
> btrfs/007        [failed, exit status 1] - output mismatch (see /home/gujx/xfstests-dev/results//btrfs/007.out.bad)
>     --- tests/btrfs/007.out     2017-08-18 12:45:06.560413266 +0800
>     +++ /home/gujx/xfstests-dev/results//btrfs/007.out.bad      2018-04-17 13:24:06.887089998 +0800
>     @@ -1,4 +1,5 @@
>      QA output created by 007
>      *** test send / receive
>     -*** done
>     +failed: '/home/gujx/xfstests-dev/src/fssum -r /tmp/tmp.SkEUIXw683/incr.fssum /mnt/scratch/incr'
>     +(see /home/gujx/xfstests-dev/results//btrfs/007.full for details)
>      *** unmount
>     ...
>     (Run 'diff -u tests/btrfs/007.out /home/gujx/xfstests-dev/results//btrfs/007.out.bad'  to see the entire diff)
>
> And the detail can be found in the attachment.
>
> Thanks, Gu Jinxiang
>
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
