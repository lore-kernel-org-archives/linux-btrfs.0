Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:36640 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbJ2LpV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 07:45:21 -0400
Received: by ykba4 with SMTP id a4so3156820ykb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 04:45:21 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Oct 2015 17:15:21 +0530
Message-ID: <CAH4kpJwNsmkC-c7r3DEOY-gJ0VgANM9y3hWPBqtM3spD3g5rdg@mail.gmail.com>
Subject: Question about Object IDs
From: Quad Cores <quadcores.pict@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On the Btrfs wiki link :
https://btrfs.wiki.kernel.org/index.php/Trees, under the section 'FS
Tree' it says that the trees are numbered 5,256,257 and so on, and the
top level subvolume has the ID 5; and the first created subvolume has
an ID of 256.

However, after installing btrfs on my system as a module, when I
created a new subvolume (my first subvolume), the ID given to it was
257. I checked this through the command:
btrfs subvolume list /mnt/point

A member on the btrfs IRC <holgerh> also confirmed it and suggested me
to ask the mailing list first and update the wiki if required.

Thanks,
QuadCores
