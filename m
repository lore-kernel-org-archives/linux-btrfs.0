Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9621 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932324AbaDBSAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 14:00:23 -0400
Message-ID: <533C5031.7090600@fb.com>
Date: Wed, 2 Apr 2014 14:00:17 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Space cache degradation
References: <CAKgsxVSJEug-R-OT3Z2TF5JFf-AU+hw4MaPOnupDV2CZBBLU7A@mail.gmail.com>
In-Reply-To: <CAKgsxVSJEug-R-OT3Z2TF5JFf-AU+hw4MaPOnupDV2CZBBLU7A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/02/2014 01:54 PM, Justin Maggard wrote:
> I've found that, after using some btrfs filesystems for some time,
> that the first large write after a reboot takes a very long time.  So
> I went to work trying out different test cases to simplify
> reproduction of the issue, and I've got it down to just these steps:
>
> 1) mkfs.btrfs on a large-ish device.  I used a 14TB MD RAID5 device.
> 2) Fill it up a bit over half-way with ~5MB files.  In my test I made
> 30 copies of a 266GB data set consisting of 52,356 files and 20,268
> folders.
> 3) umount
> 4) mount
> 5) time fallocate -l 2G /mount/point/2G.dat
> real 3m9.412s
> user 0m0.002s
> sys 0m2.939s
>
> By comparison, if I don't use space cache things go much better:
> # umount
> # mount -o nospace_cache
> # time fallocate -l 2G /mount/point/2G.dat
> real 0m15.982s
> user 0m0.002s
> sys 0m0.103s
>
> If I use the clear_cache mount option, that also resolves the slowness.
>
> Is this a known issue?  For me it's 100% reproducible, on various
> kernel versions including 3.14-rc8.  Is there anything I should
> provide to help debug?
>

Neat, not a known issue.  What's probably happening is that without 
space cache on, you're jumping out into unused space while it 
regenerates the space cache.  Once the caching thread is done caching 
all the free space, you should go slowly again.

I'll try to reproduce.

-chris



