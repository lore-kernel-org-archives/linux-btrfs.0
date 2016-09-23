Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36162 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965005AbcIWVW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 17:22:56 -0400
Received: by mail-pf0-f173.google.com with SMTP id q2so45548606pfj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 14:22:55 -0700 (PDT)
Date: Fri, 23 Sep 2016 14:22:53 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2 6/6] Btrfs: use less memory for delalloc sanity tests
Message-ID: <20160923212253.GA15294@vader>
References: <cover.1474580472.git.osandov@fb.com>
 <c75f5b086bbf8ee43b2bb18e74aebcaeb81fa77a.1474580472.git.osandov@fb.com>
 <20160923092727.GU16983@twin.jikos.cz>
 <20160923165201.GA28767@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160923165201.GA28767@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 09:52:01AM -0700, Omar Sandoval wrote:
> On Fri, Sep 23, 2016 at 11:27:27AM +0200, David Sterba wrote:
> > On Thu, Sep 22, 2016 at 05:24:25PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > test_find_delalloc() allocates 256 MB worth of pages. That's all of the
> > > RAM that my MIPS emulator has, so it ends up panicking after it OOM
> > > kills everything. We don't actually need to use that much for this test.
> > 
> > I'm not sure we should limit it that way as more bytes can give it more
> > stress. Can we do it somehow dynamically ? Like start with 256M and fall
> > back to the numbers you've used.
> > 
> > Or maybe start from the low bound and allocate until it fails with first
> > ENOMEM.
> 
> I figured out how to get qemu to do highmem on MIPS, so we can drop this
> patch. It's reasonable to assume that the sanity tests are running on a
> machine with a decent amount of memory.

I lied, that didn't fix the problem for me, since these page allocations
can't use highmem. Anyways, the tests seem to be testing more for logic
errors manipulating the extent io tree, so just scaling it down
shouldn't be a huge issue, right?

The problem with relying on ENOMEM for anything is that the OOM killer
will kick in before we actually get the ENOMEM. I tried adding
__GFP_NORETRY, which claims that it doesn't invoke the OOM killer, but
it still did :(

Anyways, Cc Josef to see what he thinks since he wrote the test.

-- 
Omar
