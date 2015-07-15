Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f48.google.com ([209.85.216.48]:42419 "EHLO
	mail-vn0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbbGOPpS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 11:45:18 -0400
Received: by vnbf62 with SMTP id f62so4959864vnb.9
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 08:45:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A63F03.2080207@gmail.com>
References: <55A4F74D.9000305@gmail.com>
	<55A50DBF.1080602@gmail.com>
	<CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
	<55A63F03.2080207@gmail.com>
Date: Wed, 15 Jul 2015 09:45:17 -0600
Message-ID: <CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 5:07 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I've managed to get the other filesystems I was having issues with mounted
> again with the device= options and clear_cache after running btrfs dev scan
> a couple of times.  It seems to me (at least from what I'm seeing) that
> there is some metadata that isn't synchronized properly between the disks.

OK see if this logic follows without mistakes:

The fs metadata is raid6, and therefore is broken up across all
drives. Since you successfully captured an image of the file system
with btrfs-image, clearly user space tool is finding a minimum of n-2
drives. If it didn't complain of missing drives, it found n drives.

And yet the kernel is not finding n drives. And even with degraded it
still won't mount, therefore it's not finding n-2 drives.

By "drives" I mean either the physical device, or more likely whatever
minimal metadata is necessary for "assembling" all devices into a
volume. I don't know what that nugget of information is that's on each
physical device, separate from the superblocks (which I think is
distributed at logical addresses and therefore not on every physical
drive), and if we have any tools to extract just that and debug it.



-- 
Chris Murphy
