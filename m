Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:53412 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbdJ3SwE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 14:52:04 -0400
Received: by mail-oi0-f54.google.com with SMTP id h6so23757637oia.10
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 11:52:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
 <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 30 Oct 2017 19:52:02 +0100
Message-ID: <CAJCQCtRNhOH7ex6-FFiNmp0nyy+S3cneukm8yy44GZCuMeVsWQ@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 30, 2017 at 2:57 AM, Zak Kohler <y2k@y2kbugger.com> wrote:

> $ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX1
> Scrub result:
> Tree bytes scrubbed: 5234425856
> Tree extents scrubbed: 638968
> Data bytes scrubbed: 4353723670528
> Data extents scrubbed: 374300
> Data bytes without csum: 533200896
> Read error: 0
> Verify error: 0
> Csum error: 150
>
> $ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX2
> Scrub result:
> Tree bytes scrubbed: 5234425856
> Tree extents scrubbed: 638967
> Data bytes scrubbed: 4353723314176
> Data extents scrubbed: 374300
> Data bytes without csum: 533200896
> Read error: 0
> Verify error: 0
> Csum error: 238
>
> $ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX3
> Scrub result:
> Tree bytes scrubbed: 5234491392
> Tree extents scrubbed: 638975
> Data bytes scrubbed: 4353723572224
> Data extents scrubbed: 374300
> Data bytes without csum: 533200896
> Read error: 0
> Verify error: 0
> Csum error: 175 #first run
> Csum error: 112 #second run...
> Csum error: 285 #third run...
>
> But I ran the /dev/disk/by-id/WD-XX3 device three times and you can
> see the result...


I expect these commands are the same, and involve all three drives in
the offline scrub each time. So you have five different results, but
all five involve csum errors. So the errors have a certain transience
to them, hence inconsistent results.

But the online scrub consistently reports zero errors. That to me
sounds like a bug in the offline scrub code. Maybe it's confused, and
reports data without csums (nodatacow) as csum errors? That does not
explain the inconsistency though.

And then you're getting an consistent failure, but at an inconsistent
location, with Btrfs send, ostensibly due to IO error, which sounds
like it's hitting a bad csum check.

It is entirely possible to get transient errors like this somewhere in
a storage stack that's otherwise not reported by the error detection
code in that layer. The thing I really don't understand is how you're
getting zero errors with conventional online scrub, every time.

On my tiny 23G installation I'm traveling with, I get the same results
with all three scrub methods on an NVMe drive. Zero errors. The
slighly larger spinning rust drives are not with me so I can't check
them for a while.



-- 
Chris Murphy
