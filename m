Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35703 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbLIF1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 00:27:18 -0500
Received: by igcsu19 with SMTP id su19so3203028igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 21:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449637341.20669.0.camel@love2code.net>
References: <1449637341.20669.0.camel@love2code.net>
Date: Tue, 8 Dec 2015 22:27:17 -0700
Message-ID: <CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
Subject: Re: Missing half of available space (resend)
From: Chris Murphy <lists@colorremedies.com>
To: David Hampton <mailinglists@love2code.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 8, 2015 at 10:02 PM, David Hampton
<mailinglists@love2code.net> wrote:
> The
> 'btrfs fi df' command consistently shows a total size of around 3TB, and
> says that space is almost completely full.

and


> root@selene:~# btrfs fi df /video
> Data, RAID6: total=3.15TiB, used=3.11TiB

The "total=3.15TiB" means "there's a total of 3.15TiB allocated for
data chunks using raid6 profile" and of that 3.11TiB is used.

btrfs fi df doesn't ever show how much is free or available. You can
get an estimate of that by using 'btrfs fi usage' instead.



> root@selene:~# df -h /video
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vda         15T  3.2T  8.3T  28% /video

That's about right although it seems it's slightly overestimating the
available free space.


-- 
Chris Murphy
