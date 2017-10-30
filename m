Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:49746 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdJ3B5c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 21:57:32 -0400
Received: from mail-yw0-f181.google.com ([209.85.161.181]) by
 mrelay.perfora.net (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0MRELZ-1djWGS3jWJ-00Ue6O for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017
 02:57:31 +0100
Received: by mail-yw0-f181.google.com with SMTP id w2so10229888ywa.9
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Oct 2017 18:57:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
From: Zak Kohler <y2k@y2kbugger.com>
Date: Sun, 29 Oct 2017 21:57:00 -0400
Message-ID: <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Chris Murphy <lists@colorremedies.com>
Cc: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 29, 2017 at 3:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Oct 26, 2017 at 4:34 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
>
>> I will gladly repeat this process, but I am very concerned why this
>> corruption happened in the first place.
>
> Right. So everyone who can, needs to run the three scrubs on all
> available Btrfs volumes/devices and see if they get any discrepancies.
> I only ever use the online scrub so I have no idea if --offline or the
> older check --check-data-csum differ from it.
>
> scrub start
> scrub start --offline
> btrfs check --check-data-csum
>
> I think you've hit a software bug if those three methods don't exactly
> agree with each other. And it's a question which one is correct, or if
> they all have different bugs in them?
>
>
>
>>
>> More tests:
>>
>> scrub start --offline
>>     All devices had errors in differing amounts
>>     I will verify that these counts are repeatable.
>>     Csum error: 150
>>     Csum error: 238
>>     Csum error: 175
>>
>> btrfs check
>>     found 2179745955840 bytes used, no error found
>>
>> btrfs check --check-data-csum
>>     mirror 0 bytenr 13348855808 csum 2387937020 expected csum 562782116
>>     mirror 0 bytenr 23398821888 csum 3602081170 expected csum 1963854755
>
>
> Offhand that sounds like three different results, which is sorta fakaked.
Those results for passing each of the three devices:

$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX1
Scrub result:
Tree bytes scrubbed: 5234425856
Tree extents scrubbed: 638968
Data bytes scrubbed: 4353723670528
Data extents scrubbed: 374300
Data bytes without csum: 533200896
Read error: 0
Verify error: 0
Csum error: 150

$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX2
Scrub result:
Tree bytes scrubbed: 5234425856
Tree extents scrubbed: 638967
Data bytes scrubbed: 4353723314176
Data extents scrubbed: 374300
Data bytes without csum: 533200896
Read error: 0
Verify error: 0
Csum error: 238

$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX3
Scrub result:
Tree bytes scrubbed: 5234491392
Tree extents scrubbed: 638975
Data bytes scrubbed: 4353723572224
Data extents scrubbed: 374300
Data bytes without csum: 533200896
Read error: 0
Verify error: 0
Csum error: 175 #first run
Csum error: 112 #second run...
Csum error: 285 #third run...

But I ran the /dev/disk/by-id/WD-XX3 device three times and you can
see the result...


So I ran memtest86+ 5.01 for >4 days:
Pass: 39 Errors: 0


Only other think I can think to try is transferring those drives to
another system.

I'm running '$ sudo btrfs scrub start --offline --progress
/dev/disk/by-id/WD-XX3' one more time to just to make sure that I
wasn't reading something wrong.

I just noticed that all three drives are blinking so I can assume that
$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX1
$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX2
$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX3
are all equivalent and are checking the entire filesystem?

The original problem was noticed during a btrfs send, and it would
stop and send a dmesg after an intermittent amount of data. You could
run it 3 times and it would stop at the same spot and then next time
it would make it further.
Given these dmesg error, I'll tabularize the info to more clearly show
the intermittent nature

[  114.450699] BTRFS warning (device sdn): csum failed ino 6407 \
off 7683907584 csum 1745651892 expected csum 3952841867

   time     ino        off          csum    expected
[  114.43]  6407    7683907584  1745651892  3952841867
[  114.45]  6407    7683907584  1745651892  3952841867
[38494.97]  4708    27529216    876064455   874979996
[38494.98]  4708    27529216    2615801759  874979996
[38541.07]  4708    27529216    876064455   874979996
[38571.24]  4708    27529216    2615801759  874979996
[39434.21]  4708    27529216    2615801759  874979996
[73132.65]  4708    27529216    2615801759  874979996
[73167.89]  4708    27529216    2615801759  874979996

Sometimes it gets stuck at the same ino, sometimes not. Sometime the
actual incorrect csum repeats, sometimes it doesn't.



>
>>     ...
>>
>> The only thing I could think of is that the btrfs version that I used to mkfs
>> was not up to date. Is there a way to determine which version was used to
>> create the filesystem?
>
> That information isn't in the superblock. I think it could be added to
> the device tree as a PERSISTENT_ITEM, although I'm not sure how useful
> it is.
>
> Anyway, I don't think it's related. mkfs.btrfs writes a tiny amount to
> the drive, and almost certainly the problem is happening later.
>
>
>
> --
> Chris Murphy
