From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 11:06:22 -0500
Message-ID: <1299427596.15017.8.camel@ayu>
References: <il0a8d$4ev$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <il0a8d$4ev$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2011-03-06 at 10:46 -0500, Brian J. Murrell wrote:
> I have a backup volume on an ext4 filesystem that is using rsync and
> it's --link-dest option to create "hard-linked incremental" backups.  I
> am sure everyone here is familiar with the technique but in case anyone
> isn't basically it's effectively doing (each backup):

> So I replicated a few of the directories in my backup volume to a btrfs
> volume using snapshots for each backup to take advantage of CoW and with
> any luck, avoid entire file duplication where only some subset of the
> file has changed.
> 
> Overall, it seems that I saw success.  Most backups on btrfs were
> smaller than their source, and overall, for all of the backups
> replicated, the use was less.  There were some however that were
> significantly larger.  Here's the analysis:

> Taking the biggest anomaly, monthly.15, a du of just that directory on
> both the btrfs and ext4 filesystems shows results I would expect:
> 
> btrfs: 136,876,580 monthly.15
> ext4:  142,153,928 monthly.15
> 
> Yet the before and after "df" results show the btrfs usage higher than
> ext4.  Is there some "periodic" jump in "overhead" used by btrfs that
> would account for this mysterious increased usage in some of the copies?

There actually is such a periodic jump in overhead, caused by the way
which btrfs dynamically allocates space for metadata as needed by the
creation of new files, which it does whenever the free metadata space
ratio reaches a threshold (it's probably more complicated than that, but
close enough for now).

To see exactly what's going on, you should use the "btrfs filesystem df"
command to see how space is being allocated for data and metadata
separately:

ayu ~ # btrfs fi df /
Data: total=266.01GB, used=249.35GB
System, DUP: total=8.00MB, used=36.00KB
Metadata, DUP: total=3.62GB, used=1.93GB
ayu ~ # df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda4             402G  254G  145G  64% /

If you use the btrfs tool's df command to account for space in your
testing, you should get much more accurate results.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

