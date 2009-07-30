From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 11:05:15 -0700
Message-ID: <20090730180515.GB7541@mail.oracle.com>
References: <8763dcvagk.fsf@master.homenet>
 <20090729130106.GF13940@think>
 <4A705959.7010303@draigBrady.com>
 <20090729161014.GJ13940@think>
 <4A70918D.6020003@draigBrady.com>
 <20090730005702.GA32157@mail.oracle.com>
 <87fxcevcuy.fsf@meyering.net>
 <87ocr2frmx.fsf@basil.nowhere.org>
 <87iqhatqzz.fsf@meyering.net>
 <20090730105416.GB4534@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Meyering <jim@meyering.net>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090730105416.GB4534@basil.fritz.box>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2009 at 12:54:16PM +0200, Andi Kleen wrote:
> > With classic cp, if I copy a 1GB non-sparse file and there's less
> > space than that available, cp fails with ENOSPC.
> > With this new feature, it succeeds even if there are
> > just a few blocks available.
> > 
> > Also, consider (buggy!) code that then depends on being able to modify
> > that file in-place, and that "knows" it doesn't need to check for ENOSPC.
> > Sure, they should always check for write failure, but still.  It is
> > a change.
> 
> Fair point, although I suspect there are cases where ENOSPC
> on non extending write can already happen on specific file systems. e.g. on 
> btrfs it might happen when the tree gets rebalanced? Or perhaps on nilfs2
> when the garbage collector doesn't run in time. Wouldn't surprise 
> me if there weren't more cases already.

	In some sense, using btrfs, nilfs2i, ocfs2 with refcount trees
enabled, or any other CoW-ish filesystem is a tacit approval of the
delayed ENOSPC.  The same can be said of "thin provisioning" LUNs.
However, the other concerns are still valid.  A user invoking vanilla
cp(1) expects two independent storage regions for the data.
	(Oh, and what about future support of de-duping in filesystems?
:-)

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
