Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:35575 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753414AbdHUAiw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 20:38:52 -0400
Received: by mail-ua0-f194.google.com with SMTP id q40so847100uag.2
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Aug 2017 17:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818160838.GB2866@twin.jikos.cz>
References: <20170724172939.24527-1-dsterba@suse.com> <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
 <20170805012745.g44pyqgb42z6jvro@angband.pl> <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
 <20170818160838.GB2866@twin.jikos.cz>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 20 Aug 2017 18:38:50 -0600
Message-ID: <CAJCQCtRsTSypEVx7iVG+TCojqL30Q15xZH2PYiZq3HdqLqwa9A@mail.gmail.com>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
To: David Sterba <dsterba@suse.cz>, Nick Terrell <terrelln@fb.com>,
        Adam Borowski <kilobyte@angband.pl>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 10:08 AM, David Sterba <dsterba@suse.cz> wrote:

> That's quite a lot, in kernel. IIRC zlib and lzo use less than 200kb,
> zstd wants 800kb for level 1. And this needs to be contiguous memory, so
> if we're lucky and get the memory at the mount time, fine. In general
> the memory can be fragmented (in the worst case, there are only 4k
> chunks available), so we'd have to vmalloc and consume the virtual,
> mappings in great numbers.

Any thoughts on bootloader support, both in general, and as it relates
to levels of compression and memory constraints? GRUB switches to
protected mode early on but other bootloaders might have more
limitations. I guess really it's just GRUB and extlinux right now,
there were patches some time ago for Das U-Boot but they still aren't
merged.


-- 
Chris Murphy
