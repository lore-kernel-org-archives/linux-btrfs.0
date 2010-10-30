From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.37
Date: Sat, 30 Oct 2010 09:21:08 -0700
Message-ID: <AANLkTim+JMLE4fbg7gkoA+g9JfQzy6edUfiHh87mMSa7@mail.gmail.com>
References: <20101030135111.GA2918@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.og,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030135111.GA2918@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 30, 2010 at 6:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
>
> There were some minor conflicts with Linus' current tree, so my branch
> is merged with Linus' tree as of this morning.

Gaah. Please don't do this. Unless it's a _really_ messy merge, I
really do want to do the merge. It's fine to have an alternate
pre-merged branch for me to compare against, but please do that
separately.

So what I did was to just instead merge the state before your merge,
and in the process I:

 (a) noticed that your merge was incorrect (you had left around a
unused "error:" label in btrfs_mount()), since I did use your merge as
something to compare against (see above). That label had been removed
in your branch by  commit 0e78340f3c1f, but your merge resurrected it.

 (b) saw just how horribly nasty your writeback_inodes_sb() end result
was, and decided to clean up the estimation of dirty pages in order to
not end up with the function call argument from hell.

Now, it's obviously totally possible that I screwed things up entirely
in the process, but as mentioned elsewhere, I do feel that actually
seeing the merge conflicts really does help me get a feel for what I'm
merging, and what the points of conflict are.

And yes, maybe it's just me showing my insecurities again. I have
various mental hangups, and liking to feel like I know roughly what is
going on is one of them. Doing the merges and looking at the code that
clashes makes me feel like I have some kind of awareness of how things
are interacting in the development process.

                   Linus
