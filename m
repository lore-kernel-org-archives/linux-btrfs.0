Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:37084 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324Ab2FPAVX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 20:21:23 -0400
Date: Fri, 15 Jun 2012 20:21:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates
Message-ID: <20120616002119.GI19150@shiny>
References: <20120615180957.GE19150@shiny>
 <CA+55aFzD3P=DxzqhtRC6jRi9kwHiWRJo=yvyY=WnhYnhXvFi0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CA+55aFzD3P=DxzqhtRC6jRi9kwHiWRJo=yvyY=WnhYnhXvFi0w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 05:57:42PM -0600, Linus Torvalds wrote:
> On Fri, Jun 15, 2012 at 11:09 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Please pull my for-linus branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> This seems to introduce a new warning:
> 
>   In file included from fs/btrfs/ctree.c:22:0:
>   fs/btrfs/ctree.c: In function ‘btrfs_search_old_slot’:
>   fs/btrfs/ctree.h:2117:240: warning: ‘old_generation’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>   fs/btrfs/ctree.c:1178:6: note: ‘old_generation’ was declared here
> 
> which looks like just gcc being unable to see that it is only used
> when set, but it's still annoying. I'd suggest initializing it to 0
> just to shut up the compiler. Ok?
> 

Yes, this does look like noise.  It is only used when old_root is set,
but it'll be really easy to add bugs there later.

I've pushed two commits out, the second one is a printk cast on 32 bit
machines.  Neither of these are fatal but they are in for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (2) commits (+3/-2):
    Btrfs: cast devid to unsigned long long for printk %llu (+2/-1)
    Btrfs: init old_generation in get_old_root (+1/-1)

Total: (2) commits (+3/-2)

 fs/btrfs/ctree.c |    2 +-
 fs/btrfs/ioctl.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
