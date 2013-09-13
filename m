Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3IMP4t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 11:56:49 -0400
Date: Fri, 13 Sep 2013 17:56:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
Message-ID: <20130913155646.GL6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-2-git-send-email-anand.jain@oracle.com>
 <20130912163629.GD6810@twin.jikos.cz>
 <5232EDA6.6060902@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5232EDA6.6060902@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 06:49:10PM +0800, Anand Jain wrote:
> >I wonder if we should keep --all-devices as a last resort fallback eg.
> 
>  Any idea whats the real use of --all-devices option anyway
>  I am unsure. Anyway will restore --all-devices so now.

That's when udev breaks or is not present on the system at all.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/11336

It's hard to know if there are users or not, from the thread above there
is at least one.

A good practice is to leave some deprecation period before removing a
functionality, so we should rather add a warning that the option is
about to be removed -- because udev is everywhere and computers don't
break, right?

> >I see this warning and there are no mounted filesystems listed in the
> >output:
> >
> >$ ./btrfs fi show
> >ERROR: scan kernel failed, -1
> 
> when does this happen ? I can't reproduce it.

Reproduced with today's linus tree (btrfs pull is there), progs contain the
patches in question:

blkid lists btrfs filesysems:
/dev/sda5
/dev/sda6
/dev/sda7
/dev/sda8
/dev/sda9
/dev/sda11
/dev/sda15
/dev/sdb

mounted filesystems:
/dev/sda5 /mnt/a1 btrfs rw,relatime,space_cache 0 0
/dev/sdb /mnt/test btrfs rw,relatime,space_cache 0 0

$ ./btrfs fi show
ERROR: scan kernel failed, -1
Label: none  uuid: 7c7c948e-c8bc-40fb-88e3-19a3dd4fe6f9 (unmounted)
        Total devices 2 FS bytes used 288.00KiB
        devid    2 size 4.04GiB used 0.00 path /dev/sda15
        *** Some devices missing

Label: none  uuid: a7e96a20-eceb-4593-a836-a8657c66e24b (unmounted)
        Total devices 2 FS bytes used 6.87GiB
        devid    1 size 10.00GiB used 9.03GiB path /dev/sda11
        devid    0 size 10.00GiB used 4.01GiB path /dev/sda9

sda6/7/8/9 belong to sda5 and are not listed here
