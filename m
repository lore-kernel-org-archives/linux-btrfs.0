Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56539 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757708AbdKOQWL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:22:11 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, terrelln@fb.com
Subject: Re: Read before you deploy btrfs + zstd
Date: Wed, 15 Nov 2017 17:22:09 +0100
Message-ID: <1948454.KW55iiPqHI@merkaba>
In-Reply-To: <20171115143906.GM28899@twin.jikos.cz>
References: <20171113225046.GD28899@suse.cz> <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba - 15.11.17, 15:39:
> On Tue, Nov 14, 2017 at 07:53:31PM +0100, David Sterba wrote:
> > On Mon, Nov 13, 2017 at 11:50:46PM +0100, David Sterba wrote:
> > > Up to now, there are no bootloaders supporting ZSTD.
> > 
> > I've tried to implement the support to GRUB, still incomplete and hacky
> > but most of the code is there.  The ZSTD implementation is copied from
> > kernel. The allocators need to be properly set up, as it needs to use
> > grub_malloc/grub_free for the workspace thats called from some ZSTD_*
> > functions.
> > 
> > https://github.com/kdave/grub/tree/btrfs-zstd
> 
> The branch is now in a state that can be tested. Turns out the memory
> requirements are too much for grub, so the boot fails with "not enough
> memory". The calculated value
> 
> ZSTD_BTRFS_MAX_INPUT: 131072
> ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
> 
> This is not something I could fix easily, we'd probalby need a tuned
> version of ZSTD for grub constraints. Adding Nick to CC.

Somehow I am happy that I still have a plain Ext4 for /boot. :)

Thanks for looking into Grub support anyway.

Thanks,
-- 
Martin
