Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDD4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 16:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DB220C01
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 16:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfBZQeC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:34:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:33932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726507AbfBZQeC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 11:34:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3944EAAAE;
        Tue, 26 Feb 2019 16:34:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 543CCDA83C; Tue, 26 Feb 2019 17:35:18 +0100 (CET)
Date:   Tue, 26 Feb 2019 17:35:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
Subject: Re: [PATCH] Btrfs: fix deadlock between clone/dedupe and rename
Message-ID: <20190226163517.GB24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
References: <20190226120609.14450-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226120609.14450-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 26, 2019 at 12:06:09PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Reflinking (clone/dedupe) and rename are operations that operate on two
> inodes and therefore need to lock them in the same order to avoid ABBA
> deadlocks. It happens that Btrfs' reflink implementation always locked
> them in a different order from VFS's lock_two_nondirectories() helper,
> which is used by the rename code in VFS, resulting in ABBA type deadlocks.
> 
> Btrfs' locking order:
> 
>   static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
>   {
>          if (inode1 < inode2)
>                 swap(inode1, inode2);
> 
>          inode_lock_nested(inode1, I_MUTEX_PARENT);
>          inode_lock_nested(inode2, I_MUTEX_CHILD);
>   }
> 
> VFS's locking order:
> 
>   void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>   {
>         if (inode1 > inode2)
>                 swap(inode1, inode2);
> 
>         if (inode1 && !S_ISDIR(inode1->i_mode))
>                 inode_lock(inode1);
>         if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
>                 inode_lock_nested(inode2, I_MUTEX_NONDIR2);
> }
> 
> Fix this by killing the btrfs helper function that does the double inode
> locking and replace it with VFS's helper lock_two_nondirectories().
> 
> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> Fixes: 416161db9b63e3 ("btrfs: offline dedupe")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
