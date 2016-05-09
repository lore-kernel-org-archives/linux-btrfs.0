Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35565 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbcEIPqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 11:46:30 -0400
Received: by mail-io0-f196.google.com with SMTP id u185so21439154iod.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 08:46:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <8760uoqjlt.fsf@vostro.rath.org>
References: <8760uoqjlt.fsf@vostro.rath.org>
Date: Mon, 9 May 2016 16:46:29 +0100
Message-ID: <CAL3q7H4opJabDo6mBoQb3P8NeGS31=-5F3e4m8qWLs2fn6jL+Q@mail.gmail.com>
Subject: Re: Input/output error on newly created file
From: Filipe Manana <fdmanana@gmail.com>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 8, 2016 at 11:18 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
> Hello,
>
> I just created an innocent 10 MB on a btrfs file system, yet my attempt
> to read it a few seconds later (and ever since), just gives:
>
> $ ls -l in-progress/mysterious-io-error
> -rw-rw-r-- 1 nikratio nikratio 10485760 May  8 14:41 in-progress/mysterious-io-error
> $ cat in-progress/mysterious-io-error
> cat: in-progress/mysterious-io-error: Input/output error

If you unmount and mount again the filesystem, does it happen again?
How did you create the file? Does fsck reports any issues?

>
> I was hoping the kernel might tell me a little more about this, but:
>
> $ dmesg | tail -3
> [   48.982851] wlan0: RX AssocResp from 00:1f:33:be:9a:c4 (capab=0x411 status=0 aid=3)
> [   48.983757] wlan0: associated
> [ 2770.464505] kvm: zapping shadow pages for mmio generation wraparound
>
>
> How can I find out the reason for the error? Is it a bug in BTRFS,
> or somewhere else in the kernel ? Is my hardware broken?
>
> Kernel is Debian's 4.5.0-0.bpo.1-amd64. This is a btrfs file system on a
> LVM LV backed by a bcache array with two backing devices and one caching
> device.
>
>
> Best,
> -Nikolaus
>
> --
> GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
> Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F
>
>              »Time flies like an arrow, fruit flies like a Banana.«
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
