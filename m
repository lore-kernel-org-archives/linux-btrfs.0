Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:52908 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdKAFPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 01:15:12 -0400
Date: Wed, 1 Nov 2017 10:15:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Message-ID: <20171101101510.218eeead@natsu>
In-Reply-To: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 1 Nov 2017 01:00:08 -0400
Dave <davestechshop@gmail.com> wrote:

> To reconcile those conflicting goals, the only idea I have come up
> with so far is to use btrfs send-receive to perform incremental
> backups as described here:
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup .

Another option is to just use the regular rsync to a designated destination
subvolume on the backup host, AND snapshot that subvolume on that host from
time to time (or on backup completions, if you can synchronize that).

rsync --inplace will keep space usage low as it will not reupload entire files
in case of changes/additions to them.

Yes rsync has to traverse both directory trees to find changes, but that's
pretty fast (couple of minutes at most, for a typical root filesystem),
especially if you use SSD or SSD caching.

-- 
With respect,
Roman
