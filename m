Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64078C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 05:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FBDC2083E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 05:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nHJBNH8j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfDIFek (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 01:34:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfDIFek (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2019 01:34:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x395XdeI039833;
        Tue, 9 Apr 2019 05:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=N/uBZbwMEeGvLO25En14DzSVNFu285Crmfm0TPfJVG4=;
 b=nHJBNH8jOk6FOKhutARREIDnGdx2kOTCl3vsvX9gF98zkQ0iqNqQHxkK7l23/RWrk9vl
 sZbTIyM0sry9ggB32t/xFwhNL2ZHcquJfAs8Yp3BFFpqcgDmeCp09YwkIg4B7n4+P3Jl
 qL/RAWgvIa0/imB0GNquc1KHm2j2aQF012WCn6qf4g2kGB2sZAt7S87GUFkOyavp/mqe
 8RoujkMTxAV+td9t2Zbdm4t6NHpx7t10Xlg9nqOWLEae6dFk73Ho5AuLBVP9zJmsIwFl
 OOPSHQgaThnsiIg85I3giHLfDXNzaEDYq10EScDxGgKKASXZp10YYGwhXwAYCuaAiDkd UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rpkhstjv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 05:34:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x395XWWb018732;
        Tue, 9 Apr 2019 05:34:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2rpj5ac9ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 05:34:10 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x395Y8VU003582;
        Tue, 9 Apr 2019 05:34:09 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Apr 2019 22:34:08 -0700
Subject: Re: [PATCH 0/4] property fixes and cleanups
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, nborisov@suse.com
References: <20190403165134.12378-1-anand.jain@oracle.com>
 <20190408170214.GB29086@twin.jikos.cz> <20190408232320.GE29086@twin.jikos.cz>
From:   Anand Jain <Anand.Jain@oracle.com>
Message-ID: <fd0c91a6-6c7d-6acc-464f-da25557511d6@oracle.com>
Date:   Tue, 9 Apr 2019 13:34:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408232320.GE29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904090038
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904090038
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/4/19 7:23 AM, David Sterba wrote:
> On Mon, Apr 08, 2019 at 07:02:14PM +0200, David Sterba wrote:
>> On Thu, Apr 04, 2019 at 12:51:30AM +0800, Anand Jain wrote:
>>> Both mainline and misc-5.2 fails the test case that transaction
>>> generation number must be unaltered if the property validation fails.
>>>
>>> For example:
>>> btrfs in dump-super /dev/sdb | grep ^generation; \
>>> btrfs prop set /btrfs compression lz; sync; \
>>> btrfs in dump-super /dev/sdb | grep ^generation
>>> generation		53
>>> ERROR: failed to set compression for /btrfs: Invalid argument
>>> generation		54
>>>
>>> Which the patch in the mailing list fixes and based on misc-5.2
>>>    [PATCH 4/4 RESEND] btrfs: fix property validate fail should not increment
>>>
>>> But, now I notice that the reason for which the original code failed
>>> is different from the reason for which misc-5.2 failed. Former failed
>>> because the malformed 'lz' was only abled to be caught by handle->apply(),
>>> and in latter we were calling the start_transaction() too early before the
>>> handle->validation() which few of the patches in misc-5.1 did. My bad.
>>>
>>> As per your misc-5.2 branch please drop the following patches as I have
>>> better fixes as in this patch.
>>>
>>> 584aebf26bbf btrfs: merge btrfs_setxattr and do_setxattr
>>> ab54ee38fff7 btrfs: don't create transaction in btrfs_setxattr
>>> 0cbf560f72e1 btrfs: start transaction in btrfs_xattr_handler_set
>>> db0f220e98eb btrfs: start transaction in btrfs_set_acl
>>> 56e9e992c00a btrfs: start transaction in btrfs_set_prop_trans
>>> 3e2299ea6a8b btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans
>>> 737e67ce0f3f btrfs: merge _btrfs_set_prop helpers
>>>
>>> And please apply the patches as in this set.
>>>
>>> Anand Jain (4):
>>>    btrfs: rename __btrfs_set_prop to btrfs_set_prop_trans
>>>    btrfs: rename __btrfs_set_acl to do_set_acl
>>>    btrfs: fix zstd compression parameter
>>>    btrfs: fix vanished compression property after failed set
>>
>> I'm going to send the two fixes independently to 5.1 as they affect
>> current code. Regarding the increased transaction, I don't want to drop
>> the patches that move transaction around just yet, as they're 100
>> patches deep in the devel queue.
> 
> I've checked how much conflicts it creates, just one so that's not a
> problem with removing.
> 
>> The validation should happen before the transaction, the code currently
>> does a few nested calls so this might need further cleanups but I'd
>> rather go that way than to deleting what's in misc-next and starting
>> again.



>> If deleting the current misc-next patches appears to be a better option
>> in the end, then I'll do that.

> So, the removed patches are:


[1]
> - btrfs: merge btrfs_setxattr and do_setxattr
> - btrfs: don't create transaction in btrfs_setxattr
> - btrfs: start transaction in btrfs_xattr_handler_set
> - btrfs: start transaction in btrfs_set_acl
> - btrfs: start transaction in btrfs_set_prop_trans
> 
> There was one conflict with 'btrfs: Defer setting new inode mode until
> after do_set_acl succeeds' that I removed as the patch depended on the
> transaction in the function.
> 
> The inode flags that have a corresponding property, handled in
> btrfs_ioctl_setflags, need to be enclosed in the same transaction so
> they don't get out of sync. This will require splitting the validation
> and actual change, which will require restructuring the setflags
> function too.
> 

  You are right. So moving the start_transaction upward was right.
  Which means reverting these patches aren't good idea, so that
  we can enclose inode flag changes in the same transaction.

  Also similarly btrfs_set_acl() -> do_set_acl() should open code
  the do_set_acl() in btrfs_set_acl() so that it can start the
  transaction after all checks.

  Are you ok to keep these above patches [1], sorry now I have
  a stronger reason why we should start transaction in the parent
  functions.

Thanks, Anand
