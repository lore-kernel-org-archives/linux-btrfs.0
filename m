Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33449 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbcGYUtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 16:49:07 -0400
Received: by mail-io0-f176.google.com with SMTP id 38so174922750iol.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jul 2016 13:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcuexAaxha03vnwAC1bW6hcjEpH4GoQr2YBps=vWAu3RS8FJg@mail.gmail.com>
References: <CAAcuexAaxha03vnwAC1bW6hcjEpH4GoQr2YBps=vWAu3RS8FJg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 25 Jul 2016 14:49:03 -0600
Message-ID: <CAJCQCtTUGxfTgjLAqCC7_k-8PK9dYZHFJMchih-zQBxApvURRA@mail.gmail.com>
Subject: Re: Any suggestions for thousands of disk image snapshots ?
To: Kurt Seo <tiger.anam.manager@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2016 at 1:25 AM, Kurt Seo <tiger.anam.manager@gmail.com> wrote:
>  Hi all
>
>
>  I am currently running a project for building servers with btrfs.
> Purposes of servers are exporting disk images through iscsi targets
> and disk images are generated from btrfs subvolume snapshot.

How is the disk image generated from Btrfs subvolume snapshot?

On what file system is the disk image stored?


> Maximum number of clients is 500 and each client uses two snapshots of
> disk images. the first disk image's size is about 50GB and second one
> is about 1.5TB.
> Important thing is that the original 1.5TB disk image is mounted with
> loop device and modified real time - eg. continuously downloading
> torrents in it.
> snapshots are made when clients boot up and deleted when they turned off.
>
> So server has two original disk images and about a thousand of
> snapshots in total.
> I made a list of factors affect server's performance and stability.
>
> 1. Raid Configuration - Mdadm raid vs btrfs raid, configuration and
> options for them.
> 2. How to format btrfs - nodesize, features
> 3. Mount options - nodatacow and compression things.
> 4. Kernel parameter tuning.
> 5. Hardware specification.
>
>
> My current setups are
>
> 1. mdadm raid10 with 1024k chunk and 12 disks of 512GB ssd.
> 2. nodesize 32k and nothing else.
> 3. nodatacow, noatime, nodiratime, nospace_cache, ssd, compress=lzo
> 4. Ubuntu with 4.1.27 kernel without additional configurations.
> 5.
> CPU : Xeon E3- 1225v2 Quad Core 3.2Ghz
> RAM : 2 x DDR3 8GB ECC  ( total 16GB)
> NIC : 2 x 10Gbe
>
>
>  The result of test so far is
>
> 1. btrfs-transaction and btrfs-cleaner assume cpu regularly.
> 2. When cpu is busy for those processes, creating snapshots takes long.
> 3. The performance is getting slow as time goes by.
>
>
> So if there are any wrong and missing configurations , can you suggest some?
> like i need to increase physical memory.
>
> Any idea would help me a lot.

Off hand it sounds like you have a file system inside a disk image
which itself is stored on a file system. So there's two file systems.
And somehow you have to create the disk image from a subvolume, which
isn't going to be very fast. And also something I read recently on the
XFS list makes me wonder if loop devices are production worthy.

I'd reconsider the layout for any one of these reasons alone.


1. mdadm raid10 + LVM thinp + either XFS or Btrfs. The first LV you
create is the one the host is constantly updating. You can use XFS
freeze to freeze the file system, take the snapshot, and then release
the freeze. You now have the original LV which is still being updated
by the host, but you have a 2nd LV that itself can be exported as an
iSCSI target to a client system. There's no need to create a disk
image, so the creation of the snapshot and iSCSI target is much
faster.

2. Similar to the above, but you could make the 2nd LV (the snapshot)
a Btrfs seed device that all of the clients share, and they are each
pointed to their own additional LV used for the Btrfs sprout device.

The issue I had a year ago with LVM thin provisioning is when the
metadata pool gets full, the entire VG implodes very badly and I
didn't get any sufficient warnings in advance that the setup was
suboptimal, or that it was about to run out of metadata space, and it
wasn't repairable. But it was just a test. I haven't substantially
played with LVM thinp with more than a dozen snapshots. But LVM being
like emacs, you've got a lot of levers to adjust things depending on
the workload whereas Btrfs has very few.

Therefore, the plus of the 2nd option is you're only using a handful
of LVM thinp snapshots. And you're also not really using Btrfs
snapshots either, you're using the union-like fs feature of the
seed-sprout capability of Btrfs. The other nice thing is that when the
clients quit, the LV's are removed at an LVM extent level. There is no
need for file system cleanup processes to decrement reference counts
on all the affected extents. So it'd be fast.


-- 
Chris Murphy
