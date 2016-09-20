Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35368 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbcITIev (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:34:51 -0400
Received: by mail-lf0-f50.google.com with SMTP id l131so7078831lfl.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 01:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk> <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
 <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com> <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 20 Sep 2016 10:34:49 +0200
Message-ID: <CAEtw4r1FYDkUxoOW-hrngBX5XD+AydiPY8B1eQv8a=dmA9B8eQ@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

More details on the issue and a complete explantion you can find here:

http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
and
(Help! I ran out of disk space! )
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21

And an explantion for the "dlimit" solution:

Quote From: Uncommon solutions for BTRFS
(http://blog.schmorp.de/2015-10-08-smr-archive-drives-fast-now.html)

> For my purposes, I define internal fragmentation as space allocated but not usable by the filesystem. In BTRFS, each time you delete files, the space used by those files cannot be reused for new files automatically.
> It's not a hard requirement to do this maintenance regularly, but doing it regularly spares you waiting for hours when the disk is full and you need to wait for a balance clean up command - and of course also reduces the number of > times you get unexpected disk full errors. As a side note, this can also be useful to prolong the life of your SSD because it allows the SSD to reuse space not needed by the filesystem (although there is a trade-off, frequent balancing is bad, no balancing is bad, the sweet spot is somewhere in between).

2016-09-20 10:20 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> Normaly total and used should deviate us a few gb.
> depend on your write workload you should run
>
> btrfs balance start -dusage=60 /mnt
>
> every week to avoid "ENOSPC"
>
> if you use newer btrfs-progs who supper balance limit filters you should run
>
> btrfs balance start -dusage=99 -dlimit=10 /mnt
>
> every 3 hours.
>
> This will balance 2 Blocks (dlimit=10; corresponds to 10 gb) with are
> not filled full into new blocks. You could/should adjust the intervall
> and the limit-filter depend on your write workload.
> For example if you write (change files + new files) only 10GB a day it
> will be enough to run this ever night.
> The last option completly avoid the ENOSPC issue but produce aditional
> workload for your harddrives.
>
> Note: you should avoid making snapshots during balance. Use a simple
> lock-mechanic for that.
