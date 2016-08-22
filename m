Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35251 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbcHVIFg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 04:05:36 -0400
Received: by mail-qk0-f175.google.com with SMTP id v123so79439652qkh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 01:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cc2b06b5-7598-67ab-d528-9087cbf75f45@cn.fujitsu.com>
References: <cc2b06b5-7598-67ab-d528-9087cbf75f45@cn.fujitsu.com>
From: Lukas Herbolt <lherbolt@redhat.com>
Date: Mon, 22 Aug 2016 10:05:35 +0200
Message-ID: <CAM4Jq_4t0uGMA2KtGJWgM36wyu7czWjZQD0Lchh6n=gGZ9F+WQ@mail.gmail.com>
Subject: Re: [dm-devel] [Regression/Behavior change]dm-flakey corrupt read
 bio, even the feature is drop_writes
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There is patch from Mike. It's part of current pull request to 4.8-rc1
For more details check:
 - https://www.redhat.com/archives/dm-devel/2016-July/msg00561.html
 - https://www.redhat.com/archives/dm-devel/2016-August/msg00109.html

Lukas

On Mon, Aug 22, 2016 at 9:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi, Mike and btrfs and dm guys
>
> When doing regression test on v4.8-rc1, we found that fstests/btrfs/056
> always fails. With the following dmesg:
> ---
> Buffer I/O error on dev dm-0, logical block 1310704, async page read
> Buffer I/O error on dev dm-0, logical block 16, async page read
> Buffer I/O error on dev dm-0, logical block 16, async page read
> ---
>
> And bisect leads to the following commits:
> ---
> commit 99f3c90d0d85708e7401a81ce3314e50bf7f2819
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Fri Jul 29 13:19:55 2016 -0400
>
>     dm flakey: error READ bios during the down_interval
> ---
>
> While according to the document of dm-flakey, it says that when using
> drop_writes feature, read bios are not affected:
> ---
>   drop_writes:
>         All write I/O is silently ignored.
>         Read I/O is handled correctly.
> ---
>
> If I understand the word "correctly" correctly, it should means READ I/0 is
> handled without problem.
>
> However with this commit, it also corrupt the read bio, leading to the test
> failure.
>
>
> At least there are two fixes available here;
> 1) Fix fstest scripts
>    The related macro is "_flakey_drop_and_remount yes", which will
>    check the fs during the "drop_writes" time.
>
>    Currently, only btrfs/056 calls "_flakey_drop_and_remount" with
>    "yes". So other test cases are not affected.
>
>    However, even we move the fsck outside of the "drop_writes" range,
>    although test case can pass without problem, but we will still
>    get a dmesg error:
>    "Buffer I/O error on dev dm-0, logical block 1310704, async page read"
>
> 2) Revert to flakey behavior to allow READ bio
>    Then everything is back to the old good days.
>
> Not sure which one is correct for current use case, as I'm not familiar with
> dm codes.
>
> Any idea to fix dm-flaky and keep the READ bio behavior?
>
> Thanks,
> Qu
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Lukas Herbolt
RHCE, RH436, BSc, SSc
Senior Technical Support Engineer
Global Support Services (GSS)
Email:    lherbolt@redhat.com
