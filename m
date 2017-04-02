Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56674 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdDBABk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 20:01:40 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 98F4360061
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Apr 2017 02:01:39 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Btrfs Heatmap - v6
To: linux-btrfs@vger.kernel.org
Message-ID: <5a2c99d0-d419-edb7-2b0f-d9dfe81a01ef@mendix.com>
Date: Sun, 2 Apr 2017 02:01:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A few days ago, I tagged v6 of the Btrfs Heatmap utility, which
visualizes the usage of your btrfs filesystem:

https://github.com/knorrie/btrfs-heatmap

The main change is adapting to the python 3 only state of python-btrfs
v6. There's no functional difference between v5.

And... like python-btrfs, the btrfs-heatmap package is in the NEW queue
of Debian! W00t! Thanks again, kilobyte.

https://ftp-master.debian.org/new/btrfs-heatmap_6-1.html

Have fun! And, share some of your results, if you have nice pictures or
create timelapses of filesystems behaving or misbehaving. :)

-- 
Hans van Kranenburg
