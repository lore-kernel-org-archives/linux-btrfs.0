Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B80C7112C
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0628720824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mw8iUmU1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0628720824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbeJXM6I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:58:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeJXM6I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:58:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9O4T2H2152375;
        Wed, 24 Oct 2018 04:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=UyupbjrXHc+aZU1CYeQg5UuWH9CxFCbTttEdEU0avkk=;
 b=mw8iUmU1sZoSzgvQ7jQg5NJ3YYRcTs+GLWASRmk1EUVK5dxjvREhUCEFVue3vXtWqxTK
 cuLvA/3pW000fD12bf+aYAc3CTWFz1OsOtQ2xtu6f8PbIYvlmmidWNLzuI+pUZkwCxpr
 FGxvC0hL5/Mq092A9UCEaZUTRGdmYpJe6XNfFw5uXC/4S7DwnFPqmWAjZprDXTpyYhNc
 Xyq8vC9eqLnNdUjZSrwXPa3d37bXK+OvBMlSbvKbAHbgroDGkulsHZMAB85+Hp+3cgTU
 s2ZmKxjBjnsLVh7aO2D/jlR9hocVCJg0ceHqv+r9PJncuCrqfoRaUagC6HNmz0W01Y2x Yg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2n7w0qs0cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 04:31:42 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4Vbuh029175
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 04:31:37 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4Vaqa006798;
        Wed, 24 Oct 2018 04:31:36 GMT
