Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38616 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbcGAVum (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 17:50:42 -0400
Received: by mail-wm0-f51.google.com with SMTP id r201so44870393wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 14:50:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ_=Z1f6oO0gtjtA-wKiEL2VsB=iy0sE4AmwHwh-9gYXw@mail.gmail.com>
References: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
 <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com>
 <CADbsYN2Y+UaOVZO_kATeomEy6Xho6kMkY-vgAyKMK4w2MV6VCQ@mail.gmail.com> <CAJCQCtQ_=Z1f6oO0gtjtA-wKiEL2VsB=iy0sE4AmwHwh-9gYXw@mail.gmail.com>
From: Grey Christoforo <grey@christoforo.net>
Date: Fri, 1 Jul 2016 22:50:21 +0100
Message-ID: <CADbsYN15dJa6OszsV3Fia6Qt=87RxuP28swy_s2JFORjOXO4iA@mail.gmail.com>
Subject: Re: btrfs lockup
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 9:51 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is interesting:
>
> Jul 01 11:56:40 kernel: BTRFS info (device nvme0n1p5): relocating
> block group 232511242240 flags 1
>
> a. It's an NVMe drive.
> b. Btrfs at this time is involved in a balance operation of some sort.
The balance operation is one I started manually. It's a coincidence
that it's running at this point and I don't believe it's related to
the lockups because
1) I saw the lockups on a previous baobab scan of my
/var/lib/docker/btrfs/subvolumes when no balance was taking place
and
2) after removing all of docker's subvolumes, the problem has gone away
>
>
> And then what you previously reported, the parts of which I don't follow:
>
> Jul 01 12:00:31 kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck
> for 22s! [scanner:7121]
I'd guess this is the kernel's protection mechanism to try to recover
when come critical (blocking) thread does not return, looks like it's
essentially killing the process when a watchdog timer expires.
