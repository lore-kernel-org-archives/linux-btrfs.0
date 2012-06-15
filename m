Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41771 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2FOX6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 19:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120615180957.GE19150@shiny>
References: <20120615180957.GE19150@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Jun 2012 16:57:42 -0700
Message-ID: <CA+55aFzD3P=DxzqhtRC6jRi9kwHiWRJo=yvyY=WnhYnhXvFi0w@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
To: Chris Mason <chris.mason@fusionio.com>, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 11:09 AM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> Please pull my for-linus branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This seems to introduce a new warning:

  In file included from fs/btrfs/ctree.c:22:0:
  fs/btrfs/ctree.c: In function ‘btrfs_search_old_slot’:
  fs/btrfs/ctree.h:2117:240: warning: ‘old_generation’ may be used
uninitialized in this function [-Wmaybe-uninitialized]
  fs/btrfs/ctree.c:1178:6: note: ‘old_generation’ was declared here

which looks like just gcc being unable to see that it is only used
when set, but it's still annoying. I'd suggest initializing it to 0
just to shut up the compiler. Ok?

                 Linus
