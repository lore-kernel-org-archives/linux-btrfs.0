Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59341 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3CMOEB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 10:04:01 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 3517A21F17D
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 01:03:55 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: Debian 3.7.1 BTRFS crash
Date: Thu, 14 Mar 2013 01:03:53 +1100
References: <201303131238.33692.russell@coker.com.au> <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com> <5140837A.70409@redhat.com>
In-Reply-To: <5140837A.70409@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303140103.53907.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Mar 2013, Eric Sandeen <sandeen@redhat.com> wrote:
> > It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
> > burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
> > 2 months for each. ddrescue'ing the SSD would probably give better
> > chances of recovery and give BTRFS/btrfsck a chance to write correctly
> > to the newly copied image.
> 
> On what do you base that theory?  I suppose it could be, but nothing
> in the logs necessarily suggests that.  The "IO failure" is because 
> the fs shut down, went readonly, and subsequent IOs got -EIO,
> I think.

I've just used nc to transfer the filesystem to another system, there were no 
read errors so I don't think that a SSD hardware failure is the problem here.

I'm now getting similar problems running a 3.8 kernel with the filesystem on a 
loopback device.  I'll provide more information soon.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
