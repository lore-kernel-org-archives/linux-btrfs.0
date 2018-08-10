Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41500 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeHJLQO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 07:16:14 -0400
Received: by mail-oi0-f67.google.com with SMTP id k12-v6so14556955oiw.8
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 01:47:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 04:47:19 -0400
Message-ID: <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately that doesn't appear to be it, a forced restart and
attempted to mount with skip_balance leads to the same thing.

20 minutes in btrfs-transactio had a large burst of reads then started
spinning the CPU with the disk idle.

Is this recoverable? I could leave it for a day or so if it may make
progress, but if not I'd like to start on other options.

On Fri, Aug 10, 2018 at 3:59 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 8/10/18 3:40 PM, Dan Merillat wrote:
>> Kernel 4.17.9, 11tb BTRFS device (md-backed, not btrfs raid)
>>
>> I was testing something out and enabled quota groups and started getting
>> 2-5 minute long pauses where a btrfs-transaction thread spun at 100%.
>
> Looks pretty like a running balance and quota.
>
> Would you please try with balance disabled (temporarily) with
> skip_balance mount option to see if it works.
>
> If it works, then either try resume balance, or just cancel the balance.
>
> Nowadays balance is not needed routinely, especially when you still have
> unallocated space and enabled quota.
>
> Thanks,
> Qu
>
>>
>> Post-reboot the mount process spinds at 100% CPU, occasinally yielding
>> to a btrfs-transaction thread at 100% CPU.  The switchover is marked
>> by a burst of disk activity in btrace.
>>
>> Btrace shows all disk activity is returning promptly - no hanging submits.
>>
>> Currently the mount is at 6+ hours.
>>
>> Suggestions on how to go about debugging this?
>>
>
