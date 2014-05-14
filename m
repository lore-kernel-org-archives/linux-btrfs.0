Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51410 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbaENNfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 09:35:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WkZKh-0007nI-UZ
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 15:34:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 15:34:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 15:34:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
Date: Wed, 14 May 2014 13:34:40 +0000 (UTC)
Message-ID: <pan$613d3$f7783f17$e8368cec$6bbea6af@cox.net>
References: <5372C457.3000706@redhat.com> <53731BE3.5010604@cn.fujitsu.com>
	<537360B2.50107@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Wed, 14 May 2014 14:25:22 +0200 as excerpted:

> On 14/05/14 09:31, Wang Shilong wrote:
>> On 05/14/2014 09:18 AM, Eric Sandeen wrote:
>>> Allow the specification of the filesystem UUID at mkfs time.
>>>
>>> (Implemented only for mkfs.btrfs, not btrfs-convert).
>> Just out of curiosity, this option is used for what kind of use case?
>> I notice Ext4 also has this option.:-)

> Personally I can't think of any "average" or "normal" use case. The
> simplest case however is in using predictable/predetermined UUIDs.

AFAIK the most common use-case would be when redoing filesystems already 
listed in fstab with UUID= mounting.

I use and prefer LABEL= instead of UUID= mounting here, but I commonly 
keep a working and at least one identically sized partition backup 
filesystem copy of all non-throw-away filesystems, with fstab entries for 
both the working and backup versions, and periodically do a mkfs and 
recopy of the backup, with occasional boots to the backup and mkfs and 
recopy of the working version as well.  As I use LABEL= fstab entries I 
ensure that I specify the same label at mkfs time so I don't have to redo 
the fstab, and people that use UUID= fstab entries would find the ability 
to specify UUID at mkfs time as useful as I do the ability to specify 
label. =:^)

Many grub2 configurations also uses UUID so the same idea applies there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

