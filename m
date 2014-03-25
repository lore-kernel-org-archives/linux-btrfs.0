Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:36812 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251AbaCYIFP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 04:05:15 -0400
Message-ID: <533138A4.2010808@swiftspirit.co.za>
Date: Tue, 25 Mar 2014 10:04:52 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Martin <m_btrfs@ml1.co.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and raid5 status with kernel 3.14, documentation, and howto
References: <20140323225657.GA17039@merlins.org> <lgq0b9$e5r$1@ger.gmane.org> <20140324215239.GC11533@merlins.org> <lgql40$lm5$1@ger.gmane.org> <20140325012916.GF11533@merlins.org>
In-Reply-To: <20140325012916.GF11533@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/03/14 03:29, Marc MERLIN wrote:
> On Tue, Mar 25, 2014 at 01:11:43AM +0000, Martin wrote:
>> There's a big thread a short while ago about using parity across
>> n-devices where the parity is spread such that you can have 1, 2, and up
>> to 6 redundant devices. Well beyond just raid5 and raid6:
>>
>> http://lwn.net/Articles/579034/
>   
> Aah, ok. I didn't understand you meant that. I know nothing about that, but
> to be honest, raid6 feels like it's enough for me :)

There are a few of us who are very much looking forward to these 
special/flexible RAID types - for example RAID15 (very good performance, 
very high redundancy, less than 50% diskspace efficiency). The csp 
notation will probably make it easier to develop the flexible raid types 
and is very much required in order to better manage these more flexible 
raid types.

A typical RAID15 with 12 disks would in csp notation is written as:
2c5s1p

And some would like to be able to use the exact same redundancy scheme 
even with extra disks:
2c5s1p on 16 disks (note, the example is not 2c7s1p, though that would 
also be a valid scheme with 16 disks being the minimum number of disks 
required)

The last thread on this (I think) can be viewed here, 
http://www.spinics.net/lists/linux-btrfs/msg23137.html where Hugo also 
explains and lists the notation for the existing schemes.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

