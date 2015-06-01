Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34811 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbbFASSM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 14:18:12 -0400
Received: by ieczm2 with SMTP id zm2so115490559iec.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 11:18:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mkhjkp$hgl$1@ger.gmane.org>
References: <mkhjkp$hgl$1@ger.gmane.org>
Date: Mon, 1 Jun 2015 12:18:10 -0600
Message-ID: <CAJCQCtSSt623v-M6wvRUt7vbkd9qkKPnS7guMgCKDxJd+C9rtw@mail.gmail.com>
Subject: Re: [newb] move /home to subvolume
From: Chris Murphy <lists@colorremedies.com>
To: Neal Becker <ndbecker2@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 1, 2015 at 6:36 AM, Neal Becker <ndbecker2@gmail.com> wrote:
> I have everything under /:
>
> sudo btrfs subvolume list /
> ID 257 gen 65795 top level 5 path root

root is a subvolume, but is not the top level (default) subvolume.
>
> I want to move /home onto it's own subvolume.  I hope I can do this while
> the root device is mounted.

Yes.

You need to mount the top level and create a new subvolume. Assuming
you haven't changed the default subvolume, just mount the device
normally:

mount /dev/sdaX /mnt
btrfs sub create /mnt/home
cp -a --reflink /mnt/root/home /mnt/
vi /etc/fstab ## to add an entry to mount subvol=home at /home
umount /home
mount /home

And then at your leisure you can blow away the contents of the copied
and no longer used /home directory still in the root subvolume. Just
be certain you're deleting the correct home. You could:
cd /mnt/root/home
rm -rf *     ## egads be certain

This is not a mount point, but the old home directory which is no
longer in use. The path to the in use one is /mnt/home as well as
/home (in the above example).



>
> What is the procedure?
>
> I tried first to create a subvolume for /home at the top-level, but couldn't
> figure out the syntax:
>
> [nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home
> [sudo] password for nbecker:
> ERROR: '/home' exists


That doesn't work because you're trying to create a home subvolume
where a home directory exists. You need to mount the top level
subvolume to create a subvolume in it.


-- 
Chris Murphy
