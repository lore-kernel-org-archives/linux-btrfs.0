Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148FBC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 12:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E435C20684
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 12:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfCHMoS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 07:44:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:54688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbfCHMoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 07:44:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB2CBAF93;
        Fri,  8 Mar 2019 12:44:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D14FFDA93A; Fri,  8 Mar 2019 13:45:33 +0100 (CET)
Date:   Fri, 8 Mar 2019 13:45:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix incorrect file size after shrinking truncate
 and fsync
Message-ID: <20190308124532.GP31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190304140612.23950-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304140612.23950-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 04, 2019 at 02:06:12PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we do a shrinking truncate against an inode which is already present
> in the respective log tree and then rename it, as part of logging the new
> name we end up logging an inode item that reflects the old size of the
> file (the one which we previously logged) and not the new smaller size.
> The decision to preserve the size previously logged was added by commit
> 1a4bcf470c886b ("Btrfs: fix fsync data loss after adding hard link to
> inode") in order to avoid data loss after replaying the log. However that
> decision is only needed for the case the logged inode size is smaller then
> the current size of the inode, as explained in that commit's change log.
> If the current size of the inode is smaller then the previously logged
> size, we know a shrinking truncate happened and therefore need to use
> that smaller size.
> 
> Example to trigger the problem:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ xfs_io -f -c "pwrite -S 0xab 0 8000" /mnt/foo
>   $ xfs_io -c "fsync" /mnt/foo
>   $ xfs_io -c "truncate 3000" /mnt/foo
> 
>   $ mv /mnt/foo /mnt/bar
>   $ xfs_io -c "fsync" /mnt/bar
> 
>   <power failure>
> 
>   $ mount /dev/sdb /mnt
>   $ od -t x1 -A d /mnt/bar
>   0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
>   *
>   0008000
> 
> Once we rename the file, we log its name (and inode item), and because
> the inode was already logged before in the current transaction, we log it
> with a size of 8000 bytes because that is the size we previously logged
> (with the first fsync). As part of the rename, besides logging the inode,
> we do also sync the log, which is done since commit d4682ba03ef618
> ("Btrfs: sync log after logging new name"), so the next fsync against our
> inode is effectively a no-op, since no new changes happened since the
> rename operation. Even if did not sync the log during the rename
> operation, the same problem (fize size of 8000 bytes instead of 3000
> bytes) would be visible after replaying the log if the log ended up
> getting synced to disk through some other means, such as for example by
> fsyncing some other modified file. In the example above the fsync after
> the rename operation is there just because not every filesystem may
> guarantee logging/journalling the inode (and syncing the log/journal)
> during the rename operation, for example it is needed for f2fs, but not
> for ext4 and xfs.
> 
> Fix this scenario by, when logging a new name (which is triggered by
> rename and link operations), using the current size of the inode instead
> of the previously logged inode size.
> 
> A test case for fstests follows soon.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202695
> Reported-by: Seulbae Kim <seulbae@gatech.edu>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
