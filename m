Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A851C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 05:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE3DB2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 05:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LJ3G00jt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfCTFrS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 01:47:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfCTFrR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 01:47:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2K5fGWU177649;
        Wed, 20 Mar 2019 05:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zKGGN67QI+T/7ndA9MJRT+PsYrmb6xZHSchsUK7C+Bo=;
 b=LJ3G00jt+J732euSEUmZkBaStpb7SLBnGqjXYbzEh7P5eljMInZiSIRoNEvsku1n08ur
 IGJ3Z69kkATHCWu280zreHRPC66hbQ9Z/Y78MCUG6hyXEDkjbTtq+4idsIk1oVckN/R3
 hwAO/K28kgNFZ0rYa8t2i0eJ+j2b/Jh4skhjwIqLa5Crk4+aCs6Hn1rpJKGhDCSc6iBJ
 zIQJzFSdTN5k0rj3bUO31drd/KXXFfA9qyk9MfyOQ1j6m5ZGBp5CDwNVQiab9d2SKjN8
 ITtfzAl1B2gD2Mu/M1LDcwxWsSKYU+OXvhBCsSxF11bvM11Q1K3UjwoigqOxTr5b7kd/ lA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2r8rjurn27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 05:47:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2K5l794001697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 05:47:07 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2K5l7gx024560;
        Wed, 20 Mar 2019 05:47:07 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 22:47:07 -0700
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
Date:   Wed, 20 Mar 2019 13:47:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9200 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903200049
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



>>>> A tree based integrity verification
>>>>    is important for all data, which is missing.
>>>>      Fix:
>>>>      In this RFC patch it proposes to use same disk from with the
>>>> metadata
>>>>    is read to read the data.
>>>
>>> The obvious problem I found is, the idea only works for RAID1/10.
>>>
>>> For striped profile it makes no sense, or even have a worse chance to
>>> get stale data.
>>>
>>>
>>> To me, the idea of using possible better mirror makes some sense, but
>>> very profile limited.
>>
>>   Yep. This problem and fix is only for the mirror based profiles
>>   such as raid1/raid10.
> 
> Then current implementation lacks such check.
> 
> Further more, data and metadata can lie in different chunks and have
> different chunk types.

  Right. Current tests for this RFC were only for raid1.

  But the final patch can fix that.

  In fact current patch works for all the cases except for the case of
  replace is running and mix of metadata:raid1 and data:raid56

  We need some cleanups in mirror_num, basically we need to bring it
  under #define. and handle it accordingly in __btrfs_map_block()

>>> Another idea I get inspired from the idea is, make it more generic so
>>> that bad/stale device get a lower priority.
>>
>>   When it comes to reading junk data, its not about the priority its
>>   about the eliminating. When the problem is only few blocks, I am
>>   against making the whole disk as bad.
>>
>>> Although it suffers the same problem as I described.
>>>
>>> To make the point short, the use case looks very limited.
>>
>>   It applies to raid1/raid10 with nodatacow (which implies nodatasum).
>>   In my understanding that's not rare.
>>
>>   Any comments on the fix offered here?
> 
> The implementation part is, is eb->read_mirror reliable?
> 
> E.g. if the data and the eb are in different chunks, and the stale
> happens in the chunk of eb but not in the data chunk?


  eb and regular data are indeed in different chunks always. But eb
  can never be stale as there is parent transid which is verified against
  the read eb. However we do not have such a check for the data (this is
  the core of the issue here) and so we return the junk data silently.

  Also any idea why the generation number for the extent data is not
  incremented [2] when -o nodatacow and notrunc option is used, is it
  a bug? the dump-tree is taken with the script as below [1]
  (this corruption is seen with or without generation number is
  being incremented, but as another way to fix for the corruption we can
  verify the inode EXTENT_DATA generation from the same disk from which
  the data is read).

[1]
  umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb && \
  mount -o notreelog,max_inline=0,nodatasum /dev/sdb /btrfs && \
  echo 1st write: && \
  dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1 
conv=fsync,notrunc && sync && \
  btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
  echo --- && \
  btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA" && \
  echo 2nd write: && \
  dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1 
conv=fsync,notrunc && sync && \
  btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
  echo --- && \
  btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA"


1st write:
	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
		generation 6 transid 6 size 4096 nbytes 4096
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x3(NODATASUM|NODATACOW)
		atime 1553058460.163985452 (2019-03-20 13:07:40)
		ctime 1553058460.163985452 (2019-03-20 13:07:40)
		mtime 1553058460.163985452 (2019-03-20 13:07:40)
		otime 1553058460.163985452 (2019-03-20 13:07:40)
---
	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
		generation 6 type 1 (regular)
		extent data disk byte 13631488 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0 (none)
2nd write:
	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
		generation 6 transid 7 size 4096 nbytes 4096
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 2 flags 0x3(NODATASUM|NODATACOW)
		atime 1553058460.163985452 (2019-03-20 13:07:40)
		ctime 1553058460.189985450 (2019-03-20 13:07:40)
		mtime 1553058460.189985450 (2019-03-20 13:07:40)
		otime 1553058460.163985452 (2019-03-20 13:07:40)
---
	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
		generation 6 type 1 (regular)   <----- [2]
		extent data disk byte 13631488 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0 (none)


Thanks, Anand
