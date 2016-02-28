Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44131 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbcB1DJd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 22:09:33 -0500
Date: Sat, 27 Feb 2016 19:09:30 -0800
From: Marc MERLIN <marc@merlins.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160228030930.GS19699@merlins.org>
References: <20160227023938.GB5286@merlins.org>
 <20160227024533.GB11954@localhost.localdomain>
 <20160227030304.GC5286@merlins.org>
 <56D229F8.5080002@oracle.com>
 <20160228005614.GP19699@merlins.org>
 <56D25104.9020107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D25104.9020107@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 09:44:36AM +0800, Anand Jain wrote:
> 
> Marc,
> 
> > Err, I'm very perplexed now. I already have a scan in my boot process
> > after device decrypts.
> > Somehow it saw one of my 2 devices, but not the other one?
> 
> If blkid shows both the devices and if you are running 'btrfs dev scan'
> during boot, then yes kernel should see both the devices.
 
Agreed. It has every single time except that one time.

> Just to be sure, Can you reconfirm if the below blkid output is taken
> at the time of the bootup where you are running btrfs dev scan in the
> script ?

It's taken after the problem was fixed with a 2nd btrfs scan. It's a
server doing a 3 day long copy. Can't reboot it right now :)

> If you have a choice pls add, 'btrfs fi show -d' as well for the outputs
> to be taken at the time of boot just before system's 'btrfs dev scan',

I'll do that next time, thanks.

> Pls do share your /etc/fstab output for /var/local/space (I guess
> you don't have -o degrade option) which is good for this debugging,
> which means mount fails if any one of the device is missing.

Nothing fancy:
LABEL=btrfs_space      /var/local/space btrfs   subvol=varlocalspace,defaults,compress=lzo,skip_balance,noatime,noexec 0 0

I'll do more debugging if it happens agian, but I'm pretty sure it was a
one time thing.
Next boot will tell :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
