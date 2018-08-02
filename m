Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbeHBVDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 17:03:06 -0400
Date: Thu, 2 Aug 2018 21:10:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH] btrfs: revert fs_devices state on error of
 btrfs_init_new_device()
Message-ID: <20180802191033.GS3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180727000455.2647-1-naota@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180727000455.2647-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 27, 2018 at 09:04:55AM +0900, Naohiro Aota wrote:
> When btrfs hits error after modifying fs_devices in
> btrfs_init_new_device() (such as btrfs_add_dev_item() returns error), it
> leaves everything as is, but frees allocated btrfs_device. As a result,
> fs_devices->devices and fs_devices->alloc_list contain already freed
> btrfs_device, leading to later use-after-free bug.
> 
> Error path also messes the things like ->num_devices. While they go backs
> to the original value by unscanning btrfs devices, it is safe to revert
> them here.
> 
> Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Added to misc-next, thanks.
