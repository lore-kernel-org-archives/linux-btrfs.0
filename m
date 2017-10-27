Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdJ0QSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 12:18:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3964ACAB
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 16:18:29 +0000 (UTC)
Date: Fri, 27 Oct 2017 18:16:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 0/6] Btrfs-progs: rescue: To fix device related
Message-ID: <20171027161641.GL3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171017091312.31045-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 17, 2017 at 05:13:06PM +0800, Qu Wenruo wrote:
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
> Qu Wenruo (6):
>   btrfs-progs: Introduce function to fix unaligned device size
>   btrfs-progs: Introduce function to fix super block total bytes
>   btrfs-progs: rescue: Introduce fix-device-size
>   btrfs-progs: check: Also check and repair unalignment/mismatch device
>     and super size
>   btrfs-progs: test/fsck: Add test case image for --fix-dev-size
>   btrfs-progs: rescue: Fix zero-log mounted branch

Applied, thanks.

>  Documentation/btrfs-rescue.asciidoc                |  29 ++++
>  cmds-check.c                                       |  76 +++++++++
>  cmds-rescue.c                                      |  49 ++++++
>  .../dev_and_super_mismatch_unaligned.raw.xz        | Bin 0 -> 21536 bytes
>  volumes.c                                          | 178 +++++++++++++++++++++
>  volumes.h                                          |   4 +

The repair functions do not belong to volumes.c, but we need to move and
split cmds-check.c first so I'm going to apply it as-is.

I've also extended the test to exercise fix-device-size.
