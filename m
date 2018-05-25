Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43899 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966645AbeEYQCV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 12:02:21 -0400
Received: by mail-pg0-f67.google.com with SMTP id p8-v6so2476352pgq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 09:02:21 -0700 (PDT)
Date: Fri, 25 May 2018 09:02:18 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 5/6] Btrfs: rename get_chunk_map() and make it
 non-static
Message-ID: <20180525160218.GB29193@vader>
References: <cover.1527197312.git.osandov@fb.com>
 <ad156ee9fa4c91c2760a60745f42773d0032824b.1527197312.git.osandov@fb.com>
 <37cbe6e1-9ad5-3fb2-e6dd-2d696d78d582@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <37cbe6e1-9ad5-3fb2-e6dd-2d696d78d582@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 12:21:41PM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.05.2018 00:41, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
> > make it non-static.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> nit: How about introducing proper kernel doc for this function, now that
> it becomes public just as good practice so that eventually we will have
> proper kernel doc for all public interfaces. You could also mention that
> it needs a paired free_extent_map

Will do, thanks.
