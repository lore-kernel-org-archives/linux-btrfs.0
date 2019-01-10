Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43639C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 07:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF1A214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 07:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ytU678rb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfAJHcT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:32:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfAJHcT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 02:32:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0A7TX5r145189;
        Thu, 10 Jan 2019 07:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=eEqZLr+uiwTaJdDKc5KDUshLBgQm7ISgsrSl/kMjo0I=;
 b=ytU678rbPCZEYGXjwz98v2eOhxyJwgejVWr0dtc5kqS8UkYA2ZkJQJkjgf0kmx4SXnH7
 mWA9F9BDyu1qQ1vFL4Pg4Zw1PCoh99z8T5arLRb5xw/PT6/bM4N8mTpRNXE8AknX0htq
 i0WVhMuiIgqgFjzyNfB+PID1SA2TjXj+ISs3ovRTmhiSJzDLwJKZvXVUZU8lb5oSAumx
 TcbrOQwGQTt4MvQbz8BIEJkM8VeiRoPdGPI+kPt5gNtc4DULab+kYDnBXSJ4MZqwYMTo
 IOLich9YSxp8+SlLVdd5wavORwRGKFJ7/SnQZ1OfW/yEW/T6PCMGFzkZLdtvWuFaRY/7 cw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ptm0udkjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 07:32:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0A7WCP1018505
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 07:32:12 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0A7WB3g006893;
        Thu, 10 Jan 2019 07:32:12 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jan 2019 23:32:11 -0800
Subject: Re: [PATCH] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     Filipe Manana <fdmanana@kernel.org>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181213211725.14832-1-fdmanana@kernel.org>
 <20190109182653.GN23615@twin.jikos.cz>
 <CAL3q7H5iJ0_g8w2s-2jRMJdZLDT+pqgmtXU5dWQ6A4PjJAUpkg@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <103742d8-5b13-b080-05b4-070df735df77@oracle.com>
Date:   Thu, 10 Jan 2019 15:32:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5iJ0_g8w2s-2jRMJdZLDT+pqgmtXU5dWQ6A4PjJAUpkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9131 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901100062
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/10/2019 03:48 AM, Filipe Manana wrote:
> On Wed, Jan 9, 2019 at 6:27 PM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Thu, Dec 13, 2018 at 09:17:25PM +0000, fdmanana@kernel.org wrote:
>>> -     if (list_empty(&fs_devices->resized_devices))
>>> -             return;
>>> -
>>> -     mutex_lock(&fs_devices->device_list_mutex);
>>>        mutex_lock(&fs_info->chunk_mutex);
>>>        list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>>>                                 resized_list) {
>>> @@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>>>                curr->commit_total_bytes = curr->disk_total_bytes;
>>
>> I'm not sure about removing the device_list_mutex that's said to protect
>> the commit_total_bytes (comment in struct btrfs_device).
>>
>> Otherwise the logic is ok, the double lock could happen as you describe.
>>
>> btrfs_update_commit_device_size is called from btrfs_commit_transaction,
>> at the same time as commit_bytes_used. The latter is handled in a
>> similar way in btrfs_update_commit_device_bytes_used, but does not take
>> the device_list_mutex.
>>
>> commit_total_bytes is checked several times (eg. in write_dev_supers) to
>> see if writing the superblock copy is still within the device range.
>>
>> So, without the protected change, it's theoretically possible that a
>> stale value is used for the test and the superblock is either written
>> though it should not, and the other way around.
>>
>> This would require a resize racing at the time of the check. Grow and
>> shrink seem to take chunk_mutex while adjusting all the total/size
>> values, but it's not actually easy to follow as sometimes there are
>> helpers like btrfs_device_set_total_bytes used and sometimes it's direct
>> access.
>>
>> That the device_list_mutex can be safely dropped probably follows from
>> the simple fact that btrfs_update_commit_device_bytes_used is called
>> before write_dev_supers in the same context.
>>
>> But this sounds too simple, given that there are locks taken and
>> released and btrfs_write_and_wait_transaction called between.
> 
> Regardless of all that (and honestly I haven't double checked and
> skimmed only through what you said),
> there's a more important aspect I missed before: write_all_supers()
> takes (and needs) the device list mutex,
> therefore this change won't fix the deadlock because of that.

  Though this won't fix the problem, this patch is still ok
  as its drops the unnecessary device_list_mutex in
  btrfs_update_commit_device_size(). So for that if the change log
  updated,
    Reviewed-by: Anand Jain <anand.jain@oracle.com>

  To address the actual problem.

  Functions which call btrfs_alloc_device() are..
     device_list_add()
     close_fs_devices()
     btrfs_init_dev_replace_tgtdev()
     clone_fs_devices()
     btrfs_init_new_device()

  Now among the above following holds the device_list_mutex when calling
  btrfs_alloc_device()
     device_list_add()
     close_fs_devices()
     clone_fs_devices()

  Now among above three, the lock at device_list_add() and
clone_fs_devices() can be ignored, because the reclaim or flush IO can't
take place on these FSID:devices as device_list_add() is called when FS
is not-mounted or in the mounting context, and clone_fs_devices() is
called when the SEED device is still a read-only FS.

  And so we have to only worry about close_fs_devices().

  close_fs_devices() - I didn't like the way it does, that is allocate a
new struct btrfs_device instead of just zero-ing the struct btrfs_device
during unmount. I guess it was done to avoid RCU warning (not sure) and
if it isn't real issues I am happy to see btrfs_device_alloc() is
dropped in close_fs_devices(). Which means it also fixes the problem
that - you need more memory to unmount an ideal FS.

Thanks.

> thanks
> 
>>
>> Referencing this code:
>>
>> 2201         btrfs_update_commit_device_size(fs_info);
>> 2202         btrfs_update_commit_device_bytes_used(cur_trans);
>> 2203
>> 2204         clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
>> 2205         clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
>> 2206
>> 2207         btrfs_trans_release_chunk_metadata(trans);
>> 2208
>> 2209         spin_lock(&fs_info->trans_lock);
>> 2210         cur_trans->state = TRANS_STATE_UNBLOCKED;
>> 2211         fs_info->running_transaction = NULL;
>> 2212         spin_unlock(&fs_info->trans_lock);
>> 2213         mutex_unlock(&fs_info->reloc_mutex);
>> 2214
>> 2215         wake_up(&fs_info->transaction_wait);
>> 2216
>> 2217         ret = btrfs_write_and_wait_transaction(trans);
>> 2218         if (ret) {
>> 2219                 btrfs_handle_fs_error(fs_info, ret,
>> 2220                                       "Error while writing out transaction");
>> 2221                 mutex_unlock(&fs_info->tree_log_mutex);
>> 2222                 goto scrub_continue;
>> 2223         }
>> 2224
>> 2225         ret = write_all_supers(fs_info, 0);
