From: Pavel Machek <pavel@suse.cz>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Mon, 26 Jan 2009 17:27:11 +0100
Message-ID: <20090126162711.GA2083@elf.ucw.cz>
References: <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090121040042.GI10158@disturbed>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 2009-01-21 15:00:42, Dave Chinner wrote:
> On Tue, Jan 20, 2009 at 11:20:19PM +0100, Pavel Machek wrote:
> > On Tue 2009-01-20 08:28:29, Christoph Hellwig wrote:
> > > On Tue, Jan 20, 2009 at 11:59:44PM +1100, Dave Chinner wrote:
> > > > > So far the responses from xfs folks have been disappointing, if you are
> > > > > interested in bugreports i can send you some.
> > > > 
> > > > Sure I am.  It would be good if you could start testing XFS along
> > > > with all the other filesystems and report anything you find.
> > > 
> > > I think that was the issue with the debug builds.  If you do this
> > > testing always do it without CONFIG_XFS_DEBUG set as with that option
> > > we intentionally panic on detected disk corruptions.
> > 
> > Uhuh, *_DEBUG options are not supposed to make kernel less
> > stable/robust. Should that crashing functionality be guarded with
> > command line option or something? ext2 has errors=panic mount
> > option...
> 
> No, it's a debugging option that is described as:
> 
> 	"Say N unless you are an XFS developer, or you play one on TV."
> 
> Seriously, if you aren't trying to develop XFS stuff then *don't turn it
> on*.

What about this, then?
									Pavel

---
Warn in documentation that XFS_DEBUG panics machines.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 3f53dd1..55c98eb 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -76,4 +76,7 @@ config XFS_DEBUG
 	  Note that the resulting code will be HUGE and SLOW, and probably
 	  not useful unless you are debugging a particular problem.
 
+	  Turning this option on will result in kernel panicking any time
+	  it detects on-disk corruption.
+
 	  Say N unless you are an XFS developer, or you play one on TV.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
