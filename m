Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:33460 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934791AbcJMSQw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 14:16:52 -0400
Date: Thu, 13 Oct 2016 14:16:22 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161013181622.qpi5puv6ivxvslnf@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
 <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
 <20161012144012.7vvfehceoykswmun@codemonkey.org.uk>
 <fb1a1c38-1ed8-e0eb-740d-c34c1d6c18f4@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb1a1c38-1ed8-e0eb-740d-c34c1d6c18f4@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 10:42:46AM -0400, Chris Mason wrote:
 > On 10/12/2016 10:40 AM, Dave Jones wrote:
 > > On Wed, Oct 12, 2016 at 09:47:17AM -0400, Dave Jones wrote:
 > >  > On Tue, Oct 11, 2016 at 11:54:09AM -0400, Chris Mason wrote:
 > >  >  >
 > >  >  >
 > >  >  > On 10/11/2016 10:45 AM, Dave Jones wrote:
 > >  >  > > This is from Linus' current tree, with Al's iovec fixups on top.
 > >  >  > >
 > >  >  > > ------------[ cut here ]------------
 > >  >  > > WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
 > >  >  > > list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
 > >  >  > > CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13
 > >  >  > >  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
 > >  >  > >  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880
 > >  >
 > >  > I hit this again overnight, it's the same trace, the only difference
 > >  > being slightly different addresses in the list pointers:
 > >  >
 > >  > [42572.777196] list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc90000647cd8. (prev=ffff880503a0ba00).
 > >  >
 > >  > I'm actually a little surprised that ->next was the same across two
 > >  > reboots on two different kernel builds.  That might be a sign this is
 > >  > more repeatable than I'd thought, even if it does take hours of runtime
 > >  > right now to trigger it.  I'll try and narrow the scope of what trinity
 > >  > is doing to see if I can make it happen faster.
 > >
 > > .. and of course the first thing that happens is a completely different
 > > btrfs trace..
 > >
 > >
 > > WARNING: CPU: 1 PID: 21706 at fs/btrfs/transaction.c:489 start_transaction+0x40a/0x440 [btrfs]
 > > CPU: 1 PID: 21706 Comm: trinity-c16 Not tainted 4.8.0-think+ #14
 > >  ffffc900019076a8 ffffffffb731ff3c 0000000000000000 0000000000000000
 > >  ffffc900019076e8 ffffffffb707a6c1 000001e9f5806ce0 ffff8804f74c4d98
 > >  0000000000000801 ffff880501cfa2a8 000000000000008a 000000000000008a
 > 
 > This isn't even IO.  Uuughhhh.  We're going to need a fast enough test 
 > that we can bisect.

Progress...
I've found that this combination of syscalls..

./trinity -C64 -q -l off -a64 --enable-fds=testfile -c fsync -c fsetxattr -c lremovexattr -c pwritev2

hits one of these two bugs in a few minutes runtime.

Just the xattr syscalls + fsync isn't enough, neither is just pwrite + fsync.
Mix them together though, and something goes awry.

	Dave

