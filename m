Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pb-smtp1.pobox.com ([64.147.108.70]:52899 "EHLO
        sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbdE1H1w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 03:27:52 -0400
Received: from sasl.smtp.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id B38E3803D5
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:27:50 -0400 (EDT)
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id ABB50803D3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:27:50 -0400 (EDT)
Received: from mail-lf0-f41.google.com (unknown [209.85.215.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id 028C9803D2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:27:49 -0400 (EDT)
Received: by mail-lf0-f41.google.com with SMTP id h4so21905857lfj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 00:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3ce02$7e425613$62194897$37882c38@cox.net>
References: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
 <pan$3ce02$7e425613$62194897$37882c38@cox.net>
From: Bill Williamson <bill@bbqninja.com>
Date: Sun, 28 May 2017 17:27:47 +1000
Message-ID: <CAHPjZW5sRxns7CN8QmhB_HaQP5PGo7smFrf+q1QWHRRVnAToMA@mail.gmail.com>
Subject: Re: btrfs mounts RO, kernel oops on RW
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 May 2017 at 15:56, Duncan <1i5t5.duncan@cox.net> wrote:
> Bill Williamson posted on Sun, 28 May 2017 12:46:00 +1000 as excerpted:
>
>> At first I got the failed to read log tree error, so I ran
>> btrfs-zero-log.  It walked back 3-4 transactions but now seems okay.
>>
>> After that fix:
>> - btrfs check shows no errors.
>> - mounting the filesystem RO works great, I can read files.
>> - mounting the filesystem RW results in a huge kernel exception and a
>> hang, centering around can_overcommit and
>> btrfs_async_reclaim_metadata_space
>
> Try using the skip_balance mount option.  See the btrfs (5) manpage (you
> must specify the 5, or you'll get the section 8 general btrfs command
> manpage).
>
> If that works, you can resume or cancel the balance once the filesystem
> is mounted writable.

Thanks for the tip, but no joy :(

Exactly the same kernel oops.

> The sysadmin's first rule of backups:  The value of your data is defined
> by the number and currency of your backups: No backups, you are defining
> your data as of only trivial value, worth less than the time/trouble/
> resources necessary to make those backups.  (In)Actions speak louder than
> words, so the definition holds regardless of any after-the-fact protests
> to the contrary.

Thanks also for the backup reinforcement here, as it made me double
check everything I have in place.  The important data (photos etc) is
backed up in a few different places and will be easy to restore.  The
only thing that wasn't in those backups is our minecraft world saves,
so they are now backed up too :)

The rest of the data is the typical "family" stuff, as in a rip of
every blu ray/dvd we own, a lot of tv shows, etc.  So stuff that is
all replaceable, but annoys the kids that it will be gone for a short
while.  Eg not worth spending $$$ on a like for like backup regime.


> (The second rule of backups is that a would-be backup isn't a backup
> until you've tested it restorable/usable.  Until then, it's only a would-
> be backup, as the backup simply isn't complete until it has been tested.)

Also a good reminder to check that my photos will restore from
elsewhere.... and they do.

> Meanwhile, turning the topic a bit, toward your suggested 8 TB drives.
> Be aware that many of those are archive-targeted drives and aren't
> designed for normal use.

I didn't consider that, as "most" of my data is semi-archival, but it
still gets moved around a bit.  I was indeed considering the 8TB
archive hard drives you were thinking of, so thanks for the warning!

I'm not asking for a specific endorsement, but should I be considering
something like the seagate ironwolf or WD red drives?

Thanks again for the reply

BIll
