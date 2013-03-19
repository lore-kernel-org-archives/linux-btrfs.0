Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:56901 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3CST00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 15:26:26 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Chris Mason <clmason@fusionio.com>
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel\@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
References: <orhak8fm0u.fsf@livre.home>
	<20130318225245.25964.22219@localhost.localdomain>
	<orzjy0dkz9.fsf@livre.home>
	<20130319120940.29898.80124@localhost.localdomain>
Date: Tue, 19 Mar 2013 16:26:03 -0300
In-Reply-To: <20130319120940.29898.80124@localhost.localdomain> (Chris Mason's
	message of "Tue, 19 Mar 2013 08:09:40 -0400")
Message-ID: <ora9pzdwdw.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 19, 2013, Chris Mason <clmason@fusionio.com> wrote:

> My guess is the truncate is creating a orphan item

Would it, even though the truncate is used to grow rather than to shrink
the file?

> that is being processed inside the snapshot.

This doesn't explain why the master database occasionally gets similarly
corrupted, does it?

> Is it possible to create a smaller leveldb unit test that we might use
> to exercise all of this?

I suppose we can even do away with leveldb altogether, using only a
PosixMmapFile object, as created by PosixEnv::NewWritableFile (all of
this is defined in leveldb's util/env_posix.cc), to exercise the
creation and growth of multiple files, one at a time, taking btrfs
snapshots at random in between the writes.  This ought to suffice.

One thing I'm yet to check is whether ceph uses the sync leveldb
WriteOption, to determine whether or not to call the file object's Sync
member function in the test; this would bring fdatasync and msync calls
into the picture, that would otherwise be left entirely out of the test.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
