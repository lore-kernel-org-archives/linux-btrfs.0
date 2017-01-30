Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33051 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbdA3B04 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 20:26:56 -0500
Received: by mail-qk0-f196.google.com with SMTP id 11so16813720qkl.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jan 2017 17:26:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170129201650.wvpzaz45r5uzsvrb@angband.pl>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
 <20170129201650.wvpzaz45r5uzsvrb@angband.pl>
From: Subscription Account <4subsacct+btrfs@gmail.com>
Date: Sun, 29 Jan 2017 20:26:54 -0500
Message-ID: <CAHMMHbfUkrpN4+pJwAgRP_LqezC1uY8w0p5e-P1LDRUW06KyMw@mail.gmail.com>
Subject: Re: Raid1 won't mount degraded
To: Adam Borowski <kilobyte@angband.pl>
Cc: Subscription Account <4subsacct+btrfs@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 29, 2017 at 3:16 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sun, Jan 29, 2017 at 08:12:56AM -0500, Subscription Account wrote:
>> I had to remove one disk from raid 1 and I rebooted the system and was
>> able to mount in degraded mode. Then I powered off the system added a
>> new disk and when I am trying to mount the btrfs filesystem in
>> degraded mode it will no longer mount it read-write. I can mount
>> read-only though.
>>
>> [ 2506.816795] BTRFS: missing devices(1) exceeds the limit(0),
>> writeable mount is not allowed
>>
>> In the read-only mode I am not able to add a new device or replace :(.
>> Please help.
>
> A known problem; you can mount rw degraded only once, if you don't fix the
> degradation somehow (by adding a device or converting down), you can't mount
> rw again.

Uh oh! I wish I know that I only had one shot :(. Just to be clear,
once the rw mount is done first time, and a replace operation or a add
followed by delete missing is executed, irrespective of raid rebuild
status, if the machine reboots, it will still be mounted without
issues and rebuild/balance will continue? Because my concern is that
there could still be blocks with single copy if the balance has not
completed?


>
> If you know how to build a kernel, here's a crude patch.
>
>

I am feeling a little lucky because I still have the other disk and I
am assuming if I remove my current disk and put the other disk in, I
would be able to mount it once again?

Also, since I have couple times already tried btrfs repair etc, can I
trust the current disk anyways?

if I get into issue again, I would definitely use the patch to
recompile the kernel and thanks a lot for the same.

Thanks again,

--
Raj

> Meow
> --
> Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
>   ./configure --host=zx-spectrum --build=pdp11
