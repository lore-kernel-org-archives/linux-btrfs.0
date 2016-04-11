Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33535 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbcDKVQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 17:16:48 -0400
Received: by mail-io0-f178.google.com with SMTP id o126so3187874iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 14:16:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
Date: Mon, 11 Apr 2016 15:16:47 -0600
Message-ID: <CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
From: Chris Murphy <lists@colorremedies.com>
To: lenovomi <lenovomi@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 11, 2016 at 2:08 PM, lenovomi <lenovomi@gmail.com> wrote:
> Hi,
>
>
> I was running cubox with kernel 4.4.0 and with btrfs raid1 ...
>
> not it failed somehow and getting kernel panic during the boot...
>
> https://bpaste.net/show/0455daa876de
>
> i tried to connect the esata box with 3.x
>
> https://bpaste.net/show/98732bc6ce49
>
>
> Any idea? Does it mean that whole volume is dead and i lost ALL THE DATA?

Probably not, but there isn't enough information.

Try 'mount -o ro,recovery' and post all kernel messages for it. If
that fails, then run 'btrfs check' using a recent btrfs-progs (4.4.1
or newer hopefully) without --repair, and post those results.

What happened between the last time it mounted OK and when it fails?
Power failure or just kernel panic and reboot? I don't see the
complete kernel panic in either of your pastes. Actually the minute
before the kernel panic might be useful also so I suggest not trimming
the messages so much.


-- 
Chris Murphy
