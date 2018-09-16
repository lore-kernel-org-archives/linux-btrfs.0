Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from campbell-lange.net ([178.79.140.51]:44916 "EHLO
        campbell-lange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeIPX1K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 19:27:10 -0400
Date: Sun, 16 Sep 2018 19:03:25 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Move data and mount point to subvolume
Message-ID: <20180916180325.c6jkusse76gsuf52@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
 <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/09/18, Hans van Kranenburg (hans.van.kranenburg@mendix.com) wrote:
> On 09/16/2018 02:37 PM, Hans van Kranenburg wrote:
> > On 09/16/2018 01:14 PM, Rory Campbell-Lange wrote:
...
> >> We have /bkp with /bkp/backup in it. We would like to mount /bkp/backup
> >> at /bkp instead. Note that /bkp/backup has a lot of hardlinked files.
...
> So, what you can do is (similar to what I earlier typed):
> 
> * You now have subvol 5 (at /bkp)
> * btrfs sub snap /bkp /bkp/backup-subvol
> * Now you have a new subvol (256 or higher number) which already
> contains everything
> * Then inside /bkp/backup-subvol you will again see
> /bkp/backup-subvol/backup (since you snapshotted the toplevel which also
> contains it)
> * Now mv /bkp/backup/backup-subvol/* /bkp/backup-subvol (so the mv
> operations stays within the same subvolume)
> * Then remove everything outside /bkp/backup-subvol and mv
> /bkp/backup-subvol /bkp/backup, and then voila... you can now use
> subvol=/backup to mount it.

Thanks for the advice, Hans. Your suggestion makes complete sense.

So I did this:

    btrfs subvol snapshot /bkp /bkp/backup-subvol

strangely while /bkp/backup has lots of files in it,
/bkp/backup-subvol/backup has none.

# btrfs subvol list /bkp
ID 258 gen 313585 top level 5 path backup
ID 4782 gen 313590 top level 5 path backup-subvol

# btrfs fi du -s /bkp/backup-subvol/backup
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of '/bkp/backup-subvol/backup': Inappropriate
ioctl for device

Any ideas about what could be going on?

In the mean time I'm trying:

    btrfs subvol create /bkp/backup-subvol
    cp -prv --reflink=always /bkp/backup/* /bkp/backup-subvol/

One worry as I do this is that the Metadata seems to be building quickly
as I run this. At the start:

    # btrfs fi df /bkp
    Data, RAID1: total=2.52TiB, used=1.37TiB
    System, RAID1: total=32.00MiB, used=480.00KiB
    Metadata, RAID1: total=9.00GiB, used=4.80GiB <--- **
    GlobalReserve, single: total=512.00MiB, used=0.00B

15 minutes into the cp run:

    # btrfs fi df /bkp
    Data, RAID1: total=2.52TiB, used=1.37TiB
    System, RAID1: total=32.00MiB, used=480.00KiB
    Metadata, RAID1: total=9.00GiB, used=5.56GiB  <--- **
    GlobalReserve, single: total=512.00MiB, used=80.00KiB

Thanks very much for any further advice
Rory
