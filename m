Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34478 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeEKOT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 10:19:56 -0400
Received: by mail-qk0-f193.google.com with SMTP id p186-v6so4473552qkd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 07:19:56 -0700 (PDT)
Date: Fri, 11 May 2018 10:19:54 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 06/11] Btrfs: delete dead code in
 btrfs_orphan_commit_root()
Message-ID: <20180511141954.prisavxkt6lhoecq@destiny>
References: <cover.1526025007.git.osandov@fb.com>
 <49c85beed52a1a9cb350ae0e197aba8bc806682a.1526025007.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49c85beed52a1a9cb350ae0e197aba8bc806682a.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:56:11AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_orphan_commit_root() tries to delete an orphan item for a
> subvolume in the tree root, but we don't actually insert that item in
> the first place. See commit 0a0d4415e338 ("Btrfs: delete dead code in
> btrfs_orphan_add()"). We can get rid of it.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
