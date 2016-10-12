Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:45644 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754788AbcJLNsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 09:48:15 -0400
Date: Wed, 12 Oct 2016 09:47:17 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 11:54:09AM -0400, Chris Mason wrote:
 > 
 > 
 > On 10/11/2016 10:45 AM, Dave Jones wrote:
 > > This is from Linus' current tree, with Al's iovec fixups on top.
 > > 
 > > ------------[ cut here ]------------
 > > WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
 > > list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
 > > CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13 
 > >  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
 > >  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880

I hit this again overnight, it's the same trace, the only difference
being slightly different addresses in the list pointers:

[42572.777196] list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc90000647cd8. (prev=ffff880503a0ba00).

I'm actually a little surprised that ->next was the same across two
reboots on two different kernel builds.  That might be a sign this is
more repeatable than I'd thought, even if it does take hours of runtime
right now to trigger it.  I'll try and narrow the scope of what trinity
is doing to see if I can make it happen faster.

	Dave

