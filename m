Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:44738 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbcDRI7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 04:59:37 -0400
Subject: Re: RAID5 Unable to remove Failing HD
To: Anand Jain <anand.jain@oracle.com>, Rene Castberg <rene@castberg.org>,
        linux-btrfs@vger.kernel.org
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
 <56BAFC15.6080106@oracle.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5714A1F7.3050509@bouton.name>
Date: Mon, 18 Apr 2016 10:59:35 +0200
MIME-Version: 1.0
In-Reply-To: <56BAFC15.6080106@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 10/02/2016 10:00, Anand Jain a écrit :
>
>
> Rene,
>
> Thanks for the report. Fixes are in the following patch sets
>
>  concern1:
>  Btrfs to fail/offline a device for write/flush error:
>    [PATCH 00/15] btrfs: Hot spare and Auto replace
>
>  concern2:
>  User should be able to delete a device when device has failed:
>    [PATCH 0/7] Introduce device delete by devid
>
>  If you were able to tryout these patches, pls lets know.

Just found out this thread after digging for a problem similar to mine.

I just got the same error when trying to delete a failed hard drive on a
RAID1 filesystem with a total of 4 devices.

# btrfs device delete 3 /mnt/store/
ERROR: device delete by id failed: Inappropriate ioctl for device

Were the patch sets above for btrfs-progs or for the kernel ?
Currently the kernel is 4.1.15-r1 from Gentoo. I used btrfs-progs-4.3.1
(the Gentoo stable version) but it didn't support delete by devid so I
upgraded to btrfs-progs-4.5.1 which supports it but got the same
"inappropriate ioctl for device" error when I used the devid.

I don't have any drive available right now for replacing this one (so no
btrfs dev replace possible right now). The filesystem's data could fit
on only 2 of the 4 drives (in fact I just added 2 old drives that were
previously used with md and rebalanced, which is most probably what
triggered one of the new drives failure). So I can't use replace and
would prefer not to lose redundancy while waiting for new drives to get
there.

So the obvious thing to do in this circumstance is to delete the drive,
forcing the filesystem to create the missing replicas in the process and
only reboot if needed (no hotplug). Unfortunately I'm not sure of the
conditions where this is possible (which kernel version supports this if
any ?). If there is a minimum kernel version where device delete works,
can https://btrfs.wiki.kernel.org/index.php/Gotchas be updated ? I don't
have a wiki account yet but I'm willing to do it myself if I can get
reliable information.

I can reboot this system and I expect the current drive to appear
missing (it doesn't even respond to smartctl) and I suppose "device
delete missing" will work then. But should I/must I upgrade the kernel
to avoid this problem in the future and if yes which version(s)
support(s) failed device delete?

Best regards,

Lionel
