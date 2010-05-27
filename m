From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs updates
Date: Thu, 27 May 2010 10:18:04 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org>
References: <20100527151515.GA3835@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100527151515.GA3835@think>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 27 May 2010, Chris Mason wrote:
> 
>  fs/btrfs/extent-tree.c  | 2317 ++++++++++++++++++++++++++++--------------------
>  fs/btrfs/relocation.c   | 1991 +++++++++++++++++++++++++----------------
>  fs/btrfs/inode.c        | 1797 +++++++++++++++++++++++++++++--------
>  fs/btrfs/file.c         |  304 +++---
>  fs/btrfs/tree-log.c     |  241 +++-
> ...

What kind of bogus diffstat is this? 

Don't do that. I cannot compare your bogus diffstat with what I get, 
because it's just random noise. You've apparently sorted it by size of the 
damage, but the numbers are total crap too. That is _not_ the actual size 
of the changes at all.

I suspect you have some script that adds up all the patches, but that's 
wrong. If a subsequent patch changes the things that an earlier patch has 
done, then the numbers don't just add up.

And if the diffstat doesn't match what I get when I pull, then my reaction 
inevitably is "ok, that's not what they asked me to pull, so I'll just 
reject it out-of-hand". So don't play games with diffstats - that just 
means that things won't get pulled.

		Linus
