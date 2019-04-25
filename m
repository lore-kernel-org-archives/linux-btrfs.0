Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDFFC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676CA20717
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfDYRPI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 13:15:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:45408 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbfDYRPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 13:15:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F661AE15;
        Thu, 25 Apr 2019 17:15:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 01029DA847; Thu, 25 Apr 2019 19:16:08 +0200 (CEST)
Date:   Thu, 25 Apr 2019 19:16:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs: fix null pointer dereference in
 write_pinned_extent_entries
Message-ID: <20190425171605.GM20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <20190425170806.1213-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425170806.1213-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 01:08:06AM +0800, Anand Jain wrote:
> btrfs/049 fails with null pointer dereference
> 
>  kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> ::
>  kernel: RIP: 0010:write_pinned_extent_entries+0x27/0x100 [btrfs]
> ::
>  kernel: Call Trace:
>  kernel:  __btrfs_write_out_cache+0x273/0x450 [btrfs]
>  kernel:  btrfs_write_out_ino_cache+0x84/0xd0 [btrfs]
>  kernel:  btrfs_save_ino_cache+0x414/0x500 [btrfs]
>  kernel:  commit_fs_roots+0xc6/0x190 [btrfs]
>  kernel:  btrfs_commit_transaction+0x4de/0xac0 [btrfs]
>  kernel:  btrfs_sync_file+0x35b/0x3d0 [btrfs]
>  kernel:  do_fsync+0x38/0x60
>  kernel:  __x64_sys_fsync+0x10/0x20
> 
>  %block_group::fs_info should be accessed only when block_group is not null.
> 
> (Fixes: de965ddc6f29 btrfs: get fs_info from block group in
>  write_pinned_extent_entries)

Thanks, I fixed it in misc-next already.
