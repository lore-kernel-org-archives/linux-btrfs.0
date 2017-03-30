Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932851AbdC3Lok (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:44:40 -0400
Date: Thu, 30 Mar 2017 13:43:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: fix wrong failed mirror_num of read-repair on
 raid56
Message-ID: <20170330114354.GG4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
 <1490810066-18764-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490810066-18764-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 10:54:26AM -0700, Liu Bo wrote:
> In raid56 scenario, after trying parity recovery, we didn't set
> mirror_num for btrfs_bio with failed mirror_num, hence
> end_bio_extent_readpage() will report a random mirror_num in dmesg
> log.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
