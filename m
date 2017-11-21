Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34935 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbdKUQYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 11:24:36 -0500
Date: Tue, 21 Nov 2017 17:22:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Message-ID: <20171121162239.GO3553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz>
 <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 08:09:15PM +0000, Nick Terrell wrote:
> On 11/15/17, 6:41 AM, "David Sterba" <dsterba@suse.cz> wrote:
> > The branch is now in a state that can be tested. Turns out the memory
> > requirements are too much for grub, so the boot fails with "not enough
> > memory". The calculated value
> >
> > ZSTD_BTRFS_MAX_INPUT: 131072
> > ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
> >
> > This is not something I could fix easily, we'd probalby need a tuned
> > version of ZSTD for grub constraints. Adding Nick to CC.
> 
> If I understand the grub code correctly, we only need to read, and we have
> the entire input and output buffer in one segment. In that case you can use
> ZSTD_initDCtx(), and ZSTD_decompressDCtx(). ZSTD_DCtxWorkspaceBound() is
> only 155984. See decompress_single() in
> https://patchwork.kernel.org/patch/9997909/ for an example.

Does not help, still ENOMEM.
