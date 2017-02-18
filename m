Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39705 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbdBRHVn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Feb 2017 02:21:43 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: high cpu usage due to btrfs_find_space_for_alloc and rb_next
Message-ID: <02d3d58e-a254-eda5-a18a-36983d1e9f78@profihost.ag>
Date: Sat, 18 Feb 2017 08:16:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

is there any chance to optimize btrfs_find_space_for_alloc / rb_next on
big devices?

I've plenty of free space but most of the time there's only low I/O but
high cpu usage. perf top shows:

  60,41%  [kernel]                   [k] rb_next
   9,74%  [kernel]                   [k] btrfs_find_space_for_alloc
   5,55%  [kernel]                   [k] tree_search_offset.isra.25

# btrfs filesystem df /backup/
Data, single: total=14.85TiB, used=14.37TiB
System, single: total=32.00MiB, used=2.27MiB
Metadata, single: total=63.00GiB, used=54.87GiB
GlobalReserve, single: total=512.00MiB, used=80.17MiB

--
Stefan
