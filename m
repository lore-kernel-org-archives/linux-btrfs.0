Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:34254 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbbGOAdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 20:33:53 -0400
Received: by ykax123 with SMTP id x123so23160232yka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 17:33:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A4E0F4.2060708@render-wahnsinn.de>
References: <55A4E0F4.2060708@render-wahnsinn.de>
From: Paul Harvey <csirac2@gmail.com>
Date: Wed, 15 Jul 2015 10:33:33 +1000
Message-ID: <CAB3_QuLscgwnObyUMjCRrsoBa+5jM0W-fhUx73EmLKEzjg3hyw@mail.gmail.com>
Subject: Re: Recreate Snapshots and their Parent Relationships on a second Server.
To: Robert Krig <robert.krig@render-wahnsinn.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs subvolume list -uq /some/subvol" can help figure out the
existing parent relationships, but in practice if your snapshots are
simply a linear series over time then I doubt you'll gain much by
parsing all those UUIDs over simply doing an initial btrfs
send/receive without any parent followed by send/receive operations
using the previous snapshot as the parent.

I'm assuming of course that your snapshots are easier to sort by
chronological order than parsing the UUIDs out of the "btrfs subvol
list -up" output.

In my experience I actually end up using slightly less disk space with
the new parent/child relationships on the new filesystem, I assume
because the original source filesystem had missing parents that no
longer exist as they've long since been pruned, but it might also just
be that there's less fragmentation and smaller metadata consumption to
hold the new relationships.

On 14 July 2015 at 20:14, Robert Krig <robert.krig@render-wahnsinn.de> wrote:
> Hi.
>
> I have an Old Server with a bunch of btrfs Snapshots.
> I'm setting up a new server and I would like to transfer those Snapshots
> as efficiently as possible, while still maintaining their parent<->child
> relationships for space efficient storage.
>
> Apart from manually using "btrfs send" and "btrfs send -p" where
> applicable, is there an easy way to transfer everything in one go?
>
> Can I identify Snapshot relationships via their ID or some other data
> that I can display using btrfs tools?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
