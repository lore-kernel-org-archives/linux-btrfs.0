Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:39444 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab3AKW1d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 17:27:33 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Errors not found by btrfsck or scrub
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAHX0HSby06a7x9iDgvRwtMJbcysQGkFYxeQf0XTM35rRHp=m2w@mail.gmail.com>
Date: Fri, 11 Jan 2013 15:27:30 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D6893685-FF9E-43CE-817A-6799ED518FAC@colorremedies.com>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com> <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com> <20130111185449.GU19051@carfax.org.uk> <CAHX0HSby06a7x9iDgvRwtMJbcysQGkFYxeQf0XTM35rRHp=m2w@mail.gmail.com>
To: chris.r.carlin@gmail.com, Chris Carlin <chrisrcarlin@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2013, at 2:57 PM, Chris Carlin <chrisrcarlin@gmail.com> wrote:

> Thanks for the response, Hugo!
> 
> This hard drive is not production, so I can afford to tinker with it
> if it helps you guys track down anything interesting. Of course, I'd
> prefer to restore it rather than wipe it…

What is the result for?

btrfs fi show

I see from the first post that it must be two disks/partitions, since it's data raid0, and metadata partially raid1. And also it might be vaguely useful to see a conventional df or df -h.

Based on some experiences I've had, and also seen on the list recently, you might be able to back out of this situation by adding another device to the volume. It almost doesn't matter how big it is. It could be a small partition on another disk, or even a USB stick. I can't tell you how much space. It might only need a few MB, but I'd give it what you can. And then see if you can redo the balance. But it sounds to me like the file system is very close to full, at least it can't allocate more space for metadata it seems.


Chris Murphy