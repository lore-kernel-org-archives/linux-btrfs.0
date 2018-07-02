Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43872 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbeGBPTB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 11:19:01 -0400
Date: Mon, 2 Jul 2018 08:18:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180702151853.mwlrinipbihq46zu@merlins.org>
References: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I'll split this part into a new thread:

> 2) Don't keep unrelated snapshots in one btrfs.
>    I totally understand that maintain different btrfs would hugely add
>    maintenance pressure, but as explains, all snapshots share one
>    fragile extent tree.

Yes, I understand that this is what I should do given what you
explained.
My main problem is knowing how to segment things so I don't end up with
filesystems that are full while others are almost empty :)

Am I supposed to put LVM thin volumes underneath so that I can share
the same single 10TB raid5?

If I do this, I would have
software raid 5 < dmcrypt < bcache < lvm < btrfs
That's a lot of layers, and that's also starting to make me nervous :)

Is there any other way that does not involve me creating smaller block
devices for multiple btrfs filesystems and hope that they are the right
size because I won't be able to change it later?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
