Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5D8C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBE22083E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bAe1QHF7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfDLJCb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:02:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfDLJCb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:02:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C8xScc144348;
        Fri, 12 Apr 2019 09:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=/1shg52RlDAZYJe/x3F80sdDulToagv0LjgDYiV7AIU=;
 b=bAe1QHF7TDeyjQQKY94MbYwRpKN7kvn7pivhAiBUIP7vXXDeHaqdDZFMMXO+ZHnMfZb3
 g7CxGCQnMjAW1MSfTeKRyGw65yVZ/GUCX/38s3Omk7WiZ4YFYzXrahg9IzX7R0AZYdc4
 NSdzRKHWn9a+0AoDKu3DOIbaKLYopzRiDseJjokthWV9sIOmdPYgIJ/tHiXBFR6r6S0c
 GT89+TBrFAjMbeQxWWRK51rvf8cM7xPZpfN6q2K04+tDQPfdpEL9+Yd4YxBObKf1vPcP
 dn03RXiG9ZmUBke+KbtdRZMzWt0OOggLGQeVr04qqL4+KV82o0u3ocRxPmtz1TLlvkWM xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rpmrqnaqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 09:02:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C90b9X182977;
        Fri, 12 Apr 2019 09:02:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2rtqnp00y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 09:02:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C926XD022435;
        Fri, 12 Apr 2019 09:02:06 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 02:02:05 -0700
Subject: Re: [PATCH RFC 0/5] readmirror feature
To:     dsterba@suse.cz
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
 <20190409154840.GM29086@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <8d31c3a2-3fb0-63af-3173-948ed0e84de3@oracle.com>
Date:   Fri, 12 Apr 2019 17:02:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190409154840.GM29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120060
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120061
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Thanks for the comments.. more below.

On 9/4/19 11:48 PM, David Sterba wrote:
> On Tue, Mar 19, 2019 at 06:00:19PM +0800, Anand Jain wrote:
>> RFC patch as of now, appreciate your comments. This patch set has
>> been tested.
>>
>> Function call chain  __btrfs_map_block()->find_live_mirror() uses
>> thread pid to determine the %mirror_num when the mirror_num=0.
>>      
>> The pid based mirror_num extrapolation has following disadvantages
>>   . A large single-process read IO will read only from one disk.
> 
> Please note that the pid refers to the metadata kernel threads that
> submit the IO, so on average the IO is serviced by different threads
> with random PID. In the end it gets distributed over multiple drives.
> But it's nott ideal, no argument about that.

  ok.

>>   . In a worst scenario all processes read accessing the FS could have
>>         either odd or even pid, the read IO gets skewed.
>>   . There is no deterministic way of knowing/controlling which copy will
>>         be used for reading.
>>   . May see performance variations for a given set of multi process
>>         workload ran at different times.
>>      
>> So we need other types of readmirror policies.
>>      
>> This patch introduces a framework so that we can add more policies, and
>> converts the existing %pid into as a configurable parameter using the
>> property. And also provides a transient readmirror mount option, so that
>> this property can be applied for the read io during mount and for
>> readonly FS.
> 
> I think the mirror selection by pid was a temporary solution (that
> stuck, as it always happens). On average it does not work bad. Once we
> have a better way then it can be dropped. So I'm not convinced it needs
> to be one of the configuration options.

  Ok. Thanks for confirming, we could replace pid with something better,
  as of now we have devid-based and device-qdepth based, IMO qdepth based
  should be default as I commented in the respective patch.

> What exactly do you mean by 'transient'? I see that it could be needed
> for mount or read-only, though I don't see the usefulness of that.

  I mean to say does not persist across reboot. To override the
  original setting lets say device-qdepth based, but momentarily
  to avoid known read errors from a disk.

>>   For example:
>>     btrfs property set <mnt> readmirror pid
>>     btrfs property set <mnt> readmirror ""
>>     btrfs property set <mnt> readmirror devid<n>
>>
>>     mount -o readmirror=pid <mnt>
>>     mount -o readmirror=devid<n> <mnt>
>>
>> Please note:
>>   The property storage is an extented attributes of root inode
>>   (BTRFS_FS_TREE_OBJECTID), the other choice is a new ondisk KEY,
>>   which is open for comments.
> 
> A new key type is not going to be allocated for that, the extended
> attributes for properties are there. Another question is where to attach
> the property as this is a whole-filesystem property, we don't have an
> example to follow so far.

  Ok no key.
  Yep its a whole filesystem property. As of now it goes to the root
  inode as an extended attribute. I find it reasonable.

>>   This patch uses the unused btrfs_device::type, and does not use the
>>   bitwise ops because as type is u64 and bitwise ops need u32, so we
>>   need 32bits of the btrfs_device::type. Which is a kind of messy.
>>   Its open for suggestion for any better way.
> 
> For a prototype and early testing, using the type is probably ok, but
> I don't think it's right for permanent storage. Besides I'm sure that
> the u64 will not suffice in the long run.

Hmm.. I don't know. I thought
   <upper 32 bits> for disk groups
   <lower 32 bits> for disk types
should suffice. Not too sure what I am missing.

Thanks, Anand.

