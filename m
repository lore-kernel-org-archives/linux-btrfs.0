Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:42034 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3BWOSn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 09:18:43 -0500
From: Alexandre Oliva <oliva@gnu.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: collapse concurrent forced allocations
References: <orvc9lqsgt.fsf@livre.home> <orobfdqhbu.fsf@livre.home>
	<20130222155403.GC2062@localhost.localdomain>
Date: Sat, 23 Feb 2013 11:18:29 -0300
In-Reply-To: <20130222155403.GC2062@localhost.localdomain> (Josef Bacik's
	message of "Fri, 22 Feb 2013 10:54:03 -0500")
Message-ID: <orvc9jp0zu.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 22, 2013, Josef Bacik <jbacik@fusionio.com> wrote:

> So I understand what you are getting at, but I think you are doing it wrong.  If
> we're calling with CHUNK_ALLOC_FORCE, but somebody has already started to
> allocate with CHUNK_ALLOC_NO_FORCE, we'll reset the space_info->force_alloc to
> our original caller's CHUNK_ALLOC_FORCE.

But that's ok, do_chunk_alloc will set space_info->force_alloc to
CHUNK_ALLOC_NO_FORCE at the end, when it succeeds allocating, and then
anyone else waiting on the mutex to try to allocate will load the
NO_FORCE from space_info.

> So we only really care about making sure a chunk is actually
> allocated, instead of doing this flag shuffling we should just do

> if (space_info->chunk_alloc) {
> 	spin_unlock(&space_info->lock);
> 	wait_event(!space_info->chunk_alloc);
> 	return 0;
> }

Sorry, I don't follow.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
