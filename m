Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36043 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeAJPqy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:46:54 -0500
Received: by mail-qk0-f193.google.com with SMTP id d21so12422646qkj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:46:54 -0800 (PST)
Date: Wed, 10 Jan 2018 10:46:52 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH] btrfs: tree-check: reduce stack consumption in
 check_dir_item
Message-ID: <20180110154651.tq466ubntmbc7aws@destiny>
References: <20180110142851.27624-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110142851.27624-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 03:28:51PM +0100, David Sterba wrote:
> I've noticed that the updated item checker stack consumption increased
> dramatically in 542f5385e20cf97447 ("btrfs: tree-checker: Add checker
> for dir item")
> 
> tree-checker.c:check_leaf                    +552 (176 -> 728)
> 
> The array is 255 bytes long, dynamic allocation would slow down the
> sanity checks so it's more reasonable to keep it on-stack. Moving the
> variable to the scope of use reduces the stack usage again
> 
> tree-checker.c:check_leaf                    -264 (728 -> 464)
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
