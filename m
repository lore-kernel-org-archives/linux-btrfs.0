Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36007 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKXNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 18:13:24 -0500
Received: by lfs39 with SMTP id 39so24648177lfs.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 15:13:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
Date: Wed, 11 Nov 2015 18:13:22 -0500
Message-ID: <CAJCQCtTCzCOfdrvjNF2rs_VuHqVA4nU3jsgxKpkADd-+v7GtMA@mail.gmail.com>
Subject: Re: Potential to loose data in case of disk failure
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2015 at 12:30 PM, Jim Murphy <srlinuxadmin@gmail.com> wrote:
> Hi all,
>
> What am I missing or misunderstanding?  I have a newly
> purchased laptop I want/need to multi boot different OSs
> on.  As a result after partitioning I have ended up with two
> partitions on each of the two internal drives(sda3, sda8,
> sdb3 and sdb8).  FWIW, sda3 and sdb3 are the same size
> and sda8 and sdb8 are the same size.  As an end result
> I want one btrfs raid1 filesystem.  For lack of better terms,
> sda3 and sda8 "concatenated" together, sdb3 and sdb8
> "concatenated" together and then mirroring "sda" to "sdb"
> using only btrfs.  So far have found no use-case to cover
> this.

I'm going to assume that mkfs.btrfs -mraid1 -draid1 command is pointed
at the two resulting /dev/mapper/X devices resulting from the linear
concat.

>
> If I create a raid1 btrfs volume using all 4 "devices" as I
> understand it I would loose data if I were to loose a drive
> because two mirror possibilities would be:
>
> sda3 mirrored to sda8
> sdb3 mirrored to sdb8

Well you don't actually know how the mirroring will allocate is the
problem with the arrangement. But yes, it's possible some chunks on
sda3 will be mirrored to sda8, which is not what you'd want so the
linear concat idea is fine using either the md driver or lvm.



> Is what I want to do possible without using MD-RAID and/or
> LVM?

Yes, either are suitable for this purpose. The decision comes down to
the user space tools, use the tool that you're most comfortable with.


>  If so would someone point me to the documentation
> I missed.  For whatever reason, I don't want to believe that
> this can't be done.  I want to believe that the code in btrfs
> is smart enough to know that sda3 and sda8 are on the same
> drive and would not try to mirror data between them except in
> a test setup.  I hope  I just missed some documentation,
> somewhere.

As far as I know right now btrfs works strictly at the block device
level, and considers different partitions different block devices, it
doesn't grok the underlying physical device relationship.


-- 
Chris Murphy
