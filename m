Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F73CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 13:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60DB2175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 13:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nkl9hOZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfCTNyS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:54:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbfCTNyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 09:54:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2KDrmEt008226;
        Wed, 20 Mar 2019 13:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kQNW83QTshIi5RSgDIMBHjhb3PBDePrF+kVC2yPFPBs=;
 b=Nkl9hOZmkNVkhqKP9ErpIs24r0EFyK45t9Kj5sOM7Nthr9xbYirI+Ri5n+4fWMunSJne
 cDQqeUlU44u4QAGEHxzu3jQeelmz09fpmLdNRa3qf6ROoQuMYLVjWrhEvumATI4x7DsH
 z/E99IsPZsO1s6n8Y5WkrYa9zf0Qk1TuKng2CJfegCYUWepENt7qdwgMqpgGF0/XQYbb
 AsK9yrEuC6aryUgvfc0Hlmwkc/TnalhTn9uIHAKK8IP39ZgP6nQVz0A6aESmDwZqPoB1
 /LLCVGBuNXaGLC1Kaw5McjkSFiiXe/vih1oJ5/awdsrTla+7KlhAS579jk9QhAFbS0/y ag== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r8ssrjrrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 13:54:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2KDsDaM012613
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Mar 2019 13:54:13 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2KDsCrg031476;
        Wed, 20 Mar 2019 13:54:12 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 06:54:12 -0700
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <541e2efd-ae4f-bc06-1d08-46f55208a095@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ce5be72e-5fae-932b-4ba7-85e0b3d8b825@oracle.com>
Date:   Wed, 20 Mar 2019 21:54:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <541e2efd-ae4f-bc06-1d08-46f55208a095@gmx.com>
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



On 3/20/19 2:27 PM, Qu Wenruo wrote:
> 
> 
> On 2019/3/20 下午1:47, Anand Jain wrote:
>>
>>
>>>>>> A tree based integrity verification
>>>>>>     is important for all data, which is missing.
>>>>>>       Fix:
>>>>>>       In this RFC patch it proposes to use same disk from with the
>>>>>> metadata
>>>>>>     is read to read the data.
>>>>>
>>>>> The obvious problem I found is, the idea only works for RAID1/10.
>>>>>
>>>>> For striped profile it makes no sense, or even have a worse chance to
>>>>> get stale data.
>>>>>
>>>>>
>>>>> To me, the idea of using possible better mirror makes some sense, but
>>>>> very profile limited.
>>>>
>>>>    Yep. This problem and fix is only for the mirror based profiles
>>>>    such as raid1/raid10.
>>>
>>> Then current implementation lacks such check.
>>>
>>> Further more, data and metadata can lie in different chunks and have
>>> different chunk types.
>>
>>   Right. Current tests for this RFC were only for raid1.
>>
>>   But the final patch can fix that.
>>
>>   In fact current patch works for all the cases except for the case of
>>   replace is running and mix of metadata:raid1 and data:raid56
>>
>>   We need some cleanups in mirror_num, basically we need to bring it
>>   under #define. and handle it accordingly in __btrfs_map_block()
> 
> 
> Wait for a minute.
> 
> There is a hidden pitfall from the very beginning.
> 
> Consider such chunk layout:
> Chunk A Type DATA|RAID1
> Stripe 1: Dev 1
> Stripe 2: Dev 2
> 
> Chunk B Type METADATA|RAID1
> Stripe 1: Dev 2
> Stripe 2: Dev 1

  Right this fix can't solve this case.
  So one down. The other choice I had is to
  Quarantine whole disk by comparing dev1 and dev2 generation # in the 
superblock during mount. or
  Quarantine whole chunk(s) by comparing dev1 and dev2 generation # in 
the chunk tree during mount. or
  Always read eb from both dev1 and dev2, if fails then fail its 
corresponding data block as well if any. or
  During mount compare dev1 and dev2 generation #, record the range of 
generation number missing on the disk. But this need ondisk format 
changes. (But nodatacow, notrunc reg data extent write must change gen#). or
  Similar to btree eb read pages, nest the extent data read as well.
  (But nodatacow, notrunc reg data extent write must change gen#).

Thanks, Anand


> Then when we found stale metadata in chunk B mirror 1, caused by dev 2,
> then your patch consider device 2 stale, and try to use mirror num 2 to
> read from data chunk.
> 
> However in data chunk, mirror num 2 means it's still from device 2, and
> we get stale data.
> 
> So the eb->mirror_num can still map to bad/stale device, due to the
> flexibility provided by btrfs per-chunk mapping.
> 
> Thanks,
> Qu
> 
>>
>>>>> Another idea I get inspired from the idea is, make it more generic so
>>>>> that bad/stale device get a lower priority.
>>>>
>>>>    When it comes to reading junk data, its not about the priority its
>>>>    about the eliminating. When the problem is only few blocks, I am
>>>>    against making the whole disk as bad.
>>>>
>>>>> Although it suffers the same problem as I described.
>>>>>
>>>>> To make the point short, the use case looks very limited.
>>>>
>>>>    It applies to raid1/raid10 with nodatacow (which implies nodatasum).
>>>>    In my understanding that's not rare.
>>>>
>>>>    Any comments on the fix offered here?
>>>
>>> The implementation part is, is eb->read_mirror reliable?
>>>
>>> E.g. if the data and the eb are in different chunks, and the stale
>>> happens in the chunk of eb but not in the data chunk?
>>
>>
>>   eb and regular data are indeed in different chunks always. But eb
>>   can never be stale as there is parent transid which is verified against
>>   the read eb. However we do not have such a check for the data (this is
>>   the core of the issue here) and so we return the junk data silently.
>>
>>   Also any idea why the generation number for the extent data is not
>>   incremented [2] when -o nodatacow and notrunc option is used, is it
>>   a bug? the dump-tree is taken with the script as below [1]
>>   (this corruption is seen with or without generation number is
>>   being incremented, but as another way to fix for the corruption we can
>>   verify the inode EXTENT_DATA generation from the same disk from which
>>   the data is read).
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
