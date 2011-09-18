From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix pages truncation in btrfs_ioctl_clone()
Date: Sun, 18 Sep 2011 11:31:49 -0400
Message-ID: <1316359797-sup-4549@shiny>
References: <4E731009.2030202@cn.fujitsu.com> <Pine.LNX.4.64.1109160934590.11043@cobra.newdream.net>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.1109160934590.11043@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Sage Weil's message of 2011-09-16 12:39:06 -0400:
> On Fri, 16 Sep 2011, Li Zefan wrote:
> > It's a bug in commit f81c9cdc567cd3160ff9e64868d9a1a7ee226480
> > (Btrfs: truncate pages from clone ioctl target range)
> > 
> > We should pass the dest range to the truncate function, but not the
> > src range.
> 
> Sigh... yes.
> 
> > Also move the function before locking extent state.
> 
> Hmm, any reason?  i_mutex protects us from a racing write(2), but what 
> about a racing mmap()?  e.g.
> 
> cloner: truncates dest pages
> writer: mmap -> page_mkwrite locks extent, creates new dirty page, unlocks
> cloner: locks extent, clones, unlocks extent

Thanks guys.  The locking order is page lock -> extent lock.  So if we
call truncate_inode_pages with the extent lock held, we're off into
ABBA.

If we want to avoid the mmap race, we'll have to look for the dirty
pages with the extent lock held, drop the lock and goto back to the
truncate_inode_pages call.

-chris
