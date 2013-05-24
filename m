Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3EXKwb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 06:52:31 -0400
Date: Fri, 24 May 2013 12:52:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger Fischer <hoo.mb@web.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-tools: debian/patches/09-unaligned-memaccess.patch
Message-ID: <20130524105229.GO5187@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <519C52DA.9080000@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <519C52DA.9080000@web.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 22, 2013 at 07:08:42AM +0200, Holger Fischer wrote:
> Dear BTRFS-Community,
> attached is a patch that probably could be applied upstream:
> It is ... Fixing unaligned memory accesses ...
> Details to this patch could be read under
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=656955
> 
> I rechecked against latest git.
> As far as I can see, it's not applied yet.

I had been applied, but had to be updated further, see

https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=7b668965f0cf3fb8632c505a7a011189ee1a5a8e

"
Replacing memcpy with memmove does't work - gcc treats memmove
the same way it treats memcpy.

This patch brings in {get|put}_unaligned_le{16|32|64} (using the
packed struct method), and uses them in the failing get/set calls.

On architectures where unaligned accesses are cheap, these unaligned
macros should be optimized out by the compiler.
"

What's still missing is get_unaligned_* in the BTRFS_SETGET_STACK_FUNCS
macros.


david
