Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34925 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031610AbdEWViD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 17:38:03 -0400
Received: by mail-yw0-f176.google.com with SMTP id l74so81028521ywe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 14:38:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170523170025.sweg3oyzs5f2jxca@merlins.org>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net> <20170523170025.sweg3oyzs5f2jxca@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 May 2017 15:38:01 -0600
Message-ID: <CAJCQCtT1QKpPWmoKhM-LTN3bweW-Yq=fGMjJU+b4wW+h98ydJg@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Marc MERLIN <marc@merlins.org>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 23, 2017 at 11:00 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Thu, May 04, 2017 at 03:55:28AM +0000, Duncan wrote:
>> > But that alone may not fix it, I think you need a newer kernel...
>>
>> Well, while the 4.4 LTS kernel series /is/ getting a bit long in the
>> tooth by now, it's still the second newest LTS series available, 4.9
>> being the newest.
>>
>> And on-list we've long recommended staying within the latest two series
>> in either the LTS or current kernel series, which means the 4.4 series
>> should still be reasonably supported.
>
> For what it's worth, I also had an ext4 filesystem created by some
> debian testing install, tried to convert it, it worked, I rebooted, then
> it worked once and got corrupted and in the end I had to destroy it and
> convert by hand.
>
> I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
> never worked properly any of those times, sadly.

Since the 4.6 total rewrite? There are also recent bug fixes related
to convert in the changelog, it should be working now and if there are
problems Qu is probably interested in getting them fixed.

-- 
Chris Murphy
