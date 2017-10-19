Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:44326 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdJSUE1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 16:04:27 -0400
Received: by mail-oi0-f52.google.com with SMTP id v132so16848060oie.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 13:04:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 19 Oct 2017 21:04:26 +0100
Message-ID: <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
Subject: Re: SLES 11 SP4: can't mount btrfs
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 6:43 PM, Lentes, Bernd
<bernd.lentes@helmholtz-muenchen.de> wrote:
> Hi,
>
> this is the continuation of a thread i started on a SLES forum (https://forums.suse.com/showthread.php?10109-lv-with-btrfs-corrupt-some-tips-please), but i think this is the more appropriate place.

Maybe, but as this is SLES, you're effectively paying for support, and
it's actually better to open a support instance, in my opinion. Btrfs
is not just supported by SUSE, it's the default file system.


> I booted the system now with knoppix 8.1, which has kernel 4.12.7 and btrfs-progs 4.7.3-1. Is that ok ?

Since it's SLES, you have to use whatever they recommend. I don't know
Knoppix kernels, so I can't say with any certainty what's in 4.12.7,
but 4.7.3 for btrfs-progs is rather old. There have been many
improvements since that time, in particular with 'btrfs check'

What I usually recommend is getting a current version of Fedora
because it'll have very recent kernels, the gotcha being that to also
get recent btrfs-progs you have to get a copy of Rawhide or like right
now you could use Fedora 27 Beta which is decently safe and also has
new kernel and progs, and in terms of Btrfs of block level stuff we
care about, Fedora runs pretty much identical to to kernel.org code,
so it's not like developers have to use secret decoder rings to know
what the kernel version really means.
https://getfedora.org/en/workstation/prerelease/



> I tried:
>
> mount /dev/vg1/lv_root /lv_root -o recovery,ro
> and got:
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg1-lv_root,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>
>
> and got via dmesg:
> [92518.955408] BTRFS info (device dm-0): disk space caching is enabled
> [92518.990561] BTRFS error (device dm-0): parent transid verify failed on 196314759168 wanted 793932 found 793496
> [92518.990911] BTRFS error (device dm-0): parent transid verify failed on 196314759168 wanted 793932 found 793496
> [92518.990919] BTRFS error (device dm-0): failed to read block groups: -5
> [92519.070084] BTRFS error (device dm-0): open_ctree failed





>
> next step:
>
> root@Microknoppix:~# btrfs device scan
> Scanning for Btrfs filesystems
> root@Microknoppix:~#
>
> no result !?!

Normal. Scan just tells btrfs to go look for devices, it doesn't
return a result.

>
> Now i changed to https://btrfs.wiki.kernel.org/index.php/Restore:
>
> btrfs restore -smSvi /dev/vg1/lv_root /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/ |tee /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/recover.log
>
> I just started it. I get lines like:
> offset is 61440
> offset is 98304
> offset is 4096
> offset is 143360
> offset is 8192
> offset is 184320
>
> or
>
> Error searching /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/@/tmp/localhpsum/assets/doc/help/en
> Error searching /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/@/tmp/localhpsum/assets/doc/help/ja/images/callouts
>
> What does that mean ?

btrfs restore is pretty much just a brute force hammer for scraping
data off a volume, pretty much it either works or doesn't work,
there's not a lot of in between.

You're probably better off doing both 'btrfs check' and 'btrfs check
--mode=lowmem' without the --repair option, and report back what both
results are.

You can cancel the restore that's in progress is sounds like it's
still doing something, but stuck in a loop maybe. I'm not sure if
there are many restore fixes since btrfs-progs 4.7 though; you could
check the changelog which is in the wiki.

I think the way forward is to get a little more information for
developers, and then maybe they'll be able to say whether --repair is
safe to use or not in your situation.

In any case, report back what you find out. It'd be useful.

-- 
Chris Murphy
