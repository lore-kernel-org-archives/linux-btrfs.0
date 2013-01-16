Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3APNDO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 08:03:14 -0500
Date: Wed, 16 Jan 2013 14:03:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 10/11] Btrfs: use bit operation for ->fs_state
Message-ID: <20130116130309.GS20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50EEB96F.6040706@cn.fujitsu.com>
 <20130110175735.GI20089@twin.jikos.cz>
 <50F3B8C7.3000902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F3B8C7.3000902@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 03:50:31PM +0800, Miao Xie wrote:
> On 	thu, 10 Jan 2013 18:57:35 +0100, David Sterba wrote:
> > On Thu, Jan 10, 2013 at 08:51:59PM +0800, Miao Xie wrote:
> >> There is no lock to protect fs_info->fs_state, it will introduce some problems,
> >> such as the value may be covered by the other task when several tasks modify
> >> it. Now we use bit operation for it to fix the above problem.
> > 
> > Can you please describe in more detail how does that happen and to what
> > problems it leads?
> 
> For example:
> 	Task0 - CPU0		Task1 - CPU1
> 	mov %fs_state rax
> 	or $0x1 rax
> 				mov %fs_state rax
> 				or $0x2 rax
> 	mov rax %fs_state
> 				mov rax %fs_state
> 
> The expected value is 3, but in fact, it is 2

Yes, generally this happens like this, but lacks connection to btrfs.
What's the call stack on the cpus when this happens? This would mean
that abort transaction is called at the same time from 2 cpus and 2
different flag bits need to be set on fs_state. As there's only one such
flag that's not the case right now.

Losing an error flag here is potentailly bad, so I agree this needs to be
fixed and be future proof, although I doubt that the case of 2
simultaneous aborts is even remotely possible. (Personal note: look for
such occurences.)

The changelog is not very specific and wants to be improved.

david
