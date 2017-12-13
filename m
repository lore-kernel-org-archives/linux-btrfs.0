Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:35918 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdLMWKd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 17:10:33 -0500
Received: by mail-it0-f54.google.com with SMTP id d16so6452301itj.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 14:10:33 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 14 Dec 2017 01:09:52 +0300
Message-ID: <CAGqmi76womfiPa_EkKiJ-BgxEcU1GjK7efrh8bWVD0kD+C9NrQ@mail.gmail.com>
Subject: [BUG?] Defrag on compressed FS do massive data rewrites
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i see massive data rewrites of defragmented files when work with
btrfs fi def <args>.
Before, i just thought it's a design problem - i.e. defrag always
rewrite data to new place.

At now, i read the code and see 2 bad cases:
1. With -c<compression_algo> all extents of data will be rewriten, always.
2. btrfs use "bad" default target extent size, i.e. kernel by default
try get 256KiB extent, btrfs-progres use 32MiB as a threshold.
 Both of them make ioctl code should_defrag_range() think, that extent
are "too" fragmented, and rewrite all compressed extents.

Does that behavior expected?

i.e. only way that i can safely use on my data are:
btrfs fi def -vr -t 128KiB <path>
That will defrag all fragmented compressed extents.

"Hacky" solution that i see for now, is a create copy of inode_need_compress()
for defrag ioctl, and if file must be compressed, force use of 128KiB
as target extent.
or at least document that not obvious behaviour.

Thanks!

-- 
Have a nice day,
Timofey.
