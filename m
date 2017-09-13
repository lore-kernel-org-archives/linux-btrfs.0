Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36798 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdIMAxR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 20:53:17 -0400
Received: by mail-oi0-f49.google.com with SMTP id x190so37602234oix.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 17:53:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
References: <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru> <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl> <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl> <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl> <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
 <20170912200057.3mrgtahlvszkg334@angband.pl> <e169336d-db31-276f-1d71-bf897cf10d4b@gmail.com>
 <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 13 Sep 2017 03:52:36 +0300
Message-ID: <CAGqmi74UxBRj6pPJ2aEon-raAq46R=29sef_f_wWWGQY1WpwDA@mail.gmail.com>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Marat Khalili <mkh@rqc.ru>,
        Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-13 0:13 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
> On Tue, Sep 12, 2017 at 04:12:32PM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-09-12 16:00, Adam Borowski wrote:
>> > Noted.  Both Marat's and my use cases, though, involve VMs that are off most
>> > of the time, and at least for me, turned on only to test something.
>> > Touching mtime makes rsync run again, and it's freaking _slow_: worse than
>> > 40 minutes for a 40GB VM (source:SSD target:deduped HDD).
>> 40 minutes for 40GB is insanely slow (that's just short of 18 MB/s) if
>> you're going direct to a hard drive.  I get better performance than that on
>> my somewhat pathetic NUC based storage cluster (I get roughly 20 MB/s there,
>> but it's for archival storage so I don't really care).  I'm actually curious
>> what the exact rsync command you are using is (you can obviously redact
>> paths as you see fit), as the only way I can think of that it should be that
>> slow is if you're using both --checksum (but if you're using this, you can
>> tell rsync to skip the mtime check, and that issue goes away) and --inplace,
>> _and_ your HDD is slow to begin with.
>
> rsync -axX --delete --inplace --numeric-ids /mnt/btr1/qemu/ mordor:$BASE/qemu
> The target is single, compress=zlib SAMSUNG HD204UI, 34976 hours old but
> with nothing notable on SMART, in a Qnap 253a, kernel 4.9.
>
> Both source and target are btrfs, but here switching to send|receive
> wouldn't give much as this particular guest is Win10 Insider Edition --
> a thingy that shows what the folks from Redmond have cooked up, with roughly
> weekly updates to the tune of ~10GB writes 10GB deletions (if they do
> incremental transfers, installation still rewrites everything system).
>
> Lemme look a bit more, rsync performance is indeed really abysmal compared
> to what it should be.
>
>
> Meow!
> --
> ⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
> ⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
> ⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
> ⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

No, no, no, no...
No new ioctl, no change in fallocate.
Fisrt: VM can do punch hole, if you use qemu -> qemu know how to do it.
Windows Guest also know how to do it.

Different Hypervisor? -> google -> Make issue to support, all
Linux/Windows/Mac OS support holes in files.

No new code, no new strange stuff to fix not broken things.

You want replace zeroes? EXTENT_SAME can do that.

truncate -s 4M test_hole
dd if=/dev/zero of=./test_zero bs=4M

duperemove -vhrd ./test_hole ./test_zero

~ du -hs test_*
0       test_hole
0       test_zero

-- 
Have a nice day,
Timofey.
