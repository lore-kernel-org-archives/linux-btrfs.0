Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CBEC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60AA2081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfCGQau (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:30:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:33438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbfCGQau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 11:30:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39535AC8A
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 16:30:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2B1A9DA83C; Thu,  7 Mar 2019 17:32:05 +0100 (CET)
Date:   Thu, 7 Mar 2019 17:32:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: trace: Add trace events for extent_io_tree
Message-ID: <20190307163204.GK31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190301024800.17649-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301024800.17649-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 10:47:57AM +0800, Qu Wenruo wrote:
> - Allow NULL fs_info for TP_fast_assign_fsid()
>   There is extent bits operation in selftest which is too deep to pass
>   fs_info. And since it's in selftest, it shouldn't trigger trace
>   events.
>   But to be safe, we still need to check fs_indo in
>   TP_fast_assign_fsid(), for NULL fs_info, just keep fsid filled with
>   zero.

Ok, better be safe here. I'd still like to remove the conditional, as
the tests typically access only a single filesystem we could export the
fs_info globally, avoiding the need to pass it around.

> There is one point which need extra attention:
> 1) Those trace events are pretty heavy
>    The following workload would generate over 400 trace events.

I'm not sure if 400 is considered a lot, I'd say 400.000 would be a lot
for the steps below.

> 	mkfs.btrfs -f $dev
> 	start_trace
> 	mount $dev $mnt -o enospc_debug
> 	sync
> 	touch $mnt/file1
> 	touch $mnt/file2
> 	touch $mnt/file3
> 	xfs_io -f -c "pwrite 0 16k" $mnt/file4
> 	umount $mnt
> 	end_trace
>    It's not recommended to use them in real world environment.
> 
> Changelog:
> v2:
> - Introduce fs_info to distinguish different btrfs filesystems
> - Code style change to make trace code more elegant
> - Minor IO_TREE_* naming change.
> - Use btrfs_ino() to replace raw inode number.
> - Change extent_io_tree::owner declaration to avoid affecting spinlock.

v2 looks good to me, thanks. I'll add it to the 5.2 queue.
