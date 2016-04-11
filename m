Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:32778 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbcDKVwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 17:52:12 -0400
Received: by mail-ig0-f171.google.com with SMTP id kb1so93118833igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 14:52:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
 <CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
From: lenovomi <lenovomi@gmail.com>
Date: Mon, 11 Apr 2016 23:51:42 +0200
Message-ID: <CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i didnt try mount -o ro, when i tried to mount it via esata i got
kernel panic immediately. Then i conntected enclosure with drives via
usb and tried to mount it :

https://bpaste.net/show/641ab9172539
plugged via usb -> mount randomly one of the drive mount /dev/sda /mnt/brtfs

I was told on irc channel that i should not run btrfs check and if so
i should run it as
btrfs check --repair --init-extent-tree


Also there was recommendation to run btrfs restore before repair.


It was mounted and all worked fine, then i find out that i miss one
nfs mount and find out cubox was dead, so i rebooted it and now i cant
mount that btrfs volume (data r0, metadata in raid1)

I was told that both metadata copies were corrupted?


Still not clear what should i do as next step.


thanks

On Mon, Apr 11, 2016 at 11:16 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Apr 11, 2016 at 2:08 PM, lenovomi <lenovomi@gmail.com> wrote:
>> Hi,
>>
>>
>> I was running cubox with kernel 4.4.0 and with btrfs raid1 ...
>>
>> not it failed somehow and getting kernel panic during the boot...
>>
>> https://bpaste.net/show/0455daa876de
>>
>> i tried to connect the esata box with 3.x
>>
>> https://bpaste.net/show/98732bc6ce49
>>
>>
>> Any idea? Does it mean that whole volume is dead and i lost ALL THE DATA?
>
> Probably not, but there isn't enough information.
>
> Try 'mount -o ro,recovery' and post all kernel messages for it. If
> that fails, then run 'btrfs check' using a recent btrfs-progs (4.4.1
> or newer hopefully) without --repair, and post those results.
>
> What happened between the last time it mounted OK and when it fails?
> Power failure or just kernel panic and reboot? I don't see the
> complete kernel panic in either of your pastes. Actually the minute
> before the kernel panic might be useful also so I suggest not trimming
> the messages so much.
>
>
> --
> Chris Murphy
