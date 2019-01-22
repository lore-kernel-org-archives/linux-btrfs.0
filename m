Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB20CC41518
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 13:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9138C217D4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 13:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YS9TvMHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfAVNoB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:44:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbfAVNoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 08:44:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0MDY46G059176;
        Tue, 22 Jan 2019 13:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mmnBQGDgD1QNyyJn44E7nktRWOgZ6rZ3OcOvax73KWg=;
 b=YS9TvMHoZmSh7BJPWq/QVc2ilfnmd1s5TEQp1p+uePcrJgjo8QQfCOKMOkya9AwyixUJ
 lSc6Yz7npIEq/+lcaPek1f6vNLA5TJwVP+ywKmBH8euaDyzVl9nclT07T/fD48Bs1Vyz
 FeKRFxDQBfa4XWecWAGJB+8TV0UPPojgnG5OvOZimy1JpZZ4We1PUA6tqLaNR3VSFKZo
 OQAaqwI7hgy+BjE9y55lyEJo+e6kaNSVRiQLJql57Ns3zMUs2JxYAmkygNfALJp+CANE
 clGL/jHpI5o5kwL2TRPqT0eAwTiQMsZIhxNACAagxo4KQAFXAUAzA0a/SyMtNYpLG+Ez 2Q== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2q3sdebsg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jan 2019 13:43:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0MDhsZC020055
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jan 2019 13:43:55 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0MDhr3h002058;
        Tue, 22 Jan 2019 13:43:53 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jan 2019 05:43:53 -0800
Subject: Re: [PATCH v2 2/3] btrfs: add read_mirror_policy parameter devid
To:     Steven Davies <btrfs-list@steev.me.uk>, linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516100359.7752-3-anand.jain@oracle.com>
 <443d1af2948306c1f776baaa227272ae@steev.me.uk>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <24ea40ca-5216-fbe4-2b4b-64da7d8a89fa@oracle.com>
Date:   Tue, 22 Jan 2019 21:43:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <443d1af2948306c1f776baaa227272ae@steev.me.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9143 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901220107
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/21/2019 07:56 PM, Steven Davies wrote:
> On 2018-05-16 11:03, Anand Jain wrote:
> 
> Going back to an old patchset I was testing this weekend:
> 
>> Adds the mount option:
>>   mount -o read_mirror_policy=<devid>
>>
>> To set the devid of the device which should be used for read. That
>> means all the normal reads will go to that particular device only.
>>
>> This also helps testing and gives a better control for the test
>> scripts including mount context reads.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Tested-By: Steven Davies <btrfs-list@steev.me.uk>

Thanks for testing.

> 
>> ---
>>  fs/btrfs/super.c   | 21 +++++++++++++++++++++
>>  fs/btrfs/volumes.c | 10 ++++++++++
>>  fs/btrfs/volumes.h |  2 ++
>>  3 files changed, 33 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 21eff0ac1e4f..7ddecf4178a6 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -852,6 +852,27 @@ int btrfs_parse_options(struct btrfs_fs_info
>> *info, char *options,
>>                      BTRFS_READ_MIRROR_BY_PID;
>>                  break;
>>              }
>> +
>> +            intarg = 0;
>> +            if (match_int(&args[0], &intarg) == 0) {
>> +                struct btrfs_device *device;
>> +
>> +                device = btrfs_find_device(info, intarg,
>> +                               NULL, NULL);
>> +                if (!device) {
>> +                    btrfs_err(info,
>> +                      "read_mirror_policy: invalid devid %d",
>> +                      intarg);
>> +                    ret = -EINVAL;
>> +                    goto out;
>> +                }
>> +                info->read_mirror_policy =
>> +                        BTRFS_READ_MIRROR_BY_DEV;
>> +                set_bit(BTRFS_DEV_STATE_READ_MIRROR,
>> +                    &device->dev_state);
> 
> Not an expert, but might this be overwritten with another state? e.g. 
> BTRFS_DEV_STATE_REPLACE_TGT. The device would then lose its READ_MIRROR 
> flag and the fs would always use the first device for reading.

  It won't it is defined as bitmap.

>> +                break;
>> +            }
> 
> I noticed that it's possible to pass this option multiple times at 
> mount, which sets multiple devices as read mirrors. While that doesn't 
> do anything harmful, the code below will only use the first device. It 
> may be worth at least mentioning this in documentation.

  There were few feedback if read_mirror_policy should be a mount
  option or a sysfs or a property. IMO property is better as it would
  be persistent. In sysfs and mount-option, the user or a config file
  has to remember. Will fix.

>> +
>>              ret = -EINVAL;
>>              goto out;
>>          case Opt_err:
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 64dba5c4cf33..3a9c3804ff17 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5220,6 +5220,16 @@ static int find_live_mirror(struct
>> btrfs_fs_info *fs_info,
>>          num_stripes = map->num_stripes;
>>
>>      switch(fs_info->read_mirror_policy) {
>> +    case BTRFS_READ_MIRROR_BY_DEV:
>> +        preferred_mirror = first;
>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>> +                 &map->stripes[preferred_mirror].dev->dev_state))
>> +            break;
>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>> +                 &map->stripes[++preferred_mirror].dev->dev_state)) <--[*]
>> +            break;
>> +        preferred_mirror = first;
> 
> Why set preferred_mirror again? The only effect of re-setting it will be 
> to use the lowest devid (1) rather than the highest (2). Is there any 
> difference? Either way it should never happen, because the above code 
> traps it (except when the BTRFS_DEV_STATE_READ_MIRROR flag has been 
> changed as mentioned above).

  Code at [*] above does ++preferred_mirror. So the following
    preferred_mirror = first;
  is not redundant.

>  From Goffredo's comment[1] on Timofey's similar effect patch, if it 
> becomes possible to have more mirrors in a RAID1/RAID10 fs then this 
> code will need to be updated to test dev_state for more than two 
> devices. Would it be sensible to implement this as a for loop straight 
> away?

  Right. A loop is better, will add.

>> +        break;
>>      case BTRFS_READ_MIRROR_DEFAULT:
>>      case BTRFS_READ_MIRROR_BY_PID:
>>      default:
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 953df9925832..55b2eebbf183 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -37,6 +37,7 @@ struct btrfs_pending_bios {
>>  enum btrfs_read_mirror_type {
>>      BTRFS_READ_MIRROR_DEFAULT,
>>      BTRFS_READ_MIRROR_BY_PID,
>> +    BTRFS_READ_MIRROR_BY_DEV,
>>  };
>>
>>  #define BTRFS_DEV_STATE_WRITEABLE    (0)
>> @@ -44,6 +45,7 @@ enum btrfs_read_mirror_type {
>>  #define BTRFS_DEV_STATE_MISSING        (2)
>>  #define BTRFS_DEV_STATE_REPLACE_TGT    (3)
>>  #define BTRFS_DEV_STATE_FLUSH_SENT    (4)
>> +#define BTRFS_DEV_STATE_READ_MIRROR    (5)
>>
>>  struct btrfs_device {
>>      struct list_head dev_list;
> 
> Happy to add Tested-By on patch 1/3 too, but I haven't looked at 3/3 yet.
> 
> [1]: https://patchwork.kernel.org/patch/10678531/#22315779


  Thanks,
Anand.
