Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55458 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaF0Atp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 20:49:45 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: cancel btrfs delete job
Date: Fri, 27 Jun 2014 10:49:40 +1000
Message-ID: <61052648.lopAtLMs1F@xev>
In-Reply-To: <pan$6d335$5c2b9a29$9bcb428d$7e0aa9cc@cox.net>
References: <1403783232.7657.25.camel@hsew-frn.HIPERSCAN> <pan$6d335$5c2b9a29$9bcb428d$7e0aa9cc@cox.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2453759.S1Xx5MHKpT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2453759.S1Xx5MHKpT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thu, 26 Jun 2014 13:25:09 Duncan wrote:
> properly.  And if you do automated snapshots, use a good thinning script 
> to thin them down so you're well under 500. (I've posted figures where 
> even starting with per-minute snapshots, thinning down to 10 minute, then 
> to half hour within the day, then to say 4/day after two days, 1/day 
> after a week, one a week after four weeks, one every 13 weeks aka 
> quarterly after say six months, and clearing them all and relying on off-
> machine backups after a year or 18 months, runs only 250-ish or so, under 
> 300.)

What scripts are people using for this?

I've attached the latest scripts I use for managing BTRFS, they assume that 
the filesystem is mounted on root.  They use /backup for snapshots of root and 
/backup-$DIR for snapshots of /$DIR.  I've also attached the scrub and 
rebalance script I use.

These aren't the greatest scripts, I'll probably write something better 
eventually if no-one else has done so.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

--nextPart2453759.S1Xx5MHKpT
Content-Disposition: attachment; filename="btrfs-make-snapshot"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="btrfs-make-snapshot"

#!/bin/bash
set -e

# usage:
# btrfs-make-snapshot [-d] minutes|days paths
# example:
# btrfs-make-snapshot minutes /home /mail

if [ "$1" == "-d" ]; then
  BTRFS="echo btrfs"
  shift
else
  BTRFS=/sbin/btrfs
fi

if [ "$1" == "minutes" ]; then
  DATE=$(date +%Y-%m-%d:%H:%M)
else
  DATE=$(date +%Y-%m-%d)
fi
shift


for n in $* ; do
  BASENAME=$(basename $n)
  if [ "$BASENAME" == "/" ]; then
    BACKUPDIR="/backup"
  else
    BACKUPDIR="/backup-$BASENAME"
  fi
  $BTRFS subvol snapshot -r $n $BACKUPDIR/$DATE
done

--nextPart2453759.S1Xx5MHKpT
Content-Disposition: attachment; filename="btrfs-remove-snapshots"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="btrfs-remove-snapshots"

#!/bin/bash
set -e

# usage:
# btrfs-remove-snapshots [-d] MINSNAPS DAYSNAPS paths
# example:
# btrfs-remove-snapshots 100 100 /home /mail

if [ "$1" == "-d" ]; then
  BTRFS="echo btrfs"
  shift
else
  BTRFS=/sbin/btrfs
fi

MINSNAPS=$1
shift
DAYSNAPS=$1
shift

for DIR in $* ; do
  BASENAME=$(basename $DIR)
  if [ "$BASENAME" == "/" ]; then
    BACKUPDIR="backup"
  else
    BACKUPDIR="backup-$BASENAME"
  fi

  for n in $(/sbin/btrfs subvol list /|grep \ ${BACKUPDIR}/.*:|head -n -$MINSNAPS|sed -e "s/^.* //"); do
    $BTRFS subvol delete /$n
  done
  for n in $(/sbin/btrfs subvol list /|grep \ ${BACKUPDIR}/|grep -v :|head -n -$DAYSNAPS|sed -e "s/^.* //"); do
    $BTRFS subvol delete /$n
  done
done

--nextPart2453759.S1Xx5MHKpT
Content-Disposition: attachment; filename="btrfs-scrub"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="btrfs-scrub"

#!/bin/bash
set -e

/sbin/btrfs scrub start -B /
/sbin/btrfs fi balance start -dusage=30 -musage=30 /

--nextPart2453759.S1Xx5MHKpT--

