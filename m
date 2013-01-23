Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31404 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AWGTv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 01:19:51 -0500
Date: Wed, 23 Jan 2013 14:16:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 -rc4
Message-ID: <20130123061635.GD17162@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20130104125059.GE20089@twin.jikos.cz>
 <20130122142615.GD28263@twin.jikos.cz>
 <20130122143902.GD22634@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130122143902.GD22634@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 09:39:02AM -0500, Chris Mason wrote:
> On Tue, Jan 22, 2013 at 07:26:15AM -0700, David Sterba wrote:
> > On Fri, Jan 04, 2013 at 01:50:59PM +0100, David Sterba wrote:
> > > I've noticed a few csum mismatch messages, and a few failed xfstests:
> > 
> > They're still there, we're on rc4, so I started looking for potential
> > patches to revert, but tonight the test reproduced csums with these
> > patches removed:
> 
> I'm able to trigger crc errors with just 50 parallel fsx O_DIRECT procs
> hammering in parallel.  Trying to nail down the test case a little
> better.

After this patch(Btrfs: put csums on the right ordered extent),
I'm unable to get crc errors by running this script.

thanks,
liubo

> 
> #!/bin/bash
> 
> num=$1
> 
> if [ "x$num" == "x" ]; then
>     num=50
> fi
> 
> echo "using $num procs"
> 
> for x in `seq 1 $num` ; do
>     echo -n "$x "
>     fsx -q xxxf$x -Z -R -W -r 4096 -w 4096 &
> done
> echo "waiting"
> wait
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
