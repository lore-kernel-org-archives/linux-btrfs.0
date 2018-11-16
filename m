Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A06C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 10:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41ACC2087A
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 10:29:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="064kxODY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41ACC2087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbeKPUlB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 15:41:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbeKPUlA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 15:41:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAGATD9N044852;
        Fri, 16 Nov 2018 10:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=P1RIwEj5JAN7vyES9SZ0oUeQglo6I5WqyJktTAjYexM=;
 b=064kxODYApy3NE5bv/Bl93FwBve4u2nH+zn7w27P5TR5vWUaIj03q71ag+snqygWTT3F
 zP2B9gkcVKpzStWvTeiKdl0a/Q2vSrvmXZzeq2/R1HtnIIvt2byVoAQmtqsOcT3FaTz8
 uUewRD9ICas8ihEMnEJTrMREyghq78TVOgYhuuv43zImsAoJ28gS0Tzaul8Q6yk6rYyw
 JzFRTxqn8GY4EHi9nAd6NQqfJnsGRebOzKkitm7bSCZGBguQ3lnK/DssPq3aXUJQfhao
 Lzgj2o8wUKPEpAoLlOGXSMuXdv7oyGLy9pBeLE0reJQ6eS1PkOX28qp7XtR1Lq31X8ee qw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nr7csegsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 10:29:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAGATCZi003722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 10:29:12 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAGATCCm022227;
        Fri, 16 Nov 2018 10:29:12 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 02:29:11 -0800
Subject: Re: [PATCH 8/9] btrfs: user requsted replace cancel is not an error
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-9-git-send-email-anand.jain@oracle.com>
 <20181115153124.GT24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <5e7d6012-5231-a6ed-ddd3-c9e104b536bd@oracle.com>
Date:   Fri, 16 Nov 2018 18:29:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181115153124.GT24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160096
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/15/2018 11:31 PM, David Sterba wrote:
> On Sun, Nov 11, 2018 at 10:22:23PM +0800, Anand Jain wrote:
>> As of now only user requested replace cancel can cancel the replace-scrub
>> so no need to log error for it.
> 
> This has probably some user visible effect or threre are steps to
> reproduce the message even if it's not expected (ie. the case that this
> patch fixes). Please update the changelog, thanks.
> 



before the patch [1]
   [1]
     btrfs: fix use-after-free due to race between replace start and cancel

  We used to set the replace_state to CANCELED [2] and then call
  btrfs_scrub_cancel(), but the problem with this approach is
  if the scrub isn't running yet, then things get messier.

[2]
-       dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;

  So to fix, [1] shall set replace_state to CANCELED only after the
  replace cancel thread has successfully canceled the replace using
  btrfs_scrub_cancel().

  And about the cleanup process for the replace target..
  we call
    btrfs_dev_replace_finishing(.. ret)
  after
   ret= btrfs_scrub_dev()

  now ret is -ECANCELED due to replace cancel request by the user.
  (its not set to -ECANCELED for any other reason).

  btrfs_dev_replace_finishing() has the following code [3] which it
  earlier blocked processing of the cleanup process after the cancel,
  because the replace_state was already updated to
  BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED.


[3]
--------------
static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
                                        int scrub_ret)
{

::
         /* was the operation canceled, or is it finished? */
         if (dev_replace->replace_state !=
             BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
                 btrfs_dev_replace_read_unlock(dev_replace);
                 mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
                 return 0;
         }
-----------

  In fact before this patch [1] the code wasn't sync-ing the IO
  when replace was canceled. Which this patch also fixes by using
  the  btrfs_dev_replace_finishing()


-----------
btrfs_dev_replace_finishing
::
         /*
          * flush all outstanding I/O and inode extent mappings before the
          * copy operation is declared as being finished
          */
         ret = btrfs_start_delalloc_roots(fs_info, -1);
         if (ret) {
                 mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
                 return ret;
         }
         btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
-----------

  So to answer above question... these warn and error log wasn't
  reported before when replace was canceled and now since I am
  using the btrfs_dev_replace_finishing() to finish the job
  of cancel.. it shall be reported which is ok to quite.

  Do you think we still need to update the change log?

HTH.

Thanks, Anand
