Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51712 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966745Ab3HIK5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 06:57:34 -0400
Message-ID: <5204CB14.3020207@oracle.com>
Date: Fri, 09 Aug 2013 18:57:24 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: introduce btrfs filesystem show --kernel
In-Reply-To: <20130808180816.GW12314@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375949227-23729-1-git-send-email-anand.jain@oracle.com>
 <1375949227-23729-3-git-send-email-anand.jain@oracle.com>
 <20130808180816.GW12314@lenny.home.zabbo.net>




On 09/08/2013 02:08, Zach Brown wrote:
> On Thu, Aug 08, 2013 at 04:07:07PM +0800, Anand Jain wrote:
>> As of now btrfs filesystem show reads directly from
>> disks. So sometimes output can be stale, mainly when
>> user want to verify their last operation like,
>> labeling or device delete or add... etc.
>>
>> This patch adds --kernel option to the 'filesystem show'
>> subcli, which will read from the kernel instead of
>> the disks directly.
>
> Why should this be an option?
>
> When mounted, the kernel cache is authoritative.  It was always a bug to
> read stale data from disk.
>
> The kernel should be read first, and if that isn't available it can fall
> back to offering unreliable data from disk with a giant wraning.
>
> Right?

  Yes !
  For the no option - what I like is more an intelligent way
  of listing all btrfs - mounted and unmounted by appropriately
  reading from the kernel and disks respectively.

  However to do this, we need a better disk list with in btrfs-progs
  which isn't there yet. I am getting those related components ready
  to be there someday.

  So at the moment an interim solution for the bug, which will
  also help the long term design.

Thanks, Anand
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
