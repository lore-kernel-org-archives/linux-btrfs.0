Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44770 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbeHJNzI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 09:55:08 -0400
Received: by mail-oi0-f43.google.com with SMTP id s198-v6so15150348oih.11
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 04:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com> <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com> <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 07:25:37 -0400
Message-ID: <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 6:51 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 8/10/18 6:42 PM, Dan Merillat wrote:
>> On Fri, Aug 10, 2018 at 6:05 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> But considering your amount of block groups, mount itself may take some
> time (before trying to resume balance).

I'd believe it, a clean mount took 2-3 minutes normally.

btrfs check ran out of RAM eventually so I killed it and went on to
trying to mount again.

readonly mounted pretty quickly, so I'm just letting -o remount,rw
spin for however long it needs to.  Readonly access is fine over the
weekend, and hopefully it will be done by monday.

To be clear, what exactly am I watching with dump-tree to monitor
forward progress?

Thanks again for the help!
