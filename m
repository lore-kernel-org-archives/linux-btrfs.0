Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2G1NrJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 09:47:09 -0400
Received: by weyx8 with SMTP id x8so2676387wey.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 06:47:06 -0700 (PDT)
Message-ID: <5013ED4A.3070609@gmail.com>
Date: Sat, 28 Jul 2012 15:46:50 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>,
        Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: No SysRq remount because sb->s_bdev is NULL
References: <1389197.DvrDHJORPI@nezir>
In-Reply-To: <1389197.DvrDHJORPI@nezir>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just a first thought. Is there a possibility to write a dummy value into
sb->s_bdev for btrfs super blocks. Thus it will not be NULL and
everything in do_emergency_remount() in fs/super.c will work as wanted.

Thanks,
Andreas


On 28.07.2012 15:41, Florian Albrechtskirchinger wrote:
> Hi,
>
> During a SysRq emergency remount Btrfs mounts are not remounted. I tracked the 
> issue down to this line in do_emergency_remount() in fs/super.c:
> if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
> 	!(sb->s_flags & MS_RDONLY))
> s_bdev is NULL for Btrfs super blocks and subsequently do_remount_sb() is 
> never called. I couldn't think of a solution, besides resorting to an ugly 
> strcmp(sb->s_type->name, "btrfs"), without adding a field to struct super_block 
> or similar changes.
> Thoughts?
>
>     Flo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

