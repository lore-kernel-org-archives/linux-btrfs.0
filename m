Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:48189 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaIKGk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 02:40:27 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: No space on empty, degraded raid10
Date: Thu, 11 Sep 2014 16:40:23 +1000
References: <CAL-Saa_3uU936baHYjVOHXMVkNtP4mgLD6WuPUu2Wxw4SaPrzQ@mail.gmail.com> <540D8C7A.4030700@gmail.com>
In-Reply-To: <540D8C7A.4030700@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201409111640.23845.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 8 Sep 2014, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> Also, I've found out the hard way that system chunks really should be
> RAID1, NOT RAID10, otherwise it's very likely that the filesystem
> won't mount at all if you lose 2 disks.

Why would that be different?

In a RAID-1 you expect system problems if 2 disks fail, why would RAID-10 be 
different?

Also it would be nice if there was a N-way mirror option for system data.  As 
such data is tiny (32MB on the 120G filesystem in my workstation) the space 
used by having a copy on every disk in the array shouldn't matter.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
