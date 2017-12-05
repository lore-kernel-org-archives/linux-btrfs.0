Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752592AbdLEP4f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 10:56:35 -0500
Date: Tue, 5 Dec 2017 16:54:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Message-ID: <20171205155433.GI3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz>
 <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com>
 <20171121162239.GO3553@suse.cz>
 <5BB834FC-A54C-4448-8D86-1D2F22806096@fb.com>
 <20171128234937.GG3553@suse.cz>
 <EF0643B4-092E-4D82-BA5B-9B02DFDEACA6@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EF0643B4-092E-4D82-BA5B-9B02DFDEACA6@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:44:32AM +0000, Nick Terrell wrote:
> >> It looks like XZ had the same issue, and they make the decompression
> >> context a static object (grep for GRUB_EMBED_DECOMPRESSOR). We could
> >> potentially do the same and statically allocate the workspace:
> >> 
> >> ```
> >> /* Could also be size_t */
> >> #define BTRFS_ZSTD_WORKSPACE_SIZE_U64 (155984 / sizeof(uint64_t))
> >> static uint64_t workspace[BTRFS_ZSTD_WORKSPACE_SIZE_U64];
> >> 
> >> /* ... */
> >> 
> >> assert(sizeof(workspace) >= ZSTD_DCtxWorkspaceBound());
> >> ```
> > 
> > Interesting, thanks for the tip, I'll try it next.

And it worked.

> > I've meanwhile tried to tweak the numbers, the maximum block for zstd,
> > that squeezed the DCtx somewhere under 48k, with block size 8k. Still
> > enomem.
> 
> Sadly the block size has to stay 128 KiB, since that is the block size that
> is used for compression.
> 
> > I've tried to add some debugging prints to see what numbers get actually
> > passed to the allocator, but did not see anything printed.  I'm sure
> > there is a more intelligent way to test the grub changes.  So far each
> > test loop takes quite some time, as I build the rpm package, test it in
> > a VM and have to recreate the environmet each time.
> 
> Is the code in github.com/kdave/grub in the btrfs-zstd branch up to date?
> btrfs.c:1230 looks like it will error for zstd compression, but not with
> ENOMEM. btrfs.c:1272 [2] looks like a typo. Maybe the second is causing
> the compressed block to be interpreted as uncompressed, and causes a
> too-large allocation?

I had a different branch with patches from openSUSE, so the diffs apply with
minimal efforts to the package. The branch btrfs-zstd has been synced up. The
ENOMEM error was not from the file decompression but from the zstdio.c module,
that does something different, now disabled.

I got a bit further, with a few debugging messages, this check fails:

 957   total_size = grub_le_to_cpu32 (grub_get_unaligned32 (ibuf));
 958   ibuf += sizeof (total_size);
 959
 960   if (isize < total_size) {
 961     grub_error (GRUB_ERR_BAD_FS, "ASSERTION: isize < total_size: %ld < %ld",
 962                     isize, total_size);
 963     return -1;
 964   }

with: "isize < total_size: 61440 < -47205080"

total_size is u32, but wrngly printed as signed long so it's negative, but
would be wrong anyway. This looks like the compressed format is not read
correctly.
