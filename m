Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AF2C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 14:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23E102082D
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 14:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P/bFqxwX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E102082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbeJZXFA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 19:05:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbeJZXFA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 19:05:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9QENiUc109993;
        Fri, 26 Oct 2018 14:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=gUtBEg4IFOTLOMXFmntJPNvfDKSsskfPPU2fEjJf5pU=;
 b=P/bFqxwXS0aThzqx4D6zBzexEgYu9vbbElfxoXJaYqd+G2zfmp6Edesfe6NjLA6WUhhB
 dRqrJ22NsCOA50UNk1bRZoM7ew/wK7NI0UFrGkFBboF1u8aNMtGbQja1jdfBT26/qvTZ
 H418FOs5y/HvlW8LjEOwgYFHt59/nR3f3KkGIT3wCrkaMip+v5PxohL0MCOcBFB2q6Jh
 Shu1E7ZkkmNBHKAUKJLE4D5KXZ8LYApp7C2CIGbWUb1ShNXen49QIdomVdLIpBivzHQb
 70UEp4Yd4uqL9xOrjq/tmhxGUNOJfYa3JYxVL38uLchpXOVKx+GTZvOYHK/HiwXjV64T qg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n7usuqkhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 14:27:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9QERdSQ030717
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 14:27:39 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9QERdr8012700;
        Fri, 26 Oct 2018 14:27:39 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Oct 2018 07:27:38 -0700
Subject: Re: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540355502-22489-1-git-send-email-anand.jain@oracle.com>
 <1540355502-22489-3-git-send-email-anand.jain@oracle.com>
 <4ca26c1c-3fc2-5673-5443-e543cf23a1b5@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1a2b1d3b-6fdd-8940-450b-c8fc3856616f@oracle.com>
Date:   Fri, 26 Oct 2018 22:27:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <4ca26c1c-3fc2-5673-5443-e543cf23a1b5@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9057 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810260124
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 08:21 PM, Nikolay Borisov wrote:
> 
> 
> On 24.10.2018 07:31, Anand Jain wrote:
>> This patch adds cli
>>    btrfs device forget [dev]
>> to remove the given device structure in the kernel if the device
>> is unmounted. If no argument is given it shall remove all stale
>> (device which are not mounted) from the kernel.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-device.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
>>   ioctl.h       |  2 ++
>>   2 files changed, 53 insertions(+), 8 deletions(-)
>>
>> diff --git a/cmds-device.c b/cmds-device.c
>> index 2a05f70a76a9..c2a2b7f304b8 100644
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
>> +	"btrfs device scan [(-d|--all-devices)|(-u|--forget)|<device> "\
>> +							"[<device>...]]",
>> +	"Scan or forget (deregister) devices for a btrfs filesystem",
>>   	" -d|--all-devices (deprecated)",
>> +	" -u|--forget [<device> ..]",
>>   	NULL
>>   };
>>   
>> @@ -267,32 +289,45 @@ static int cmd_device_scan(int argc, char **argv)
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
>>   	if (all || argc - optind == 0) {
>> +		if (forget) {
>> +			ret = btrfs_forget_devices(NULL);
>> +			error_on(ret, "error %d while running forget", ret);
>> +			goto out;
>> +		}
> 
> nit: I would prefer to also have an if () {} else {} construct here,
> similar to what you do below.

  Will fix.

  Also, I think I can use sterror() instead of ret, in the error_on().

  Fixed both of these in v11.

Thanks, Anand

>>   		printf("Scanning for Btrfs filesystems\n");
>>   		ret = btrfs_scan_devices();
>>   		error_on(ret, "error %d while scanning", ret);
>> @@ -315,11 +350,19 @@ static int cmd_device_scan(int argc, char **argv)
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
