Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:56585
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab3ACV1Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 16:27:24 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130103212342.GE19051@carfax.org.uk>
Date: Thu, 3 Jan 2013 14:27:21 -0700
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
Message-Id: <125D7A41-DBE8-40C0-B8EE-B64DD2D95A93@colorremedies.com>
References: <1CC7957D-2FAD-4E8D-9850-6A06458FF1ED@colorremedies.com> <CO8jEAMeCXB@helmut.hullen.de> <20130103212342.GE19051@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2013, at 2:23 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Jan 03, 2013 at 09:28:00PM +0100, Helmut Hullen wrote:
>> 
>> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
>> 
>>        btrfs fi label /dev/sdb mylabel
>> 
>> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc" and  
>> "/dev/sdd" remain without label.
> 
>   This is a bug.

It's a bug that appears to be fixed. I inadvertently tested it first on CentOS 6.0 which has quite an older kernel and btrfsprogs. And Fedora 18 of course has a much newer kernel and btrfs-progs so I have no idea when in between those two this was fixed.

Helmut what kernel and btrfs-progs or distribution are you using? I think newer progs fixes this.

>> 
>> But before the first mounting of the system only "/dev/sdb" showed the  
>> label. Maybe with the first mounting the label spreads over all disks.
> 
>   Probably.

Not in my case with F18. I never mounted it once and immediately all commands saw the file system label change.

     

Chris Murphy

