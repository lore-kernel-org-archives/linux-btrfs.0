Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59058 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbbHLDEc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 23:04:32 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 201DBEB58
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 13:04:29 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
Date: Wed, 12 Aug 2015 13:04:27 +1000
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com> <CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com> <CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
In-Reply-To: <CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201508121304.27963.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 12 Aug 2015 07:24:00 AM Chris Murphy wrote:
> > There is still data redundancy.  Will a scrub at least notice that the
> > copies differ?
> 
> No, that's what I mean by "nodatasum means no raid1 self-healing is
> possible". You have data redundancy, but without checksums btrfs has
> no way to know if they differ. It doesn't do two reads and compares
> them, it's just like md raid, it picks one device, and so long as
> there's no read error from the device, that copy of the data is
> assumed to be good.

Linux Software RAID scrub will copy the data from one disk to the other to 
make them identical, the theory is that it's best to at least be consistent if 
you can't be sure you are right.

Will a BTRFS scrub do this on a non-CoW file?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
