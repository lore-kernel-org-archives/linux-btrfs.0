Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34982 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcDZJXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 05:23:45 -0400
Received: by mail-yw0-f180.google.com with SMTP id g133so7578700ywb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 02:23:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjfrL1qbhDpE5W4vJZOyHKNd=G7+wCMapZSwUYs-dkOoQ@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
	<CALq5X_iJcbXeaQxPAoHPwXyDSSXSx7HnWPApbQcXB4s7utGG_g@mail.gmail.com>
	<CAD=QJKjfrL1qbhDpE5W4vJZOyHKNd=G7+wCMapZSwUYs-dkOoQ@mail.gmail.com>
Date: Tue, 26 Apr 2016 17:23:43 +0800
Message-ID: <CALq5X_gW2QaQenhCworrc757QUCffCchNORFWxgw8Xn+vvjtJw@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: David Alcorn <nroclaed@gmail.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/26/16, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> On 22 April 2016 at 06:44, David Alcorn <nroclaed@gmail.com> wrote:
>>
>> First, I verified that while the Debian Installer will install to a
>> pre set default BTRFS RAID6 subvolume, the Grub install step fails.
>> The alternative to restore installation to a RAID6 subvolume requires
>> installation to a non RAID6 subvolume and then send|receive the
>> snapshotted installation to the array.  To prepare for this attempt, I
>> reinstalled BTRFS (Debian stable) to a flash drive using separate
>> partitions for efi, /boot/ and / (in a subvolume).  The default
>> subvolume was set to 5 for both the flash / partition and also the
>> RAID6 array.  I used a separate /boot partition to reduce complexity.
>> Both the kernel and btrfs tools were upgraded to 4.4.  I soon
>> thereafter got lost.
>
> 1. Have you partially filled your RAID6 array?  If so, do you have
> current backups for everything you care about?
> 2. Please indicate whether you prefer to mount by LABEL, UUID, or /dev
> 3. If it's by /dev, please send the output of: parted -l
> 4. If it's by LABEL or UUID, please also send the output of: blkid
>
> Sincerely,
> Nicholas
>


Nicholas:

1. My RAID array is partially filled and backed up.
2. I prefer to mount by UUID.
3. n/a
4. the relevant content of my blkid is:
"/dev/sda1: UUID="AEF6-E013" TYPE="vfat"
PARTUUID="b4b9c894-aa4f-4c83-ba27-8919eaaeac49"
/dev/sda2: UUID="a428a1ea-5174-47b6-a894-521166a7a354" TYPE="ext2"
PARTUUID="e25bcabb-2fd3-4515-bf74-3a2f0c548fec"
/dev/sda3: UUID="1b413c7c-d39d-4c10-9f1d-4f3a21791c50"
UUID_SUB="e2d12168-c216-425f-9a82-6d46dad8ccc8" TYPE="btrfs"
PARTLABEL="primary" PARTUUID="1651d9f1-35ff-458b-ae64-bb6003c72159"
/dev/sdb: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
UUID_SUB="b4c6bbc5-ea80-4a79-89ca-333d351b09e5" TYPE="btrfs"
/dev/sdc: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
UUID_SUB="c4ac65e7-45bb-4450-9aa4-80a7fbebed3a" TYPE="btrfs"
/dev/sdd: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
UUID_SUB="5f55bf3b-8e82-4b50-8b62-5dc45c892281" TYPE="btrfs"
/dev/sde: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
UUID_SUB="5a12cbd5-bdc2-4258-9bc8-23d95cbb1db6" TYPE="btrfs"


I omitted /dev/sdf from my blkid content as it is an unused,
transitory drive that will be redeployed after "/" is moved to the
array.  /dev/sda is my flash drive with separate partitions for efi
(vfat), /boot/ (ext2) and "/" (btrfs subvolume).

David Alcorn
