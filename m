Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:55136 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3CRVPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 17:15:10 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
Subject: corruption of active mmapped files in btrfs snapshots
Date: Mon, 18 Mar 2013 18:14:41 -0300
Message-ID: <orhak8fm0u.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For quite a while, I've experienced oddities with snapshotted Firefox
_CACHE_00?_ files, whose checksums (and contents) would change after the
btrfs snapshot was taken, and would even change depending on how the
file was brought to memory (e.g., rsyncing it to backup storage vs
checking its md5sum before or after the rsync).  This only affected
these cache files, so I didn't give it too much attention.

A similar problem seems to affect the leveldb databases maintained by
ceph within the periodic snapshots it takes of its object storage
volumes.  I'm told others using ceph on filesystems other than btrfs are
not observing this problem, which makes me thing it's not memory
corruption within ceph itself.  I've looked into this for a bit, and I'm
now inclined to believe it has to do with some bad interaction of mmap
and snapshots; I'm not sure the fact that the filesystem has compression
enabled has any effect, but that's certainly a possibility.

leveldb does not modify file contents once they're initialized, it only
appends to files, ftruncate()ing them to about a MB early on, mmap()ping
that in and memcpy()ing blocks of various sizes to the end of the output
buffer, occasionally msync()ing the maps, or running fdatasync if it
didn't msync a map before munmap()ping it.  If it runs out of space in a
map, it munmap()s the previously mapped range, truncates the file to a
larger size, then maps in the new tail of the file, starting at the page
it should append to next.

What I'm observing is that some btrfs snapshots taken by ceph osds,
containing the leveldb database, are corrupted, causing crashes during
the use of the database.

I've scripted regular checks of osd snapshots, saving the
last-known-good database along with the first one that displays the
corruption.  Studying about two dozen failures over the weekend, that
took place on all of 13 btrfs-based osds on 3 servers running btrfs as
in 3.8.3(-gnu), I noticed that all of the corrupted databases had a
similar pattern: a stream of NULs of varying sizes at the end of a page,
starting at a block boundary (leveldb doesn't do page-sized blocking, so
blocks can start anywhere in a page), and ending close to the beginning
of the next page, although not exactly at the page boundary; 20 bytes
past the page boundary seemed to be the most common size, but the
occasional presence of NULs in the database contents makes it harder to
tell for sure.

The stream of NULs ended in the middle of a database block (meaning it
was not the beginning of a subsequent database block written later; the
beginning of the database block was partially replaced with NULs).
Furthermore, the checksum fails to match on this one partially-NULed
block.  Since the checksum is computed just before the block and the
checksum trailer are memcpy()ed to the mmap()ed area, it is a certainty
that the block was copied entirely to the right place at some point, and
if part of it became zeros, it's either because the modification was
partially lost, or because the mmapped buffer was partially overwritten.
The fact that all instances of corruption I looked at were correct right
to the end of one block boundary, and then all zeros instead of the
beginning of the subsequent block to the end of that page, makes a
failure to write that modified page seem more likely in my mind (more so
given the Firefox _CACHE_ file oddities in snapshots); intense memory
pressure at the time of the corruption also seems to favor this
possibility.

Now, it could be that btrfs requires those who modify SHARED mmap()ed
files so as to make sure that data makes it to a subsequent snapshot,
along the lines of msync MS_ASYNC, and leveldb does not take this sort
of precaution.  However, I noticed that the unexpected stream of zeros
after a prior block and before the rest of the subsequent block
*remains* in subsequent snapshots, which to me indicates the page update
is effectively lost.  This explains why even the running osd, that
operates on the “current” subvolumes from which snapshots for recovery
are taken, occasionally crashes because of database corruption, and will
later fail to restart from an earlier snapshot due to that same
corruption.


Does this problem sound familiar to anyone else?

Should mmaped-file writers in general do more than umount or msync to
ensure changes make it to subsequent snapshots that are supposed to be
consistent?

Any tips on where to start looking so as to fix the problem, or even to
confirm that the problem is indeed in btrfs?


TIA,

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
