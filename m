Return-Path: <SRS0=Wt7H=T4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBBAC04AB6
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 17:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2EC2075B
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 17:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfE1RSb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 May 2019 13:18:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:43802 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbfE1RSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 May 2019 13:18:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33712AE4D;
        Tue, 28 May 2019 17:18:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 06763DA85E; Tue, 28 May 2019 19:19:24 +0200 (CEST)
Date:   Tue, 28 May 2019 19:19:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: fix wrong ctime and mtime of a directory
 after log replay
Message-ID: <20190528171924.GV15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190515150247.24776-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515150247.24776-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 15, 2019 at 04:02:47PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When replaying a log that contains a new file or directory name that needs
> to be added to its parent directory, we end up updating the mtime and the
> ctime of the parent directory to the current time after we have set their
> values to the correct ones (set at fsync time), efectivelly losing them.
> 
> Sample reproducer:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ mkdir /mnt/dir
>   $ touch /mnt/dir/file
> 
>   # fsync of the directory is optional, not needed
>   $ xfs_io -c fsync /mnt/dir
>   $ xfs_io -c fsync /mnt/dir/file
> 
>   $ stat -c %Y /mnt/dir
>   1557856079
> 
>   <power failure>
> 
>   $ sleep 3
>   $ mount /dev/sdb /mnt
>   $ stat -c %Y /mnt/dir
>   1557856082
> 
>     --> should have been 1557856079, the mtime is updated to the current
>         time when replaying the log
> 
> Fix this by not updating the mtime and ctime to the current time at
> btrfs_add_link() when we are replaying a log tree.
> 
> This could be triggered by my recent fsync fuzz tester for fstests, for
> which an fstests patch exists titled "fstests: generic, fsync fuzz tester
> with fsstress".
> 
> Fixes: e02119d5a7b43 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to 5.2-rc queue, thanks.
