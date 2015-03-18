Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:36353 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbbCRVGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 17:06:46 -0400
Received: by ykcn8 with SMTP id n8so21015732ykc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 14:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5509E34F.6010504@graphitesystems.com>
References: <5509E34F.6010504@graphitesystems.com>
Date: Wed, 18 Mar 2015 15:06:45 -0600
Message-ID: <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 2:42 PM, K Richard Pixley
<rpixley@graphitesystems.com> wrote:
> I'm having trouble deleting a subvolume.
>
> [root@new-alfred ~]# uname -a
> Linux new-alfred.corp.graphitesystems.com 3.10.0-123.el7.x86_64 #1 SMP Mon

If highly recommend that you check out elrepo.org for a newer kernel
than this. Currently they have
kernel-ml-3.19.1-1.el7.elrepo.x86_64.rpm available.

The Fedora 21 package for btrfs-progs-3.19 also works on RHEL 7/CentOS
7, which you can find in koji.fedoraproject.org, or build it from
source if you prefer.



> [root@new-alfred ~]#   btrfs fi show
> Label: 'rhel_bark'  uuid: d3c6c783-c190-4675-99f2-b83f3c462656
>         Total devices 2 FS bytes used 14.25GiB
>         devid    1 size 461.38GiB used 7.03GiB path /dev/sda2
>         devid    2 size 465.76GiB used 12.01GiB path /dev/sdb1
>
> Btrfs v3.16.2
> [root@new-alfred ~]#   btrfs fi df /
> Data, single: total=15.01GiB, used=13.19GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=2.00GiB, used=1.07GiB
> Metadata, single: total=8.00MiB, used=0.00
> [root@new-alfred ~]# btrfs subvolume list /
> ID 257 gen 1483 top level 5 path root
> ID 258 gen 1466 top level 5 path home
> [root@new-alfred ~]# btrfs subvolume delete home
> Transaction commit: none (default)
> ERROR: error accessing 'home'
> [root@new-alfred ~]# btrfs subvolume delete /home
> Transaction commit: none (default)
> ERROR: error accessing '/home'
>
> What format do I need to use to delete the "home" subvolume?

# mkdir  /mnt/btr
# mount /dev/sda2 /mnt/btr
# btrfs subvolume delete /mnt/btr/home

The Fedora/RHEL/CentOS installer creates two subvolumes: root and
home. If you check out fstab, those subvolumes are mounted at / and
/home. Therefore the top level subvolume (id 5) is not mounted by
default, so there's no way to delete subvolumes in the top level.



-- 
Chris Murphy
