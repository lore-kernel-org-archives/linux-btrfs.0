Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755861AbdJQNFY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 09:05:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 76CEFAB02
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 13:05:22 +0000 (UTC)
Subject: Re: [PATCH v2 0/6] Btrfs-progs: rescue: To fix device related
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171017091312.31045-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6a9d4d36-df2e-008f-281f-0eb08fb1e1de@suse.com>
Date: Tue, 17 Oct 2017 16:05:21 +0300
MIME-Version: 1.0
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.10.2017 12:13, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev
> 
> There are several reports in mail list for btrfs device size related
> problems.
> 
> 1) kernel refuse to mount some fs, due to mismatched super total_bytes
>    Unmountable if super total_bytes is smaller than total rw bytes of
>    all devices.
>    Root cause seems to be that, at least for kernel v4.13, some
>    device resize/add operation on unaligned device can lead to super
>    size out of sync with device size.
>    And normally this will cause super size to be 1 page (4096) smaller
>    than all devices' size.
> 
>    This patchset provides the tool to fix it offline.
>    (At least better than unmountable forever)
> 
> 2) Harmless kernel warning for btrfs_update_device()
>    v4.14 introduced restrict device size checker.
>    This is causing harmless but annoying kernel warnning.
> 
>    It can be fixed online with "btrfs filesystem resize".
> 
>    This patchset also provide a fallback method to fix it.
> 
> Finally, fix a typo which makes "btrfs rescue zero-log" to continue
> execution even the fs is mounted and error message outputted.
> 
> Changelog:
> v2:
>   Move the command line tool from "btrfs check" to "btrfs rescue",
>   suggested by David. Although fsck can still repair/detect it.
>   Function naming change for cmds-check.c part, suggested by Nikolay.
>   Remove inaccurate kernel version, suggested by Nikolay.
>   Fix a bug when coding in cmds-rescue.c.
>   Split the first patch to make review easier.
> 

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> Qu Wenruo (6):
>   btrfs-progs: Introduce function to fix unaligned device size
>   btrfs-progs: Introduce function to fix super block total bytes
>   btrfs-progs: rescue: Introduce fix-device-size
>   btrfs-progs: check: Also check and repair unalignment/mismatch device
>     and super size
>   btrfs-progs: test/fsck: Add test case image for --fix-dev-size
>   btrfs-progs: rescue: Fix zero-log mounted branch
> 
>  Documentation/btrfs-rescue.asciidoc                |  29 ++++
>  cmds-check.c                                       |  76 +++++++++
>  cmds-rescue.c                                      |  49 ++++++
>  .../dev_and_super_mismatch_unaligned.raw.xz        | Bin 0 -> 21536 bytes
>  volumes.c                                          | 178 +++++++++++++++++++++
>  volumes.h                                          |   4 +
>  6 files changed, 336 insertions(+)
>  create mode 100644 tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz
> 