Received: from [10.190.205.83] (/192.188.170.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Oct 2018 21:31:36 -0700
Subject: Re: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
 <1539317191-9265-3-git-send-email-anand.jain@oracle.com>
 <6e1d87e3-5e2d-bff2-0421-3b3e67588d5b@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <b681e1d2-8f51-dc0a-82f5-aea2177920a6@oracle.com>
Date:   Wed, 24 Oct 2018 12:31:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6e1d87e3-5e2d-bff2-0421-3b3e67588d5b@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9055 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810240039
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/12/2018 05:03 PM, Nikolay Borisov wrote:
> 
> 
> On 12.10.2018 07:06, Anand Jain wrote:
>> This patch adds cli
>>    btrfs device forget [dev]
>> to remove the given device structure in the kernel if the device
>> is unmounted. If no argument is given it shall remove all stale
>> (device which are not mounted) from the kernel.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-device.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
>>   ioctl.h       |  2 ++
>>   2 files changed, 56 insertions(+), 9 deletions(-)
>>
>> diff --git a/cmds-device.c b/cmds-device.c
>> index 2a05f70a76a9..ecc391ea01d8 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -254,10 +254,32 @@ static int cmd_device_delete(int argc, char **argv)
>>   	return _cmd_device_remove(argc, argv, cmd_device_delete_usage);
>>   }
>>   
>> +static int btrfs_forget_devices(char *path)
>> +{
>> +	struct btrfs_ioctl_vol_args args;
>> +	int ret;
>> +	int fd;
>> +
>> +	fd = open("/dev/btrfs-control", O_RDWR);
>> +	if (fd < 0)
>> +		return -errno;
>> +
>> +	memset(&args, 0, sizeof(args));
>> +	if (path)
>> +		strncpy_null(args.name, path);
>> +	ret = ioctl(fd, BTRFS_IOC_FORGET_DEV, &args);
>> +	if (ret)
>> +		ret = -errno;
>> +	close(fd);
>> +	return ret;
>> +}
>> +
>>   static const char * const cmd_device_scan_usage[] = {
>> -	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
>> -	"Scan devices for a btrfs filesystem",
>> +	"btrfs device scan [(-d|--all-devices)|-u|--forget|<device> "\
>> +							"[<device>...]]",
>> +	"Scan or forget (deregister) devices for a btrfs filesystem",
>>   	" -d|--all-devices (deprecated)",
>> +	" -u|--forget [<device> ..]",
>>   	NULL
>>   };
>>   
>> @@ -267,32 +289,40 @@ static int cmd_device_scan(int argc, char **argv)
>>   	int devstart;
>>   	int all = 0;
>>   	int ret = 0;
>> +	int forget = 0;
>>   
>>   	optind = 0;
>>   	while (1) {
>>   		int c;
>>   		static const struct option long_options[] = {
>>   			{ "all-devices", no_argument, NULL, 'd'},
>> +			{ "forget", no_argument, NULL, 'u'},
>>   			{ NULL, 0, NULL, 0}
>>   		};
>>   
>> -		c = getopt_long(argc, argv, "d", long_options, NULL);
>> +		c = getopt_long(argc, argv, "du", long_options, NULL);
>>   		if (c < 0)
>>   			break;
>>   		switch (c) {
>>   		case 'd':
>>   			all = 1;
>>   			break;
>> +		case 'u':
>> +			forget = 1;
>> +			break;
>>   		default:
>>   			usage(cmd_device_scan_usage);
>>   		}
>>   	}
>>   	devstart = optind;
>>   
>> +	if (all && forget)
>> +		usage(cmd_device_scan_usage);
>> +
>>   	if (all && check_argc_max(argc - optind, 1))
>>   		usage(cmd_device_scan_usage);
>>   
>> -	if (all || argc - optind == 0) {
>> +	if (!forget && (all || argc - optind == 0)) {
>>   		printf("Scanning for Btrfs filesystems\n");
>>   		ret = btrfs_scan_devices();
>>   		error_on(ret, "error %d while scanning", ret);
>> @@ -301,6 +331,13 @@ static int cmd_device_scan(int argc, char **argv)
>>   		goto out;
>>   	}
>>   
>> +	if (forget && (all || argc - optind == 0)) {
> 
> You cannot ever have (forget && all) since you specifically call usage()
> above, just remove the 'all'. Furthermore, I think the code will be more
> legible if it's part of an else if rather than a plain if construct. > In fact the whole function will be more readable. I.e you will have the
> error conditions at the to, followed by "all device scan" case, followed
> by "all device forget" and in the final else branch you will have the
> specific device handling. 

  Originally the -d | --all option is bit broken.
  The -d | --all expects either no arguments OR only one device as an 
argument.

         if (all && check_argc_max(argc - optind, 1))
                 usage(cmd_device_scan_usage);

  Now because of

     if (all || argc - optind == 0) {

    The cli 'btrfs device scan --all /dev/sdb' which should have scanned
     only one device, ends up scanning all the devices and I am not
     trying to fix this bug in this patch because..
   . -d|--all is marked as deprecated, I hope -d option would go away
   . For now some script might be using this bug as a feature, and fixing
     this bug might lead to mount failure.

  However still there is some opportunity to make the my patch more 
readable, thanks for the comments pls see v10 if it is much better?

> The increased indentation level won't be a
> problem since the longest lines are string prints and we are not
> wrapping those.
> 
> 
>> +		ret = btrfs_forget_devices(NULL);
>> +		if (ret)
>> +			error("Can't forget: %s", strerror(-ret));
>> +		goto out;
>> +	}
>> +
>>   	for( i = devstart ; i < argc ; i++ ){
>>   		char *path;
>>   
>> @@ -315,11 +352,19 @@ static int cmd_device_scan(int argc, char **argv)
>>   			ret = 1;
>>   			goto out;
>>   		}
>> -		printf("Scanning for Btrfs filesystems in '%s'\n", path);
>> -		if (btrfs_register_one_device(path) != 0) {
>> -			ret = 1;
>> -			free(path);
>> -			goto out;
>> +		if (forget) {
>> +			ret = btrfs_forget_devices(path);
>> +			if (ret)
>> +				error("Can't forget '%s': %s",
>> +							path, strerror(-ret));
> 
> For consistency sake I think this error printout should be moved inside
> btrfs_forget_devices() similarly to what btrfs_register_one_device does
> on error.

  Where possible we are trying to move the printing to the parent
  functions, so that these helper functions can be used as a/part
  of the library function. As here we can successfully return the unique
  errno for the two possible errors, I would like to keep it as
  it is as of now.

Thanks, Anand

>> +		} else {
>> +			printf("Scanning for Btrfs filesystems in '%s'\n",
>> +									path);
>> +			if (btrfs_register_one_device(path) != 0) {
>> +				ret = 1;
>> +				free(path);
>> +				goto out;
>> +			}
>>   		}
>>   		free(path);
>>   	}
>> diff --git a/ioctl.h b/ioctl.h
>> index 709e996f401c..e27d80e09392 100644
>> --- a/ioctl.h
>> +++ b/ioctl.h
>> @@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>>   				   struct btrfs_ioctl_vol_args)
>>   #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>   				   struct btrfs_ioctl_vol_args)
>> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
>> +				   struct btrfs_ioctl_vol_args)
>>   /* trans start and trans end are dangerous, and only for
>>    * use by applications that know how to avoid the
>>    * resulting deadlocks
>>
