Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:32941 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbbGOIA7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 04:00:59 -0400
Date: Wed, 15 Jul 2015 10:00:57 +0200
From: Sander <sander@humilis.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150715080057.GA15200@panda>
Reply-To: sander@humilis.net
References: <11148188.L9vtSMaNHV@merkaba>
 <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org>
 <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150715031412.GZ5274@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN wrote (ao):
> On Wed, Jul 15, 2015 at 10:03:16AM +1000, Paul Harvey wrote:
> > The way it works in snazzer (and btrbk and I think also btrfs-sxbackup
> > as well), local snapshots continue to happen as normal (Eg. daily or
> > hourly) and so when your backup media or backup server is finally
> > available again, the size of each individual incremental is still the
> > same as usual, it just has to perform more of them.
>  
> Good point. My system is not as smart. Every night, it'll make a new
> backup and only send one incremental and hope it gets there. It doesn't
> make a bunch of incrementals and send multiple.
> 
> The other options do a better job here.

FWIW, I've written a bunch of scripts for making backups. The lot has
grown over the past years to what is is now. Not very pretty to see, but
reliable.

The subvolumes backupadmin home root rootvolume and var are snapshotted
every hour.

Each subvolume has their own entry in crontab for the actual backup.
For example rootvolume once a day, home and backupadmin every hour.

The scripts uses tar to make a full backup every first backup of a
subvolume that month, an incremental daily backup, and an incremental
hourly backup if applicable.

For a full backup the oldest available snapshot for that month is used,
regardless of when the backup is started. This way the backup of each
subvolume can be spread not to overload a system.

Backups are running in the idle queue to not hinder other processes, are
compressed with lbzip2 to utilize all cores, and are encrypted with gpg
for obvious reasons. In my tests lbzip2 gives the best size/speed ratio
compared to lzop, xz, bzip2, gzip, pxz and lz4(hc).

The script outputs what files and directories are in the backup to the
backupadmin subvolume. This data is compressed with lz4hc as lz4hc is
the fastest to decompress (useful to determine which archive contains
what you want restored).

Archives get transfered to a remote server by ftp, as ftp is the leanest
way of file transfer and supports resume. The initial connection is
encrypted to hide username/password, but as the archive is already
encrypted, the data channel is not. The ftp transfer is throttled to
only use part of the available bandwith.

A daily running script checks for archives which are not transfered yet
due to remote server not available or failed connection or the like, and
retransmits those archives.

Snapshots and archives are pruned based on disk usage (yet another
script).

Restore can be done by hand from snapshots (obviously), or by a script
from the locale archive if still available, or the remote archive.

The restore script can search a specific date-time range, and checks
both local and remote for the availability of an archive that contains
the wanted.

A bare metal restore can be done by fetching the archives from the
remote host and pipe them directly into gpg/tar. No need for additional
local storage and no delay. First the monthly full backup is restored,
then every daily incremental since, and then every hourly since the
youngest daily, if applicable. tar incremental restore is smart, and
removes the files and directories that were removed between backups.

	Sander
