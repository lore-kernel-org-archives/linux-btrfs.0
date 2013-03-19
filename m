Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:55874 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3CSFU1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 01:20:27 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel\@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
References: <orhak8fm0u.fsf@livre.home>
	<20130318225245.25964.22219@localhost.localdomain>
Date: Tue, 19 Mar 2013 02:20:10 -0300
In-Reply-To: <20130318225245.25964.22219@localhost.localdomain> (Chris Mason's
	message of "Mon, 18 Mar 2013 18:52:45 -0400")
Message-ID: <orzjy0dkz9.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 18, 2013, Chris Mason <chris.mason@fusionio.com> wrote:

> A few questions.  Does leveldb use O_DIRECT and mmap together?

No, it doesn't use O_DIRECT at all.  Its I/O interface is very
simplified: it just opens each new file (database chunks limited to 2MB)
with O_CREAT|O_RDWR|O_TRUNC, and then uses ftruncate, mmap, msync,
munmap and fdatasync.  It doesn't seem to modify data once it's written;
it only appends.  Reading data back from it uses a completely different
class interface, using separate descriptors and using pread only.

> (the source of a write being pages that are mmap'd from somewhere
> else)

AFAICT the source of the memcpy()s that append to the file are
malloc()ed memory.

> That's the most likely place for this kind of problem.  Also, you
> mention crc errors.  Are those reported by btrfs or are they application
> level crcs.

These are CRCs leveldb computes and writes out after each db block.  No
btrfs CRC errors are reported in this process.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
