From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Memory leak?
Date: Sun, 3 Jul 2011 20:09:13 +0100
Message-ID: <20110703190913.GA4474@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

I've got a server using brtfs to implement a backup system.
Basically, every night, for a few machines, I rsync (and other
methods) their file systems into one btrfs subvolume each and
then snapshot it.

On that server, the btrfs fs is on 3 3TB drives, mounted with
compress-force. Every week, I rsync the most recent snapshot of
a selection of subvolumes onto an encrypted (LUKS) external hard
drive (3TB as well).

Now, on a few occasions (actually, most of the time), when I
rsynced the data (about 2.5TB) onto the external drive, the
system would crash after some time with "Out of memory and no
killable process". Basically, something in kernel was allocating
the whole memory, then oom mass killed everybody and crash.

That was with ubuntu 2.6.38. I had then moved to debian and
2.6.39 and thought the problem was fixed, but it just happened
again with 3.0.0rc5 while rsyncing onto an initially empty btrfs
fs.

I'm going to resume the rsync again, and it's likely to happen
again. Is there anything simple (as I've got very little time to
look into that) I could do to help debug the issue (I'm not 100%
sure it's btrfs fault but that's the most likely culprit).

For a start, I'll switch the console to serial, and watch
/proc/vmstat. Anything else I could do?

Note that that server has never crashed when doing a lot of IO
at the same time in a lot of subvolumes with remote hosts. It's
only when copying data to that external drive on LUKS that it
seems to crash.

Cheers,
Stephane
