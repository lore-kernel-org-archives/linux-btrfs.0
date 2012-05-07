From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 23:17:00 +0200
Message-ID: <C8PDfzNPCXB@helmut.hullen.de>
References: <4FA835D7.3040207@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA835D7.3040207@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Daniel,

Du meintest am 07.05.12:

>>    mkfs.btrfs  -m raid1 -d raid0
>>
>> with 3 disks gives me a "cluster" which looks like 1 disk/partition/
>> directory.
>> If one disk fails nothing is usable.

> How is that different from putting ext on top of a raid0?

Classic raid0 doesn't allow deleting/removing disks from a cluster.

>> With ext2/3/4 I mount 2 disks/partitions into the first disk. If one
>> disk fails the contents of the 2 other disks is still readable,

> There is nothing that prevents you from using this strategy with
> btrfs.

How?
I've tried many installations of btrfs, sometimes 1 disk failed, and  
then the data on all other disks was inaccessible.

Viele Gruesse!
Helmut
