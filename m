Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34799 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3F3RfK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 13:35:10 -0400
Received: by mail-ob0-f181.google.com with SMTP id 16so3557310obc.12
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 10:35:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
References: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
Date: Sun, 30 Jun 2013 12:35:09 -0500
Message-ID: <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
Subject: Re: lz4 status?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Roger Pack <rogerpack2005@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's been a parallel effort to incorporate a general set of lz4
patches in the kernel.

I see these patches are currently queued up in the linux-next tree, so
we may see them in the 3.11 kernel.

It looks like lz4 and lz4hc will be provided.

So, instead of btrfs having it's own implementation of lz4, the
patches will be re-worked around kernel's new lz4 library.

On Wed, Jun 26, 2013 at 10:57 AM, Roger Pack <rogerpack2005@gmail.com> wrote:
> Any update on the "unmerged" lz4 patches? Have they been merged?
> Just wondering (and +1'ing my support, obviously).
> Thank you.
> -roger-
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
