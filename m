Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47617 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2G1Oul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 10:50:41 -0400
Received: by wgbdr13 with SMTP id dr13so3592215wgb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 07:50:40 -0700 (PDT)
From: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
To: Andreas Philipp <philipp.andreas@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: No SysRq remount because sb->s_bdev is NULL
Date: Sat, 28 Jul 2012 16:50:38 +0200
Message-ID: <2108513.KBpvBiH5fV@nezir>
In-Reply-To: <5013ED4A.3070609@gmail.com>
References: <1389197.DvrDHJORPI@nezir> <5013ED4A.3070609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, July 28, 2012 15:46:50 Andreas Philipp wrote:
> On 28.07.2012 15:41, Florian Albrechtskirchinger wrote:
> > During a SysRq emergency remount Btrfs mounts are not remounted. I tracked
> > the issue down to this line in do_emergency_remount() in fs/super.c:
> > if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
> > 	!(sb->s_flags & MS_RDONLY))
> > s_bdev is NULL for Btrfs super blocks and subsequently do_remount_sb() is
> > never called. I couldn't think of a solution, besides resorting to an ugly
> > strcmp(sb->s_type->name, "btrfs"), without adding a field to struct
> > super_block or similar changes.
> > Thoughts?
>
> Just a first thought. Is there a possibility to write a dummy value into
> sb->s_bdev for btrfs super blocks. Thus it will not be NULL and
> everything in do_emergency_remount() in fs/super.c will work as wanted.

Then other code paths testing sb->s_bdev for NULL and assuming a non-NULL sb-
>s_bdev is a valid block device would fail.

    Flo
