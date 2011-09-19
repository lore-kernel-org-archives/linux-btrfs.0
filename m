From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] Btrfs: fix pages truncation in btrfs_ioctl_clone()
Date: Sun, 18 Sep 2011 22:40:42 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1109182237480.24861@cobra.newdream.net>
References: <4E731009.2030202@cn.fujitsu.com> <Pine.LNX.4.64.1109160934590.11043@cobra.newdream.net>
 <1316359797-sup-4549@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316359797-sup-4549@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 18 Sep 2011, Chris Mason wrote:
> Excerpts from Sage Weil's message of 2011-09-16 12:39:06 -0400:
> > On Fri, 16 Sep 2011, Li Zefan wrote:
> > > It's a bug in commit f81c9cdc567cd3160ff9e64868d9a1a7ee226480
> > > (Btrfs: truncate pages from clone ioctl target range)
> > > 
> > > We should pass the dest range to the truncate function, but not the
> > > src range.
> > 
> > Sigh... yes.
> > 
> > > Also move the function before locking extent state.
> > 
> > Hmm, any reason?  i_mutex protects us from a racing write(2), but what 
> > about a racing mmap()?  e.g.
> > 
> > cloner: truncates dest pages
> > writer: mmap -> page_mkwrite locks extent, creates new dirty page, unlocks
> > cloner: locks extent, clones, unlocks extent
> 
> Thanks guys.  The locking order is page lock -> extent lock.  So if we
> call truncate_inode_pages with the extent lock held, we're off into
> ABBA.

Oh right.  This patch makes sense now.
 
> If we want to avoid the mmap race, we'll have to look for the dirty
> pages with the extent lock held, drop the lock and goto back to the
> truncate_inode_pages call.

Yeah, given that (at Li points out) we're not locking dst extents at all, 
I don't think it's worth worrying about now.  Sorry for the noise!

sage

