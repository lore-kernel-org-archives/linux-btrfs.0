Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40081 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916Ab3BNLE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 06:04:28 -0500
Date: Thu, 14 Feb 2013 22:04:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>, Karel Zak <kzak@redhat.com>,
        xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130214110423.GN26694@dastard>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
 <20130212202753.GC26694@dastard>
 <20130213080154.GC18597@x2.net.home>
 <alpine.LFD.2.00.1302131127070.2315@(none)>
 <20130213121655.GA7799@x2.net.home>
 <20130213221720.GH26694@dastard>
 <982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
 <alpine.LFD.2.00.1302140929570.2315@(none)>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <alpine.LFD.2.00.1302140929570.2315@(none)>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 14, 2013 at 09:36:38AM +0100, Lukáš Czerner wrote:
> On Thu, 14 Feb 2013, Chris Murphy wrote:
> 
> > Date: Thu, 14 Feb 2013 00:29:59 -0700
> > From: Chris Murphy <lists@colorremedies.com>
> > To: Dave Chinner <david@fromorbit.com>
> > Cc: Karel Zak <kzak@redhat.com>, Lukáš Czerner <lczerner@redhat.com>,
> >     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
> >     linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> > 
> > 
> > On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > it is the responsibility of filesystem
> > > tools to behave sanely, not for the rest of the world to have to
> > > work around the dangerous behaviour of a specific filesystems'
> > > toolset.
> > 
> > I appreciate this, and in particular that mkfs.xfs doesn't nerf a file system without the use of -f; even an existing XFS file system. Considering most data loss is user induced, I'd appreciate it if other file systems's tools weren't so easily made belligerent by (hopefully temporarily) confused apes wearing pants.
> > 
> > Chris Murphy
> 
> I would not be so optimistic about it. The reason being that there
> are almost _always_ old file system signatures on the device.

That assumption is way off the mark.  What you do as a filesystem
developer (remake filesystems on the same block device hundreds of
times a day) is not at all typical, so you cannot extrapolate from
your usage habits to what typically happens in production
environments.

Admins don't tend to use "force" options by default (especially for
destructive comands like mkfs) as 1) they are rarely necessary in the
real world and 2) the consequences of errors are severe.  The most
common filesystem creation pattern in production systems (be it
desktop, workstation or server) is that storage, devices and
filesystems are set up once and then used for the entire lifetime
ofthe system without ever having mkfs run on them again. i.e on
pristine, empty hardware. Hence users rarely, if ever, need to use
the force option for mkfs.xfs.

> So I
> think that it got to the point where users will usually use mkfs.xfs
> -f all the time. And even if they did not and they would use a wrong
> device they would probably get the same warning even for the device
> they wanted to use in the first place.

I get a couple of queries a year from people saying they
accidentally ran mkfs.ext4 on the wrong device and want to know if
they can recover their XFS filesystem. The next question is usually
"why didn't mkfs.ext4 warn me there was an existing filesystem on
the device like mkfs.xfs does?".

That is why the "don't overwrite an existing filesystem by default"
behaviour is important. Users like to be protected from mistakes
they weren't aware they made, and far too few of our filesystem
utilities provide that safety net.

A couple of users a year losing data like this is a couple of users
too many. Especially when it would only take a couple of hours of
your time to implement....

> So even thoug it might help in some cases I do not think that we
> should go and change all file systems to do that as well, it would
> not be very useful anyway.

Tell that to the next user that trashes their data because a
filesystem tool simply assumed in correctly that it owned the block
device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
