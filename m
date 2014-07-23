Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaGWEQg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 00:16:36 -0400
Message-ID: <53CF370E.1090707@redhat.com>
Date: Tue, 22 Jul 2014 23:16:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com, Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded,
 btrfs replace failure, then oops
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com> <53CF235D.1040703@redhat.com> <FE022C52-674C-491B-AAC1-2A5B4576D8B3@colorremedies.com> <20140723033649.GB4955@localhost.localdomain>
In-Reply-To: <20140723033649.GB4955@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/22/14, 10:36 PM, Liu Bo wrote:
> On Tue, Jul 22, 2014 at 09:28:52PM -0600, Chris Murphy wrote:
>>
>> On Jul 22, 2014, at 8:52 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>
>>> This one (your bug #4) was likely caused by:
>>>
>>> commit 99994cde9c59c2b8bb67d46d531b26cc73e39747
>>> Author: Anand Jain <Anand.Jain@oracle.com>
>>> Date:   Tue Jun 3 11:36:00 2014 +0800
>>>
>>>    btrfs: dev delete should remove sysfs entry
>>>
>>> and hopefully fixed by:
>>>
>>> commit 0bfaa9c5cb479cebc24979b384374fe47500b4c9
>>> Author: Eric Sandeen <sandeen@redhat.com>
>>> Date:   Mon Jul 7 12:34:49 2014 -0500
>>>
>>>    btrfs: test for valid bdev before kobj removal in btrfs_rm_device
>>
>> OK good. Hopefully the first one is reverted or the second one is accepted before 3.16 is released, replace appears to be broken at the moment.
>>
> 
> Looks that they are not the same one, since you didn't use a btrfs_rm_device,

Oh, you're right - I'm sorry, I didn't look closely enough.

-Eric

