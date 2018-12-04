Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA73CC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ACA72082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ACA72082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbeLDOPu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:15:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:48536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726809AbeLDOPu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 09:15:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E553DADD6;
        Tue,  4 Dec 2018 14:15:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 75418DAC39; Tue,  4 Dec 2018 15:15:29 +0100 (CET)
Date:   Tue, 4 Dec 2018 15:15:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix fsync of files with multiple hard links in
 new directories
Message-ID: <20181204141529.GS17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181128142231.18822-1-fdmanana@kernel.org>
 <20181128145428.22944-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128145428.22944-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 02:54:28PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The log tree has a long standing problem that when a file is fsync'ed we
> only check for new ancestors, created in the current transaction, by
> following only the hard link for which the fsync was issued. We follow the
> ancestors using the VFS' dget_parent() API. This means that if we create a
> new link for a file in a directory that is new (or in an any other new
> ancestor directory) and then fsync the file using an old hard link, we end
> up not logging the new ancestor, and on log replay that new hard link and
> ancestor do not exist. In some cases, involving renames, the file will not
> exist at all.
> 
> Example:
> 
>   mkfs.btrfs -f /dev/sdb
>   mount /dev/sdb /mnt
> 
>   mkdir /mnt/A
>   touch /mnt/foo
>   ln /mnt/foo /mnt/A/bar
>   xfs_io -c fsync /mnt/foo
> 
>   <power failure>
> 
> In this example after log replay only the hard link named 'foo' exists
> and directory A does not exist, which is unexpected. In other major linux
> filesystems, such as ext4, xfs and f2fs for example, both hard links exist
> and so does directory A after mounting again the filesystem.
> 
> Checking if any new ancestors are new and need to be logged was added in
> 2009 by commit 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes"),
> however only for the ancestors of the hard link (dentry) for which the
> fsync was issued, instead of checking for all ancestors for all of the
> inode's hard links.
> 
> So fix this by tracking the id of the last transaction where a hard link
> was created for an inode and then on fsync fallback to a full transaction
> commit when an inode has more than one hard link and at least one new hard
> link was created in the current transaction. This is the simplest solution
> since this is not a common use case (adding frequently hard links for
> which there's an ancestor created in the current transaction and then
> fsync the file). In case it ever becomes a common use case, a solution
> that consists of iterating the fs/subvol btree for each hard link and
> check if any ancestor is new, could be implemented.
> 
> This solves many unexpected scenarios reported by Jayashree Mohan and
> Vijay Chidambaram, and for which there is a new test case for fstests
> under review.
> 
> Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
> Reported-by: Jayashree Mohan <jayashree2912@gmail.com>
> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
