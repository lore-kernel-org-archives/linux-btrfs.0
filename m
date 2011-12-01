From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Resize command syntax wrong?
Date: 01 Dec 2011 07:46:00 +0100
Message-ID: <Bz2R4Xhi1uB@helmut.hullen.de>
References: <4ED6C3E8.60009@cfl.rr.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED6C3E8.60009@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Phillip,

Du meintest am 30.11.11:

>> You start with a system of 2 disks. They get filled nearly
>> simultaneously.
>> Then you add a 3rd disk (which is empty at that time). Now it's a
>> good idea to run "balance" for equalizing the filling.

> balance != resize

I know.

p.e.
Start with 1 disk with 2 GB and 1 disk with 4 GByte
Fill it with 2 Gbyte data, each disk gets 1 GByte.

Add a disk with 10 GByte, run "balance": each disk gets about 700 MByte.

That has nothing to do with "resize".

Viele Gruesse!
Helmut
