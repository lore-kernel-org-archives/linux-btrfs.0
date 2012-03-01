From: cwillu <cwillu@cwillu.com>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Thu, 1 Mar 2012 05:54:40 -0600
Message-ID: <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: asj <anand.jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330484376-16178-2-git-send-email-anand.jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

There's a few things that bother me about this, not least of all the
assumptions it makes about cron,(notably the direct modification of
crontab files, which is considered to be an internal detail if I
understand correctly, and I'm fairly certain is broken as written),
and how it writes to its own config file.  Neither has any business in
btrfs-progs in my somewhat irrelevant opinion. :p

It also does not appear to handle mountpoints in its directory walk,
which will cause grief if snapshotting /

There doesn't appear to be any reason for the scratch file to exist at
all (one can build up the hash while reading the directories), and
keeping a scratch file in /etc/ is poor practice in the first place
(that's what /tmp and/or /var/run is for).  It's also a lot of io to
stat every file in the subvolume every time you make a snapshot, and
I'm not convinced that the walk is actually correctly implemented:
what stops an autosnap of / from including all of /proc and /sys in
the hash?

Perhaps all that is unnecessary:  rather than doing the walk, why not
make use of btrfs subvolume find-new (or rather, the syscalls it
uses)?

Prior to making a new snapshot, grab the (stored) transid of the
previous snapshot, and check if any files have been modified in the
source since that transid:  btrfs sub find "${source}"
"${previous_transid}".  If nothing is returned, then you don't have to
bother making the snapshot at all, otherwise after making the
snapshot, grab the transid via btrfs sub find "${new_snapshot}" -1,
and store it some place (even a dot file in the root of the snapshot
would work).

This avoids creating and immediately deleting a snapshot every time
nothing has changed, completely avoids the need to stat the entire
subvolume every time, and removes the dependency on the crypto libs.

There's a decent number of other gripes, more related to the actual
code than the design itself, which I'll leave to someone who spends
more time c than I do.  A bunch of them are moot in the face the above
anyway.

-- Carey
