Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3666FC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 14:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C302175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 14:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EmAAzu0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfCTOAC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:00:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfCTOAC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 10:00:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2KDrlmL007992;
        Wed, 20 Mar 2019 13:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=HLwvgonsRV0Z0zfWOBl/onusixsGNcFZj15YDcBXWiI=;
 b=EmAAzu0NpNONTIIoOL2R/bCHz+Q8ZZF1rGpvOHO6UkE6WEqjCZ0vSGwaICTVdBBizd4O
 vGLkVNeneWnwuKguy95whgHZR22cD6jzIag4ssKsjjgiJEkFqf8FDcFHH4UEOjcooj7P
 z08uRe9xwOi1qk8yt55s4qz/VpOH3GlOnEOVTg1fpPveIbHxdyM7ta66b076pX/psCPW
 ZEjbNdGs0ZtFbZXfgOmLjc3Ja8B2NOeMPQNw1mNN15klO6aksHNDk1m8wBc6v91Z4gBr
 oHBbKcPvS40wTdIXjUTdWu8t/mjKzuIUZEm2ReNa6SnQwzH01w350vXiBlSjPSkb6+Go bQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r8ssrjsy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 13:59:58 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2KDxvMq030747
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 13:59:57 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2KDxuBw022576;
        Wed, 20 Mar 2019 13:59:56 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 06:59:56 -0700
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
Date:   Wed, 20 Mar 2019 22:00:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9200 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903200108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


>>   Also any idea why the generation number for the extent data is not
>>   incremented [2] when -o nodatacow and notrunc option is used, is it
>>   a bug? the dump-tree is taken with the script as below [1]
>>   (this corruption is seen with or without generation number is
>>   being incremented, but as another way to fix for the corruption we can
>>   verify the inode EXTENT_DATA generation from the same disk from which
>>   the data is read).
> 
> For the generation part, it's the generation when data is written to disk.
> 
> Truncation/nocow overwrite shouldn't really change the generation of
> existing file extents.
> 
> So I'm afraid you can't use that generation to do the check.

  Any idea why it shouldn't change? Albeit there isn't new allocation
  due to nodatacow and notrunc overwrite, but sure data is overwritten.
  If that's the case then I would guess there will be bug in send receive
  as well.

Thanks, Anand

> Thanks,
> Qu
> 
>>
>> [1]
>>   umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb && \
>>   mount -o notreelog,max_inline=0,nodatasum /dev/sdb /btrfs && \
>>   echo 1st write: && \
>>   dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1
>> conv=fsync,notrunc && sync && \
>>   btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
>>   echo --- && \
>>   btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA" && \
>>   echo 2nd write: && \
>>   dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1
>> conv=fsync,notrunc && sync && \
>>   btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
>>   echo --- && \
>>   btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA"
>>
>>
>> 1st write:
>>      item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>>          generation 6 transid 6 size 4096 nbytes 4096
>>          block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>>          sequence 1 flags 0x3(NODATASUM|NODATACOW)
>>          atime 1553058460.163985452 (2019-03-20 13:07:40)
>>          ctime 1553058460.163985452 (2019-03-20 13:07:40)
>>          mtime 1553058460.163985452 (2019-03-20 13:07:40)
>>          otime 1553058460.163985452 (2019-03-20 13:07:40)
>> ---
>>      item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>          generation 6 type 1 (regular)
>>          extent data disk byte 13631488 nr 4096
>>          extent data offset 0 nr 4096 ram 4096
>>          extent compression 0 (none)
>> 2nd write:
>>      item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>>          generation 6 transid 7 size 4096 nbytes 4096
>>          block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>>          sequence 2 flags 0x3(NODATASUM|NODATACOW)
>>          atime 1553058460.163985452 (2019-03-20 13:07:40)
>>          ctime 1553058460.189985450 (2019-03-20 13:07:40)
>>          mtime 1553058460.189985450 (2019-03-20 13:07:40)
>>          otime 1553058460.163985452 (2019-03-20 13:07:40)
>> ---
>>      item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>          generation 6 type 1 (regular)   <----- [2]
>>          extent data disk byte 13631488 nr 4096
>>          extent data offset 0 nr 4096 ram 4096
>>          extent compression 0 (none)
>>
>>
>> Thanks, Anand
> 
