Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44236 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbcFOIoR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 04:44:17 -0400
Subject: Re: [PATCH 1/6] fstests: btrfs: add functions to set and reset
 required number of SCRATCH_DEV_POOL
To: Eryu Guan <eguan@redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <20160612044059.GZ5140@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a5d80e3c-9e4c-0e98-0322-ed45d7398ef5@oracle.com>
Date: Wed, 15 Jun 2016 16:44:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160612044059.GZ5140@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for reviewing.

On 06/12/2016 12:40 PM, Eryu Guan wrote:
> On Tue, May 17, 2016 at 10:32:05PM +0800, Anand Jain wrote:
>> This patch provides functions
>>  _scratch_dev_pool_get()
>>  _scratch_dev_pool_put()
>>
>> Which will help to set/reset SCRATCH_DEV_POOL with the required
>> number of devices. SCRATCH_DEV_POOL_SAVED will hold all the devices.
>>
>> Usage:
>>   _scratch_dev_pool_get() <ndevs>
>>   :: do stuff
>>
>>   _scratch_dev_pool_put()
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> I'm not sure about the usefulness and the implementation of these
> helpers (include the _spare_dev_get|_put helpers), but they look good to
> me. It'd better to have btrfs developers review them as well.
>
>> ---
>>  common/rc | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 47 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 91e8f1c8e693..33632fd8e4a3 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -786,6 +786,53 @@ _scratch_mkfs()
>>      esac
>>  }
>>
>> +#
>> +# $1 Number of the scratch devs required
>> +#
>
> Some comments about its usage/purpose would be good, otherwise one has
> to search for the commit log and look into it to understand its purpose

added in v2.

>> +_scratch_dev_pool_get()
>> +{
>> +	if [ $# != 1 ]; then
>> +		_fail "Usage: _scratch_dev_pool_get ndevs"
>> +	fi
>> +
>> +	local test_ndevs=$1
>> +	local config_ndevs=`echo $SCRATCH_DEV_POOL| wc -w`
>> +	local devs[]="( $SCRATCH_DEV_POOL )"
>> +
>> +	typeset -p config_ndevs >/dev/null 2>&1
>> +	if [ $? != 0 ]; then
>> +		_fail "Bug: unset val, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
>
> This error message seems confusing, it's _scratch_dev_pool_get being
> called here, not _put.

ah, copy paste typo. fixed it in v2.

>> +	fi
>> +
>> +	# _require_scratch_dev_pool $test_ndevs
>> +	# must have already checked the min required devices
>> +	# but just in case, trap here for any potential bugs
>> +	# perpetuating any further
>> +	if [ $config_ndevs -lt $test_ndevs ]; then
>> +		_notrun "Need at least test requested number of ndevs $test_ndevs"
>
> This message is not clear to me either.

  ok, updated.

Thanks, Anand


> Thanks,
> Eryu
>
