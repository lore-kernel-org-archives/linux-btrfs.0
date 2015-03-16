Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35900 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbbCPN4R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 09:56:17 -0400
Received: by igbue6 with SMTP id ue6so42180937igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2015 06:56:16 -0700 (PDT)
Message-ID: <5506E0FB.6090006@gmail.com>
Date: Mon, 16 Mar 2015 09:56:11 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, peer.loz@gmx.net
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount option
 at same time?
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46> <201503162246.12052.russell@coker.com.au>
In-Reply-To: <201503162246.12052.russell@coker.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-03-16 07:46, Russell Coker wrote:
> On Sun, 15 Mar 2015, peer.loz@gmx.net wrote:
>> Following common recommendations [1], I use these mount options on my
>> main developing machine: noatime,autodefrag. This is desktop machine and
>> it works well so far. Now, I'm also going to install several KVM virtual
>> machines on this system. I want to use qcow2 files stored on SSD with a
>> btrfs on it. In order to avoid bad performance with the VMs, I want to
>> disable the Copy-On-Write mechanism on the storage directory of my VM
>> images as for example described in [2].
>
> Why do you expect a great performance benefit from that?
>
> As there is no real seek time SSDs probably won't give you much benefit from
> defragmenting.  As for disabling CoW, that will reduce the number of writes
> (as you don't need to write the metadata all the way up the tree) and improve
> performance, but not as much as on spinning media where you need to do seeks
> for all that.
>
> Finally having checksums on everything to give the possibility of recognising
> corrupt data is a really good feature and something that you want on your VM
> images.
>
> So far I have never even tried disabling CoW or using auto defragment.  All of
> my BTRFS filesystems have either low performance or run on SSD.
>
Personally, I've found that autodefrag _does_ provide a small 
performance improvement on SSD's, because reading one larg extent takes 
less time than reading multiple small ones.  The caveat here is you want 
to make sure that at least the 'ssd' mount option is set as well, and 
run fstrim on a roughly weekly basis.

NOCOW however is a Bad Idea (TM) on most 'consumer grade' SSD's, as it 
reduces the effectiveness of many of the wear-leveling algorithms used 
on them.  On Enterprise quality SSD's (and recent Intel SSD's) though, 
it shouldn't be as much of an issue as they are much smarter, and the 
good ones even have built in ECC's to catch data corruption.
