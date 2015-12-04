Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.198.36.40.188.clients.your-server.de ([188.40.36.198]:45896
	"EHLO mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbbLDPVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Dec 2015 10:21:38 -0500
Subject: Re: btrfs crashing the kernel with Seagate 8TB SMR drives.
To: Codebird <codebird@birds-are-nice.me>, linux-btrfs@vger.kernel.org
References: <566084F8.5050705@birds-are-nice.me>
From: Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <5661AF77.6000009@render-wahnsinn.de>
Date: Fri, 4 Dec 2015 16:21:27 +0100
MIME-Version: 1.0
In-Reply-To: <566084F8.5050705@birds-are-nice.me>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As Chris mentioned, check out the Bug report here:
https://bugzilla.kernel.org/show_bug.cgi?id=93581


I have a 8TB SMR Drive and the kernel was reporting drive errors.
Switching to Kernel 3.16 (Standard Debian Jessie kernel) fixed it for me
( for the moment).

>From what I read in that kernel bug report. The patch has been submitted
for kernel 4.4.

On 03.12.2015 19:07, Codebird wrote:
> I've got a nice bug for you - because I can offer you what everyone
> likes to see, a precise error message.
>
> I've got a btrfs filesystem spread over six devices, RAID1 mode. Four
> of these are Seagate 8TB archive drives - those SMR ones that a few
> others have reported failing when used with btrfs. I've had that issue
> too, and I just can't explain why, other than to say that it only
> occurs when using them on my mainboard SATA ports, not via USB dock.
> But that's not what I'm reporting - that's just the source of the
> problem that causes the crash I am reporting.
>
> The crash occurs when scrubbing, after some time and some terabytes -
> or possibly just when reading a certain place, I'm not sure - and it
> gives this helpful error left on the screen along with a system so
> unresponsive numlock won't flash:
>
> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO
> failure
> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO
> failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
> IO failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
> IO failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
> IO failure
> <long indent, as if a CR was lost> BTRFS: assertion failed:
> f(fs_info->sb->s_flags & MS  <Cut by edge of screen>
> -----------[ cut here ]------------
> kernel BUG at ../fs/btrfs/ctree.h:4057!
>
> Not sure if some of those 5 might be 6, as I was in a hurry to get it
> back up both times and just got a blurry photo. But it looks to me
> like there might be a chunk of code that doesn't handle a hardware
> fault - rather than cleanly return an error it's causing the kernel to
> hang entirely. I've managed to get this to happen twice now, so it's
> certainly something worth looking into. This is on SUSE tumbleweed,
> with kernel 4.3.0-2-default.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

