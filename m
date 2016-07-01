Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34232 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbcGAVSi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 17:18:38 -0400
Received: by mail-oi0-f44.google.com with SMTP id s66so127064315oif.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 14:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADbsYN2Y+UaOVZO_kATeomEy6Xho6kMkY-vgAyKMK4w2MV6VCQ@mail.gmail.com>
References: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
 <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com> <CADbsYN2Y+UaOVZO_kATeomEy6Xho6kMkY-vgAyKMK4w2MV6VCQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Jul 2016 14:51:50 -0600
Message-ID: <CAJCQCtQ_=Z1f6oO0gtjtA-wKiEL2VsB=iy0sE4AmwHwh-9gYXw@mail.gmail.com>
Subject: Re: btrfs lockup
To: Grey Christoforo <grey@christoforo.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 2:38 PM, Grey Christoforo <grey@christoforo.net> wrote:
> On Fri, Jul 1, 2016 at 7:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> This is too well trimmed. I'm not seeing the actual oops, can you trim
>> this less so it's possible to see what was going on a minute (or 10)
>> before this?
> I've updated the log[3]. There is no crash per se here, just the
> system becomes unresponsive. It looks like some watchdog timer goes
> off (NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!) and it
> becomes usable again for a few seconds before it locks up again and
> the process repeats.


This is interesting:

Jul 01 11:56:40 kernel: BTRFS info (device nvme0n1p5): relocating
block group 232511242240 flags 1

a. It's an NVMe drive.
b. Btrfs at this time is involved in a balance operation of some sort.


And then what you previously reported, the parts of which I don't follow:

Jul 01 12:00:31 kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck
for 22s! [scanner:7121]

Jul 01 12:00:31 kernel: CPU: 0 PID: 7121 Comm: scanner Tainted: P D W
O 4.6.3-1-ARCH #1
Jul 01 12:00:31 kernel: Hardware name: Dell Inc. XPS 15 9550/0N7TVV,
BIOS 01.02.00 04/07/2016
Jul 01 12:00:31 kernel: task: ffff880345c19e80 ti: ffff880157bac000
task.ti: ffff880157bac000
Jul 01 12:00:31 kernel: RIP: 0010:[<ffffffff810c5164>]
[<ffffffff810c5164>] queued_spin_lock_slowpath+0x174/0x190


Hmm, I'm not sure of the relationship between
queued_spin_lock_slowpath and Btrfs, in particular as it relates to
NVMe drives.

You could give 4.7.0rc5 a whirl and see if it reproduces there, but
that means redoing your balance at the same time as whatever else was
running at the same time.


>> About how many subvolumes?
> 100, maybe more.

That's nothing. I'd say it's a non-factor, but good to know.


-- 
Chris Murphy
