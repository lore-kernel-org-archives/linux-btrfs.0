Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34449 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbL1CSR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:18:17 -0500
Received: by mail-io0-f176.google.com with SMTP id e126so294712123ioa.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 18:18:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568098B1.2040908@online.no>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
	<pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
Date: Sun, 27 Dec 2015 19:18:17 -0700
Message-ID: <CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 7:04 PM, Waxhead <waxhead@online.no> wrote:

> Since all drives register and since I can even mount the filesystem.

OK so you've umounted the file system, reconnected all devices,
mounted the file system normally, and there are no problems reported
in dmesg?

If so, yes I agree that a scrub should probably work, it should fix
any problems with the simulated corrupt device, and also not crash.

What if you umount, and run btrfs check without --repair, what are the
results? This is btrfs-progs 4.3.1?



-- 
Chris Murphy
