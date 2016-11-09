Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:44630 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751800AbcKIIJm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 03:09:42 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: spinning kworker with space_cache=v2 searching for free space
Message-ID: <c9bf6cbb-ea68-a517-3c6e-7ff4ec1a788e@profihost.ag>
Date: Wed, 9 Nov 2016 09:09:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

even there's a lot of free space on my disk:

# df -h /vmbackup/
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/stripe0-backup   37T   24T   13T  64% /backup

# btrfs filesystem df /backup/
Data, single: total=23.75TiB, used=22.83TiB
System, DUP: total=8.00MiB, used=3.94MiB
Metadata, DUP: total=283.50GiB, used=105.82GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

I always have a kworker process endless spinning.

# perf top shows:
  47,56%  [kernel]               [k] rb_next
   7,71%  [kernel]               [k] tree_search_offset.isra.25
   6,44%  [kernel]               [k] btrfs_find_space_for_alloc

Mount options:
rw,noatime,compress-force=zlib,nossd,noacl,space_cache=v2,skip_balance

What's wrong here?

Greets,
Stefan
