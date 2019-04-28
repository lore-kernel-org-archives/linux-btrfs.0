Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DA7C43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 14:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A2D0206BB
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 14:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purdea.ro header.i=@purdea.ro header.b="WAOdC+F1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfD1Ohc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 10:37:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40309 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfD1Ohc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 10:37:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id h11so11687148wmb.5
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2019 07:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purdea.ro; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=jnKRNSNlFuPJJyd7oHWhODviInUgYHffLaTQ7duQalE=;
        b=WAOdC+F1IAeCYCYJSbfGLldtv1IXRDh1do2ei8nadbLr+GvI5jVgYQSUuG8IG8YPEb
         k+49DyYHYH/hL00DJhXxHBYRXsomkuvGHmYqA6pTPhTRObvfti64QKxqgXyx5J0ntOYp
         +w5/OZyVdchqn9fOdnlEAB8F930O7uzpL1p8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jnKRNSNlFuPJJyd7oHWhODviInUgYHffLaTQ7duQalE=;
        b=YpaaM92a4kS8LZojfU5Vd4QN5Tr5jfFaHcTwSPmNl4QT42xJLhe71TzToEXCFiD1+S
         BVfjFa8DRFc4CGH3yBmsCmRLttgANgnUB76BPiGxkmVjx/Zq0IBXd6hSSxqpyDgnDF09
         rdWzhGXZ3vPzNrvvlHrjRwBjxLZMJFsp5FPal3e3mJaAcIL7186aJ0GfZsMhAdrwEC+H
         7Ru/nnwn+dTRT+g7VQlRLjipTOgvflqg1Bt31TFdMV+EYZA8qRE7sGT67zEoS5nWnH00
         cB2P8P8Gu4WwAQntcGkMmwicRPVF4uA/5CY2+mi+MNH+TIG91I9ysVsX7Z+Av5uVueFt
         GlZQ==
X-Gm-Message-State: APjAAAU4rxEkKVehL/3saiI4PiYBqO83079ABSMhIST6pTHO/TVbL6/R
        OYJC0r+5GLZuosplodCfbf2n0qXc6/fXnW3folOdnu97Ep4L
X-Google-Smtp-Source: APXvYqxKjUIrTiWHP96J0/CapPdjcegXReC0XGpfxBUav+C+540s73i5zoVOARQz++aeQz0ezNki1pjjza0H8VSM7TU=
X-Received: by 2002:a1c:c243:: with SMTP id s64mr2009755wmf.46.1556462249438;
 Sun, 28 Apr 2019 07:37:29 -0700 (PDT)
MIME-Version: 1.0
From:   Andrei Purdea <andrei@purdea.ro>
Date:   Sun, 28 Apr 2019 17:37:18 +0300
Message-ID: <CA+mMEgfz_t__SRCxi2jHbsbGU+MMHb=ti9N43StHjfv7j4btFQ@mail.gmail.com>
Subject: Corruption of newly created files after degraded mount of a raid1 filesystem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everyone,

I have a 2xSSD raid1 btrfs filesystem, 213GiB, used as a root
filesystem for a debian install.
I had to mount this filesystem in degraded mode because I needed to
temporarily steal a SATA port, and I was planning to rebuild the raid
after I was done.

But all hell broke loose right after the first boot with rootflags=degraded.

Here is a demo to show how the corruption happens with some simple commands:
https://pastebin.com/ev2hd5Lm
The corruption sometimes happens almost immediately, and sometimes it
takes tens of seconds to happen.

Note: /boot is an ext3 filesystem.
If I run "vbindiff /boot/bla ./bla", I see the first 0x1000 bytes of
the file have been zeroed out,
and the remaining bytes remain untouched.
If I run "sync; echo 3 > /proc/sys/vm/drop_caches", and run vbindiff
after that, then the entire file is all zeros. (but it keeps the same
size as the original file)
If I unmount and re-mount the file "bla" becomes a 0-length file.

During all of this there are no btrfs csum errors in dmesg.

I reproduced the problem both by booting the damanged filesystem on
its original machine using kernel 4.19.0-4-amd64 (official kernel in
debian repo), and then I also tried moving the SSD to a different
computer, this one is running kernel "5.1.0-rc5+", compiled fresh from
git about a week ago. The behaviour is exactly the same, and on the
second machine I didn't boot the damaged filesystem as root, so the
only thing accessing this filesystem was me running my cp, diff,
vbindiff commands.

The filesystem was mounted as such:
/dev/sdb2 on / type btrfs
(rw,noatime,nodiratime,degraded,compress=lzo,ssd,discard,space_cache,subvolid=5,subvol=/)

But I also tried without "compress=", and without "discard", and the
behavior remains the same.

Somebody on IRC asked me to run "filefrag -v" on the file, so here's
it's output: https://pastebin.com/4pgRXu4N

And here's the output of "btrfs check --readonly":
https://pastebin.com/dEHJ55ui

Could any of the check errors explain the problems I am seeing? Or are
they just symptoms too?

I am fairly confident that the problem was caused by me mounting the
filesystem degraded. Before the first mount the system was working
properly, and after the first degraded mount I couldn't do basic
things: I couldn't run apt-get update (it is complaining about
checksum errors, non-btrfs checksum errors), and google-chrome is
complaining that it can't access it's cache. The system is effectively
unusable. The only suggestion that there may have been anything wrong
from before is that this is the only btrfs filesystem that I have that
reported non-zero values for "btrfs device stats": (the below values
were non-zero even before the degraded mount)

[/dev/sda2].write_io_errs 161
[/dev/sda2].read_io_errs 0
[/dev/sda2].flush_io_errs 0
[/dev/sda2].corruption_errs 1863
[/dev/sda2].generation_errs 0
[/dev/sdb2].write_io_errs 2230
[/dev/sdb2].read_io_errs 51
[/dev/sdb2].flush_io_errs 0
[/dev/sdb2].corruption_errs 37
[/dev/sdb2].generation_errs 0

I chucked this up to the fact that these are SSDs, and sometimes
sectors go bad on SSDs. The couple btrfs scrub operations I ran over
the lifetime of the array never turned up with any errors. I still
don't think this is related to the corruption, but I am showing this
in the interest of full disclosure.

Here are some more outputs of device usage, filesystem usage,
filesystem show, and filesystem df:
https://pastebin.com/hD3Me4qS

The only error message that I'm ever getting is if I try to copy the
same file over itself like this:
https://pastebin.com/tRic42Dx
and no errors when I create new files.

I realize that I have 0 unallocated space, but I have 9GiB free on
data and 1.7GiB free on metadata, I don't think I should be getting
these errors...

Anyway, any ideas on how I can continue to debug and explain this?

Thanks,
Andrei
