Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37504 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbcEAU54 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 16:57:56 -0400
Subject: Re: [PATCH 2/3] btrfs: keep sysfs target add in the last
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
 <1458816494-483-2-git-send-email-anand.jain@oracle.com>
 <20160425162358.GD29353@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57266DCF.3050205@oracle.com>
Date: Mon, 2 May 2016 04:57:51 +0800
MIME-Version: 1.0
In-Reply-To: <20160425162358.GD29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/26/2016 12:23 AM, David Sterba wrote:
> On Thu, Mar 24, 2016 at 06:48:13PM +0800, Anand Jain wrote:
>> Sysfs create context should come in the last, so that we
>> don't have to undo sysfs operation for the reason that any
>> other operation has failed.
>
> Moving the sysfs call will make a visible change: in the old code, the
> sysfs node exists during the whole replace process, while in the new
> code it appears only after it finishes.

> While this is not necessarily a
> problem, I'd like to check that his is an intended change, as it's not
> mentioned in the changelog.

  Ah. I missed this point.

> Besides, the sysfs node seems to be added unconditionally, so if the
> scrub is running in parallel (checked a few lines above the new code),
> we'll happily add the target device although no replace happened.

Replace may take a long time, We definitely need devid 0 shown at
sysfs. Apparently we don't have the undo-sysfs part in the original
code, which this patch tried to mitigate, but it needs a deeper fix.
I have to pull this patch out and leave the original bug as is for now.

Further we need to handle fail return of btrfs_dev_replace_finishing()
which seeks sysfs and rest of the stuff un-done as well.

Thanks, Anand
