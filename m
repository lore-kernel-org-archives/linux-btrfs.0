Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:41330 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753040AbeGBRdL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:33:11 -0400
Date: Mon, 2 Jul 2018 22:33:09 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180702223309.582f4e19@natsu>
In-Reply-To: <20180702151903.j3j522urrtyznylf@merlins.org>
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
        <20180702151903.j3j522urrtyznylf@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2 Jul 2018 08:19:03 -0700
Marc MERLIN <marc@merlins.org> wrote:

> I actually have fewer snapshots than this per filesystem, but I backup
> more than 10 filesystems.
> If I used as many snapshots as you recommend, that would already be 230
> snapshots for 10 filesystems :)

(...once again me with my rsync :)

If you didn't use send/receive, you wouldn't be required to keep a separate
snapshot trail per filesystem backed up, one trail of snapshots for the entire
backup server would be enough. Rsync everything to subdirs within one
subvolume, then do timed or event-based snapshots of it. You only need more
than one trail if you want different retention policies for different datasets
(e.g. in my case I have 91 and 31 days).

-- 
With respect,
Roman
