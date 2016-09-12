Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33951 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755635AbcILCAW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 22:00:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjGXd-0003nT-QX
        for linux-btrfs@vger.kernel.org; Mon, 12 Sep 2016 04:00:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Small fs
Date: Mon, 12 Sep 2016 02:00:04 +0000 (UTC)
Message-ID: <pan$e206f$d515790a$646cc891$9e1c047e@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
        <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 11 Sep 2016 14:33:18 -0600 as excerpted:

> Something else that's screwy in that bug that I just realized, why is it
> not defaulting to mixed-block groups on a 100MiB fallocated file? I
> thought mixed-bg was the default below a certain size like 2GiB or
> whatever?

You apparently missed the memo...

Newer btrfs-progs mkfs.btrfs no longer defaults under-1-GiB to mixed-bg 
mode, tho it remains very strongly recommended below 1 GiB, and soft-
recommended to somewhere between 4 and 32 GiB (I believe the wiki says 5 
GiB at this point but don't know how it arrived at that, but the numbers 
I've seen suggested on-list range between 4 and 32 GiB, as above).

The explanation of why, based on the thread where I remember it coming 
up, was because defaulting to mixed-mode was making testing more 
complex.  Don't ask me to agree with that because I most certainly don't; 
IMO sane defaults for normal use, which everyone seems to agree mixed-
mode for under a GiB is, should apply, and if testing needs special-
cased, well, special-case it.  But none-the-less, that's the context in 
which it was agreed to do away with the mixed-mode default, despite it 
still being extremely strongly recommended for under a GiB.  <shrug>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

