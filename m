Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51311 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3AVOjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 09:39:05 -0500
Date: Tue, 22 Jan 2013 09:39:02 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 -rc4
Message-ID: <20130122143902.GD22634@shiny>
References: <20130104125059.GE20089@twin.jikos.cz>
 <20130122142615.GD28263@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130122142615.GD28263@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 07:26:15AM -0700, David Sterba wrote:
> On Fri, Jan 04, 2013 at 01:50:59PM +0100, David Sterba wrote:
> > I've noticed a few csum mismatch messages, and a few failed xfstests:
> 
> They're still there, we're on rc4, so I started looking for potential
> patches to revert, but tonight the test reproduced csums with these
> patches removed:

I'm able to trigger crc errors with just 50 parallel fsx O_DIRECT procs
hammering in parallel.  Trying to nail down the test case a little
better.

#!/bin/bash

num=$1

if [ "x$num" == "x" ]; then
    num=50
fi

echo "using $num procs"

for x in `seq 1 $num` ; do
    echo -n "$x "
    fsx -q xxxf$x -Z -R -W -r 4096 -w 4096 &
done
echo "waiting"
wait
