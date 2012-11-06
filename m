Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42185 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2KFU5r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 15:57:47 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so1303960iea.19
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Nov 2012 12:57:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50997863.DxtbfvNUpe1vD8o/%fengguang.wu@intel.com>
References: <50997863.DxtbfvNUpe1vD8o/%fengguang.wu@intel.com>
Date: Tue, 6 Nov 2012 21:57:47 +0100
Message-ID: <CAB9VWqBg-WFg=G1ogfGWCDW0rJaGce09X=ceTGeoSKY5mMvKuQ@mail.gmail.com>
Subject: Re: [ablock84-btrfs:btrfs-far 20/20] fs/btrfs/send.c:1683:51: sparse:
 incorrect type in argument 5 (different base types)
From: Alexander Block <ablock84@googlemail.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 6, 2012 at 9:51 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://github.com/ablock84/linux-btrfs.git btrfs-far
> head:   f9a5bb450a8cc7aa5fd4f11d0306b3f48cf2771d
> commit: f9a5bb450a8cc7aa5fd4f11d0306b3f48cf2771d [20/20] Btrfs: use libfarstream for btrfs send
>
>
> sparse warnings:
>
> + fs/btrfs/send.c:1683:51: sparse: incorrect type in argument 5 (different base types)
> fs/btrfs/send.c:1683:51:    expected unsigned long long [unsigned] [usertype] vol_gen
> fs/btrfs/send.c:1683:51:    got restricted __le64 [usertype] ctransid
> fs/btrfs/send.c:1693:61: sparse: incorrect type in argument 5 (different base types)
> fs/btrfs/send.c:1693:61:    expected unsigned long long [unsigned] [usertype] vol_gen
> fs/btrfs/send.c:1693:61:    got restricted __le64 [usertype] ctransid
> + fs/btrfs/send.c:3102:50: sparse: incorrect type in argument 2 (different address spaces)
> fs/btrfs/send.c:3102:50:    expected char [noderef] <asn:1>*<noident>
> fs/btrfs/send.c:3102:50:    got char *read_buf
> fs/btrfs/send.c:4101:62: sparse: incorrect type in argument 5 (different base types)
> fs/btrfs/send.c:4101:62:    expected unsigned long long [unsigned] [usertype] vol_gen
> fs/btrfs/send.c:4101:62:    got restricted __le64 [usertype] ctransid
> fs/btrfs/send.c:4132:51: sparse: incorrect type in argument 5 (different base types)
> fs/btrfs/send.c:4132:51:    expected unsigned long long [unsigned] [usertype] vol_gen
> fs/btrfs/send.c:4132:51:    got restricted __le64 [usertype] ctransid
>
> vim +1683 fs/btrfs/send.c
>
> 31db9f7c Alexander Block 2012-07-25  1677       read_extent_buffer(leaf, name, (unsigned long)(ref + 1), namelen);
> 31db9f7c Alexander Block 2012-07-25  1678       btrfs_release_path(path);
> 31db9f7c Alexander Block 2012-07-25  1679
> f9a5bb45 Alexander Block 2012-11-06  1680       vid = far_volume_identifier_create("btrfs", -1,
> f9a5bb45 Alexander Block 2012-11-06  1681                       sctx->send_root->root_item.uuid,
> f9a5bb45 Alexander Block 2012-11-06  1682                       BTRFS_UUID_SIZE,
> f9a5bb45 Alexander Block 2012-11-06 @1683                       sctx->send_root->root_item.ctransid,
> f9a5bb45 Alexander Block 2012-11-06  1684                       name, namelen);
> f9a5bb45 Alexander Block 2012-11-06  1685       if (!vid) {
> f9a5bb45 Alexander Block 2012-11-06  1686               ret = -ENOMEM;
> f9a5bb45 Alexander Block 2012-11-06  1687               goto out;
> 31db9f7c Alexander Block 2012-07-25  1688       }
> 31db9f7c Alexander Block 2012-07-25  1689       if (parent_root) {
> f9a5bb45 Alexander Block 2012-11-06  1690               parent_vid = far_volume_identifier_create("btrfs", -1,
> f9a5bb45 Alexander Block 2012-11-06  1691                               sctx->parent_root->root_item.uuid,
> f9a5bb45 Alexander Block 2012-11-06  1692                               BTRFS_UUID_SIZE,
> f9a5bb45 Alexander Block 2012-11-06 @1693                               sctx->parent_root->root_item.ctransid,
> f9a5bb45 Alexander Block 2012-11-06  1694                               "", -1);
> f9a5bb45 Alexander Block 2012-11-06  1695               if (!parent_vid) {
> f9a5bb45 Alexander Block 2012-11-06  1696                       ret = -ENOMEM;
>
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation

Sorry for the noise. For some reason that I currently don't understand
there is a build robot subscribed to my github account which thinks
that posting to the mailing list is a good idea...
