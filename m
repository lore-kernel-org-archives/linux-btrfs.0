Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:39727 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbaLIXNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 18:13:24 -0500
Message-ID: <54878210.8030807@pobox.com>
Date: Tue, 09 Dec 2014 15:13:20 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com> <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
In-Reply-To: <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
> Label: none  uuid: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
>      Total devices 1 FS bytes used 1.35TiB
>      devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1
>
>
> Data, single: total=1.35TiB, used=1.35TiB
> System, single: total=32.00MiB, used=112.00KiB
> Metadata, single: total=3.00GiB, used=1.55GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Are you trying to convert a filesystem on a single device/partition to 
RAID 1?

I don't think thats legal. Whithout a second slice to distribute the 
copies of the data onto there is no raiding to be done.

Add the second device with btrfs device add, and _then_ use balance to 
redistribute and copy the data to the second device.

ASIDE: I, personally, think that a single device RAID1 should be legal. 
I also think that it should be possible to tell the system that you want 
N copies if you have N-or-more slices onto which they would spread. 
These would match my expectations from mdadm and several hardware and 
appliance RAID solutions. But my opinions in the matter do _not_ match 
the BTRFS code base. RAID1 means exactly two devices (for any given 
piece of information) [though I don't know whether it always has to be 
the _same_ two devices for two different pieces of information.]

So yea, if that is what you are trying to do, the inability to find a 
second drive on which to allocate the peer-block(s) for an extent would 
produce interesting errors. I cant say for sure that this is the exact 
genesis of your issue, but I've read here in other threads a number of 
comments that would translate as "trying to set RAID1 with on a 
one-slice file system will be full of fail".
