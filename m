Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755313AbcIWJ3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 05:29:31 -0400
Date: Fri, 23 Sep 2016 11:27:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH v2 6/6] Btrfs: use less memory for delalloc sanity tests
Message-ID: <20160923092727.GU16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1474580472.git.osandov@fb.com>
 <c75f5b086bbf8ee43b2bb18e74aebcaeb81fa77a.1474580472.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c75f5b086bbf8ee43b2bb18e74aebcaeb81fa77a.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:24:25PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> test_find_delalloc() allocates 256 MB worth of pages. That's all of the
> RAM that my MIPS emulator has, so it ends up panicking after it OOM
> kills everything. We don't actually need to use that much for this test.

I'm not sure we should limit it that way as more bytes can give it more
stress. Can we do it somehow dynamically ? Like start with 256M and fall
back to the numbers you've used.

Or maybe start from the low bound and allocate until it fails with first
ENOMEM.
