Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46192 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbeAZO3A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:29:00 -0500
Received: by mail-qt0-f193.google.com with SMTP id o35so1611569qtj.13
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:29:00 -0800 (PST)
Date: Fri, 26 Jan 2018 09:28:58 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: handle failure of add_pending_csums
Message-ID: <20180126142858.fz5zz2u447wezpgh@destiny>
References: <20180105164449.GQ3553@twin.jikos.cz>
 <1515401983-28451-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515401983-28451-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 10:59:43AM +0200, Nikolay Borisov wrote:
> add_pending_csums was added as part of the new data=ordered implementation in
> e6dcd2dc9c48 ("Btrfs: New data=ordered implementation"). Even back then it
> called the btrfs_csum_file_blocks which can fail but it never bothered handling
> the failure. In ENOMEM situation this could lead to the filesystem failing to
> write the checksums for a particular extent and not detect this. On read this
> could lead to the filesystem erroring out due to crc mismatch. Fix it by
> propagating failure from add_pending_csums and handling them
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
