Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36730 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXQVm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 12:21:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 659FB7C041C
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 10:21:42 -0600 (MDT)
Date: Mon, 24 Jun 2013 12:21:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miguel =?iso-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send/receive issues
Message-ID: <20130624162139.GI4288@localhost.localdomain>
References: <1372027293.1052.12.camel@miguel-MacBookPro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <1372027293.1052.12.camel@miguel-MacBookPro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 23, 2013 at 11:41:33PM +0100, Miguel Negrão wrote:
> Hi,
> 
> I want to do a backup of a btrfs subvolume from one disk to another
> disk, both with btrfs filesystems, using the btrfs  send receive
> functionality. I do 
> 
> cd /media/miguel/btrfs_backup/
> mkdir backups
> sudo btrfs send /mnt/@backup2 | sudo btrfs receive /media/miguel/btrfs_backup/backups/
> 
> and this works fine, the @backup2 subvolume is created
> at /media/miguel/btrfs_backup/backups/. Then I try to send a second
> snapshot taken after @backup2 :
> 
> sudo btrfs send -p /mnt/@backup2 /mnt/@backup3 | sudo btrfs receive /media/miguel/btrfs_backup/backups/
> 
> And I get:
> 
> At subvol /mnt/@backup3
> At snapshot @backup3
> ERROR: open backups/@backup2 failed. No such file or directory
> 
> But @backup2 is a subvolume in /media/miguel/btrfs_backup/backups/ 
> 
> I'm I doing something wrong ?
> 

I'm not sure, I just did it and it worked fine for me.  Could you file a
bugzilla at bugzilla.kernel.org and make sure the component is set to btrfs?
Also could you do the send to a file, and then receive from the file so we can
see if its send or receive that's giving you the error and put that in the
bugzilla?  Thanks,

Josef
