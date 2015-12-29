Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34478 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbbL2A35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 19:29:57 -0500
Received: by mail-ig0-f174.google.com with SMTP id ik10so5276030igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 16:29:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5681BDD0.1060407@online.no>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
	<pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
	<CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
	<5681A4D5.4060203@online.no>
	<CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
	<5681BDD0.1060407@online.no>
Date: Mon, 28 Dec 2015 17:29:56 -0700
Message-ID: <CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 3:55 PM, Waxhead <waxhead@online.no> wrote:

> I tried the following....
>
>  btrfs-image -t4 -c9 /dev/sdb1 /btrfs_raid6.img
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> checksum verify failed on 28734324736 found 5F516E2A wanted BBB2D39C
> checksum verify failed on 28734324736 found C4AA0B8D wanted 41745FB5
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> bytenr mismatch, want=28734324736, have=16273726433708437499
> Error reading metadata block
> Error adding block -5
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> checksum verify failed on 28734324736 found 5F516E2A wanted BBB2D39C
> checksum verify failed on 28734324736 found C4AA0B8D wanted 41745FB5
> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
> bytenr mismatch, want=28734324736, have=16273726433708437499
> Error reading metadata block
> Error flushing pending -5
> create failed (Success)
>
> Well, I can't make out what this is supposed to mean, but no output file...

Dunno. Maybe btrfs-show-super -fa for each device, along with
btrfs-debug-tree <dev> output to a file might have some useful info
for a dev. It could be a while before we hear from one though,
considering the season.

> Here is a (rather long) stack trace... should I use a pastebin instead of
> such large posts on this mailinglist?!

Nah if it posts without wrapping and all of it can go on list, best on
list. I'm expecting the balance fails because the fs is actually
damaged in a way neither the kernel or btrfs check can work around. So
I think it's an interesting case, but even better is if it's
reproducible. The thing is, you have one device with generation 0
which really makes no sense to me; and another with generation 4 which
is the one sabotaged. Yet the fs mounts without complaint, and without
the need for degraded mount option. Seems strange to me, and may not
be reproducible if there's something else that's happen unaccounted
for.



-- 
Chris Murphy
