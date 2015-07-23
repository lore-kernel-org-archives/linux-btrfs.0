Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbbGWL4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 07:56:08 -0400
Date: Thu, 23 Jul 2015 13:55:59 +0200
From: David Sterba <dsterba@suse.com>
To: Marc MERLIN <marc@merlins.org>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: Btrfs progs release 4.1.1
Message-ID: <20150723115558.GQ6306@suse.cz>
Reply-To: dsterba@suse.com
References: <20150706212156.GY17274@merlins.org>
 <20150710134348.GB15535@suse.cz>
 <20150712010229.GA5284@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150712010229.GA5284@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 11, 2015 at 06:02:29PM -0700, Marc MERLIN wrote:
> Are you interested in crash reports for fsck?
> 
> If so, see my recent message:
> 
> On Mon, Jul 06, 2015 at 02:21:56PM -0700, Marc MERLIN wrote:
> > 
> > myth:~# btrfs check --repair /dev/mapper/crypt_sdd1 
> > enabling repair mode
> > Checking filesystem on /dev/mapper/crypt_sdd1
> > UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> > checking extents
> > cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.

The bugon was added by Josef in commit 650e656a8b9c1fbe4e to
(https://git.kernel.org/kdave/btrfs-progs/c/650e656a8b9c1fbe4ec)

but I don't thing that your filesystem is affected by the described bug,
rather that it tripped over some other inconsistency in backrefs.

> > I can mount with -o ro without it crashing, but if I drop ro, it then
> > tries to do something and crashes, and unfortunately the error doesn't
> > make it to syslog
> > 
> > Screenshot: http://marc.merlins.org/tmp/btrfs_crash.jpg

So it's 32bit system, 3.19.8, crashing during snapshot deletion and
backref walking. EIP is in do_walk_down+0x142. I've tried to match it to
the sources on a local 32bit build, but it does not point to the
expected crash site:

(gdb) l *(do_walk_down+0x142)
0x1cdc2 is in do_walk_down (fs/btrfs/extent-tree.c:7875).
7870
7871                            wc->stage = UPDATE_BACKREF;
7872                            wc->shared_level = level - 1;
7873                    }
7874            } else {
7875                    if (level == 1 &&
7876                        (wc->flags[0] & BTRFS_BLOCK_FLAG_FULL_BACKREF))
7877                            goto skip;
7878            }
7879

There are other places where it could hit a bug-on. It would need more
debugging to find out what's happening.
