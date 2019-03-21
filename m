Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6608C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 06:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ACB0218AE
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 06:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SgFhelak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfCUGik (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 02:38:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfCUGij (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 02:38:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L6Sl78022310;
        Thu, 21 Mar 2019 06:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LQp2hJp/tCdhHFqtFgVw7TaWUI+pLa16SGogBh2XQTE=;
 b=SgFhelakOBZEH+qiRwH8kgQDT3mKQDjoAxq1ipp5SEmaOpPNsIdrhxYzHC0Au2/d2ABO
 Fr+aiB0vD6pBQrq2xsP+mGxv1/7U72ywhc5mF+APlpUEyghPNdYPTyB5ay7TDbx3Ivt3
 KBg7qb44UgCVy7nVb/u7pYqzZztlpzGCUCSyR7nHKpLD67QiKak3ugB01nRcnKIUzvkw
 fA+EP17KxWySySFnBsytPxW51hf4w4rYfulm8IcW1zDTArW+/gSJwLFuZ3AoUSpbBB+M
 ZvNA8m4wtU8DxzDZ1QbRQELpv3qIxsFvcaBBjLJOG9a/UJgQTvvsTS/t6q6RMuL77i+y iQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnexvsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 06:38:16 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2L6cBdX015071
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 06:38:11 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L6cA93022199;
        Thu, 21 Mar 2019 06:38:10 GMT
Received: from [10.186.49.135] (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 23:38:10 -0700
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
 <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
 <0a922843-9223-5771-c6d6-16d1c2ddcc98@gmx.com>
 <20190320154048.GD16651@hungrycats.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <00492b06-9c55-985a-72fa-bb181c4137ba@oracle.com>
Date:   Thu, 21 Mar 2019 14:37:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190320154048.GD16651@hungrycats.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210047
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/20/19 11:40 PM, Zygo Blaxell wrote:
> On Wed, Mar 20, 2019 at 10:40:07PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/3/20 下午10:00, Anand Jain wrote:
>>>
>>>>>    Also any idea why the generation number for the extent data is not
>>>>>    incremented [2] when -o nodatacow and notrunc option is used, is it
>>>>>    a bug? the dump-tree is taken with the script as below [1]
>>>>>    (this corruption is seen with or without generation number is
>>>>>    being incremented, but as another way to fix for the corruption we can
>>>>>    verify the inode EXTENT_DATA generation from the same disk from which
>>>>>    the data is read).
>>>>
>>>> For the generation part, it's the generation when data is written to
>>>> disk.
>>>>
>>>> Truncation/nocow overwrite shouldn't really change the generation of
>>>> existing file extents.
>>>>
>>>> So I'm afraid you can't use that generation to do the check.
>>>
>>>   Any idea why it shouldn't change? Albeit there isn't new allocation
>>>   due to nodatacow and notrunc overwrite, but sure data is overwritten.
> 
> The references to the extent in the subvol trees hold a copy of the
> extent's generation, so if the extent's generation is modified, all the
> references to the extent in all the subvol trees have to be modified too,
> or they fail transid verification later on.


  Extents with refs > 1 will cow , so gen # is incremented on the
  overwritten extents. But my scenario is when refs = 1. As one of
  the idea I am mulling is to track/record missed generation numbers
  on the disks and quarantine those reads on those disks accordingly.


> Compared to pure datacow
> (nodatasum, compress=none), this would be the same number of iops, only
> fragmentation can be saved because of block overwrites (and even that
> isn't saved all the time).
> 
>>>   If that's the case then I would guess there will be bug in send receive
>>>   as well.
> 
> Send requires a read-only snapshot, > and the snapshot's reference to
> the nodatacow extents automatically turns on datacow for those extents.
> Thus, send behaves correctly because nodatacow is disabled.
> 
> The nodatacow flag is advisory.  It doesn't prevent btrfs from relocating
> data when needed.

  Oh yes. I forgot, there is rdonly snapshot prerequisite for the sends.

Thanks, Anand

>> I'm not sure about the send part.
>>
>> On the other hand, if btrfs is going to update the generation of
>> nodatacow file extent overwrite, it should cause pretty big performance
>> degradation.
>>
>> The idea of nodatacow is to skip all the expensive csum, extent
>> allocation (maybe not that expensive) and the race of subvol tree.
> 
> nodatacow also skips RAID data integrity checks.  Generally, applications
> and admins should plan for any data put in a nodatacow file to be silently
> corrupted at any time, i.e. the same situation as an ext4-on-mdadm setup.
> This is the price for minimizing the overhead for a write to a nodatacow
> extent.
> 
>> If we're going to update file extents for such case, we're re-introduce
>> performance impact to users who don't want that impact at all.
>> I don't believe it's worthy at all.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Thanks, Anand
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> [1]
>>>>>    umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb && \
>>>>>    mount -o notreelog,max_inline=0,nodatasum /dev/sdb /btrfs && \
>>>>>    echo 1st write: && \
>>>>>    dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1
>>>>> conv=fsync,notrunc && sync && \
>>>>>    btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
>>>>>    echo --- && \
>>>>>    btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA" && \
>>>>>    echo 2nd write: && \
>>>>>    dd status=none if=/dev/urandom of=/btrfs/anand bs=4096 count=1
>>>>> conv=fsync,notrunc && sync && \
>>>>>    btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item" && \
>>>>>    echo --- && \
>>>>>    btrfs in dump-tree /dev/sdb  | grep -A4 "257 EXTENT_DATA"
>>>>>
>>>>>
>>>>> 1st write:
>>>>>       item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>>>>>           generation 6 transid 6 size 4096 nbytes 4096
>>>>>           block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>>>>>           sequence 1 flags 0x3(NODATASUM|NODATACOW)
>>>>>           atime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>>           ctime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>>           mtime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>>           otime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>> ---
>>>>>       item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>>>>           generation 6 type 1 (regular)
>>>>>           extent data disk byte 13631488 nr 4096
>>>>>           extent data offset 0 nr 4096 ram 4096
>>>>>           extent compression 0 (none)
>>>>> 2nd write:
>>>>>       item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>>>>>           generation 6 transid 7 size 4096 nbytes 4096
>>>>>           block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>>>>>           sequence 2 flags 0x3(NODATASUM|NODATACOW)
>>>>>           atime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>>           ctime 1553058460.189985450 (2019-03-20 13:07:40)
>>>>>           mtime 1553058460.189985450 (2019-03-20 13:07:40)
>>>>>           otime 1553058460.163985452 (2019-03-20 13:07:40)
>>>>> ---
>>>>>       item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>>>>           generation 6 type 1 (regular)   <----- [2]
>>>>>           extent data disk byte 13631488 nr 4096
>>>>>           extent data offset 0 nr 4096 ram 4096
>>>>>           extent compression 0 (none)
>>>>>
>>>>>
>>>>> Thanks, Anand
>>>>
>>
> 
> 
> 
