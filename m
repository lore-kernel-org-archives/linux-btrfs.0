Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729725AbeGMPpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 11:45:15 -0400
Date: Fri, 13 Jul 2018 17:30:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH] btrfs: fix use-after-free of cmp workspace pages
Message-ID: <20180713153003.GB3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180713140720.4390-1-naota@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180713140720.4390-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 11:07:20PM +0900, Naohiro Aota wrote:
> btrfs_cmp_data_free() puts cmp's src_pages and dst_pages, but leaves
> their page address intact. Now, if you hit "goto again" in
> btrfs_extent_same_range() and hit some error in
> btrfs_cmp_data_prepare(), you'll try to unlock/put already put pages.
> 
> This is simple fix to reset the address to avoid use-after-free.
> 
> Fixes: 67b07bd4bec5 ("Btrfs: reuse cmp workspace in EXTENT_SAME ioctl")
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Thanks for catching it.

Reviewed-by: David Sterba <dsterba@suse.com>
