Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39619 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaGWBGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 21:06:16 -0400
Received: by mail-vc0-f175.google.com with SMTP id hu12so869298vcb.20
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 18:06:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53CE7ACF.7070109@fb.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<53C7CD0F.7070603@fb.com>
	<CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
	<1745216.hDa4tC2HJJ@merkaba>
	<53CE7ACF.7070109@fb.com>
Date: Tue, 22 Jul 2014 21:06:15 -0400
Message-ID: <CAGfcS_==i3_6AeqBKefJgQC+nuGerwKxd5uNAhvu0SZZdZwYKA@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Mason <clm@fb.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Cody P Schafer <dev@codyps.com>,
        Chris Samuel <chris@csamuel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 22, 2014 at 10:53 AM, Chris Mason <clm@fb.com> wrote:
>
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.

I've been away on vacation so I haven't been able to try your latest
patch, but I can try whatever is out there starting this weekend.

I was getting fairly consistent hangs during heavy IO (especially
rsync) on 3.15 with lzo enabled.  This is on raid1 across 5 drives,
directly against the partitions themselves (no dmcrypt, mdadm, lvm,
etc).  I disabled lzo and haven't had problems since.  I'm now running
on mainline without issue, but I think I did see the hang on mainline
when I tried enabling lzo again briefly.

Rich
