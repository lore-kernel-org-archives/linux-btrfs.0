Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36616 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbbEQIg4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 04:36:56 -0400
Received: by pdfh10 with SMTP id h10so99065059pdf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 01:36:55 -0700 (PDT)
Date: Sun, 17 May 2015 01:36:54 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
Message-ID: <20150517083654.GA5425@mew>
References: <554F6D43.2060806@googlemail.com>
 <554F7232.9080804@googlemail.com>
 <5557F490.5000606@googlemail.com>
 <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 17, 2015 at 08:19:48AM +0000, Duncan wrote:
> Philip Seeger posted on Sun, 17 May 2015 03:53:20 +0200 as excerpted:
> > 
> > On 05/10/2015 04:58 PM, Philip Seeger wrote:
> >> 
> >> Forgot to mention kernel version: Linux 4.0.1-1-ARCH
> >>
> >> $ sudo btrfs fi show Label: none  uuid:
> >> 3e8973d3-83ce-4d93-8d50-2989c0be256a
> >>     Total devices 1 FS bytes used 19.87GiB
> >>     devid    1 size 45.00GiB used 21.03GiB path /dev/sda1
> >>
> >> btrfs-progs v3.19.1
> >>
> > I think I forgot to mention that this btrfs filesystem was converted
> > from ext4 (not initially created as btrfs).
> > Could this cause this corruption?
> > 
> > Also, does this df output look weird to anyone, shouldn't metadata be
> > duplicated?
> > # btrfs fi df /
> > Data, single: total=21.00GiB, used=20.82GiB
> > System, single: total=32.00MiB, used=4.00KiB
> > Metadata, single: total=1.25GiB, used=901.21MiB
> > GlobalReserve, single: total=304.00MiB, used=0.00B
> 
> [Reordered to standard quote/reply order, so replies have proper 
> context.  Top posting... not so fun to reply to! =:^( ]
> 
> I can't answer the corruption bit, but answering the df metadata 
> question...
> 
> Normally, btrfs on a single device defaults to dup metadata type, single 
> data type.  The one /normal/ exception to that is when mkfs.btrfs detects 
> an ssd, where it defaults to single data due to ssd firmware often 
> canceling out the intended redundancy of dup anyway.[1]
> 
> However, conversion from ext* is a bit of a different ball game, and 
> while it /should/ default to dup metadata as well, on 4.0 and into 4.1-rcs 
> as a proper fix hasn't been posted, there's a balance-conversion bug 
> that's keeping type conversion from occurring, both in the normal btrfs 
> balance convert case and in the ext* conversion case.  Thus, ext* 
> conversions remain metadata-single mode and cannot be converted to 
> metadata-dup until this bug is fixed.
> 
> I said that a /proper/ fix hasn't yet been posted.  There has been a 
> bisect trace to the commit that killed balance-convert, and that can be 
> reverted, as I guess some distros are doing in their current releases.  
> However, that commit happened to fix an ext* to btrfs conversion fault, 
> that would cause ext* conversions to fail entirely.  So reverting that 
> commit does fix normal btrfs balance conversions, but it breaks the 
> ability to convert from ext* at all.  I don't know when /that/ was 
> broken, but apparently it was further back.
> 
> So right now, the only way to get a desired btrfs chunk redundancy type 
> is to use mkfs.btrfs to create it that way in the first place.  Which 
> means no ext* conversion unless you're happy with single-data/single-
> metadata, since that's what it ends up with, and balance-convert is ATM 
> currently broken and can't convert to other redundancy types.
> 
> Well, unless you want to do the ext* to btrfs convert with the current 
> tools as they are (with the commit in question so the ext*-conversion 
> actually works), then rebuild with that commit reverted, so balance-
> convert works...

Duncan is referring to the commit reverted here:
https://patchwork.kernel.org/patch/6238111/

Just to clarify, reverting 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e does
not break ext4 conversion. If you revert it, you can btrfs-convert, do a
btrfs balance to finalize the conversion, then do another btrfs balance
-dconvert=... -mconvert=... to convert the profile. I should have been
clearer in that other thread: conversion from ext4 to Btrfs works, its
just that the commit that caused the regression did not actually
accomplish what it set out to do: allow converting the data/metadata
profile of a freshly btrfs-converted ext4 filesystem.

-- 
Omar
