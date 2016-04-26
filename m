Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36287 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcDZLMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 07:12:19 -0400
Received: by mail-ig0-f179.google.com with SMTP id u10so38123322igr.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 04:12:19 -0700 (PDT)
Subject: Re: Add device while rebalancing
To: Juan Alberto Cirez <jacirez@rdcsafety.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
 <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net> <571DFCF2.6050604@gmail.com>
 <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net> <571E154C.9060604@gmail.com>
 <CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <571F4CD0.9050004@gmail.com>
Date: Tue, 26 Apr 2016 07:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-26 06:50, Juan Alberto Cirez wrote:
> Thank you guys so very kindly for all your help and taking the time to
> answer my question. I have been reading the wiki and online use cases
> and otherwise delving deeper into the btrfs architecture.
>
> I am managing a 520TB storage pool spread across 16 server pods and
> have tried several methods of distributed storage. Last attempt was
> using Zfs as a base for the physical bricks and GlusterFS as a glue to
> string together the storage pool. I was not satisfied with the results
> (mainly Zfs). Once I have run btrfs for a while on the test server
> (32TB, 8x 4TB HDD RAID10) for a while I will try btrfs/ceph
For what it's worth, GlusterFS works great on top of BTRFS.  I don't 
have any claims to usage in production, but I've done _a lot_ of testing 
with it because we're replacing one of our critical file servers at work 
with a couple of systems set up with Gluster on top of BTRFS, and I've 
been looking at setting up a small storage cluster at home using it on a 
couple of laptops I have which have non-functional displays.  Based on 
what I've seen, it appears to be rock solid with respect to the common 
failure modes, provided you use something like raid1 mode on the BTRFS 
side of things.
