Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:42169 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbDLLMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Apr 2015 07:12:53 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: bo.li.liu@oracle.com
Subject: Re: du accuracy
Date: Sun, 12 Apr 2015 21:12:46 +1000
Cc: linux-btrfs@vger.kernel.org
References: <201504101125.58088.russell@coker.com.au> <20150410104015.GB10185@localhost.localdomain>
In-Reply-To: <20150410104015.GB10185@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201504122112.47205.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 10 Apr 2015, Liu Bo <bo.li.liu@oracle.com> wrote:
> > Above are some consecutive du runs.  Why does the space used go from 1.2G
> > to  1.1G before going up again?  The file was created by "cat /dev/sde >
> > 2gsd" so it definitely wasn't getting smaller.
> >
> > 
> >
> > What's going on here?
> 
> What's your mount options?  with autodefrag or compression?

Linux server 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt4-2 (2015-01-27) x86_64 
GNU/Linux

Above is the kernel I'm using, one of the recent ones from Debian/Jessie.

UUID=XXXX /big btrfs skip_balance,relatime,nosuid,nodev 0 0

Above is the /etc/fstab line.

/dev/sdb2 /big btrfs 
rw,seclabel,nosuid,nodev,relatime,space_cache,skip_balance 0 0

Above is the /proc/mounts line.  I'm not doing anything noteworthy here.  

# du -h tmp|tail -1 ; sleep 10 ; du -h tmp|tail -1 
1.6G    tmp
1.4G    tmp

I've just had something similar happen when rsyncing a directory full of files 
to the server and running du to check on the progress.  It's probably possible 
that a rename could happen at the wrong time to cause a file to be missed in 
the du count.  So this could be legit.  But the case described in my previous 
message concerned a single file that was being extended.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
