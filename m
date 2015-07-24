Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46724 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbbGYBXc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 21:23:32 -0400
Date: Fri, 24 Jul 2015 09:24:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: Btrfs progs release 4.1.1
Message-ID: <20150724162446.GH30815@merlins.org>
References: <20150706212156.GY17274@merlins.org>
 <20150710134348.GB15535@suse.cz>
 <20150712010229.GA5284@merlins.org>
 <20150723115558.GQ6306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150723115558.GQ6306@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 01:55:59PM +0200, David Sterba wrote:
> On Sat, Jul 11, 2015 at 06:02:29PM -0700, Marc MERLIN wrote:
> > Are you interested in crash reports for fsck?
> > 
> > If so, see my recent message:
> > 
> > On Mon, Jul 06, 2015 at 02:21:56PM -0700, Marc MERLIN wrote:
> > > 
> > > myth:~# btrfs check --repair /dev/mapper/crypt_sdd1 
> > > enabling repair mode
> > > Checking filesystem on /dev/mapper/crypt_sdd1
> > > UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> > > checking extents
> > > cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
> 
> The bugon was added by Josef in commit 650e656a8b9c1fbe4e to
> (https://git.kernel.org/kdave/btrfs-progs/c/650e656a8b9c1fbe4ec)
> 
> but I don't thing that your filesystem is affected by the described bug,
> rather that it tripped over some other inconsistency in backrefs.
> 
> > > I can mount with -o ro without it crashing, but if I drop ro, it then
> > > tries to do something and crashes, and unfortunately the error doesn't
> > > make it to syslog
> > > 
> > > Screenshot: http://marc.merlins.org/tmp/btrfs_crash.jpg
> 
> So it's 32bit system, 3.19.8, crashing during snapshot deletion and
> backref walking. EIP is in do_walk_down+0x142. I've tried to match it to
> the sources on a local 32bit build, but it does not point to the
> expected crash site:

Thanks for looking.
Unfortunately it's a mythtv where if I put a 64bit kernel, other things
go wrong with the 32bit userland/64bit kernel split.
But I'll put a newer 64bit kernel on it to see what happens and report
back.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
