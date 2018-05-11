Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40200 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbeEKORN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 10:17:13 -0400
Received: by mail-qt0-f195.google.com with SMTP id h2-v6so7235660qtp.7
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 07:17:13 -0700 (PDT)
Date: Fri, 11 May 2018 10:17:11 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 04/11] Btrfs: stop creating orphan items for truncate
Message-ID: <20180511141710.xgq3ozlug4ctp55f@destiny>
References: <cover.1526025007.git.osandov@fb.com>
 <bc3b880668e4102f32f2400dcf7945bb3a784050.1526025007.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bc3b880668e4102f32f2400dcf7945bb3a784050.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:56:09AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we insert an orphan item during a truncate so that if there's
> a crash, we don't leak extents past the on-disk i_size. However, since
> commit 7f4f6e0a3f6d ("Btrfs: only update disk_i_size as we remove
> extents"), we keep disk_i_size in sync with the extent items as we
> truncate, so orphan cleanup will never have any extents to remove. Don't
> bother with the superfluous orphan item.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
