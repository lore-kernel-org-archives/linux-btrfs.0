Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53612 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab3FSSCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 14:02:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8F4E37C0696
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 12:02:36 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130617185810.GA13370@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130617134955.GB15861@redhat.com>
 <20130617173942.15057.63201@localhost.localdomain>
 <20130617182005.GA9839@redhat.com>
 <20130617184227.15057.75499@localhost.localdomain>
 <20130617185810.GA13370@redhat.com>
Message-ID: <20130619180233.5430.5764@localhost.localdomain>
Subject: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Date: Wed, 19 Jun 2013 14:02:33 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Jones (2013-06-17 14:58:10)
> On Mon, Jun 17, 2013 at 02:42:27PM -0400, Chris Mason wrote:
>  > Quoting Dave Jones (2013-06-17 14:20:06)
>  > > On Mon, Jun 17, 2013 at 01:39:42PM -0400, Chris Mason wrote:
>  > >  > Quoting Dave Jones (2013-06-17 09:49:55)
>  > >  > > Hit this while running this script in a loop..
>  > >  > > https://github.com/kernelslacker/io-tests/blob/master/setup.sh
>  > >  > > [34385.251507] ------------[ cut here ]------------
>  > >  > > [34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
>  > >  > 
>  > >  > Thanks Dave, how long did you have to run the script to trigger it?
>  > >  > 
>  > >  > -chris
>  > > 
>  > > Judging by the timestamp, about 9 hours.  This is on a 3 disk (sata)
>  > > (oldish) quad opteron. Might repro faster on a more modern machine.
>  > 
>  > Exactly how did you run it?  I want to make sure I'm matching your
>  > config.
> 
> while [ 1 ];
> do
>   setup.sh
> done
> 
> You'll need to set DISK1 etc variables at the top of the script to point to
> at least 3 disks for it to scribble over.
> 
> you'll also need fsx and fsstress in /usr/local/bin.

I've tried with and without memory pressure, and let it run for about 30
hours.  So far, nothing here.  Have you seen this again?

-chris

