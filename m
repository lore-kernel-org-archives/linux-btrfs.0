Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752069AbdDKLrN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 07:47:13 -0400
Date: Tue, 11 Apr 2017 13:47:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix potential use-after-free for cloned bio
Message-ID: <20170411114710.GF4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491852986-7133-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491852986-7133-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:36:26PM -0700, Liu Bo wrote:
> KASAN reports that there is a use-after-free case of bio in btrfs_map_bio.
> 
> If we need to submit IOs to several disks at a time, the original bio
> would get cloned and mapped to the destination disk, but we really should
> use the original bio instead of a cloned bio to do the sanity check
> because cloned bios are likely to be freed by its endio.
> 
> Reported-by: Diego <diegocg@gmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
