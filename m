Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [50.115.112.57] ([50.115.112.57]:27832 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753220Ab3HPSDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 14:03:16 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50869 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VAOMB-002oHx-VO
	for linux-btrfs@vger.kernel.org; Fri, 16 Aug 2013 12:02:40 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: How btrfs resize should work ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130816163039.GK12314@lenny.home.zabbo.net>
Date: Fri, 16 Aug 2013 12:02:35 -0600
Message-Id: <F668151D-F261-4093-9E6F-A7F7A3F10EF4@colorremedies.com>
References: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain> <20130816163039.GK12314@lenny.home.zabbo.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 16, 2013, at 10:30 AM, Zach Brown <zab@redhat.com> wrote:

>> So it appears that it only resized part of the file system which
>> lies on /dev/sda to 3G. This behavior is confusing as hell, is this
>> really desirable behaviour ?
> 
> Yeah, 'btrfs filesystem resize' is misnamed.  It only resizes a
> specified device which defaults to devid 1 if you don't specify one.

I think there shouldn't be a default devid. If it's not specified, it should fail.

On Aug 16, 2013, at 2:19 AM, Lukáš Czerner <lczerner@redhat.com> wrote:

> I do understand that you're able to specify devid to resize, however
> without devid specification this kind of does not make any sense. dm
> get it right, and it also has several different policies on handling
> this stuff and it was not easy to get this right. Is btrfs going to
> fix this somehow, it does it expect user to take care of this (I
> hope not). Because currently ssm is not able to resize btrfs
> correctly.

The Btrfs volume is like a combined VG/LV. So it seems to me it lacks the granularity to do what can be done with LVM. When I shrink resize an LV, its freed extents return to the VG without affecting the PV's or their partitioning.

When a Btrfs multiple device volume is shrunk resized, it directly affects the partition size which must also be changed as a separate operation right now. I don't see Btrfs having the same granularity as LVM in this respect.


Chris Murphy