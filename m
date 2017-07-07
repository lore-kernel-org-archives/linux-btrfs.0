Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39843 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdGGXk2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 19:40:28 -0400
Date: Sat, 8 Jul 2017 01:40:18 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170707234018.syyfaktjxyxvwglc@angband.pl>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <20170706163225.xbluc2gi2nlaafzo@angband.pl>
 <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 07, 2017 at 11:17:49PM +0000, Nick Terrell wrote:
> On 7/6/17, 9:32 AM, "Adam Borowski" <kilobyte@angband.pl> wrote:
> > Got a reproducible crash on amd64:
> >
> > [98235.266511] BUG: unable to handle kernel paging request at ffffc90001251000

> > [98235.314008]  ? ZSTD_compressBlock_fast+0x94b/0xb30
> > [98235.315975]  ? ZSTD_compressContinue_internal+0x1a0/0x580
> > [98235.317938]  ? ZSTD_compressStream_generic+0x248/0x2f0
> > [98235.319877]  ? ZSTD_compressStream+0x41/0x60
> > [98235.321821]  ? zstd_compress_pages+0x236/0x5d0
> > [98235.323724]  ? btrfs_compress_pages+0x5e/0x80
> > [98235.325684]  ? compress_file_range.constprop.79+0x1eb/0x750
> 
> Thanks for the bug report Adam! I'm looking into the failure, and haven't
> been able to reproduce it yet. I've built my kernel from your tree, and
> I ran your script with the kernel.tar tarball 100 times, but haven't gotten
> a failure yet.

Crashed the same way 4 out of 4 tries for me.

> I have a few questions to guide my debugging.
> 
> - How many cores are you running with? I’ve run the script with 1, 2, and 4 cores.
> - Which version of gcc are you using to compile the kernel? I’m using gcc-6.2.0-5ubuntu12.
> - Are the failures always in exactly the same place, and does it fail 100%
>   of the time or just regularly?

6 cores -- all on bare metal.  gcc-7.1.0-9.

Lemme try with gcc-6, a different config or in a VM.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
