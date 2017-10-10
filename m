Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755214AbdJJIP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 04:15:58 -0400
Subject: Re: [PATCH 0/4] btrfs-progs repair support for unaligned/mismatched
 device sizes
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yoasif@gmail.com, rrauenza@gmail.com
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2adcdf9e-3a38-8be1-4e5b-bec71038ee26@suse.com>
Date: Tue, 10 Oct 2017 11:15:53 +0300
MIME-Version: 1.0
In-Reply-To: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.10.2017 10:51, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev
> 
> There are several reports in mail list for btrfs device size related
> problems.
> 
> 1) Unmountable fs, due to mismatched super total_bytes
>    Unmountable if super total_bytes is smaller than total rw bytes of
>    all devices.
>    Root cause under investigation, but only one report here.

Don't you mean mountable? We've internally seen mounting being a problem
due to said size mismatch.

> 
>    This patchset provides the tool to fix it offline.
>    (At least better than unmountable forever)
> 
> 2) Harmless kernel warning for btrfs_update_device()
>    v4.14 introduced restrict device size checker.
>    This somewhat break the backward compatibility and causing kernel
>    warning.
> 
>    It can be fixed online with "btrfs filesystem resize".
>    (Although it is better to fixed it at mount time)
> 
>    This patchset also provide a fallback method to fix it.
> 
> Qu Wenruo (4):
>   btrfs-progs: Introduce functions to repair unaligned/mismatch device
>     size
>   btrfs-progs: fsck: Introduce --fix-dev-size option
>   btrfs-progs: check: Also check unalignment/mismatch device and super
>     size
>   btrfs-progs: test/fsck: Add test case image for --fix-dev-size
> 
> Qu Wenruo (4):
>   btrfs-progs: Introduce functions to repair unaligned/mismatch device
>     size
>   btrfs-progs: fsck: Introduce --fix-dev-size option
>   btrfs-progs: check: Also check unalignment/mismatch device and super
>     size
>   btrfs-progs: test/fsck: Add test case image for --fix-dev-size
> 
>  Documentation/btrfs-check.asciidoc                 |  23 ++
>  cmds-check.c                                       | 292 ++++++++++++++++++++-
>  .../dev_and_super_mismatch_unaligned.raw.xz        | Bin 0 -> 21536 bytes
>  3 files changed, 314 insertions(+), 1 deletion(-)
>  create mode 100644 tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz
> 
