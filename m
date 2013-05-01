Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51861 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3EAIoM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 04:44:12 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: dima <dolenin@parallels.com>
Subject: Re: Best Practice - Partition, or not?
Date: Wed, 1 May 2013 18:44:06 +1000
Cc: linux-btrfs@vger.kernel.org
References: <loom.20130501T094600-451@post.gmane.org> <5180CB66.9030803@parallels.com>
In-Reply-To: <5180CB66.9030803@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201305011844.07087.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 1 May 2013, dima <dolenin@parallels.com> wrote:
> > If I want to manage a complete disk with btrfs, what's the "Best
> > Practice"? Would it be best to create the btrfs filesystem on
> > "/dev/sdb", or would it be better to create just one partition from
> > start to end and then do "mkfs.btrfs /dev/sdb1"?
> > 
> > Would the same recomendation hold true, if we're talking about huge
> > disks, like 4TB or so?

My biggest BTRFS array is a RAID-1 of 2*3TB disks.  The system in question 
boots from an Intel SSD so I have no need of boot support on the hard disks.

> (NB: grub will not boot from "/dev/sdb", selinux will)

Not sure what you mean here, but SE Linux isn't a boot loader.  Did you mean 
syslinux?  That's a boot loader but I don't know if it works in such a 
configuration.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
