Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758460Ab3BNSgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 13:36:06 -0500
Message-ID: <511D2E88.4010403@redhat.com>
Date: Thu, 14 Feb 2013 12:35:52 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Chris Murphy <lists@colorremedies.com>, Karel Zak <kzak@redhat.com>,
        xfs@oss.sgi.com, Zach Brown <zabrown@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1302140929570.2315@(none)> <20130214110423.GN26694@dastard> (sfid-20130214_122246_817720_6973E5AA) <201302141548.42185.Martin@lichtvoll.de>
In-Reply-To: <201302141548.42185.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/14/13 8:48 AM, Martin Steigerwald wrote:
> Am Donnerstag, 14. Februar 2013 schrieb Dave Chinner:
>>> So I
>>> think that it got to the point where users will usually use mkfs.xfs
>>> -f all the time. And even if they did not and they would use a wrong
>>> device they would probably get the same warning even for the device
>>> they wanted to use in the first place.
>>
>> I get a couple of queries a year from people saying they
>> accidentally ran mkfs.ext4 on the wrong device and want to know if
>> they can recover their XFS filesystem. The next question is usually
>> "why didn't mkfs.ext4 warn me there was an existing filesystem on
>> the device like mkfs.xfs does?".
>>
>> That is why the "don't overwrite an existing filesystem by default"
>> behaviour is important. Users like to be protected from mistakes
>> they weren't aware they made, and far too few of our filesystem
>> utilities provide that safety net.
>>
>> A couple of users a year losing data like this is a couple of users
>> too many. Especially when it would only take a couple of hours of
>> your time to implement....
>>
>>> So even thoug it might help in some cases I do not think that we
>>> should go and change all file systems to do that as well, it would
>>> not be very useful anyway.
>>
>> Tell that to the next user that trashes their data because a
>> filesystem tool simply assumed in correctly that it owned the block
>> device.
> 
> Full ACK.
> 
> I always loved that mkfs.xfs asks in that case.
> 
> IMO its just sane to do so.

I just sent a patch to do so for btrfs-progs, FWIW.  :)

-Eric


