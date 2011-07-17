From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: Broken btrfs?
Date: Sun, 17 Jul 2011 14:01:08 +0000 (UTC)
Message-ID: <loom.20110717T160020-81@post.gmane.org>
References: <20110716214404.50480@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schubert <jan.schubert <at> gmx.li> writes:
> Please find some data and log below. Is there any chance to fix this?

After playing around (incl. deleting the log) I get the strong feeling
it has something todo with compression=lzo. Dunno why it started suddenly
but I disabled compression and did reinstall everything which helped a lot.
I still have some broken configuration and other (non reinstalable) files
which causes crashing the box when I try to access them. I detect them
manually, is there any way to do this automagically?

Of course I'm still interessted in knowing the initial reason for this and
how to prevent this in the future...

Thx,
Jan



