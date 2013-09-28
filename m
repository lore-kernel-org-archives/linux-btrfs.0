Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42501 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3I1Xfg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 19:35:36 -0400
Received: by mail-ie0-f176.google.com with SMTP id as1so6988444iec.21
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 16:35:35 -0700 (PDT)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sun, 29 Sep 2013 01:35:15 +0200
Message-ID: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
Subject: Questions regarding logging upon fsync in btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have few questions regarding logging triggered by calling fsync in BTRFS:

1. If I understand correctly, fsync will call to log entire inode in
the log tree. Does this mean that the data extents are also logged
into the log tree? Are they copied into the log tree, or just
referenced? Are they copied into the subvolume's extent tree again
upon replay?

2. During replay, when the extents are added into the extent
allocation tree, do they acquire the physical extent number during
replay? Does they physical extent allocated to the data in the log
tree differ from that in the subvolume?

3. I see there is a mount option of notreelog available. After
disabling tree logging, does fsync still lead to flushing of buffers
to the disk directly?

4. Is it possible to selectively identify certain files in the log
tree and flush them to disk directly, without waiting for the replay
to do it?

Thanks

-- 
Aastha Mehta
