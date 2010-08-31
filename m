From: Simon Kirby <sim@hostway.ca>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 23:38:41 -0700
Message-ID: <20100831063841.GF29552@hostway.ca>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com> <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com> <4C7BF087.6060400@noir.com> <AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com> <4C7C370E.1080901@noir.com> <AANLkTimNOqfQHwPmJk4mQUsFOwORHtZvyZ_8QZ5om=wT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "K. Richard Pixley" <rich@noir.com>, linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimNOqfQHwPmJk4mQUsFOwORHtZvyZ_8QZ5om=wT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 31, 2010 at 07:07:29AM +0200, Fred van Zwieten wrote:

> Hmmm, maybe, but rsync would take a lot of time to find the changes.
> the actual blocks of a snap _are_ the changes, that's why SnapMirror
> is very efficient. And, I don't see how rsync will retain the snap's
> between both sites. It would be great if a tool like rsync could have
> access to the changed blocks in a snap. Don't know if btrfs exposes
> these somehow.

rsync doesn't have the hinting required to do this efficiently.  It has
to scan the whole thing every time it is run, and isn't anything like a
continuous replication in this respect.  Also, We've had problems in the
past with very large file systems causing rsync to run out of memory,
because it builds a file list in memory.  This lead us to build a "cpbk"
tool that basically did the same thing without file listsm, which turned
out to be a piece of crap, so some other guy kindly rewrote it, but he
unfortunately missed the original point entirely and rewrote it using
file lists.  Sigh.

Anyway, there _is_ this interface:

	btrfs subvolume find-new <path> <last_gen>
		List the recently modified files in a filesystem.

Eg:

	btrfs sub find-new /mnt 0

This should print all files on the file system, and the last transaction
ID marker.  This can be used to call the interface again, which lists
only new changed things since that ID.

So, it might be pretty easy to glue these tools together, for now, until
something does this automatically and/or in some more efficient or
low-level way.

Simon-
