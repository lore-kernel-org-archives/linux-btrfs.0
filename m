Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35925 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbcDYTiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 15:38:54 -0400
Received: by mail-wm0-f41.google.com with SMTP id v188so110969965wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 12:38:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALq5X_iJcbXeaQxPAoHPwXyDSSXSx7HnWPApbQcXB4s7utGG_g@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
	<CALq5X_iJcbXeaQxPAoHPwXyDSSXSx7HnWPApbQcXB4s7utGG_g@mail.gmail.com>
Date: Mon, 25 Apr 2016 15:38:52 -0400
Message-ID: <CAD=QJKjfrL1qbhDpE5W4vJZOyHKNd=G7+wCMapZSwUYs-dkOoQ@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: David Alcorn <nroclaed@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 April 2016 at 06:44, David Alcorn <nroclaed@gmail.com> wrote:
>
> First, I verified that while the Debian Installer will install to a
> pre set default BTRFS RAID6 subvolume, the Grub install step fails.
> The alternative to restore installation to a RAID6 subvolume requires
> installation to a non RAID6 subvolume and then send|receive the
> snapshotted installation to the array.  To prepare for this attempt, I
> reinstalled BTRFS (Debian stable) to a flash drive using separate
> partitions for efi, /boot/ and / (in a subvolume).  The default
> subvolume was set to 5 for both the flash / partition and also the
> RAID6 array.  I used a separate /boot partition to reduce complexity.
> Both the kernel and btrfs tools were upgraded to 4.4.  I soon
> thereafter got lost.

1. Have you partially filled your RAID6 array?  If so, do you have
current backups for everything you care about?
2. Please indicate whether you prefer to mount by LABEL, UUID, or /dev
3. If it's by /dev, please send the output of: parted -l
4. If it's by LABEL or UUID, please also send the output of: blkid

Sincerely,
Nicholas
