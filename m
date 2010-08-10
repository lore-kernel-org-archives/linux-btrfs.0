From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Recover Corruption - verify_parent_transid
Date: Tue, 10 Aug 2010 05:37:41 +0100
Message-ID: <1281415061.3192.23.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Not being one of the developers on this project, I cannot offer you a
solution to recovering data from this volume, and my guess is that a
ready solution is unlikely to be forthcoming simply because if this was
possible then btrfsck would include the code to recover the filesystem
already.

However, rather than simply observe that anything not backed up is
lost... I thought I would offer the solution of the 4th dimension....
The data is not "lost", but simply unavailable to you until the tools to
repair the filesystem have been developed further.  If I had something
critical which had become inaccessible, I might be tempted to put the
drive on a shelf for 6 months and see if btrfsck was able to repair
filesystems by then.  It may be that the on disk format is changed
before that happens, but I understand that this is now relatively
unlikely.

A. James Lewis


