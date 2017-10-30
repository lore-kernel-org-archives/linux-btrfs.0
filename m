Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58334 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdJ3EKa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 00:10:30 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e91Ot-00043A-OZ
        for linux-btrfs@vger.kernel.org; Mon, 30 Oct 2017 05:10:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output
 error"
Date: Mon, 30 Oct 2017 04:09:58 +0000 (UTC)
Message-ID: <pan$7f6a7$60d76ea4$36d8c4cb$1d03823c@cox.net>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
        <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
        <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
        <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
        <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
        <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
        <1484297967.48018.1508985286675@email.1and1.com>
        <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
        <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zak Kohler posted on Sun, 29 Oct 2017 21:57:00 -0400 as excerpted:

> So I ran memtest86+ 5.01 for >4 days:
> Pass: 39 Errors: 0

Be aware that memtest86+ will detect some types of errors but not others.

In particular, some years ago I had some memory (DDR1/3-digit-Opteron 
era), actually registered as required by Opterons and ECC, that passed 
that sort of memory test because what the test /tests/ is memory cell 
retention (if you put a value in does it verify on read-back?), that was 
none-the-less bad memory in that at its rated speed it was unreliable at 
memory /transfers/.

Eventually that mobo got a BIOS update that could adjust memory clocking, 
and I downclocked it a notch (from its rated pc3200 to 3000, IIRC).  At 
the lower clock it was rock stable, even with reduced wait-states to make 
up a bit of the performance I was losing to the lower clock.  But I had 
to get a BIOS that could do it, first, and as I said, in the mean time 
memtest86, etc, reported it was fine, because it was testing stable-
state, not stress-testing memory transfers at full rated bandwidth.

Eventually I did a memory upgrade, and the new memory worked fine at full 
rated speed.

As for actual symptoms, that was well before I switched to btrfs 
(actually probably about time btrfs development started, I'd guess), but 
the most frequent early symptoms were untar/bunzip2 checksum failures, 
with some system crashes during builds (gentoo so I do a lot of 
untarballing of sources and builds).  Later, when the kernel got support 
for the amd/opteron system-check error detection hardware, that would 
sometimes, but not always, trigger as well, but the most frequent symptom 
really was checksum verification failures untarring tbz2s.

Of course if btrfs had been around for me to try to run back then I 
expect I'd have been triggering enough checksum failures that I'd have 
given up on running it.  But FWIW, tho the reiserfs I was running wasn't 
checksummed, it didn't ever seem to significantly corrupt, with this or 
other hardware problems I had.  

That's what really amazed me about reiserfs, that it remained stable thru 
not only that hardware problem but various others I've had over the years 
that would have killed or made unworkable other filesystems.  Once it got 
ordered journaling (as opposed to the original writeback journaling that 
gave it the bad rep... and later poked holes in ext3 reliability when 
they tried it there for a few kernel versions too) and switched to 
ordered by default, it really /was/ remarkably stable, even in the face 
of hardware issues that would take down many filesystems.

Of course one of the things that attracted me to btrfs years later was 
that it was the same Chris Mason that helped reiserfs get that ordered 
journaling back when he was working for SuSE and they were using reiserfs 
by default, that began btrfs.

Tho btrfs is far more complex, and isn't yet as stable as reiserfs ended 
up being for me.  And on bad hardware it may never be, even if eventually 
it's simply due to checksum failures making it effectively unusable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

