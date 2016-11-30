Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:51308 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750700AbcK3FiO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 00:38:14 -0500
Date: Wed, 30 Nov 2016 10:38:08 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Wilson Meier <wilson.meier@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Convert from RAID 5 to 10
Message-ID: <20161130103808.74e5ae95@natsu>
In-Reply-To: <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com>
 <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Nov 2016 00:16:48 +0100
Wilson Meier <wilson.meier@gmail.com> wrote:

> That said, btrfs shouldn't be used for other then raid1 as every other
> raid level has serious problems or at least doesn't work as the expected
> raid level (in terms of failure recovery).

RAID1 shouldn't be used either:

*) Read performance is not optimized: all metadata is always read from the
first device unless it has failed, data reads are supposedly balanced between
devices per PID of the process reading. Better implementations dispatch reads
per request to devices that are currently idle.

*) Write performance is not optimized, during long full bandwidth sequential
writes it is common to see devices writing not in parallel, but with a long
periods of just one device writing, then another. (Admittedly have been some
time since I tested that).

*) A degraded RAID1 won't mount by default.

If this was the root filesystem, the machine won't boot.

To mount it, you need to add the "degraded" mount option.
However you have exactly a single chance at that, you MUST restore the RAID to
non-degraded state while it's mounted during that session, since it won't ever
mount again in the r/w+degraded mode, and in r/o mode you can't perform any
operations on the filesystem, including adding/removing devices.

*) It does not properly handle a device disappearing during operation. (There
is a patchset to add that).

*) It does not properly handle said device returning (under a
different /dev/sdX name, for bonus points).

Most of these also apply to all other RAID levels.

-- 
With respect,
Roman
