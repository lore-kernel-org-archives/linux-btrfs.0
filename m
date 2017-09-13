Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53673 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdIMP3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:29:02 -0400
Date: Wed, 13 Sep 2017 17:27:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, mfasheh@suse.de, dsterba@suse.com
Subject: Re: [PATCH] btrfs: propagate error to btrfs_cmp_data_prepare caller
Message-ID: <20170913152731.GN29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <150486053591.31637.4198233649091096390.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <150486053591.31637.4198233649091096390.stgit@naota.dhcp.fujisawa.hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 05:48:55PM +0900, Naohiro Aota wrote:
> btrfs_cmp_data_prepare() (almost) always returns 0 i.e. ignoring errors
> from gather_extent_pages(). While the pages are freed by
> btrfs_cmp_data_free(), cmp->num_pages still has > 0. Then,
> btrfs_extent_same() try to access the already freed pages causing faults
> (or violates PageLocked assertion).
> 
> This patch just return the error as is so that the caller stop the process.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> Fixes: f441460202cb ("btrfs: fix deadlock with extent-same and readpage")
> Cc: <stable@vger.kernel.org> # 4.2

Reviewed-by: David Sterba <dsterba@suse.com>
