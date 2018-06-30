Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:39723 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936131AbeF3ABo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 20:01:44 -0400
Received: by mail-oi0-f48.google.com with SMTP id d189-v6so1221944oib.6
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 17:01:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30ad064e-99e0-4398-2af7-d97f9577ff8f@hamburg.ccc.de>
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
 <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com> <30ad064e-99e0-4398-2af7-d97f9577ff8f@hamburg.ccc.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 29 Jun 2018 18:01:43 -0600
Message-ID: <CAJCQCtTV8UFdQUA8xKRzfQmKABsNCYFwR9XdvbD3br_cJ-Dp2w@mail.gmail.com>
Subject: Re: btrfs suddenly think's it's raid6
To: marble <marble@hamburg.ccc.de>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 4:09 PM, marble <marble@hamburg.ccc.de> wrote:
> Hey,
> Thanks for the quick reply :-)
>
>> Is there anything like unexpected power loss happens?
> Power loos may have happened. It was power via a RPi.
>> And would you provide the following data for debugging?
>>
>> # btrfs ins dump-super -fFa /dev/mapper/black
> See attachment.
>> And further more, what's the device mapper setup for /dev/mapper/black?
>> Is there anything like RAID here?
> This is due to LUKS I think. "black" is the name I gave to cryptsetup open.

No log_root* in the super. So no fsyncing at the time? What was
happening at the time of the power loss?

Pretty weird, all three supers are OK and yet two copies of the fs
tree are corrupt. Why doesn't it fall back automatically to one of the
other roots?

You could try 'mount -o usebackuproot,ro' and see if that's permissive
enough to succeed.

I wonder if the drive firmware reordered things contrary to Btrfs
expectation right at the powerfail - or even if the powerfail caused
the drive firmware to do the writes in the wrong order?


-- 
Chris Murphy
