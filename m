Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36571 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbcKLXT2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 18:19:28 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id EDCD260112
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Nov 2016 00:19:23 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Btrfs Heatmap - visualize your filesystem
Message-ID: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
Date: Sun, 13 Nov 2016 00:19:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It seems I never mailed the list yet about a fun little tool to
visualize the space usage of a btrfs filesystem:

https://github.com/knorrie/btrfs-heatmap

It needs python-btrfs to query a btrfs filesystem for block group usage
and pypng to generate an image showing disk space usage as some kind of
heatmap.

More info is in the README inside the project.

The Hilbert curve might seem a little weird at first, but I haven't seen
a better way of visualization that keeps providing useful information
about locality for larger filesystems.

Today on IRC naptastic shared a timelapse video of using btrfs balance
after adding 2 disks to a filesystem:

20:30 < naptastic> https://youtu.be/AA5gvsRtLgI
20:30 < naptastic> Enjoy!

Oh, and if someone is bored... What about creating an ncurses frontend
for fun, that looks like this, while you're waiting on btrfs balance to
complete... https://hblok.net/blog_pics/nsd.png

Quote of the day:
01:09 < kdave> watching speeddisk was a computer game substitute of my youth

P.S. This program also shows how convenient it is to build something
else on top of python-btrfs... The lines that are really needed to get
all information about the filesystem can be counted on two hands. :)

Moo!
Knorrie
