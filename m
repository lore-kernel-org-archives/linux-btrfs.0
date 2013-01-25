Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27744 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3AYJOp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 04:14:45 -0500
Message-ID: <51024E7B.2070401@oracle.com>
Date: Fri, 25 Jan 2013 17:20:59 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 05/10] Btrfs-progs: add function btrfs_get_subvol to get
 root_info of a subvol
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-6-git-send-email-anand.jain@oracle.com> <5100BD56.7080907@redhat.com>
In-Reply-To: <5100BD56.7080907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/24/2013 12:49 PM, Eric Sandeen wrote:
> On 1/23/13 2:12 AM, Anand Jain wrote:
>> We need a function which can get the root_info of a given
>> subvol. This is in preparation to add support for the show
>> sub-cli.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   btrfs-list.c | 38 ++++++++++++++++++++++++++++++++++++++
>>   btrfs-list.h |  1 +
>>   2 files changed, 39 insertions(+)
>>
>> diff --git a/btrfs-list.c b/btrfs-list.c
>> index 1851f3e..ec64a36 100644
>> --- a/btrfs-list.c
>> +++ b/btrfs-list.c
>> @@ -1455,6 +1455,44 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
>>   	return 0;
>>   }
>>
>> +int btrfs_get_subvol(int fd, struct root_info *the_ri)
>> +{
>> +	int ret = -1;
>> +	struct root_lookup rl;
>> +	struct rb_node *rbn;
>> +	struct root_info *ri;
>> +	u64 root_id = btrfs_list_get_path_rootid(fd);
>> +
>> +	if (btrfs_list_subvols(fd, &rl))
>> +		return 13;
>
> Unless there is an ongoing plan to actually do something with these
> magical returns, can we maybe just be normal about error return values
> in new code?
>
> The caller you add only cares about 0 or not, right?  Or is there some other
> purpose for "13" I'm not aware of?
>
> Thanks,
> -Eric

  It was as in the original return value. But I think
  its time we fix this. now. accepted.

Thanks, Anand
