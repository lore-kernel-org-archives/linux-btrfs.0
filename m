Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35906 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbcFPRLW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 13:11:22 -0400
Received: by mail-lf0-f50.google.com with SMTP id q132so44753236lfe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 10:11:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT32cJr7EfEFsh0YgP8t+pCX6xcAUb=8ofp3wUGezSbhQ@mail.gmail.com>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
 <CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com>
 <CAJCQCtQrBegWBCfM6nqfqNc5u-3M-7pdRn3Wf370oL-MXh9uiQ@mail.gmail.com>
 <CALy3tB31yK8Tu7U1z+wu8urSfZDtHVxO+SQppMhhF5kjyrATJQ@mail.gmail.com> <CAJCQCtT32cJr7EfEFsh0YgP8t+pCX6xcAUb=8ofp3wUGezSbhQ@mail.gmail.com>
From: Nisse Karlsson <nisse@xcorp.at>
Date: Thu, 16 Jun 2016 19:11:01 +0200
Message-ID: <CALy3tB1Gx-0rbC7UBesxhgtvhH37EpOQjp34NuQFSL+vsWg92Q@mail.gmail.com>
Subject: Re: Balance fails with unallocated diskspace
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After some more balance passes with different values of -dusage and
removal of some files (around 50GB) I finally managed to convert the
volume back to raid1.
So my problem is solved, but it still seems like bug to me.

//Nisse

2016-06-15 18:29 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Wed, Jun 15, 2016 at 10:00 AM, Nisse Karlsson <nisse@xcorp.at> wrote:
>> Thanks,
>>
>> Will update the bug-report with more information.
>> Not sure I trust the device info in dmesg though, when running device
>> delete /dev/sdh /files it still refers to to sdb in dmesg. I think it
>> just shows the device that was used for mounting the fs.
>
> Hmm that's not very helpful if it's not reporting the device that's
> having the enospc problem...
>
> Anyway, the debugfs output should probably make this more clear, but
> also the dmesg will still be useful in that it'll report what block
> group was being worked on at the time. So it'll be possible to see
> that in the debugfs output along with stripe info for that bg.
>
>
> --
> Chris Murphy
