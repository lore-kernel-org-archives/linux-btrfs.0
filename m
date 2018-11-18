Return-Path: <SRS0=WB35=N5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CF8C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 13:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE84A20815
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 13:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="edy3bxtS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE84A20815
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbeKRXv4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Nov 2018 18:51:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeKRXv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Nov 2018 18:51:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAIDUoGW057975;
        Sun, 18 Nov 2018 13:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SPVbBRsDTuGH/srsTEvU5lTounR5KtVduYQFmgqcewc=;
 b=edy3bxtSa97sfbQVAZjez6phhnH9djEUA3ZIj7QaPir4M9XRReTVlgqbE9c08NozfzG5
 6B6LRPM/gELI1l0V4/rEpG4kBtDN7wrwbToL6+8qt/NX6ZZOMyaLYoQ2qoz5cyPlAFxE
 25ch0OIrg0RMzY5K9PYbu/4xzprZWAYKouDBNX9Opm+Qoi1rC9LOwxg3nuksDiPr/gxj
 OKv4SXXStDDiXOOqcWXe4DrQLBAczn1sWcImcZcr7FIHgLKnI98VOCDo6Y4NORADnzfU
 ON21vatjaR+jYeMZraKhtQSmUup6Nu0K4fnJaeKAEOvDXhZ4LwIiR1xBcYnb6+QsjPkb sg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ntadtjs90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Nov 2018 13:31:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAIDVW22022467
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Nov 2018 13:31:32 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAIDVVpT005411;
        Sun, 18 Nov 2018 13:31:31 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 18 Nov 2018 05:31:31 -0800
Subject: Re: bad tree block start, want 705757184 have 82362368
To:     Stephan Olbrich <stephanolbrich@gmx.de>,
        linux-btrfs@vger.kernel.org
References: <1758973.r4I5FPff6i@chaos-desktop>
 <3061596.RPKkM7PgOY@chaos-desktop>
 <e65c8b2a-e337-6c9c-6fbc-839d810353df@gmx.com>
 <32822632.LIG5tvG1AF@chaos-desktop>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <8262543f-167a-6157-348a-74bb71079bf4@oracle.com>
