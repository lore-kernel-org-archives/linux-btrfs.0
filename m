Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3GQClx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 22:41:53 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6H2fqYf014174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 02:41:52 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6H2fpdJ023823
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 02:41:51 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6H2fpi6014745
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 02:41:51 GMT
Message-ID: <51E605A1.5050407@oracle.com>
Date: Wed, 17 Jul 2013 10:46:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: fix the long lines
References: <1373866527-10604-1-git-send-email-anand.jain@oracle.com> <1373866527-10604-2-git-send-email-anand.jain@oracle.com> <51E401E7.8040202@redhat.com>
In-Reply-To: <51E401E7.8040202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Strings being grep-able is important. Thanks Stefan and Eric
  for the comments.

  Hopefully we shall have some better ways to handle long strings.

  OR

  shorter error message and still communicate the
  intended message is another choice but challenging. :-)

  I have dropped this patch for now.

Thanks Anand


On 07/15/2013 10:06 PM, Eric Sandeen wrote:
> On 7/15/13 12:35 AM, Anand Jain wrote:
>> trivial: cmds-replace.c contains long lines fix it
>
> I realize that this is total bikeshedding, so you can take or leave it, but:
>
> One downside to this is that it makes it a little harder to grep for strings
> when they get arbitrarily split across lines.
>
> One thing XFS userspace did was to out-dent in cases like this, i.e.:
>
>> --- a/cmds-replace.c
>> +++ b/cmds-replace.c
>> @@ -211,8 +211,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   		struct btrfs_ioctl_dev_info_args *di_args = NULL;
>>
>>   		if (atoi(srcdev) == 0) {
>> -			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
>> -				srcdev);
>> +			fprintf(stderr,
>> +	"Error: Failed to parse the numerical devid value '%s'\n",
>> +				srcdev);
>>   			goto leave_with_error;
>>   		}
>>   		start_args.start.srcdevid = (__u64)atoi(srcdev);
>
> so that the strings remain more easily searchable.  Just a thought; maybe folks hate that idea but I thought I'd throw it out there.
>
> But as a more topical review:
>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-replace.c |   17 ++++++++++-------
>>   1 files changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/cmds-replace.c b/cmds-replace.c
>> index 6397bb5..c68986a 100644
>> --- a/cmds-replace.c
>> +++ b/cmds-replace.c
>> @@ -211,8 +211,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   		struct btrfs_ioctl_dev_info_args *di_args = NULL;
>>
>>   		if (atoi(srcdev) == 0) {
>> -			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
>> -				srcdev);
>> +			fprintf(stderr, "Error: Failed to parse the numerical "\
>                                                                                 ^
> There's no need for the line continuation, this isn't a macro.  ;)
>
> To split the line this way just do:
>
>> +			fprintf(stderr, "Error: Failed to parse the numerical "
>> +				"devid value '%s'\n", srcdev);
>
> -Eric
>
>>   			goto leave_with_error;
>>   		}
>>   		start_args.start.srcdevid = (__u64)atoi(srcdev);
>> @@ -235,8 +235,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   				break;
>>   		free(di_args);
>>   		if (i == fi_args.num_devices) {
>> -			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
>> -				srcdev, path);
>> +			fprintf(stderr, "Error: '%s' is not a valid devid for "\
>> +				"filesystem '%s'\n", srcdev, path);
>>   			goto leave_with_error;
>>   		}
>>   	} else {
>> @@ -283,7 +283,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
>>   	if (ret >= 0 && !force_using_targetdev) {
>>   		fprintf(stderr,
>> -			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
>> +			"Error, target device %s contains filesystem, "\
>> +			"use '-f' to force overwriting.\n",
>>   			dstdev);
>>   		goto leave_with_error;
>>   	}
>> @@ -321,7 +322,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   	if (do_not_background) {
>>   		if (ret) {
>>   			fprintf(stderr,
>> -				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
>> +				"ERROR: ioctl(DEV_REPLACE_START) failed "\
>> +				"on \"%s\": %s, %s\n",
>>   				path, strerror(errno),
>>   				replace_dev_result2string(start_args.result));
>>   			goto leave_with_error;
>> @@ -330,7 +332,8 @@ static int cmd_start_replace(int argc, char **argv)
>>   		if (start_args.result !=
>>   		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
>>   			fprintf(stderr,
>> -				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" returns error: %s\n",
>> +				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" "\
>> +				"returns error: %s\n",
>>   				path,
>>   				replace_dev_result2string(start_args.result));
>>   			goto leave_with_error;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
