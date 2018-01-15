Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755018AbeAOJRf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 04:17:35 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 02910ACF6
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 09:17:34 +0000 (UTC)
Subject: Re: [PATCH 0/7] Misc btrfs-progs cleanups/fixes
To: linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e5d7b12d-d669-0f7d-caf6-2b2b8340f01d@suse.com>
Date: Mon, 15 Jan 2018 11:17:33 +0200
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.12.2017 10:39, Nikolay Borisov wrote:
> Here is a series doing some minor code cleanups, hopefully making the code 
> more idiomatic and easier to follow. They should be pretty low-risk and 
> introduce no functional changes (patches 1-5). 
> 
> The the last 2 patches deal with a regression of btrfs rescue super-recovery. 
> Turns out this was broken for sometime. Patch 6 introduces a regression test
> which hopefully will prevent further occurences and patch 7 fixes the actual 
> bug. 
> 
> Nikolay Borisov (7):
>   btrfs-progs: Explictly state test.sh must be executable
>   btrfs-progs: Factor out common print_device_info
>   btrfs-progs: Remove recover_get_good_super
>   btrfs-progs: Use list_for_each_entry in write_dev_all_supers
>   btrfs-progs: Document logic of btrfs_read_dev_super
>   btrfs-progs: Add test for super block recovery
>   btrfs-progs: Fix super-recovery
> 
>  chunk-recover.c                                  | 18 -------
>  disk-io.c                                        | 21 ++++++--
>  super-recover.c                                  | 28 ++---------
>  tests/README.md                                  |  4 +-
>  tests/fsck-tests/029-superblock-recovery/test.sh | 64 ++++++++++++++++++++++++
>  utils.c                                          | 18 +++++++
>  utils.h                                          |  3 ++
>  7 files changed, 110 insertions(+), 46 deletions(-)
>  create mode 100755 tests/fsck-tests/029-superblock-recovery/test.sh


Gentle ping since I'd like to get this into next btrfs-progs version,
especially the  "fix super-recovery" patch.

> 
