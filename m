Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CEBC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 05:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D330216FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 05:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GFPp5uX3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D330216FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbeKLPWY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:22:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53748 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeKLPWX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 10:22:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAC5UET2096484;
        Mon, 12 Nov 2018 05:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rUABcPARRoB/b7Fbeidt20w7EYog6F49yPK741E9c3w=;
 b=GFPp5uX3/FG6jJWT0c8VhUTcOU8jz7bD4MTmQJj/+G/2ReTyFaK4LGkSjV3XDus9fo4d
 gp9Dgv5eNwvuTf9MvJ6y9Gtp+zxHEkUTEW0iw6zIqkLyMW3/73pVGi5GvqT3qTkkX5gv
 hfebWsUL6nq56d5Jbl4OIZf87v/zfu8S+5ZIoaCQejgbU11N05oULxVXYtsZkkbDS5oY
 Bx+yjUCAkylt+hGJT8eHIuhsBbGCAADQY2N543bNI1SH6RkHMB4BSxFEUKSxERWWNbyi
 J05m4GP0krU6lbznfDCqMeZ4pXIk2ZNA/9Xr/GK7/golC7q9reMVQv95g4sYClhwyHVv pQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nnwc0b85y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Nov 2018 05:30:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAC5UcNk011688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Nov 2018 05:30:38 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAC5Ubmw008531;
        Mon, 12 Nov 2018 05:30:37 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 21:30:37 -0800
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Pieter Maes <maescool@gmail.com>, linux-btrfs@vger.kernel.org
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
 <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
 <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <3c224cf5-ae12-2de6-80b4-ed161891f9b5@oracle.com>
Date:   Mon, 12 Nov 2018 13:30:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9074 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811120051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/12/2018 10:12 AM, Qu Wenruo wrote:
> 
> 
> On 2018/11/12 上午9:35, Anand Jain wrote:
>>
>>
>> On 11/09/2018 09:21 AM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/11/9 上午6:40, Pieter Maes wrote:
>>>> Hello,
>>>>
>>>> So, I've had the full disk issue, so when I tried re-balancing,
>>>> I got a panic, that pushed filesystem read-only and I'm unable to
>>>> balance or grow the filesystem now.
>>>>
>>>> fs info:
>>>> btrfs fi show /
>>>> Label: none  uuid: 9b591b6b-6040-437e-9398-6883ca3bf1bb
>>>>       Total devices 1 FS bytes used 614.94GiB
>>>>       devid    1 size 750.00GiB used 750.00GiB path /dev/mapper/vg0-root
>>>>
>>>> btrfs fi df /
>>>> Data, single: total=740.94GiB, used=610.75GiB
>>>> System, DUP: total=32.00MiB, used=112.00KiB
>>>> Metadata, DUP: total=4.50GiB, used=3.94GiB
>>>
>>> Metadata usage the the biggest problem.
>>> It's already used up.
>>>
>>>> GlobalReserve, single: total=512.00MiB, used=255.06MiB
>>>
>>> And the reserved space is also been used, that's a pretty bad news.
>>>
>>>>
>>>> btrfs sub list -ta /
>>>> ID    gen    top level    path
>>>> --    ---    ---------    ----
>>>>
>>>> btrfs --version
>>>> btrfs-progs v4.4
>>>>
>>>> Log when booting machine now from root:
>>>>
>>>> ----
>>>>
>>>> [   54.746700] ------------[ cut here ]------------
>>>> [   54.746701] BTRFS: Transaction aborted (error -28)
>>>
>>> Transaction can't even be done due to lack of space.
>>>
>>> [snip]
>>>>
>>>> ----
>>>>
>>>> When booting to a net/livecd rescue
>>>> First I run a check with repair:
>>>>
>>>> ----
>>>>
>>>> enabling repair mode
>>>> Checking filesystem on /dev/vg0/root
>>>> UUID: 9b591b6b-6040-437e-9398-6883ca3bf1bb
>>>> checking extents
>>>> Fixed 0 roots.
>>>> checking free space cache
>>>> cache and super generation don't match, space cache will be invalidated
>>>> checking fs roots
>>>> reset nbytes for ino 6228034 root 5
>>>
>>> It's a minor problem.
>>> So the fs itself is still pretty health.
>>>
>>>> checking csums
>>>> checking root refs
>>>> found 664259596288 bytes used err is 0
>>>> total csum bytes: 619404608
>>>> total tree bytes: 4237737984
>>>> total fs tree bytes: 1692581888
>>>> total extent tree bytes: 1461665792
>>>> btree space waste bytes: 945044758
>>>> file data blocks allocated: 1568329531392
>>>>    referenced 537131163648
>>>> ----
>>>>
>>>> But then when I try to mount the fs:
>>>>
>>>> ----
>>> [snip]
>>>>
>>>> rescue kernel: 4.9.120
>>>>
>>>> ----
>>>>
>>>> I've grown the blockdevice, but there is no way I can grow the fs,
>>>> it doesn't want to mount in my rescue system, and it only mounts
>>>> read-only when booting from it, so I can't do it from there either
>>>
>>> Btrfs-progs could do it with some extra dirty work.
>>> (I purposed offline device resize idea, but didn't implement it yet)
>>>
>>> You could use this branch:
>>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>>
>> Qu,
>>
>>   The online resize should work here right?
> 
> Nope, the user reported unable to mount RW, due to exhausted metadata space.
> 
> And due to the failure of RW mount, reported can't do online resize,
> thus we need to do offline one.

  Its nice tool fixed the issue here, but in the long term we need
  a way to free some space IMO.

  Source of the problem is unable to mount RW when metadata space is
  full. A serious issue.

  Adding more disk space was viable workaround at this use case, which
  might not be true in all use cases. Like user may just want to mount
  and free some space.

  I think we need to fine tune the reserve space usage like distinguish
  the reserve space allocation between the new metadata item VS
  modification of the old metadata items. And reserve a space for
  the modification of the metadata, so that mount and freeing of
  some files will work.

Thanks, Anand


> Thanks,
> Qu
> 
>>
>> Thanks, Anand
>>
>>
>>> It's a quick and dirty fix to allow "btrfs-corrupt-block -X <device>" to
>>> extent device size to max.
>>>
>>> Please try above command to see if it solves your problem.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> I hope someone can help me out with this.
>>>> Thanks!
>>>>
>>>
> 
