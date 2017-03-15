Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47051 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751358AbdCONIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 09:08:32 -0400
Date: Wed, 15 Mar 2017 14:07:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/7] cleanup __btrfs_map_block
Message-ID: <20170315130753.GG14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 01:33:54PM -0700, Liu Bo wrote:
> This is attempting to make __btrfs_map_block less scary :)
> 
> The major changes are
> 
> 1) split operations for discard out of __btrfs_map_block and we don't copy
> discard operations for the target device of dev replace since they're not
> as important as writes.
> 
> 2) put dev replace stuff into helpers since they're basically
> self-independant.

Thank, I'm going to add the branch to 4.12 queue (right now the branch
is misc-next but it could change),

https://marc.info/?l=linux-btrfs&m=148741582021588

and fix that one too.
