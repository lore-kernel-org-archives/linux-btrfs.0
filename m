Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36680 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731863AbeISXsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 19:48:15 -0400
Received: by mail-yw1-f65.google.com with SMTP id i144-v6so2658121ywc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 11:09:11 -0700 (PDT)
Date: Wed, 19 Sep 2018 14:09:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 2/6] mm: export add_swap_extent()
Message-ID: <20180919180909.GC18068@cmpxchg.org>
References: <cover.1536704650.git.osandov@fb.com>
 <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 03:34:45PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Btrfs will need this for swap file support.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

That looks reasonable. After reading the last patch, it's somewhat
understandable why you cannot simply implemnet ->bmap and use the
generic activation code. But it would be good to explain the reason(s)
for why you can't here briefly to justify this patch.
