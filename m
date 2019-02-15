Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E095BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEB6821927
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfBORpn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:45:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:44572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbfBORpn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 12:45:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 605A6AE65;
        Fri, 15 Feb 2019 17:45:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7ED88DA87D; Fri, 15 Feb 2019 18:47:06 +0100 (CET)
Date:   Fri, 15 Feb 2019 18:47:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Btrfs: fix fsync after succession of renames of
 different files
Message-ID: <20190215174704.GH9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190212180628.25682-1-fdmanana@kernel.org>
 <20190213121403.3386-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213121403.3386-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 13, 2019 at 12:14:03PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After a succession of rename operations of different files and fsyncing
> one of them, such that each file gets a new name that corresponds to an
> old name of another file, we can end up with a log that will cause a
> failure when attempted to replay at mount time (an EEXIST error).
> We currently have correct behaviour when such succession of renames
> involves only two files, but if there are more files involved, we end up
> not logging all the inodes that are needed, therefore resulting in a
> failure when attempting to replay the log.
> 
> Example:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ mkdir /mnt/testdir
>   $ touch /mnt/testdir/fname1
>   $ touch /mnt/testdir/fname2
> 
>   $ sync
> 
>   $ mv /mnt/testdir/fname1 /mnt/testdir/fname3
>   $ mv /mnt/testdir/fname2 /mnt/testdir/fname4
>   $ ln /mnt/testdir/fname3 /mnt/testdir/fname2
> 
>   $ touch /mnt/testdir/fname1
>   $ xfs_io -c "fsync" /mnt/testdir/fname1
> 
>   <power failure>
> 
>   $ mount /dev/sdb /mnt
>   mount: mount /dev/sdb on /mnt failed: File exists
> 
> So fix this by checking all inode dependencies when logging an inode. That
> is, if one logged inode A has a new name that matches the old name of some
> other inode B, check if inode B has a new name that matches the old name
> of some other inode C, and so on. This fix is implemented not by doing any
> recursive function calls but by using an iterative method using a linked
> list that is used in a first-in-first-out fashion.
> 
> A test case for fstests follows soon.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

1 and 2 lightly reviewed, added to for-next and scheduled for 5.1.
Thanks.
