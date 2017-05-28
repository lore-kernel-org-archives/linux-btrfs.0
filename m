Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56984 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdE1ReH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 13:34:07 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 15C796003B
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 19:34:05 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v7
To: linux-btrfs@vger.kernel.org
Message-ID: <be800613-2bc3-14f3-707a-2ea34a6567a1@mendix.com>
Date: Sun, 28 May 2017 19:34:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tagged v7 of the python btrfs library:

https://github.com/knorrie/python-btrfs

This is a small release, with some fixes and a few new examples:

python-btrfs v7, May 28 2017
  * Also unpack bitmaps when showing the free space tree
  * Fixes:
    - A few unfortunate typos in __str__ methods of objects
  * Examples added:
    - Show background subvolume removal progress.
    - Show metadata tree sizes in bytes and amount of tree blocks.
    - Show file info by tree and inode number

Have fun,
-- 
Hans van Kranenburg
