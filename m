Return-Path: <SRS0=Wt7H=T4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500C5C04AB6
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 17:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D1CD2075B
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 17:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfE1RB6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 May 2019 13:01:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:38850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfE1RB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 May 2019 13:01:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2771AD43;
        Tue, 28 May 2019 17:01:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8B55FDA85E; Tue, 28 May 2019 19:02:51 +0200 (CEST)
Date:   Tue, 28 May 2019 19:02:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Btrfs: fix fsync not persisting changed
 attributes of a directory
Message-ID: <20190528170251.GU15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190515150238.21939-1-fdmanana@kernel.org>
 <20190516144855.11945-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516144855.11945-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 16, 2019 at 03:48:55PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> While logging an inode we follow its ancestors and for each one we mark
> it as logged in the current transaction, even if we have not logged it.
> As a consequence if we change an attribute of an ancestor, such as the
> UID or GID for example, and then explicitly fsync it, we end up not
> logging the inode at all despite returning success to user space, which
> results in the attribute being lost if a power failure happens after
> the fsync.
> 
> Sample reproducer:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ mkdir /mnt/dir
>   $ chown 6007:6007 /mnt/dir
> 
>   $ sync
> 
>   $ chown 9003:9003 /mnt/dir
>   $ touch /mnt/dir/file
>   $ xfs_io -c fsync /mnt/dir/file
> 
>   # fsync our directory after fsync'ing the new file, should persist the
>   # new values for the uid and gid.
>   $ xfs_io -c fsync /mnt/dir
> 
>   <power failure>
> 
>   $ mount /dev/sdb /mnt
>   $ stat -c %u:%g /mnt/dir
>   6007:6007
> 
>     --> should be 9003:9003, the uid and gid were not persisted, despite
>         the explicit fsync on the directory prior to the power failure
> 
> Fix this by not updating the logged_trans field of ancestor inodes when
> logging an inode, since we have not logged them. Let only future calls to
> btrfs_log_inode() to mark inodes as logged.
> 
> This could be triggered by my recent fsync fuzz tester for fstests, for
> which an fstests patch exists titled "fstests: generic, fsync fuzz tester
> with fsstress".
> 
> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Added to 5.2-rc queue, thanks.
