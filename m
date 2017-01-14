Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49512 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbdANUDe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Jan 2017 15:03:34 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id E6D7E60017
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jan 2017 20:53:49 +0100 (CET)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Btrfs Heatmap - v4 ... colors!!
To: linux-btrfs@vger.kernel.org
Message-ID: <33090601-0b56-7360-a256-aa5c27339d99@mendix.com>
Date: Sat, 14 Jan 2017 20:53:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just tagged v4 of the Btrfs Heatmap utility, which visualizes the
usage of your btrfs filesystem:

https://github.com/knorrie/btrfs-heatmap

It needs at least python-btrfs v5 to run, because of the fixed backref
handling.

The main changes are:
 * Colors! colors! colors!!!
 * Colors!
 * Improved documentation, thanks to user feedback. The first README
page does focus on quick satisfaction, while there are two extra
subpages about the extent-level details pictures and a scripting HOWTO
which explains how to do everything that the command line options cannot do.
 * The external 2k8 loc png library dependency is dropped, in favour of
a 34 line single purpose png writer implementation directly in the
script itself. This makes it even easier to get the thing going quickly,
and it makes the thing go more quickly as well.

And now, no more text to read. Go and create a bunch of beautiful
pictures and timelapses of your filesystem!

Have fun!

P.S. Here's where it all started... :D
http://logs.tvrrug.org.uk/logs/%23btrfs/2015-12-09.html#2015-12-09T20:54:04

-- 
Hans van Kranenburg
