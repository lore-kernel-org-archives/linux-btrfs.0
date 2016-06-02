Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:44415 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbcFBKDp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 06:03:45 -0400
Subject: Re: raid5/6 production use status?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <20160602093525.GC24492@carfax.org.uk>
From: Gerald Hopf <gerald.hopf@nv-systems.net>
Message-ID: <7e498fbd-2c8b-9fb9-2baf-f4091bb379db@nv-systems.net>
Date: Thu, 2 Jun 2016 12:03:44 +0200
MIME-Version: 1.0
In-Reply-To: <20160602093525.GC24492@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> Hey.
>>>
>>> I've lost a bit track recently and the wiki changelog doesn't seem to
>>> contain much about how things went on at the RAID5/6 front... so how're
>>> things going?
>>>
>>> Is it already more or less "productively" usable? What's still missing?
>> Well, you still can't even check for free space.
>     You can, but not with that tool.
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools
>
>     Hugo.
That tool however according to the wiki is the "new tool" which you are 
supposed to use! The other options are not that good...

btrfs fi usage
==> 3x WARNING: RAID56 detected, not implemented
btrfs fi df
==> only shows what part of "allocated" space is in use, not useful 
information if you want to know if you have free space
btrfs fi show
==> does not show total free space. I guess you can use the information 
in btrfs fi show and then subtract used from total and then multiply 
that? But by what? n disks? Or by n-1 disks because of parity?
==> multiplying it by all disks (including parity) seems to arrive at a 
similar free space as df -h shows me. But is it correct? Or should it be 
4/5 of this because I have one parity disk and 4 data disks?

I do however stand corrected: You actually can (barely) check for free 
space. And you can get a number that might or might not be the free space.

