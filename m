From: Sander <btrfs@humilis.net>
Subject: Re: ENOSPC on file deletion with 3.1.6
Date: Tue, 3 Jan 2012 15:06:43 +0100
Message-ID: <20120103140643.GA18405@attic.humilis.net>
References: <24549767.TiRljH7Edl@a4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arie Peterson <ariep@xs4all.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <24549767.TiRljH7Edl@a4>
List-ID: <linux-btrfs.vger.kernel.org>

Arie Peterson wrote (ao):
> After upgrading my kernel from 2.6.38 (which has worked fine for months) to 
> 3.1.6, I got ENOSPC on recompiling gcc (even though df says there is 16G free 
> of 50G; this is a raid1 setup, so in fact it's 8 of 25).
> 
> After this error, I tried to remove the compilation directory (with "rm -r"): 
> this also gives ENOSPC. I am trying to work around this by first truncating 
> files using "echo > $file", but this fails for some files, again with ENOSPC. 
> Also, removal of files is very slow even if it succeeds.
> 
> Moreover, any write operation on the file system now fails with ENOSPC.
> 
> Reverting to my old kernel does not help: it now shows the same problem.
> 
> Is this a known issue? Is there a way to make this file system unstuck? (I have 
> backups, but I'd like to preserve snapshot information if possible.) Should I 
> try upgrading to an even newer kernel?

Maybe your snapshots take up space. Can you show 'btrfs filesystem df /' ?

FWIW, I also had a disk full just a few days ago. Removed all snapshots
and some big files, but to no avail. Likely the background cleanup took
too much time. A reboot fixed this.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
