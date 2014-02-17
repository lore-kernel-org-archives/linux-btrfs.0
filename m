Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39755 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaBQFcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 00:32:36 -0500
Date: Sun, 16 Feb 2014 21:32:32 -0800
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>, Josef Bacik <jbacik@fb.com>
Message-ID: <20140217053232.GQ27097@merlins.org>
References: <1392558191-14475-1-git-send-email-fdmanana@gmail.com>
 <20140214015426.GH27097@merlins.org>
 <20140216142352.GN27097@merlins.org>
 <CAL3q7H5JY=1WdG0vtNqPcHmwvPXdgznOqU9J9M3ctKgzVZQqAA@mail.gmail.com>
 <20140216172315.GC2117@merlins.org>
 <CAL3q7H7uuaTjH7RWW-Q73E7zpc5=bpHP4nCrK3JkOsXaAj08Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7uuaTjH7RWW-Q73E7zpc5=bpHP4nCrK3JkOsXaAj08Jw@mail.gmail.com>
Subject: Re: How to recover from failing btrfs send | btrfs receive?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 16, 2014 at 09:08:57PM +0000, Filipe David Manana wrote:
> I'll see if I come up with other ways of getting into that issue.

If you're collecting them, I found another bug, although it might not
matter to most: if I put my laptop in S3 sleep during a send/receive, it
reliably breaks the copy (this is disk to disk, not disk to network).

Not a problem for a server, but on a laptop, if you happen to have a
background backup from disk1 to disk2 and you put the laptop to sleep,
it will break the backup in a way that's not recoverable and you need to
start back up from scratch.

btrfs send | btrfs receive gives:
Create a readonly snapshot of 'home' in './home_ro.20140216_21:03:53'
At subvol home_ro.20140216_21:03:53
At subvol home_ro.20140216_21:03:53

ERROR: crc32 mismatch in command.
Error line 137 with status 234

If that helps, I can reproduce at will.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
