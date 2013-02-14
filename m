Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51120 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab3BNOsn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 09:48:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Date: Thu, 14 Feb 2013 15:48:41 +0100
Cc: Dave Chinner <david@fromorbit.com>,
        =?utf-8?q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>,
        Chris Murphy <lists@colorremedies.com>, Karel Zak <kzak@redhat.com>,
        xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1302140929570.2315@(none)> <20130214110423.GN26694@dastard> (sfid-20130214_122246_817720_6973E5AA)
In-Reply-To: <20130214110423.GN26694@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302141548.42185.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 14. Februar 2013 schrieb Dave Chinner:
> > So I
> > think that it got to the point where users will usually use mkfs.xfs
> > -f all the time. And even if they did not and they would use a wrong
> > device they would probably get the same warning even for the device
> > they wanted to use in the first place.
> 
> I get a couple of queries a year from people saying they
> accidentally ran mkfs.ext4 on the wrong device and want to know if
> they can recover their XFS filesystem. The next question is usually
> "why didn't mkfs.ext4 warn me there was an existing filesystem on
> the device like mkfs.xfs does?".
> 
> That is why the "don't overwrite an existing filesystem by default"
> behaviour is important. Users like to be protected from mistakes
> they weren't aware they made, and far too few of our filesystem
> utilities provide that safety net.
> 
> A couple of users a year losing data like this is a couple of users
> too many. Especially when it would only take a couple of hours of
> your time to implement....
> 
> > So even thoug it might help in some cases I do not think that we
> > should go and change all file systems to do that as well, it would
> > not be very useful anyway.
> 
> Tell that to the next user that trashes their data because a
> filesystem tool simply assumed in correctly that it owned the block
> device.

Full ACK.

I always loved that mkfs.xfs asks in that case.

IMO its just sane to do so.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
