Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36809 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbdA3Vfc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:35:32 -0500
Received: by mail-yb0-f194.google.com with SMTP id o65so2227430ybo.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 13:35:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSO+vUxOL6FHOdgLqOLSm6C6U4YfUga=K-h7fhBDCaXng@mail.gmail.com>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de> <CAJCQCtSO+vUxOL6FHOdgLqOLSm6C6U4YfUga=K-h7fhBDCaXng@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 30 Jan 2017 14:35:30 -0700
Message-ID: <CAJCQCtTfi7BeHZeV9Hr=LMA_kN3nKoe+sPmfehDQ3=SV8RaD3w@mail.gmail.com>
Subject: Re: btrfs recovery
To: Chris Murphy <lists@colorremedies.com>
Cc: Michael Born <Michael.Born@aei.mpg.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 2:20 PM, Chris Murphy <lists@colorremedies.com> wrote:

> What people do with huge databases, which have this same problem,
> they'll take a volume snapshot. This first commits everything in
> flight, freezes the fs so no more changes can happen, then takes a
> snapshot, then unfreezes the original so the database can stay online.
> The freeze takes maybe a second or maybe a bit longer depending on how
> much stuff needs to be committed to stable media. Then backup the
> snapshot as a read-only volume. Once the backups is done, delete the
> snapshot.I

In Btrfs land, the way to do it is snapshot a subvolume, and then
rsync or 'btrfs send' the contents of the snapshot somewhere. I
actually often use this for whole volume backups:

## this will capture /boot and /boot/efi on separate file systems and
put the tar on Btrfs root.
cd /
tar -acf boot.tar.gz boot/

## My subvolumes are at the top level, fstab mounts them specifically,
so mount the top level to get access
sudo mount -o noatime <dev> /mnt
## Take a snapshot of rootfs
sudo btrfs sub snap - r /mnt/root /mnt/root.20170130
## Send it to remote server
sudo btrfs send /mnt/root.20170130 | ssh chris@server "cat - >
~/root.20170130.btrfs'
## Restore it from server, assumes the subvolume/snapshot does not exist
ssh chris@server "sudo btrfs send -f ~/root.20170130.btrfs" | sudo
btrfs receive /mnt/

The same can be done with incremental images, but of course you need
all the the files and named in a sane way so you know in what order to
restore them since those incrementals are parent/child specific.

The other thing this avoids, critically, is the form of corruptions of
Btrfs whenever two or more of the same volume (by UUID) appears to the
kernel at the same time, and one of them is mounted. See gotchas of
block level copies.

https://btrfs.wiki.kernel.org/index.php/Gotchas

-- 
Chris Murphy
