Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43144 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbcDAX7S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 19:59:18 -0400
Subject: Re: [PATCH 12/12] btrfs: check device for critical errors and mark
 failed
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261349-32206-13-git-send-email-anand.jain@oracle.com>
 <20160330004907.GA8929@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FF0B51.3070006@oracle.com>
Date: Sat, 2 Apr 2016 07:59:13 +0800
MIME-Version: 1.0
In-Reply-To: <20160330004907.GA8929@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/30/2016 08:49 AM, Yauhen Kharuzhy wrote:
> On Tue, Mar 29, 2016 at 10:22:29PM +0800, Anand Jain wrote:
>> Write and Flush errors are considered as critical errors,
>> upon which the device will be brought offline and marked as
>> failed. Write and Flush errors are identified using device
>> error statistics.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> btrfs: check for failed device and hot replace
>>
>> This patch creates casualty_kthread to check for the failed
>> devices, and triggers device replace.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ctree.h   |   2 +
>>   fs/btrfs/disk-io.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/disk-io.h |   2 +
>>   fs/btrfs/volumes.c |   1 +
>>   fs/btrfs/volumes.h |   4 ++
>>   5 files changed, 169 insertions(+), 1 deletion(-)
>
> btrfs_check_and_handle_casualty() tries to perfom auto-replacement
> only once after each failure. If no hotspare was added in system before failure, only one
> remaining way to replace drive is to perform replace manually. This sounds
> reasonable, so just clarification: are you sure that we shouldn't start
> autoreplacement if hotspare will be added after drive failure?
>
> V1 of the patchset tried to perform autoreplace endlessly until replace
> drive is added.

Yeah. I did that change purposely, but in V3 I have reverted, so
that code is more flexible and has better design control/change.

Thanks, Anand


