Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:56640 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3CDAym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 19:54:42 -0500
From: Alexandre Oliva <oliva@gnu.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: collapse concurrent forced allocations
References: <orvc9lqsgt.fsf@livre.home> <orobfdqhbu.fsf@livre.home>
	<20130222155403.GC2062@localhost.localdomain>
	<orvc9jp0zu.fsf@livre.home>
Date: Sun, 03 Mar 2013 21:54:05 -0300
In-Reply-To: <orvc9jp0zu.fsf@livre.home> (Alexandre Oliva's message of "Sat,
	23 Feb 2013 11:18:29 -0300")
Message-ID: <orr4jwnfwy.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 23, 2013, Alexandre Oliva <oliva@gnu.org> wrote:

> On Feb 22, 2013, Josef Bacik <jbacik@fusionio.com> wrote:
>> So I understand what you are getting at, but I think you are doing it wrong.  If
>> we're calling with CHUNK_ALLOC_FORCE, but somebody has already started to
>> allocate with CHUNK_ALLOC_NO_FORCE, we'll reset the space_info->force_alloc to
>> our original caller's CHUNK_ALLOC_FORCE.

> But that's ok, do_chunk_alloc will set space_info->force_alloc to
> CHUNK_ALLOC_NO_FORCE at the end, when it succeeds allocating, and then
> anyone else waiting on the mutex to try to allocate will load the
> NO_FORCE from space_info.

>> So we only really care about making sure a chunk is actually
>> allocated, instead of doing this flag shuffling we should just do

>> if (space_info->chunk_alloc) { spin_unlock(&space_info->lock);
>> wait_event(!space_info->chunk_alloc); return 0;

I looked a bit further into it.  I think I this would work if we had a
wait_queue for space_info->chunk_alloc.  We don't, so the mutex
interface is probably the best we can do.

OTOH, I found out we seem to get into an allocate spree when a large
file is being quickly created, such as when creating a ceph journal or
making a copy of a multi-GB file.  I suppose btrfs is just trying to
allocate contiguous space for the file, but unfortunately there doesn't
seem to be a fallback for allocation failure: as soon as data allocation
fails and space_info is set as full, the large write fails and the
filesystem becomes full, without even trying to use non-contiguous
storage.  Isn't that a bug?


I've also been trying to track down why, on a single-data filesystem,
(compressed?) data reads that fail because of bad blocks also spike the
CPU load and lock the file that failed to map in and the entire
filesystem, so that the only way to recover is to force a reboot.
Does this sound familiar to anyone?

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
