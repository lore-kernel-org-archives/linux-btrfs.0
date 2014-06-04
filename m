Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:33362 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaFDNar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 09:30:47 -0400
From: Russell Coker <russell@coker.com.au>
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Partition tables / Output of parted
Date: Wed, 04 Jun 2014 23:30:43 +1000
Message-ID: <16894659.LPcZdlAJqm@xev>
In-Reply-To: <20140604111916.GB1657@mars>
References: <20140604111916.GB1657@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 4 Jun 2014 13:19:16 Stefan Malte Schumacher wrote:
> I have created multiple filesystems with btrfs, in all cases directly
> on the devices themself without creating partitions beforehand.

I do that sometimes, it works well.  I've done the same thing with Ext2/3 in 
the past as well, it's no big deal.

> Now,
> if I open the disks containing the multi-device filesystem in parted
> it outputs the partion table as loop and shows one partition with
> btrfs which covers the whole disk.

http://lists.alioth.debian.org/pipermail/parted-devel/2009-May/002840.html

A Google search on "Partition Table: loop" turned up the above explanation as 
the third result.

> I am unsure how to interpret this output. Two possible explanations
> come to mind: a) Btrfs does create partitions, but only if a filesystem
> spans multiple devices or b) the output of parted is faulty and no actual
> partition is created in both cases.

BTRFS doesn't create partitions.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

