Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36605 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbcFOQ3f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 12:29:35 -0400
Received: by mail-ob0-f172.google.com with SMTP id hx8so794213obb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALy3tB31yK8Tu7U1z+wu8urSfZDtHVxO+SQppMhhF5kjyrATJQ@mail.gmail.com>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
	<CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com>
	<CAJCQCtQrBegWBCfM6nqfqNc5u-3M-7pdRn3Wf370oL-MXh9uiQ@mail.gmail.com>
	<CALy3tB31yK8Tu7U1z+wu8urSfZDtHVxO+SQppMhhF5kjyrATJQ@mail.gmail.com>
Date: Wed, 15 Jun 2016 10:29:34 -0600
Message-ID: <CAJCQCtT32cJr7EfEFsh0YgP8t+pCX6xcAUb=8ofp3wUGezSbhQ@mail.gmail.com>
Subject: Re: Balance fails with unallocated diskspace
From: Chris Murphy <lists@colorremedies.com>
To: Nisse Karlsson <nisse@xcorp.at>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 10:00 AM, Nisse Karlsson <nisse@xcorp.at> wrote:
> Thanks,
>
> Will update the bug-report with more information.
> Not sure I trust the device info in dmesg though, when running device
> delete /dev/sdh /files it still refers to to sdb in dmesg. I think it
> just shows the device that was used for mounting the fs.

Hmm that's not very helpful if it's not reporting the device that's
having the enospc problem...

Anyway, the debugfs output should probably make this more clear, but
also the dmesg will still be useful in that it'll report what block
group was being worked on at the time. So it'll be possible to see
that in the debugfs output along with stripe info for that bg.


-- 
Chris Murphy
