Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED33C04EB9
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 01:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0355820868
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 01:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M9M5ynap"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0355820868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbeK3MHy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 07:07:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbeK3MHy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 07:07:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAU0sUf2182697;
        Fri, 30 Nov 2018 01:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=uV/oEUEoJZj+Bh+3+Xq15wsVxGUB6JONyWB5wCMiK4M=;
 b=M9M5ynapZhH7OuJYnzoD3OygQQdlrqd5AJZgFezwkHkrvJQe5WtbCk+i8GXfUOhcAQ1U
 aiaL5XpEQv616ozh6l2caHgvOunKppoaY6w7loB2/1f8HF/8EEIcUOyythTDNfNO8Frf
 DS7/oIDBJqc5wAv5T5ftGn6AkP0dyMnhgIwKTD9XGXve/MrYfIO2SYP8c7leImnjofzw
 XtI4SyuTO3MFKn7zS649OOdP7TKb5APD3bhSMyJ+AUybETvblzDiBYd39LyBTX4qNKKz
 U1pNDgJS+sLduhJ3i6zm8P8eBIXH2RXZ/lxpbu9pk+3ic9vsi1f1Gwy0kWBqsXurCfz0 aQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2p2jf0jndy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 01:00:26 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAU10P1L030212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 01:00:25 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAU10PSD029288;
        Fri, 30 Nov 2018 01:00:25 GMT
Received: from [192.168.0.120] (/202.156.140.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 17:00:25 -0800
Subject: Re: [PATCH v2 1/3] btrfs: scrub: maintain the unlock order in scrub
 thread
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
 <1543483513-16724-2-git-send-email-anand.jain@oracle.com>
 <CAL3q7H667aumMBiyOQrcULVVNpiCP3FJ5W7FPjf_8-udSMn0Qg@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <6875ed20-9cf5-1f7b-990d-76eec97f4239@oracle.com>
Date:   Fri, 30 Nov 2018 09:00:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H667aumMBiyOQrcULVVNpiCP3FJ5W7FPjf_8-udSMn0Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9092 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=820
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811300005
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/29/2018 06:36 PM, Filipe Manana wrote:
> On Thu, Nov 29, 2018 at 9:27 AM Anand Jain <anand.jain@oracle.com> wrote:
>>
>> The device_list_mutex and scrub_lock creates a nested locks in
>> btrfs_scrub_dev().
>>
>> During lock the order is device_list_mutex and then scrub_lock, and during
>> unlock, the order is device_list_mutex and then scrub_lock.
>> Fix this to the lock order of scrub_lock and then device_list_mutex.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v1->v2: change the order of lock acquire first scrub_lock and then
>>          device_list_mutex, which matches with the order of unlock.
>>          The extra line which are now in the scrub_lock are ok to be
>>          under the scrub_lock.
> 
> I don't get it.
> What problem does this patch fixes?
> Doesn't seem any functional fix to me, nor performance gain (by the
> contrary, the scrub_lock is now held for a longer time than needed),
> nor makes anything more readable or "beautiful".

  btrfs_scrub_dev() isn't following the lock and unlock FILO order.
  Such as lock-a lock-b .. unlock-b unlock-a. So this patch is
  trying to fix it.

  This patch fixes the order but I think you mean to say as
  __scrub_blocked_if_needed() calls unlock scrub_lock. oops my
  bad this patch is wrong.

  Scrub concurrency needs overhaul including the dependency on the
  user land btrfs-progs, which I was trying to avoid. but looks like
  its better to fix that as well. As of now I am NACK this patch.

Thanks, Anand

>>   fs/btrfs/scrub.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 902819d3cf41..a9d6fc3b01d4 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3813,28 +3813,29 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>                  return -EINVAL;
>>          }
>>
>> -
>> +       mutex_lock(&fs_info->scrub_lock);
>>          mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>          dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>>          if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
>>                       !is_dev_replace)) {
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  return -ENODEV;
>>          }
>>
>>          if (!is_dev_replace && !readonly &&
>>              !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
>>                                  rcu_str_deref(dev->name));
>>                  return -EROFS;
>>          }
>>
>> -       mutex_lock(&fs_info->scrub_lock);
>>          if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
>>              test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
>> -               mutex_unlock(&fs_info->scrub_lock);
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  return -EIO;
>>          }
>>
>> @@ -3843,23 +3844,23 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>              (!is_dev_replace &&
>>               btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
>>                  btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>> -               mutex_unlock(&fs_info->scrub_lock);
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  return -EINPROGRESS;
>>          }
>>          btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>
>>          ret = scrub_workers_get(fs_info, is_dev_replace);
>>          if (ret) {
>> -               mutex_unlock(&fs_info->scrub_lock);
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  return ret;
>>          }
>>
>>          sctx = scrub_setup_ctx(dev, is_dev_replace);
>>          if (IS_ERR(sctx)) {
>> -               mutex_unlock(&fs_info->scrub_lock);
>>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +               mutex_unlock(&fs_info->scrub_lock);
>>                  scrub_workers_put(fs_info);
>>                  return PTR_ERR(sctx);
>>          }
>> --
>> 1.8.3.1
> 
> 
> 
