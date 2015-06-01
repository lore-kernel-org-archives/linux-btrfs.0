Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46316 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbbFAXD2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 19:03:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzYju-00026p-GY
	for linux-btrfs@vger.kernel.org; Tue, 02 Jun 2015 01:03:26 +0200
Received: from c-76-100-246-88.hsd1.md.comcast.net ([76.100.246.88])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2015 01:03:26 +0200
Received: from ndbecker2 by c-76-100-246-88.hsd1.md.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2015 01:03:26 +0200
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: Re: [newb] move /home to subvolume
Date: Mon, 01 Jun 2015 19:03:19 -0400
Message-ID: <mkiobn$icn$1@ger.gmane.org>
References: <mkhjkp$hgl$1@ger.gmane.org> <CAJCQCtSSt623v-M6wvRUt7vbkd9qkKPnS7guMgCKDxJd+C9rtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:

> On Mon, Jun 1, 2015 at 6:36 AM, Neal Becker <ndbecker2@gmail.com> wrote:
>> I have everything under /:
>>
>> sudo btrfs subvolume list /
>> ID 257 gen 65795 top level 5 path root
> 
> root is a subvolume, but is not the top level (default) subvolume.
>>
>> I want to move /home onto it's own subvolume.  I hope I can do this while
>> the root device is mounted.
> 
> Yes.
> 
> You need to mount the top level and create a new subvolume. Assuming
> you haven't changed the default subvolume, just mount the device
> normally:
> 
> mount /dev/sdaX /mnt
> btrfs sub create /mnt/home
> cp -a --reflink /mnt/root/home /mnt/
> vi /etc/fstab ## to add an entry to mount subvol=home at /home
> umount /home
> mount /home
> 
> And then at your leisure you can blow away the contents of the copied
> and no longer used /home directory still in the root subvolume. Just
> be certain you're deleting the correct home. You could:
> cd /mnt/root/home
> rm -rf *     ## egads be certain
> 
> This is not a mount point, but the old home directory which is no
> longer in use. The path to the in use one is /mnt/home as well as
> /home (in the above example).
> 

Thanks, this all worked just fine.  Only thing I did differently, I needed 
to rename the old /home to /oldhome and mkdir /home for the new subvol 
mount, so that I now have /home and /oldhome and can, at my leisure, rm -rf 
oldhome (otherwise, mounting /home would have hidden the old /home and made 
it impossible to rm).

