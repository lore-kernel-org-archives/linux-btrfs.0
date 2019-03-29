Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7ACC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BDA221773
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:32:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kAZHLXzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfC2GcW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 02:32:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53588 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfC2GcW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 02:32:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2T6PiwZ015635;
        Fri, 29 Mar 2019 06:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=u+lZWPnL+DW7Q/XwK7qno7KrwCxzHLkLI2izJTeY8xw=;
 b=kAZHLXzwdYgIqjHM7Vj91f0rLdbiQqXq0Pn9XYy1WZrTerhT8FCvhDZwApl847XEF4WE
 JfJ9tq/ONy0+Yoq2WV0l6URcA5yYvNB1gusUvb0PidmFub7NvcYlBoaGtH+IjKgWorXi
 qmW0PnoAJ1GCTAhQJ+5TrGJIAp+aEaZLP8jtaLcEfzRsZ5mZaAwvURhCf4nOGCrgPUoH
 QvMPZpiJF7VHybPt6Scfae9U44gl/gzH6JmiQUXIj2b8awGnCcX4y9ZDI5+3kLyDC63A
 8Lz0U0jeoIWCH6E0gFJEzDy71ZpewqMLEz4Of0ofaXJ1Ed5YhQGiar+jCsEcpQWx9HGC fA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2re6djtkvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 06:32:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2T6WGwV019196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Mar 2019 06:32:16 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2T6WGoE022345;
        Fri, 29 Mar 2019 06:32:16 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 23:32:16 -0700
Subject: Re: [PATCH] fstests: btrfs try use forget to unregister device
To:     dsterba@suse.cz
References: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
 <20190328175047.GR29086@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <7787e21a-3d37-e670-b782-0df43e256f83@oracle.com>
Date:   Fri, 29 Mar 2019 14:32:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190328175047.GR29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9210 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290047
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/29/19 1:50 AM, David Sterba wrote:
> On Tue, Mar 19, 2019 at 05:49:40PM +0800, Anand Jain wrote:
>> btrfs module reload was introduced to unregister devices in the btrfs
>> kernel module.
>>
>> The problem with the module reload approach is that you can't run btrfs
>> test cases 124, 125, 154 and 164 on the system with btrfs as root fs.
>>
>> Patches [1] introduced btrfs forget feature which lets to cleanup the
>> kernel device list without kernel module reload.
>>
>>   [1]
>>   btrfs-progs: add cli to forget one or all scanned devices
> 
> The subject lines was changed to "btrfs-progs: device scan: add new
> option to forget one or all scanned devices"

  ok thanks will fix.

>>   btrfs: introduce new ioctl to unregister a btrfs device
> 
>> So this patch uses forget feature instead of kernel module reload, if
>> the forget feature is available.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   common/btrfs    | 20 ++++++++++++++++++++
>>   tests/btrfs/124 |  6 +++---
>>   tests/btrfs/125 |  6 +++---
>>   tests/btrfs/154 |  6 +++---
>>   tests/btrfs/164 |  4 ++--
>>   5 files changed, 31 insertions(+), 11 deletions(-)
>>
>> diff --git a/common/btrfs b/common/btrfs
>> index f6513c06f95f..e94e011db04e 100644
>> --- a/common/btrfs
>> +++ b/common/btrfs
>> @@ -382,3 +382,23 @@ _scratch_btrfs_sectorsize()
>>   	$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV |\
>>   		grep sectorsize | awk '{print $2}'
>>   }
>> +
>> +_btrfs_supports_forget()
>> +{
>> +	$BTRFS_UTIL_PROG device scan --help | grep -wq forget && \


>> +		$BTRFS_UTIL_PROG device scan --forget > /dev/null 2>&1
> 
> The second part actually unregisters all devices, is there some more
> lightweight way to detect the support?  > Like providing a valid block
> device but without btrfs. If the ioctl is supported, then it returns
> -ENOENT and if not supported then -EOPNOTSUPP.

_btrfs_supports_forget() has two different usage
   _require_btrfs_forget_if_not_fs_loadable
which is called in the beginning of the test so its fine to clean all 
the (unmounted) devices in the kernel.

    _btrfs_forget_if_not_fs_reload
Earlier we were reloading the btrfs.ko in the middle of the test case, 
so this is certainly more lightweight.

Looked into the return values if I could use any better [1]. So
_require_btrfs_forget_if_not_fs_loadable() need a btrfs on a loop device
to verify if we need to avoid unregister all devices. Bit messy though.

[1]
With btrfs patches:
We still get error if the device is not in the kernel dev_list.
--------
# mkfs.btrfs -fq /dev/sdb
# wipefs -a /dev/sdb
/dev/sdb: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48 52 
66 53 5f 4d
# mkfs.xfs -fq /dev/sdb
# btrfs dev scan --forget /dev/sdb; echo $?
0
# btrfs dev scan --forget /dev/sdb; echo $?
ERROR: Can't forget '/dev/sdb': No such file or directory
1
----------

With out any btrfs forget patches:
Usage error and error code = 1 (it should rather be EINVAL).
--------
# btrfs dev scan --forget  /dev/sda
usage: btrfs device scan [(-d|--all-devices)|<device> [<device>...]]

     Scan devices for a btrfs filesystem

      -d|--all-devices (deprecated)
1
-----------

With out the btrfs kernel patch:
Returns error code 1. (After the patch sent to the ML it will
return EOPNOTSUPP).
---------------
# btrfs dev scan --forget /dev/loop0; echo $?
ERROR: Can't forget '/dev/loop0': Inappropriate ioctl for device
1
---------------




>> +}
>> +
>> +_require_btrfs_forget_if_not_fs_loadable()
> 
> _require_btrfs_forget_or_module_loadable
> 
> We don't want to load the filesystem but the kernel module.

  Will fix.

>> +{
>> +	_btrfs_supports_forget && return
> 
> Why is the 'return' here? If the first command succeeds, then &&
> proceeds to return that does implicitli returns 0. So it's redundant, or
> I'm missing something subtle here.

  Hmm. Not sure if I understood. Do you mean we could

   _btrfs_supports_forget  || _require_loadable_fs_module "btrfs"

>> +
>> +	_require_loadable_fs_module "btrfs"
>> +}
>> +
>> +_btrfs_forget_if_not_fs_reload()
> 
> Same naming

Ok

Thanks, Anand

> 
>> +{
>> +	_btrfs_supports_forget && return
>> +
>> +	_reload_fs_module "btrfs"
>> +}
