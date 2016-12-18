Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:43112 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbcLRXxi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 18:53:38 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 582206002F
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 00:53:36 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Btrfs Heatmap - v3 - scriptable .. more flexible
Message-ID: <0ad8cf30-04bb-40d3-9929-388eb26a765e@mendix.com>
Date: Mon, 19 Dec 2016 00:53:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just tagged v3 of the Btrfs Heatmap utility, which can visualize the
usage of your btrfs filesystem.

https://github.com/knorrie/btrfs-heatmap

The changes since v2 implement features based on feedback here on the
list. Instead of ending up with a bloated list of command line options
while adding each requested feature, I chose to refactor the code so it
can be scripted, so users can build whatever they want, retrieving
objects with python-btrfs and feeding them to the image generator.

As such, there is no change in functionality available using heatmap.py
on the command line.

    But...

"Make heatmap better scriptable for flexibility"
https://github.com/knorrie/btrfs-heatmap/commit/095412ee2ec162b734219c64d9b3041a1741f28f

This change allows creating images from any list of devices or
blockgroups in the file system (Austin S. Hemmelgarn, "split separate
devices into independent images"). Examples are included in the commit
message. The actual images which belong to the example output can be
found here:
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2016-12-18-heatmap-scripting/

Qu Wenruo pointed out that the greyscale value used for dev_extent (the
usage for the block group is used here) does not necessarily have to be
correct: "And for 50%/50% assumption for RAID0, it's not true and we can
easily create a case where it's 100%/0%". (Qu)

I replied on that with "OTOH, for most cases it will still be correct
enough for the eye, because statistically seen, distribution of data
over the stripes will be more uniform more often than not".

Still, "The point is, for full fs or per-device output, a developer may
focus on the fragments of unallocated space in each device." (Qu)

The last commit, "Don't hardcode minimal brightness for dev_extents"
exposes the min_brightness, which tunes the brightness range of
allocated space. "Setting it to 255 will cause any allocated space to
show up as bright white, regardless of usage."

https://github.com/knorrie/btrfs-heatmap/commit/12483cedb287331afcf0e3ef076d7ba3c5ec7966

Oh, and I removed the code for the linear output mode, because my
opinion is that is really does not lead to usable images.

And yes, the next task is getting some colors involved! \o/

-- 
Hans van Kranenburg
