Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35676 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdHVFAP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 01:00:15 -0400
Received: by mail-ua0-f169.google.com with SMTP id q42so40832097uad.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKWrsEgWQz23mVqOgS7r_nKX0SzuN=-U4xmiYmy1cM0pjw@mail.gmail.com>
References: <CAG+QAKWrsEgWQz23mVqOgS7r_nKX0SzuN=-U4xmiYmy1cM0pjw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 21 Aug 2017 23:00:14 -0600
Message-ID: <CAJCQCtT7iRfe-qpc-mtTbkBQ=TFGbyaAVCZ0kUAvnDievoBDdg@mail.gmail.com>
Subject: Re: btrfs corrupt message when mounting (but still mounts and no
 scrub errors.)
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:55 PM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
> I'm getting messages like this when mounting:
>
> [    4.034300] BTRFS info (device sdg3): bdev /dev/sdg3 errs: wr 0, rd
> 0, flush 0, corrupt 4, gen 0
> [    4.034828] BTRFS info (device sdg3): bdev /dev/sdf3 errs: wr 0, rd
> 0, flush 0, corrupt 68, gen 0


These are cumulative values stored in the file system persistently.
They should match up with 'btrfs dev stats'. You can reset it by using
-z.


>
> But it mounts fine, and scrub says it is fine:
>
> $  sudo btrfs scrub start -Bd /dev/sdf3
> scrub device /dev/sdf3 (id 1) done
>         scrub started at Mon Aug 21 21:34:10 2017 and finished after 00:02:55
>         total bytes scrubbed: 28.33GiB with 0 errors
>
> $ sudo btrfs scrub start -Bd /dev/sdg3
> scrub device /dev/sdg3 (id 2) done
>         scrub started at Mon Aug 21 21:49:47 2017 and finished after 00:02:28
>         total bytes scrubbed: 28.33GiB with 0 errors

Scrub shows errors for the particular scrub with that time stamp, so
it's not cumulative.


-- 
Chris Murphy
