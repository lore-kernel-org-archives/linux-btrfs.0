Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35324 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbcILEyo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 00:54:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjJGK-0002sZ-NB
        for linux-btrfs@vger.kernel.org; Mon, 12 Sep 2016 06:54:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Small fs
Date: Mon, 12 Sep 2016 04:54:24 +0000 (UTC)
Message-ID: <pan$612d5$bc50d5d7$f1744b5$1e6b9281@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
        <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
        <pan$e206f$d515790a$646cc891$9e1c047e@cox.net>
        <CAJCQCtQz6cPhE1ciP5KJ2B5Ccy_5PSbzrmLmvh3rULoz_3h0bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 11 Sep 2016 21:03:04 -0600 as excerpted:

> The man page says:
> "The recommended size for the mixed mode is for filesystems less than
> 1GiB." But in this case recommended !=default which requires some mental
> gymnastics to rectify. If mixed-bg becomes obsolete upon enospc being no
> more likely with isolated block groups, then OK fine, but in the
> meantime...

On the bright side, the double-whammy of being under such tight 
filesystem size constraints, coupled with finding out you have less than 
half the space of the filesystem actually available due to default-mixed-
mode AND default dup-metadata (thus dup everything), gets eliminated, and 
barring problems with unbalanced chunk-sizes, you actually get to use 
most of capacity of the filesystem for actual files, instead of less than 
half of it.

=:^)

But I remain unconvinced that benefit outweighs the serious 
administrative headaches trying to run without mixed-mode on such small 
btrfs is likely to generate.  And what's worse, it's the same folks that 
are likely to have problems coping with either issue, but fixing the 
under-half-available-for-use (at the cost of filesystem resiliency) is a 
one-time thing, while the administrative issue of unbalanced chunks is 
likely to come back to bite them again and again.

But still, having people find they can fit only ~110 MiB in a 256 MiB 
btrfs, while with ext*, they can fit say 240 MiB in the same size 
filesystem, could be a bit more to try to explain to the technically 
under-literate, than the devs decided they were willing to deal with.  
Just saying it'd divided in chunks and another chunk won't fit is 
arguably easier than trying to explain why the filesystem will fit less 
than half of what the size of it suggests it should fit, IOW.

And I think that argument /was/ made, to some extent.  But the whole 
thing only came up because they found testing with small filesystems 
inconvenient due to the mixed-bg default, so rather than fix that by 
fixing the tests, they broke the previously sane defaults, instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

