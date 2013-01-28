Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab3A1RSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 12:18:00 -0500
Date: Mon, 28 Jan 2013 18:17:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Ben Peddell <klightspeed@killerwolves.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix unaligned accesses v2
Message-ID: <20130128171756.GE16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130127063404.6B61CF4275@kepler.killerwolves.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130127063404.6B61CF4275@kepler.killerwolves.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 27, 2013 at 03:45:43PM +1000, Ben Peddell wrote:
> gcc optimizes out the memcpy calls at -O2 and -Os.
> 
> Replacing memcpy with memmove does't work - gcc treats memmove
> the same way it treats memcpy.
> 
> This patch brings in {get|put}_unaligned_le{16|32|64} (using the
> packed struct method), and uses them in the failing get/set calls.
> 
> On architectures where unaligned accesses are cheap, these unaligned
> macros should be optimized out by the compiler.

Thanks, queued for integration. These tricky compilers ...

david
