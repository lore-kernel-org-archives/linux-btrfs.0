Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:33865 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdKSVjA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 16:39:00 -0500
Received: by mail-ot0-f169.google.com with SMTP id o23so6164635otd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 13:39:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 19 Nov 2017 14:38:59 -0700
Message-ID: <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Andrei Borzenkov <arvidjaar@gmail.com>, Jeff Mahoney <jeffm@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 19.11.2017 09:17, Chris Murphy пишет:
>> fstrim should trim free space, but it only trims unallocated. This is
>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>> behaved this way with 4.12 also.
>>
>
> Well, I was told it should also trim free space ...
>
> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>

It definitely isn't. If I do a partial balance, then fstrim, I get a
larger trimmed value, corresponding exactly to unallocated space.



-- 
Chris Murphy
