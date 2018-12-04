Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5DBC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF3C206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF3C206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbeLDOXl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:23:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:50114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeLDOXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 09:23:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C710EAE18;
        Tue,  4 Dec 2018 14:23:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F192FDAC39; Tue,  4 Dec 2018 15:23:16 +0100 (CET)
Date:   Tue, 4 Dec 2018 15:23:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: skip file_extent generation check for
 free_space_inode in run_delalloc_nocow
Message-ID: <20181204142315.GT17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181129093132.25147-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129093132.25147-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 05:31:32PM +0800, Lu Fengqi wrote:
> The btrfs/001 with inode_cache mount option will encounter the following
> warning:
> 
> WARNING: CPU: 1 PID: 23700 at fs/btrfs/inode.c:956 cow_file_range.isra.19+0x32b/0x430 [btrfs]
> CPU: 1 PID: 23700 Comm: btrfs Kdump: loaded Tainted: G        W  O      4.20.0-rc4-custom+ #30
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> RIP: 0010:cow_file_range.isra.19+0x32b/0x430 [btrfs]
> Call Trace:
>  ? free_extent_buffer+0x46/0x90 [btrfs]
>  run_delalloc_nocow+0x455/0x900 [btrfs]
>  btrfs_run_delalloc_range+0x1a7/0x360 [btrfs]
>  writepage_delalloc+0xf9/0x150 [btrfs]
>  __extent_writepage+0x125/0x3e0 [btrfs]
>  extent_write_cache_pages+0x1b6/0x3e0 [btrfs]
>  ? __wake_up_common_lock+0x63/0xc0
>  extent_writepages+0x50/0x80 [btrfs]
>  do_writepages+0x41/0xd0
>  ? __filemap_fdatawrite_range+0x9e/0xf0
>  __filemap_fdatawrite_range+0xbe/0xf0
>  btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
>  __btrfs_write_out_cache+0x42c/0x480 [btrfs]
>  btrfs_write_out_ino_cache+0x84/0xd0 [btrfs]
>  btrfs_save_ino_cache+0x551/0x660 [btrfs]
>  commit_fs_roots+0xc5/0x190 [btrfs]
>  btrfs_commit_transaction+0x2bf/0x8d0 [btrfs]
>  btrfs_mksubvol+0x48d/0x4d0 [btrfs]
>  btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
>  btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
>  btrfs_ioctl+0x123f/0x3030 [btrfs]
> 
> The file extent generation of the free space inode is equal to the last
> snapshot of the file root, so the inode will be passed to cow_file_rage.
> But the inode was created and its extents were preallocated in
> btrfs_save_ino_cache, there are no cow copies on disk.
> 
> The preallocated extents don't present on disk, and the
> btrfs_cross_ref_exist will ignore the -ENOENT returned by
> check_committed_ref, so we can directly write the inode to the disk.
> 
> Fixes: 78d4295b1eee ("btrfs: lift some btrfs_cross_ref_exist checks in nocow path")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

With updated changelog and reviewed-by added to misc-next, thanks.
