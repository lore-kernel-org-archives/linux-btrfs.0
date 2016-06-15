Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34333 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcFOQAu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 12:00:50 -0400
Received: by mail-lf0-f54.google.com with SMTP id j7so18645448lfg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:00:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQrBegWBCfM6nqfqNc5u-3M-7pdRn3Wf370oL-MXh9uiQ@mail.gmail.com>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
 <CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com> <CAJCQCtQrBegWBCfM6nqfqNc5u-3M-7pdRn3Wf370oL-MXh9uiQ@mail.gmail.com>
From: Nisse Karlsson <nisse@xcorp.at>
Date: Wed, 15 Jun 2016 18:00:29 +0200
Message-ID: <CALy3tB31yK8Tu7U1z+wu8urSfZDtHVxO+SQppMhhF5kjyrATJQ@mail.gmail.com>
Subject: Re: Balance fails with unallocated diskspace
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks,

Will update the bug-report with more information.
Not sure I trust the device info in dmesg though, when running device
delete /dev/sdh /files it still refers to to sdb in dmesg. I think it
just shows the device that was used for mounting the fs.

//Nisse

2016-06-15 17:33 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>
>
> On Wed, Jun 15, 2016 at 3:58 AM, Nisse Karlsson <nisse@xcorp.at> wrote:
>>
>>
>> Unallocated:
>>    /dev/sdb 222.50GiB
>
>
> The filed bug report needs a complete dmesg attached (at least from the time
> the fs is mounted and including enospc), what mount options are used, and
> what btrfs-progs version is used.
>
> But the fact sdb reports this much free space and yet the enospc kernel
> message you report later refers to sdb is unexpected, so it's good to have
> filed a bug.
>
> You can also include as an attachment the output from btrfs-debugfs which is
> a python script not normally installed as a part of btrfs-progs but you can
> get it from here:
> https://github.com/kdave/btrfs-progs
>
> btrfs-debugfs -b <mountpoint>
>
>
>
> --
> Chris Murphy
