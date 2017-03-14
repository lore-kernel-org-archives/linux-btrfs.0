Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752387AbdCNR16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 13:27:58 -0400
Date: Tue, 14 Mar 2017 18:27:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/7] cleanup __btrfs_map_block
Message-ID: <20170314172720.GE14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 17, 2017 at 05:28:14PM -0800, Liu Bo wrote:
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

The cleanup looks good to me, still reviewable. There's some feedback
beyond trivial, please update the patchset and resend so I can add it to
for-next.
