Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:54108 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbdH1MS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 08:18:57 -0400
Date: Mon, 28 Aug 2017 17:18:55 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: deleted subvols don't go away?
Message-ID: <20170828171855.142a7224@natsu>
In-Reply-To: <83c6b0bb-a120-e0e3-dfc3-069ede63906f@gmail.com>
References: <1503854146.5155.2.camel@scientia.net>
        <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
        <cab790fa-22f7-b05d-b18e-000c7d1a81cd@gmail.com>
        <1503907621.1671.5.camel@scientia.net>
        <83c6b0bb-a120-e0e3-dfc3-069ede63906f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 28 Aug 2017 15:03:47 +0300
Nikolay Borisov <n.borisov.lkml@gmail.com> wrote:

> when the cleaner thread runs again the snapshot's root item is going to
> be deleted for good and you no longer will see it.

Oh, that's pretty sweet -- it means there's actually a way to reliably wait
for cleaner work to be done on all deleted snapshots before unmounting the FS.
I was wondering about that recently for some transient filesystems (which get
mounted, synced to, snapshot-created/removed, then unmounted). Now can just
loop with a few second sleeps until `btrfs sub list -d $PATH` comes up empty.

-- 
With respect,
Roman
