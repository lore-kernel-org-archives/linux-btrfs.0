Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:40741 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTPYB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 11:24:01 -0400
Received: by mail-qg0-f51.google.com with SMTP id a108so7453485qge.24
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 08:24:00 -0700 (PDT)
Message-ID: <53F4BD8D.9090203@gmail.com>
Date: Wed, 20 Aug 2014 11:23:57 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Andrej Manduch <amanduch@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: M G Berberich <btrfs@oss.m-berberich.de>
Subject: Re: Questions on using BtrFS for fileserver
References: <20140819162151.GA15166@forwiss.uni-passau.de> <53F3C3C7.8020303@gmail.com>
In-Reply-To: <53F3C3C7.8020303@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2014 05:38 PM, Andrej Manduch wrote:
> Hi,
> 
> On 08/19/2014 06:21 PM, M G Berberich wrote:> · Are there any
> reports/papers/web-pages about BtrFS-systems this size
>>   in use? Praises, complains, performance-reviews, whatever…
> 
> I don't know about papers or benchmarks but few weeks ago there was a
> guy who has problem with really long mounting with btrfs with similiar size.
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36226.html
> 
> And I would not recommend 3TB disks. *I'm not btrfs dev* but as far as I
> know there is a quite different between rebuilding disk on real RAID and
> btrfs RAID. The problem is btrfs has RAID on filesystem level not on hw
> level so there is bigger mechanical overheat on drives and thus it take
> significantli longer than regular RAID.
It really suprises me that so many people come to this conclusion, but
maybe they don't provide as much slack space as I do on my systems.  In
general you will only have a longer rebuild on BTRFS than on hardware
RAID if the filesystem is more than about 50% full.  On my desktop array
(4x 1TB disks using BTRFS RAID10), I've replaced disks before and it
took less than an hour for the operation.  Of course that array is
usually not more than 10% full.  Interestingly, it took less time to
rebuild this array the last time I lost a disk than it did back when it
was 3x 1TB disks in a BTRFS RAID1, so things might improve overall with
a larger number of disks in the array.
