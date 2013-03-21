Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:59921
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab3CUPJZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:09:25 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: How to recover uncorrectable errors ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <68196576.8us4kWVCD5@athlonxp>
Date: Thu, 21 Mar 2013 09:09:25 -0600
Message-Id: <85A90DE5-4801-41E5-8AC4-14FB16A86ED5@colorremedies.com>
References: <6033676.gK0GbPgrpE@athlonxp> <4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com> <20130321012414.3b232660@natsu> <68196576.8us4kWVCD5@athlonxp>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 21, 2013, at 2:57 AM, Frédéric COIFFIER <frederic.coiffier@free.fr> wrote:

> Hi Roman,
> 
> Le jeudi 21 mars 2013 01:24:14 Roman Mamedov a écrit :
>> On Wed, 20 Mar 2013 12:19:18 -0600
>> Chris Murphy <lists@colorremedies.com> wrote:
>> 
>>>> 195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Always       -       63508940
>> 
>>> With such high ECC recovered events, I suspect SDC. 
>> 
>> If it's a Seagate drive, this is absolutely normal.
>> All Seagate drives have a high value in SMART Hardware_ECC_Recovered.
> 
> You're right : it's a Seagate :

Your first post, btrfs scrub, contains checksum errors in metadata. It reports two logical values, at four sector values. So that tells me this is metadata profile raid1. And because this isn't a fixable error, it sounds like the mirrored metadata agree with each other, but the data itself has changed. I don't think that's due to a reset or powerloss during a write.

The source of the problem sounds to me like SDC. Some parts of the drive have bad sectors and the drive is returning the wrong data, and the FS knows this.

previously:
> Yes, I absolutely agree that we can't recover some files but btrfsck sould propose to recover these error (like fsck.ext4) even if we loose some data.
> In fact, I never got this kind of problem with ext filesystems.


It's not a fair comparison. ext is stable. btrfs is not. ext's fsck repairs by default, btrfs's does not. There are no suggestions users ask devs on a list before running fsck repair on ext, but that is the case for btrfs. So far no dev has suggested using the --repair flag. I don't know whether this would help get the file system to allow the deletion of corrupt files.

There have been many changes since kernel 3.7.4 so I suspect a dev would want you to try something newer, and also much newer progs as well.

In any case, I would still use enhanced security erase on the drive, and then do a smartctl -t long (extended offline) test, and then ensure it completes after the estimated time with smartctl -a or -x.


Chris Murphy