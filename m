Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57265 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3ALEnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 23:43:47 -0500
Received: by mail-vc0-f170.google.com with SMTP id fl11so2109175vcb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 20:43:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: chris.r.carlin@gmail.com
In-Reply-To: <D6893685-FF9E-43CE-817A-6799ED518FAC@colorremedies.com>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
 <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
 <20130111185449.GU19051@carfax.org.uk> <CAHX0HSby06a7x9iDgvRwtMJbcysQGkFYxeQf0XTM35rRHp=m2w@mail.gmail.com>
 <D6893685-FF9E-43CE-817A-6799ED518FAC@colorremedies.com>
From: Chris Carlin <chrisrcarlin@gmail.com>
Date: Fri, 11 Jan 2013 23:43:25 -0500
Message-ID: <CAHX0HSbWj6vywv56x32F6EyGkh_yt2WkZOXcEpUn4P0pmxoANw@mail.gmail.com>
Subject: Re: Errors not found by btrfsck or scrub
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Based on some experiences I've had, and also seen on the list recently, you might be able to back out of this situation by adding another device to the volume. It almost doesn't matter how big it is. It could be a small partition on another disk, or even a USB stick. I can't tell you how much space. It might only need a few MB, but I'd give it what you can. And then see if you can redo the balance. But it sounds to me like the file system is very close to full, at least it can't allocate more space for metadata it seems.

Aha! Worked fine.

I added a temporary 10GB device, and everything instantly started
working. After I ran another balance command with -dusage=5, I deleted
the new device and everything's fine with the original two devices.
The temporary device was barely touched by the filesystem, if it was
touched at all.

A weird thing is "btrfs fi show" showed tens of gigs of unallocated
space the whole time.

Anyway, so for anyone who might have a similar problem in the future,
giving btrfs a little temporary scratch space did the trick.

~Chris
