Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34911 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbcLKWlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 17:41:46 -0500
Received: by mail-io0-f173.google.com with SMTP id h30so144009166iod.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 14:41:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
From: Markus Binsteiner <makkus@gmail.com>
Date: Mon, 12 Dec 2016 11:41:45 +1300
Message-ID: <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I recon it took me about 5 minutes to realise what I'd done, then I
unmounted the volume. I don't think I wrote anything inbetween, but
there were a few applications open at that time, so there might have
been some i/o.

When you say 'by itself', you mean without the '-o 5'?

I've tried that initially, but it run for a few hours with no output
beside the initial 'Superblock...'.  I realized I forgot to redirect
the stdout which I thought that would be a good idea so I restarted it
with '-o 5' (found some advice said that's the thing to do if it was
the root subvolume that was deleted).

Anyway, restarted it without '-o 5', let's see whether it makes any
difference. Is there any indication on how long it should take? Just
roughly, hours, days? I've got about 150GB of data on that partition I
think. Also, is there supposed to be incremental output, or will it be
one big wall of text once it's finished?

As I said, when I tried before there was no output at all for hours,
which seemed a bit strange.

Thanks for your help!

On Sun, Dec 11, 2016 at 6:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Dec 10, 2016 at 5:12 PM, Markus Binsteiner <makkus@gmail.com> wrote:
>> It seems I've accidentally deleted all files in my home directory,
>> which sits in its own btrfs partition (lvm on luks). Now I'm trying to
>> find the roots to be able to use btrfs restore later on.
>>
>> btrfs-find-root seems to be taking ages though. I've run it like so:
>>
>> btrfs-find-root /dev/mapper/think--big-home  -o 5 > roots.txt
>
> Uhh, just do btrfs-find-root by itself to get everything it can find.
> And then work backwards from the most recent generation using btrfs
> restore -t using each root bytenr from btrfs-find-root. The more
> recent the generation, the better your luck that it hasn't been
> overwritten yet; but too recent and your data may not exist in that
> root. It really depends how fast you umounted the volume after
> deleting everything.
>
>
>
> --
> Chris Murphy
