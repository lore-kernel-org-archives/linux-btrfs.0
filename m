Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:64542 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0LUVxg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Dec 2010 16:53:36 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG?] There is a possibility that 'i_ino' overflows
In-reply-to: <4D0EB953.2010106@jp.fujitsu.com>
References: <4D09D153.1060208@jp.fujitsu.com> <4D0EB953.2010106@jp.fujitsu.com>
Date: Tue, 21 Dec 2010 16:52:12 -0500
Message-Id: <1292968260-sup-343@think>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tsutomu Itoh's message of 2010-12-19 21:02:59 -0500:
> 
> (2010/12/16 17:44), Tsutomu Itoh wrote:
> > Hi,
> > 
> > In btrfs, inode number is increased each time a new file or directory
> > is made.
> > Therefore, if the making deletion of the file is repeated, value of
> > 'i_ino' increases rapidly.
> > 
> > For example, inode number changes as follows. 
> > 
> >   $ touch foo
> >   $ ls -i foo
> >   266 foo
> >   $ rm foo
> >   $ touch bar
> >   $ ls -i bar
> >   267 bar
> >   $
> > 
> > And then, length of 'i_ino' and 'objectid' is as follows on the x86
> > system. 
> > 
> >   unsigned long i_ino == 32bits
> >   u64 objectid        == 64bits
> > 
> > Therefore, in the operation to substitute 'objectid' to 'i_ino',
> > 'i_ino' overflows when 'objectid' 4294967296 is substituted to 'i_ino'. 
> > Then, the file with inode number 0 is made.
> 
> I think that it is better to recycle inode number that became unused. 
> And, at least, I think that it should make the filesystem not become an
> abnormal condition. 
> 
> This patch is a patch that makes an error when inode number is bigger
> than BTRFS_LAST_FREE_OBJECTID.

Thanks, I've folded this one in.  Long term the plan is to do something
similar to Josef's block group caching code but for inode numbers.
Basically we'll cache the free ones, but it'll be less complex than the
block group caching by far.

-chris
