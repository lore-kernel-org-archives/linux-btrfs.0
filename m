Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50482 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2HAL3E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 07:29:04 -0400
Received: by gglu4 with SMTP id u4so7145809ggl.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 04:29:03 -0700 (PDT)
Message-ID: <501912FA.2010200@gmail.com>
Date: Wed, 01 Aug 2012 19:28:58 +0800
From: Liu Bo <liub.liubo@gmail.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs-progs: list snapshots by generation
References: <1343713776-14232-1-git-send-email-liubo2009@cn.fujitsu.com> <1343713776-14232-3-git-send-email-liubo2009@cn.fujitsu.com> <50184B40.8010508@libero.it>
In-Reply-To: <50184B40.8010508@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2012 05:16 AM, Goffredo Baroncelli wrote:
> Hi Bo,
> 
> On 07/31/2012 07:49 AM, Liu Bo wrote:
>> The idea is that we usually use snapshot to backup/restore our data, and the
>> common way can be a cron script which makes lots of snapshots, so we can end
>> up with spending some time to find the latest snapshot to restore.
>>
>> This adds a feature for 'btrfs subvolume list' to let it list snapshots by their
>> _created_ generation.
>>
>> What we need to do is just to list them in descending order and get the latest
>> snapshot.  What's more, we can find the oldest snapshot as well by listing
>> snapshots in ascending order.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  btrfs-list.c     |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  cmds-subvolume.c |   19 +++++-
>>  2 files changed, 185 insertions(+), 10 deletions(-)
>>
> [....]
>>  
>>  static const char * const cmd_subvol_list_usage[] = {
>> -	"btrfs subvolume list [-p] <path>",
>> +	"btrfs subvolume list [-ps] <path>",
>>  	"List subvolumes (and snapshots)",
>>  	"",
>> -	"-p     print parent ID",
>> +	"-p           print parent ID",
>> +	"-s value     list snapshots with generation in ascending/descending order",
>> +	"             (1: ascending, 0: descending)",
> 
> Please change the user interface. I suggest something like:
> 
> -s|-S		list snapshots with generation in ascending|descending
> 		order	
> 
> Or better
> 
> -s		sort by generation
> -P		sort by path
> -r		reverse the sort order
> 

I prefer to the first one, since I have no any idea how to sort by path
by then.

> 
> Anyway, whichever your choice will be, please remember to update the man
> page too.
> 

ah, I should have remembered to update it, thanks for reminding. :)

Will do it soon, thanks for reviewing this!

thanks,
liubo

>>  	NULL
>>  };
> 
> [...]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

