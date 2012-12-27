Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:48231
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab2L0TZI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 14:25:08 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Another novice question & comment
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DC7F85.4020807@petaramesh.org>
Date: Thu, 27 Dec 2012 12:25:09 -0700
Message-Id: <FFF59EFE-0915-4DDF-88AD-1C927F28A4E6@colorremedies.com>
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk> <50DC7BA0.2080401@petaramesh.org> <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com> <50DC7F85.4020807@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 10:04 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Le 27/12/2012 17:55, Chris Murphy a écrit :
>>> /dev/sda2 on /boot type btrfs (rw,relatime,subvol=UBUNTU/
>>> @boot,autodefrag)
>>> 
>>> 
>> That would only seem to work with btrfs on LVM which I'd think is uncommon and complicated.
>> 
>> 
> 
> Check the sda2 entry, this one is no LVM…


For whatever reason, our mount command behaviors differ. When I use mount, I do not get a subvol entry at all in parenthesis like you are. I can only see this information in /proc/self/mountinfo.


Chris Murphy