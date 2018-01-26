Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34186 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbeAZOWZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:22:25 -0500
Received: by mail-qt0-f175.google.com with SMTP id a27so1644595qtd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:22:25 -0800 (PST)
Date: Fri, 26 Jan 2018 09:22:21 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not check inode's runtime flags under
 root->orphan_lock
Message-ID: <20180126142220.fiqfkmy4cmmixa6v@destiny>
References: <20180125180256.10844-8-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-8-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:55AM -0700, Liu Bo wrote:
> It's not necessary to hold ->orphan_lock when checking inode's runtime
> flags.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
