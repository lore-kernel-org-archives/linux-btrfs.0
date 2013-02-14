Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:63942 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752176Ab3BNHaG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 02:30:06 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130213221720.GH26694@dastard>
Date: Thu, 14 Feb 2013 00:29:59 -0700
Cc: Karel Zak <kzak@redhat.com>,
        =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
        xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
        linux-btrfs@vger.kernel.org
Message-Id: <982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com> <20130212202753.GC26694@dastard> <20130213080154.GC18597@x2.net.home> <alpine.LFD.2.00.1302131127070.2315@(none)> <20130213121655.GA7799@x2.net.home> <20130213221720.GH26694@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> it is the responsibility of filesystem
> tools to behave sanely, not for the rest of the world to have to
> work around the dangerous behaviour of a specific filesystems'
> toolset.

I appreciate this, and in particular that mkfs.xfs doesn't nerf a file system without the use of -f; even an existing XFS file system. Considering most data loss is user induced, I'd appreciate it if other file systems's tools weren't so easily made belligerent by (hopefully temporarily) confused apes wearing pants.

Chris Murphy