Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2FEV2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 17:28:30 -0400
Date: Tue, 5 Jun 2012 14:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
Message-Id: <20120605142826.d92316a0.akpm@linux-foundation.org>
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue,  5 Jun 2012 02:46:29 -0700
Joe Perches <joe@perches.com> wrote:

> KERN_<LEVEL> currently takes up 3 bytes.
> Shrink the kernel size by using an ASCII SOH and then the level byte.
> Remove the need for KERN_CONT.
> Convert directly embedded uses of <.> to KERN_<LEVEL>

What an epic patchset.  I guess that saving a byte per printk does make
the world a better place, and forcibly ensuring that nothing is
dependent upon the internal format of the KERN_foo strings is nice.


Unfortunately the <n> thing is part of the kernel ABI:

	echo "<4>foo" > /dev/kmsg

devkmsg_writev() does weird and wonderful things with
facilities/levels.  That function incorrectly returns "success" when
copy_from_user() faults, btw.  It also babbles on about LOG_USER and
LOG_KERN without ever defining these things.  I guess they're
userspace-only concepts and are hardwired to 0 and 1 in the kernel.  Or
not.

So what to do about /dev/kmsg?  I'd say "nothing": we retain "<n>" as
the externally-presented kernel format for a facility level, and the
fact that the kernel internally uses a different encoding is hidden
from userspace.

And if the user does

	echo "\0014foo" > /dev/kmsg

then I guess we should pass it straight through, retaining the \0014. 
But from my reading of your code, this doesn't work - vprintk_emit()
will go ahead and strip and interpret the \0014, evading the stuff
which devkmsg_writev() did.

