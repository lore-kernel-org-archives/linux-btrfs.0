Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34710 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbF2Lj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 07:39:26 -0400
Received: by lagx9 with SMTP id x9so121872305lag.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 04:39:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$36112$278c5ce$95ee5224$7ba3d78f@cox.net>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
	<CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
	<CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
	<CA+xOVSMgqwOGxdhAjEZQHOCNhaJs-g2ieDE7qss8skyF4=shkw@mail.gmail.com>
	<pan$36112$278c5ce$95ee5224$7ba3d78f@cox.net>
Date: Mon, 29 Jun 2015 14:39:25 +0300
Message-ID: <CA+xOVSNnHn+H+QHVxE4Le7CY4cfddeRV2UEB87iq4ocEQDqRTg@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Regarding the main issue, the drive that was "recovered" using Noah's
trick (mount -o degraded then btrfs replace cancel) appears to be
clean. At least, it passes scrub without any errors. It even contains
all changes that were made during the replace was ongoing. Also i've
run MD's consistency check on the destination drive which contains the
corrupt FS and it appears to be clean from MD's point of view, so i
think it can be considered a "proof" the btrfs replace was actually
the source of the corruption. I'll try to reproduce the situation
before trying to upgrade the kernel/btrfs-progs with smaller loopback
devices. Not sure if it is reproducible so easily. The original
replace operation took more than 5 days and i'm not going to play with
the actual data again ;-).

If the "corrupt" version of the FS may help in debugging the issue,
please contact me today, before we have wiped it out.


On Mon, Jun 29, 2015 at 11:08 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Mordechay Kaganer posted on Mon, 29 Jun 2015 08:02:01 +0300 as excerpted:
>> 1. btrfs replace - as far as i understand, it's primarily intended for
>> replacing the member disks under btrfs's raid.
>
> It seems this /can/ work.  You demonstrated that much.  But I'm not sure
> whether btrfs replace was actually designed to do the single-device
> replace.  If not, it almost certainly hasn't been tested for it.  Even if
> so, I'm sure I'm not the only one who hadn't thought of using it that
> way, so while it might have been development-tested for single-device-
> replace, it's unlikely to have had the same degree of broader testing of
> actual usage, simply because few even thought of using it that way.

*If* replace is usable for single-drive FS, this method has the
advantage that it can be cancelled in the middle and (for single
drive, using Noah's trick) even after the operation has finished. For
multi-drive FS, the trick wouldn't help as soon as any changes were
made the the FS after the replace.

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
