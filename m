Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35326 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdFHVf1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jun 2017 17:35:27 -0400
Received: by mail-wm0-f43.google.com with SMTP id x70so85265325wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jun 2017 14:35:22 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 8 Jun 2017 15:35:10 -0600
Message-ID: <CAJCQCtTJYsYXChwochYocJN-uo-OG-BFfogMwkhQuN9X__1z6A@mail.gmail.com>
Subject: status of swapfiles on Btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>, David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What's the status?

This message gave me an idea:
http://www.spinics.net/lists/linux-btrfs/msg40323.html

What about an xattr on both subvolume and the swapfile that would
inhibit btrfs user space tools from either snapshotting the subvolume
or the swapfile?

There could be a feature in btrfs user space tool to "create a
swapfile" which would do the full sequence:
1. create a subvolume at the top level
2. set a "do not snapshot" xattr on subvolume
3. fallocate a swapfile, presumably contiguous since swap can't use a
file with holes or gaps
4. set a "do not snapshot/reflink" xattr on the swapfile

Does this solve any usability concerns?



-- 
Chris Murphy
