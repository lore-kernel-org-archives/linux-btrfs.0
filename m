Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49691 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaHSVJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 17:09:53 -0400
Received: by mail-ob0-f174.google.com with SMTP id vb8so5558311obc.5
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 14:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
References: <20140819162151.GA15166@forwiss.uni-passau.de>
Date: Tue, 19 Aug 2014 16:09:53 -0500
Message-ID: <CAKcLGm9=og4yx=RTECHozrDWW+p-bUAhvEQwX+KVUzL4Z8A58g@mail.gmail.com>
Subject: Re: Questions on using BtrFS for fileserver
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: M G Berberich <btrfs@oss.m-berberich.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 11:21 AM, M G Berberich
<btrfs@oss.m-berberich.de> wrote:
> Hello,
>
> we are thinking about using BtrFS on standard hardware for a
> fileserver with about 50T (100T raw) of storage (25×4TByte).
>

I would recommend carefully reading this thread titled: "1 week to
rebuid 4x 3TB raid10 is a long time!"

http://comments.gmane.org/gmane.comp.file-systems.btrfs/36969

There are multiple methods for replacing a device in a Btrfs RAID
array.  If I understand the conclusions of this thread, you might
still expect 12-14 hours to rebuild after replacing a 4 TByte device,
assuming you use the optimal replace commands.

With 25 devices, that leaves an uncomfortable period of time where
another device might fail.
