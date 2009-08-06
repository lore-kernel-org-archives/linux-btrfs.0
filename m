From: David Woodhouse <dwmw2@infradead.org>
Subject: RAID[56] status
Date: Thu, 06 Aug 2009 11:17:13 +0100
Message-ID: <1249553833.568.23.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we've abandoned the idea of putting the number of redundant blocks
into the top bits of the type bitmask (and I hope we have), then we're
fairly much there. Current code is at:

   git://, http://git.infradead.org/users/dwmw2/btrfs-raid56.git
   git://, http://git.infradead.org/users/dwmw2/btrfs-progs-raid56.git=20

We have recovery working, as well as both full-stripe writes and a
temporary hack to allow smaller writes to work (with the 'write hole'
problem, of course). The main thing we need to do is ensure that we
_always_ do full-stripe writes, and then we can ditch the partial write
support.

I want to do a few other things, but AFAICT none of that needs to delay
the merge:

  - Better rebuild support -- if we lose a disk and add a replacement,
    we want to recreate only the contents of that disk, rather than
    allocating a new chunk elsewhere and then rewriting _everything_.
=20
  - Support for more than 2 redundant blocks per stripe (RAID[789] or
    RAID6[=C2=B3=E2=81=B4=E2=81=B5] or whatever we'll call it).

  - RAID[56789]0 support.

  - Clean up the discard support to do the right thing.

--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
