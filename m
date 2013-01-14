Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51768 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab3ANP5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 10:57:21 -0500
Date: Mon, 14 Jan 2013 10:57:18 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
Message-ID: <20130114155718.GC1387@shiny>
References: <50F3E77B.2030901@gmail.com>
 <20130114145904.GA1387@shiny>
 <50F422BC.4000901@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
In-Reply-To: <50F422BC.4000901@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Jan 14, 2013 at 08:22:36AM -0700, Tomasz Kusmierz wrote:
> On 14/01/13 14:59, Chris Mason wrote:
> > On Mon, Jan 14, 2013 at 04:09:47AM -0700, Tomasz Kusmierz wrote:
> >> Hi,
> >>
> >> Since I had some free time over Christmas, I decided to conduct few
> >> tests over btrFS to se how it will cope with "real life storage" for
> >> normal "gray users" and I've found that filesystem will always mess up
> >> your files that are larger than 10GB.
> > Hi Tom,
> >
> > I'd like to nail down the test case a little better.
> >
> > 1) Create on one drive, fill with data
> > 2) Add a second drive, convert to raid1
> > 3) find corruptions?
> >
> > What happens if you start with two drives in raid1?  In other words, I'm
> > trying to see if this is a problem with the conversion code.
> >
> > -chris
> Ok, my description might be a bit enigmatic so to cut long story short 
> tests are:
> 1) create a single drive default btrfs volume on single partition -> 
> fill with test data -> scrub -> admire errors.
> 2) create a raid1 (-d raid1 -m raid1) volume with two partitions on 
> separate disk, each same size etc. -> fill with test data -> scrub -> 
> admire errors.
> 3) create a raid10 (-d raid10 -m raid1) volume with four partitions on 
> separate disk, each same size etc. -> fill with test data -> scrub -> 
> admire errors.
> 
> all disks are same age + size + model ... two different batches to avoid 
> same time failure.

Ok, so we have two possible causes.  #1 btrfs is writing garbage to your
disks.  #2 something in your kernel is corrupting your data.

Since you're able to see this 100% of the time, lets assume that if #2
were true, we'd be able to trigger it on other filesystems.

So, I've attached an old friend, stress.sh.  Use it like this:

stress.sh -n 5 -c <your source directory> -s <your btrfs mount point>

It will run in a loop with 5 parallel processes and make 5 copies of
your data set into the destination.  It will run forever until there are
errors.  You can use a higher process count (-n) to force more
concurrency and use more ram.  It may help to pin down all but 2 or 3 GB
of your memory.

What I'd like you to do is find a data set and command line that make
the script find errors on btrfs.  Then, try the same thing on xfs or
ext4 and let it run at least twice as long.  Then report back ;)

-chris


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="stress.sh"

#!/bin/bash -
# -*- Shell-script -*-
#
# Copyright (C) 1999 Bibliotech Ltd., 631-633 Fulham Rd., London SW6 5UQ.
#
# $Id: stress.sh,v 1.2 1999/02/10 10:58:04 rich Exp $
#
# Change log:
#
# $Log: stress.sh,v $
# Revision 1.2  1999/02/10 10:58:04  rich
# Use cp instead of tar to copy.
#
# Revision 1.1  1999/02/09 15:13:38  rich
# Added first version of stress test program.
#

# Stress-test a file system by doing multiple
# parallel disk operations. This does everything
# in MOUNTPOINT/stress.

nconcurrent=50
content=/usr/doc
stagger=yes

while getopts "c:n:s" c; do
    case $c in
    c)
	content=$OPTARG
	;;
    n)
	nconcurrent=$OPTARG
	;;
    s)
	stagger=no
	;;
    *)
	echo 'Usage: stress.sh [-options] MOUNTPOINT'
	echo 'Options: -c Content directory'
	echo '         -n Number of concurrent accesses (default: 4)'
	echo '         -s Avoid staggerring start times'
	exit 1
	;;
    esac
done

shift $(($OPTIND-1))
if [ $# -ne 1 ]; then
    echo 'For usage: stress.sh -?'
    exit 1
fi

mountpoint=$1

echo 'Number of concurrent processes:' $nconcurrent
echo 'Content directory:' $content '(size:' `du -s $content | awk '{print $1}'` 'KB)'

# Check the mount point is really a mount point.

#if [ `df | awk '{print $6}' | grep ^$mountpoint\$ | wc -l` -lt 1 ]; then
#    echo $mountpoint: This doesn\'t seem to be a mountpoint. Try not
#    echo to use a trailing / character.
#    exit 1
#fi

# Create the directory, if it doesn't exist.

if [ ! -d $mountpoint/stress ]; then
    rm -rf $mountpoint/stress
    if ! mkdir $mountpoint/stress; then
	echo Problem creating $mountpoint/stress directory. Do you have sufficient
	echo access permissions\?
	exit 1
    fi
fi

echo Created $mountpoint/stress directory.

# Construct MD5 sums over the content directory.

echo -n "Computing MD5 sums over content directory: "
( cd $content && find . -type f -print0 | xargs -0 md5sum | sort -o $mountpoint/stress/content.sums )
echo done.

# Start the stressing processes.

echo -n "Starting stress test processes: "

pids=""

p=1
while [ $p -le $nconcurrent ]; do
    echo -n "$p "

    (

	# Wait for all processes to start up.
	if [ "$stagger" = "yes" ]; then
	    sleep $((10*$p))
	else
	    sleep 10
	fi

	while true; do

	    # Remove old directories.
	    echo -n "D$p "
	    rm -rf $mountpoint/stress/$p

	    # Copy content -> partition.
	    echo -n "W$p "
	    mkdir $mountpoint/stress/$p
	    base=`basename $content`

	    #( cd $content && tar cf - . ) | ( cd $mountpoint/stress/$p && tar xf - )
	    cp -dRx $content $mountpoint/stress/$p
	    #rsync -rlD $content $mountpoint/stress/$p

	    # Compare the content and the copy.
	    echo -n "R$p "
	    ( cd $mountpoint/stress/$p/$base && find . -type f -print0 | xargs -0 md5sum | sort -o /tmp/stress.$$.$p )
	    diff $mountpoint/stress/content.sums /tmp/stress.$$.$p
	    if [ $? != 0 ]; then
	        echo "file miscompares in $p"
		killall stress.sh
		exit 1
	    fi
	    rm -f /tmp/stress.$$.$p
	done
    ) &

    pids="$pids $!"

    p=$(($p+1))
done

echo
echo "Process IDs: $pids"
echo "Press ^C to kill all processes"

trap "kill $pids" SIGINT

wait

kill $pids

--Nq2Wo0NMKNjxTN9z--
