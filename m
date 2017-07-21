Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:37645 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964950AbdGUBY1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 21:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <73a8c8a4-a9b3-18d5-35cd-9fbc7e4a1429@gmx.com>
References: <20170720230333.15930-1-jmaggard@netgear.com> <73a8c8a4-a9b3-18d5-35cd-9fbc7e4a1429@gmx.com>
From: Justin Maggard <jmaggard10@gmail.com>
Date: Thu, 20 Jul 2017 18:24:26 -0700
Message-ID: <CAKgsxVT+P4Jrd5-M1u2wvJ85cWVOHtm+mHMs7zRWs2POZaCMDQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test if receive with qgroups corrupts metadata
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: fstests@vger.kernel.org, BTRFS <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 4:44 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2017年07月21日 07:03, Justin Maggard wrote:
>>
>> This test case does some concurrent send/receives with qgroups enabled.
>> Currently (4.13-rc1) this usually results in btrfs check errors, and
>> often also results in a WARN_ON in record_root_in_trans().
>
>
> This is quite interesting.
> Despite subvolume/snapshot creation, receiving is done mostly by doing
> normal read/write/utime/... operations, which are handled quite well.
>
> BTW, the test case is doing send/receive concurrently, is the bug still
> reproducible without concurrency ?
>

I ran it 100 times without concurrency and it didn't reproduce.

-Justin
