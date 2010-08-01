From: David Brown <btrfs@davidb.org>
Subject: Re: Hardlinks-per-directory limit?
Date: Sun, 1 Aug 2010 10:43:23 -0700
Message-ID: <201008011043.23048.btrfs@davidb.org>
References: <7836277d97c74d44d8f2132e87db0b67.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7836277d97c74d44d8f2132e87db0b67.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 28 July 2010, Ken D'Ambrosio said:

> Hello, all.  I'm thinking of rolling out a BackupPC server, and --
> based on the strength of the recent Phoronix benchmarks
> (http://benchmarkreviews.com/index.php?option=com_content&task=view&id=11156&Itemid=23)
> -- had been strongly considering btrfs.  But I do seem to recall
> that there was some sort of hardlinks-per-directory limitation, and
> BackupPC *loves* hardlinks.  Would someone care to either remind me
> what the issue was, or reassure me that it's been rectified?

btrfs has a limit on the number of hardlinks that can exist in the
same directory.  I don't believe that BackupPC will create any more
hardlinks in a given directory than are already in the filesystem you
are backing up.  It uses hardlinks between directories for files that
haven't changed.

David