Date:   Sun, 18 Nov 2018 21:31:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <32822632.LIG5tvG1AF@chaos-desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9080 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811180128
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/18/2018 03:56 PM, Stephan Olbrich wrote:
> Am Sonntag, 18. November 2018, 01:30:14 CET schrieb Qu Wenruo:
>>>>> Late on I got the same errors for my /home partition (on the same drive)
>>>>> as well. I have snapshots of all partitions on another drive made by
>>>>> btrbk. To get a working system, I made new (rw) snapshots of the most
>>>>> recent backup and setup grub and fstab, so my system would boot from the
>>>>> other drive. Unfortunately now I got the "bad tree block start" error
>>>>> again at least once in dmesg but I didn't save it and it's not in syslog
>>>>> :-( What I remember is, that it was followed by other btrfs error
>>>>> messages saying something about correcting something. And the filesystem
>>>>> was still read/write this time.
>>>>> At the moment I can't reproduce it.
> 
> Today it happend again (sdb is my backup drive, which is my main drive at the moment):
> [  286.325857] BTRFS error (device sdb1): bad tree block start, want 787719208960 have 11268016545161247416
> [  286.363245] BTRFS info (device sdb1): read error corrected: ino 0 off 787719208960 (dev /dev/sdb1 sector 1243815072)
> [  286.364087] BTRFS info (device sdb1): read error corrected: ino 0 off 787719213056 (dev /dev/sdb1 sector 1243815080)
> [  286.425946] BTRFS info (device sdb1): read error corrected: ino 0 off 787719217152 (dev /dev/sdb1 sector 1243815088)
> [  286.427530] BTRFS info (device sdb1): read error corrected: ino 0 off 787719221248 (dev /dev/sdb1 sector 1243815096)

  Was there any hardware issues? How about the following data from the 
system..

   btrfs fi df <mnt>
   btrfs dev stat <mnt>

Thanks, Anand

> 
>>>>> Is there any way to find out, which files are affected by the errors
>>>>> above?
>>>>
>>>> No files are affected, but an essential tree, extent tree, is corrupted.
>>>>
>>>> Normally this may prevent RW mount, and even it mounts it can still
>>>> cause problem when doing any write.
>>>> It could even prevent RO mount if the corrupted leaf contains block
>>>> group item.
>>>>
>>>> But your data should be OK if there is no other corruption, and in that
>>>> case btrfs-restore should work well.
>>>>
>>>>> I don't really trust the data on the drive I'm using at the
>>>>> moment, as it has shown errors as well, but I have a less current backup
>>>>> on yet another drive but at it is a few weeks old, I don't want to use
>>>>> it
>>>>> to setup the system on the SSD again, but just copy the relevant files
>>>>> if
>>>>> possible. Or is it possible to repair the original file system?
>>>>
>>>> At least we need "btrfs check" output.
>>>
>>> I updated btrfs-progs and run btrfs check for / and /home
>>> No errors are found on / (sda2), but there are errors on /home ??
>>>
>>> $ btrfs --version
>>> btrfs-progs v4.19
>>>
>>> $ btrfs check /dev/sda2
>>> Opening filesystem to check...
>>> Checking filesystem on /dev/sda2
>>> UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
>>> [1/7] checking root items
>>> [2/7] checking extents
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> [5/7] checking only csums items (without verifying data)
>>> [6/7] checking root refs
>>> [7/7] checking quota groups skipped (not enabled on this FS)
>>> found 64816218112 bytes used, no error found
>>> total csum bytes: 59518732
>>> total tree bytes: 2180268032
>>> total fs tree bytes: 1965965312
>>> total extent tree bytes: 123289600
>>> btree space waste bytes: 478665777
>>> file data blocks allocated: 151083261952
>>>
>>>   referenced 76879990784
>>
>> This fs is completely fine, including your data.
>>
>>> $ btrfs check /dev/sda4
>>> Opening filesystem to check...
>>> Checking filesystem on /dev/sda4
>>> UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
>>> [1/7] checking root items
>>> [2/7] checking extents
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> root 257 inode 7970563 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>          start: 0, len: 20480
>>>
>>> root 257 inode 7970564 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>          start: 0, len: 77824
>>>
>>> ERROR: errors found in fs roots
>>
>> These are just minor errors, won't even causing any data mismatch.
>>
>> So all your fses should be mostly OK.
>>
>> Would you please try to use v4.19-rc* to see if it changes anything?
> v4.19-rc1 is the only rc I found, but that is older than v4.19, right?
> Anyway, here is the output:
> 
> $ btrfs --version
> btrfs-progs v4.19-rc1
> 
> $ btrfs check /dev/sda2
> Opening filesystem to check...
> Checking filesystem on /dev/sda2
> UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> [5/7] checking only csums items (without verifying data)
> [6/7] checking root refs
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 64816218112 bytes used, no error found
> total csum bytes: 59518732
> total tree bytes: 2180268032
> total fs tree bytes: 1965965312
> total extent tree bytes: 123289600
> btree space waste bytes: 478665777
> file data blocks allocated: 151083261952
>   referenced 76879990784
> 
> $ btrfs check /dev/sda4
> Opening filesystem to check...
> Checking filesystem on /dev/sda4
> UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> root 257 inode 7970563 errors 100, file extent discount
> Found file extent holes:
>          start: 0, len: 20480
> root 257 inode 7970564 errors 100, file extent discount
> Found file extent holes:
>          start: 0, len: 77824
> ERROR: errors found in fs roots
> found 303386652672 bytes used, error(s) found
> total csum bytes: 289501272
> total tree bytes: 2336227328
> total fs tree bytes: 1766473728
> total extent tree bytes: 202014720
> btree space waste bytes: 519245278
> file data blocks allocated: 6851730792448
>   referenced 533348069376
> 
> 
> Thanks,
> Stephan
> 
> 
>> Thanks,
>> Qu
>>
>>> found 303386652672 bytes used, error(s) found
>>> total csum bytes: 289501272
>>> total tree bytes: 2336227328
>>> total fs tree bytes: 1766473728
>>> total extent tree bytes: 202014720
>>> btree space waste bytes: 519245278
>>> file data blocks allocated: 6851730792448
>>>
>>>   referenced 533348069376
>>>
>>> Thanks,
>>> Stephan
>>>
>>>>> Some information about my system:
>>>>> Kubuntu 18.04
>>>>> Kernel 4.19.1 when the problem occured, now 4.19.2
>>>>> btrfs-tools 4.15.1
>>>>
>>>> And "btrfs check" should be executed using latest version.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> Regards,
>>>>> Stephan
> 
> 
> 
> 
