Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37C9C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87ECD218A5
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mksfBur3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfCVNvY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:51:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58772 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbfCVNvY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 09:51:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2MDmu8h130141;
        Fri, 22 Mar 2019 13:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=AihWyaTffgetSx8yEVT7CSoBRYXK7kijvBlkUPvDL3I=;
 b=mksfBur3sH9djN9dPGY3D7touoM0fUaJ1J1YnQwW4GseQybQbQkhl/TcGXDW5ill+hGw
 UQHHQ9VvlN02qZiT/j4GJ6ah6ULmANuoW5tJqgBeKkFtfXeowFKisUUeyKCrG65F1pW/
 9e89K2t1owomQt0d+MOVLdfU4RBShq+wgM4QgHjqKd6DjwWf5tgAKG65n+YU30OHDNOG
 399rf2ULRQLhSZzjaaUjnFfHapRsUF6w202plLWHi6M4aNREvAQFyXj5i5fRmd1gEcDC
 zVgwzTgddAlzSqhBlBygLPW6FGxZIWybNo/Wb2NyvkJLuWbeDmDBDoITdb/znhiIvZrc 2Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2r8pnf6bym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Mar 2019 13:51:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2MDpHCR027630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Mar 2019 13:51:17 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2MDpGao021563;
        Fri, 22 Mar 2019 13:51:16 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Mar 2019 06:51:16 -0700
Subject: Re: [PATCH] btrfs: Use raw numbers when setting passing uptodate
 parameter to btrfs_writepage_endio_finish_ordered
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320195316.27134-1-nborisov@suse.com>
 <20190321143032.GE26179@twin.jikos.cz>
 <e0f79e5f-5ed4-defb-f614-3c722e78dc41@suse.com>
 <20190321152553.GC8120@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <df534898-fb7e-68d0-d4f8-1f7e1ee15937@oracle.com>
Date:   Fri, 22 Mar 2019 21:51:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190321152553.GC8120@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9202 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903220101
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/21/19 11:25 PM, David Sterba wrote:
> On Thu, Mar 21, 2019 at 04:31:53PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 21.03.19 г. 16:30 ч., David Sterba wrote:
>>> On Wed, Mar 20, 2019 at 09:53:16PM +0200, Nikolay Borisov wrote:
>>>> The uptodate parameter of btrfs_writepage_endio_finish_ordered is used
>>>> to signal whether an error has occured while writing the given page.
>>>> 0 signal an error, which is propagated to callees and 1 signifies
>>>> success. In end_compressed_bio_write the ->bi_status is checked and
>>>> based on it either BLK_STS_OK (0) or BLK_STS_NOTSUPP (1) are used. While
>>>> from functional point of view this is ok it's a for the poor reader of
>>>> the code, since the block layer values are conflated with the semantics
>>>> of the parameter.
>>>>
>>>> Just use plain 0 or 1. No functional changes.
>>>>
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> ---
>>>>   fs/btrfs/compression.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>>>> index eb8e20b740d6..f82441f18512 100644
>>>> --- a/fs/btrfs/compression.c
>>>> +++ b/fs/btrfs/compression.c
>>>> @@ -250,7 +250,7 @@ static void end_compressed_bio_write(struct bio *bio)
>>>>   	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
>>>>   	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
>>>>   			cb->start, cb->start + cb->len - 1,
>>>> -			bio->bi_status ? BLK_STS_OK : BLK_STS_NOTSUPP);
>>>> +			bio->bi_status ? 0 : 1);
>>>
>>> Essentially reverting 2dbe0c77186c691386b74391039899808a4d3f59, but
>>> using the BLK_STS constants is definetelly wrong. The values match the
>>> intended use of 'uptodate', but otherwise are confusing.
>>>
>>> I actually think it can be simplified to bio->bi_staus == BLK_STS_OK.
>>
>> Yes that would work, are you going to fix up the patch or shall I resend?
> 
> I'll fix it.

bio->bi_staus == BLK_STS_OK ? 1 : 0);

Is better. Its confusing. Thanks for the fix.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
