Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56166 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdJaCeQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 22:34:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e9MNS-0007tB-KG
        for linux-btrfs@vger.kernel.org; Tue, 31 Oct 2017 03:34:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output
 error"
Date: Tue, 31 Oct 2017 02:33:48 +0000 (UTC)
Message-ID: <pan$684ae$1b07c469$c5218ba1$a89f7997@cox.net>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
        <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
        <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
        <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
        <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
        <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
        <1484297967.48018.1508985286675@email.1and1.com>
        <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
        <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
        <pan$7f6a7$60d76ea4$36d8c4cb$1d03823c@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 30 Oct 2017 04:09:58 +0000 as excerpted:

> Zak Kohler posted on Sun, 29 Oct 2017 21:57:00 -0400 as excerpted:
> 
>> So I ran memtest86+ 5.01 for >4 days:
>> Pass: 39 Errors: 0
> 
> Be aware that memtest86+ will detect some types of errors but not
> others.
> 
> In particular, some years ago I had some memory (DDR1/3-digit-Opteron
> era), actually registered as required by Opterons and ECC, that passed
> that sort of memory test because what the test /tests/ is memory cell
> retention (if you put a value in does it verify on read-back?), that was
> none-the-less bad memory in that at its rated speed it was unreliable at
> memory /transfers/.
> 
> Eventually that mobo got a BIOS update that could adjust memory
> clocking, and I downclocked it a notch[.] At
> the lower clock it was rock stable, even with reduced wait-states to
> make up a bit of the performance I was losing to the lower clock.  But I
> had to get a BIOS that could do it, first [...]

> That's what really amazed me about reiserfs, that it remained stable
> thru not only that hardware problem but various others I've had over the
> years that would have killed or made unworkable other filesystems.

BTW, one of those other hardware problems I had, the one that ultimately 
did in my old server-clase mobo, was leaky capacitors on the then 8-ish 
years old system.  It was of the generation that had problem capacitors, 
and it eventually succumbed...

The reason this is relevant is that it was the storage path that had the 
worst problems.  Before I figured out what the problem actually was I did 
try btrfs, with around kernel 3.6 at the time, and it really /was/ 
unusable due to checksum errors.  But I could still limp along with 
reiserfs...

One thing about the behavior I noticed, however, was that as the problem 
was developing, the system was more usable if I kept it reasonably cool.  
By the time I gave up on it, it was early summer here in Phoenix, and 
temperatures were climbing.  But I was sitting at home with the AC on, in 
a heavy winter jacket, wearing sweats under my pants and trying to type 
with gloves on my hands to keep warm, in ordered to cool down the 
computer so it'd work.  That's when I decided enough was enough and gave 
up on it.  I only found the burst capacitors, however, once I got the new 
mobo and was switching out the old one.  No WONDER it wasn't working 
right any more!

The rest of the system was actually reasonably stable, however.  I guess 
the worst caps were in the storage path.

But as I said, reiserfs was amazing.  I bought a SATA addon board with 
the same chipset as on the old mobo so I could boot the old monolithic 
kernel with those drivers builtin on the new mobo, and I didn't notice 
any corruption or anything.  But as I said, btrfs was entirely unusable 
on the old hardware, due to both checksum errors and large transactions 
(like trying to copy files over from reiserfs) ending up entirely 
reverted when I'd crash, instead of the partial completion I'd get on 
reiserfs, so I could at least reboot and start where it has crashed on 
reiserfs, instead of having to start over entirely, thus making no 
progress at all, which is what I was seeing on btrfs.

That reiserfs continued to work well enough to keep going so long under 
those conditions, while btrfs was entirely unworkable, and even more that 
once I was running good hardware again, I didn't see massive corruption 
on reiserfs as a result of trying to run it on so long on the bad 
hardware, was really /really/ amazing!

But like I said, I don't expect that btrfs, with its checksumming, with 
/ever/ be really workable on that sort of defective hardware.  It was 
just really amazing to me that reiserfs wasn't screwed up by it as well, 
as it had every right to be given the screwed up hardware I was trying to 
run it on.  No filesystem can be expected to go thru that and end up 
still usable, but somehow, reiserfs did.

Bottom line, it could be the storage path, not the memory or cpu.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

