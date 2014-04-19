Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35473 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751550AbaDSCte convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 22:49:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Fixing a degraded RAID
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <87y4z2avvz.fsf@maru2.md5i.com>
Date: Fri, 18 Apr 2014 20:49:33 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <742B9F92-56D1-4B9E-AB69-ABB7B0C4A928@colorremedies.com>
References: <87y4z2avvz.fsf@maru2.md5i.com>
To: Michael Welsh Duggan <mwd@md5i.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 18, 2014, at 8:36 PM, Michael Welsh Duggan <mwd@md5i.com> wrote:

> I had a disk in my RAID0 die:
> 
>  root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi show 8c530f6f-7592-4d57-854d-1fae33ae7cb6
>  Label: none  uuid: 8c530f6f-7592-4d57-854d-1fae33ae7cb6
>          Total devices 3 FS bytes used 329.66GiB
>          devid    1 size 1.79TiB used 357.03GiB path /dev/sdd1
>          devid    3 size 931.51GiB used 178.00GiB path /dev/sdf
>          *** Some devices missing
> 
>  Btrfs v3.12-43-gc2081e2-dirty
> 
> So, I try to mount it with -o degraded.  That fails, implying that a
> degraded mount needs to be read-only.  So I successfully mount it read
> only.  Then I want to add a new disk to replace the missing one:
> 
>  root@maru2:~# /usr/local/src/btrfs-progs/btrfs dev add /dev/sdg /mnt/
>  ERROR: error adding the device '/dev/sdg' - Read-only file system
> 
> So I can't add a disk if it's mounted read-only, and can't mount it
> read-write?  What am I missing?  What's my way around this?

Not really because it's raid0. The minimum number of disks for a 3 disk raid0 is 3 disks. Upon losing one, the data portion of the file system is toast. I'm guessing it lets you mount it ro,degraded because the metadata and hence the file system itself, is raid1 (the default for raid0 data volumes).

The file system could determine what files aren't damaged, i.e they exist entirely on one of the remaining two drives, with no dependency on the dead one. But I don't think this code exists yet. You could possibly rsync the drive to another file system, and bad files damaged by the missing disk will be reported in dmesg while the good ones would still copy over. I haven't tried this.

Chris Murphy