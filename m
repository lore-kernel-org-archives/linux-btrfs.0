Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcG0T42 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 15:56:28 -0400
Date: Wed, 27 Jul 2016 21:56:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
Message-ID: <20160727195609.GN30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 04:59:27PM +0300, Anatoly Pugachev wrote:
> Hello!
> 
> Running xfstests suite, got in logs mkfs.btrfs bus error, debugging it
> shows the following :
> 
> Program received signal SIGBUS, Bus error.
> 0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
> eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
> volumes.c:2156
> 2156                                    *(unsigned long *)(p_eb->data + i) ^=

Yeah, clear unaligned access. We have helpers for so I'll fix it. I was
looking for a way to simulate and catch that on x86 or at least let gcc
warn but no such thing seems to exist. Which means we might accidentally
introduce that in the future.
