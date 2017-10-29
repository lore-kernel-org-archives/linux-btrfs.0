Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:52273 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdJ2TFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 15:05:16 -0400
Received: by mail-oi0-f41.google.com with SMTP id c202so18069095oih.9
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Oct 2017 12:05:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1484297967.48018.1508985286675@email.1and1.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com> <1484297967.48018.1508985286675@email.1and1.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 29 Oct 2017 20:05:15 +0100
Message-ID: <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 4:34 AM, Zak Kohler <y2k@y2kbugger.com> wrote:

> I will gladly repeat this process, but I am very concerned why this
> corruption happened in the first place.

Right. So everyone who can, needs to run the three scrubs on all
available Btrfs volumes/devices and see if they get any discrepancies.
I only ever use the online scrub so I have no idea if --offline or the
older check --check-data-csum differ from it.

scrub start
scrub start --offline
btrfs check --check-data-csum

I think you've hit a software bug if those three methods don't exactly
agree with each other. And it's a question which one is correct, or if
they all have different bugs in them?



>
> More tests:
>
> scrub start --offline
>     All devices had errors in differing amounts
>     I will verify that these counts are repeatable.
>     Csum error: 150
>     Csum error: 238
>     Csum error: 175
>
> btrfs check
>     found 2179745955840 bytes used, no error found
>
> btrfs check --check-data-csum
>     mirror 0 bytenr 13348855808 csum 2387937020 expected csum 562782116
>     mirror 0 bytenr 23398821888 csum 3602081170 expected csum 1963854755


Offhand that sounds like three different results, which is sorta fakaked.


>     ...
>
> The only thing I could think of is that the btrfs version that I used to mkfs
> was not up to date. Is there a way to determine which version was used to
> create the filesystem?

That information isn't in the superblock. I think it could be added to
the device tree as a PERSISTENT_ITEM, although I'm not sure how useful
it is.

Anyway, I don't think it's related. mkfs.btrfs writes a tiny amount to
the drive, and almost certainly the problem is happening later.



-- 
Chris Murphy
