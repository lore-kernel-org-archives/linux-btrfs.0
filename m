Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34392 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbbH0QzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 12:55:17 -0400
Received: by vkm66 with SMTP id 66so12125034vkm.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 09:55:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGAq4WFEown9JQxj0qi46zuBun2eUQFKtRSOsgLC03Uv6r1UPw@mail.gmail.com>
References: <CAGAq4WGf475k4oN6+MHrOfnKNdeLsHQE1WfKQAkwPxOH3=9-cw@mail.gmail.com>
	<CAJCQCtTxrBXxi3UQVXqPbXeRQobsvdZq9rsnyVioKQ0nNCZNsw@mail.gmail.com>
	<CAGAq4WFEown9JQxj0qi46zuBun2eUQFKtRSOsgLC03Uv6r1UPw@mail.gmail.com>
Date: Thu, 27 Aug 2015 10:55:16 -0600
Message-ID: <CAJCQCtQQmz3+Cs0KXL+-18UTP1tUG3_4BEpU0qAevi=Os4bYSw@mail.gmail.com>
Subject: Re: Meta data full on a Readynas
From: Chris Murphy <lists@colorremedies.com>
To: Mike Aubury <mike@aubit.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 10:35 AM, Mike Aubury <mike@aubit.com> wrote:
> Thanks for that.
> I found something similar online - using a loop back device and a file
> on a usb stick.
> I created a 2GB file, and mounted that tried the balance - and once
> completed - rebooted.

OK but did you delete the loop device before rebooting? If not, then
that's why. You need to reactivate that loop device from the file to
mount the fs normally. It's not good enough to just balance. You have
to use btrfs dev del on the extra device so the fs moves everything
off that soon to be removed device.

>>> root@ReadyNAS:~#   btrfs fi df /data
>>> Data, single: total=6.33TiB, used=5.87TiB
>>> System, RAID1: total=32.00MiB, used=768.00KiB
>>> System, single: total=4.00MiB, used=0.00B
>>> Metadata, RAID1: total=9.00GiB, used=8.98GiB
>>> Metadata, DUP: total=3.00GiB, used=2.12GiB

I just noticed this, and it's confusing. All data is single copy. Some
of the metadata is DUP on *one* device rather than RAID1. So it's
entirely possible that some of the DUP metadata, without conversion,
ends up on the loop device and if that loop device isn't first deleted
before the reboot, then you have a broken file system because that
necessary fs metadata isn't available anywhere. The metadata DUP is
kinda dangerous in multiple device cases.



-- 
Chris Murphy
