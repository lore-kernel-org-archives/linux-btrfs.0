Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33661 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932254AbcILDDG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 23:03:06 -0400
Received: by mail-oi0-f48.google.com with SMTP id y2so283871512oie.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 20:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$e206f$d515790a$646cc891$9e1c047e@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com> <pan$e206f$d515790a$646cc891$9e1c047e@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Sep 2016 21:03:04 -0600
Message-ID: <CAJCQCtQz6cPhE1ciP5KJ2B5Ccy_5PSbzrmLmvh3rULoz_3h0bw@mail.gmail.com>
Subject: Re: Small fs
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 8:00 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sun, 11 Sep 2016 14:33:18 -0600 as excerpted:
>
>> Something else that's screwy in that bug that I just realized, why is it
>> not defaulting to mixed-block groups on a 100MiB fallocated file? I
>> thought mixed-bg was the default below a certain size like 2GiB or
>> whatever?
>
> You apparently missed the memo...

I got the memo right after I clicked send and read the thread.

> Newer btrfs-progs mkfs.btrfs no longer defaults under-1-GiB to mixed-bg
> mode, tho it remains very strongly recommended below 1 GiB, and soft-
> recommended to somewhere between 4 and 32 GiB (I believe the wiki says 5
> GiB at this point but don't know how it arrived at that, but the numbers
> I've seen suggested on-list range between 4 and 32 GiB, as above).
>
> The explanation of why, based on the thread where I remember it coming
> up, was because defaulting to mixed-mode was making testing more
> complex.  Don't ask me to agree with that because I most certainly don't;
> IMO sane defaults for normal use, which everyone seems to agree mixed-
> mode for under a GiB is, should apply, and if testing needs special-
> cased, well, special-case it.  But none-the-less, that's the context in
> which it was agreed to do away with the mixed-mode default, despite it
> still being extremely strongly recommended for under a GiB.  <shrug>

The man page says:
"The recommended size for the mixed mode is for filesystems less than
1GiB." But in this case recommended !=default which requires some
mental gymnastics to rectify. If mixed-bg becomes obsolete upon enospc
being no more likely with isolated block groups, then OK fine, but in
the meantime...


-- 
Chris Murphy
