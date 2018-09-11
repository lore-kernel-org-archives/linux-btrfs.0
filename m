Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42701 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726554AbeIKQnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:43:42 -0400
Date: Tue, 11 Sep 2018 19:44:41 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH v3 00/10] undelete subvolume offline version
Message-ID: <20180911114441.GA2790@fnst.localdomain>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2018 at 11:10:23AM +0800, Lu Fengqi wrote:
>This patchset will add undelete-subvol subcommand for btrfs rescue.
>

Hi David

Although there are some disagreements about undeleting subvolumes online
implementation, the offline version is considered more acceptable. Would
you like to spend some time talking about your opinions?

-- 
Thanks,
Lu

>Patchset can be fetched from github:
>https://github.com/littleroad/btrfs-progs.git undelete
>
>v2->v3: fixed some issues pointed out by Qu.
>v1->v2: add -s option to allow user specify the subvolume which will be
>recovered.
>
>The first patch are not modified.
>For the rest, please see the changelog in the patches.
>
>Lu Fengqi (10):
>  btrfs-progs: copy btrfs_del_orphan_item from kernel
>  btrfs-progs: extract btrfs_link_subvol from btrfs_mksubvol
>  btrfs-progs: use btrfs_find_free_dir_index to find free inode index
>  btrfs-progs: undelete-subvol: introduce is_subvol_intact
>  btrfs-progs: undelete-subvol: introduce recover_dead_root
>  btrfs-progs: undelete-subvol: introduce link_subvol_to_lostfound
>  btrfs-progs: undelete-subvol: introduce btrfs_undelete_subvols
>  btrfs-progs: undelete-subvol: add undelete-subvol subcommand
>  btrfs-progs: tests: add testcase for undelete-subvol
>  btrfs-progs: undelete-subvol: update completion and documentation
>
> Documentation/btrfs-rescue.asciidoc           |  12 +
> Makefile                                      |   3 +-
> btrfs-completion                              |   2 +-
> cmds-rescue.c                                 |  69 ++++++
> convert/main.c                                |  59 ++++-
> ctree.h                                       |   8 +-
> inode.c                                       | 119 +++++----
> .../031-undelete-subvol/intact_subvolume.img  | Bin 0 -> 4096 bytes
> .../subvolume_in_drop_progress.raw.xz         | Bin 0 -> 23452 bytes
> tests/misc-tests/031-undelete-subvol/test.sh  |  38 +++
> undelete-subvol.c                             | 227 ++++++++++++++++++
> undelete-subvol.h                             |  11 +
> 12 files changed, 501 insertions(+), 47 deletions(-)
> create mode 100644 tests/misc-tests/031-undelete-subvol/intact_subvolume.img
> create mode 100644 tests/misc-tests/031-undelete-subvol/subvolume_in_drop_progress.raw.xz
> create mode 100755 tests/misc-tests/031-undelete-subvol/test.sh
> create mode 100644 undelete-subvol.c
> create mode 100644 undelete-subvol.h
>
>-- 
>2.17.0
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
