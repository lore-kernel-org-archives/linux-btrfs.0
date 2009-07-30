From: Andi Kleen <andi@firstfloor.org>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 12:54:16 +0200
Message-ID: <20090730105416.GB4534@basil.fritz.box>
References: <4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet> <20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com> <20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com> <20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net> <87ocr2frmx.fsf@basil.nowhere.org> <87iqhatqzz.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87iqhatqzz.fsf@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> With classic cp, if I copy a 1GB non-sparse file and there's less
> space than that available, cp fails with ENOSPC.
> With this new feature, it succeeds even if there are
> just a few blocks available.
> 
> Also, consider (buggy!) code that then depends on being able to modify
> that file in-place, and that "knows" it doesn't need to check for ENOSPC.
> Sure, they should always check for write failure, but still.  It is
> a change.

Fair point, although I suspect there are cases where ENOSPC
on non extending write can already happen on specific file systems. e.g. on 
btrfs it might happen when the tree gets rebalanced? Or perhaps on nilfs2
when the garbage collector doesn't run in time. Wouldn't surprise 
me if there weren't more cases already.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
