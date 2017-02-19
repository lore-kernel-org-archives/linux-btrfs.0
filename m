Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34475 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdBSABf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Feb 2017 19:01:35 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 47F176000A
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Feb 2017 01:01:30 +0100 (CET)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Btrfs Heatmap - v5 ... snake, linear ... the virtual address space
To: linux-btrfs@vger.kernel.org
Message-ID: <c26fb483-6348-e4a0-d9aa-4363aac063a1@mendix.com>
Date: Sun, 19 Feb 2017 01:01:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just tagged v5 of the Btrfs Heatmap utility, which visualizes the
usage of your btrfs filesystem:

https://github.com/knorrie/btrfs-heatmap

The main changes are:
 * [e464bfc] New --curve to select either hilbert, linear or snake
 * [b722ff4] New --sort to sort a full filesystem picture by either
dev_extents (--sort physical, default) or by chunk/stripes (--sort virtual)
 * Improved documentation, mainly about the curve alternatives [0] and
about the new virtual address space option [1], but also other small
improvements.
 * debian branch with packaging files

[0] https://github.com/knorrie/btrfs-heatmap/blob/master/doc/curves.md
[1] https://github.com/knorrie/btrfs-heatmap/blob/master/doc/sort.md

Since I got tired of cloning and updating the thing all over the place,
I added debian packaging. I'm planning to get all of it into Debian
unstable after the Stretch release.

For the impatient, use pbuilder or grab it from our repo at $dayjob:
http://packages.mendix.com/debian/pool/main/b/btrfs-heatmap/
http://packages.mendix.com/debian/pool/main/p/python-btrfs/

Have fun! And, share some of your results, if you have nice pictures or
create timelapses of filesystems behaving or misbehaving. :)

-- 
Hans van Kranenburg
