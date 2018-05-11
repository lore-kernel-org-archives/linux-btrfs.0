Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33112 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbeEKRQr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 13:16:47 -0400
Received: by mail-pg0-f65.google.com with SMTP id i194-v6so2700450pgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:16:47 -0700 (PDT)
Date: Fri, 11 May 2018 10:16:44 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 01/11] Btrfs: remove stale comment referencing
 vmtruncate()
Message-ID: <20180511171644.GB29366@vader>
References: <cover.1526025007.git.osandov@fb.com>
 <d50e22690bdea060f485ac1dc19a54fa4d6e4411.1526025007.git.osandov@fb.com>
 <20180511101943.GS6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511101943.GS6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:19:43PM +0200, David Sterba wrote:
> On Fri, May 11, 2018 at 12:56:06AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Commit a41ad394a03b ("Btrfs: convert to the new truncate sequence")
> > changed vmtruncate() to truncate_setsize() but didn't update the comment
> > above it. truncate_setsize() never fails (the IS_SWAPFILE() check
> > happens elsewhere), so remove the comment.
> 
> There's one more mention of vmtruncate at btrfs_page_mkwrite, can you
> please remove it and review that the comment is not stale in other
> respects? Thanks.

Yup, I'll take a look at that.
